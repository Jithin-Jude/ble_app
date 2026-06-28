import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/connect_device_usecase.dart';
import '../../domain/usecase/disconnect_device_usecase.dart';
import '../../domain/usecase/get_pair_state_stream_usecase.dart';
import '../../domain/usecase/get_pair_state_usecase.dart';
import '../../domain/usecase/pair_device_usecase.dart';
import '../../domain/usecase/unpair_device_usecase.dart';
import 'connect_device_state.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_cubit.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';
import '../../../../../core/bluetooth/bluetooth_bond_manager.dart';

class ConnectDeviceCubit extends BaseCubit<ConnectDeviceState> {
  final ConnectDeviceUseCase connectUseCase;
  final DisconnectDeviceUseCase disconnectUseCase;
  final GetPairStateUseCase getPairStateUseCase;
  final PairDeviceUseCase pairDeviceUseCase;
  final UnPairDeviceUseCase unPairDeviceUseCase;
  final GetPairStateStreamUseCase getPairStateStreamUseCase;
  final BluetoothDeviceProvider deviceProvider;

  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _pairStateSubscription;

  ConnectDeviceCubit({
    required this.connectUseCase,
    required this.disconnectUseCase,
    required this.getPairStateUseCase,
    required this.pairDeviceUseCase,
    required this.unPairDeviceUseCase,
    required this.getPairStateStreamUseCase,
    required this.deviceProvider,
  }) : super(const ConnectDeviceState()) {
    _init();
  }

  void _init() {
    final device = deviceProvider.selectedDevice;
    if (device != null) {
      _startMonitoring(device);
      loadPairState(device.remoteId.str);
      _startMonitoringPairState();
    }
  }

  Future<void> connect(BluetoothDevice device) async {
    if (deviceProvider.isAnyDeviceConnected &&
        deviceProvider.connectedDevice?.remoteId != device.remoteId) {
      emit(state.copyWithS(
        effect: const ShowErrorSnackBar(AppStrings.deviceAlreadyConnected),
      ));
      return;
    }

    setLoading(true);
    
    final result = await connectUseCase(device);

    setLoading(false);
    if (result is Success) {
      deviceProvider.setConnectedDevice(device);
      _startMonitoring(device);
      loadPairState(device.remoteId.str);
    } else if (result is Failure) {
      emit(state.copyWithS(
        connectionState: BluetoothConnectionState.disconnected,
        effect: ShowErrorSnackBar(result.message),
      ));
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    setLoading(true);
    final result = await disconnectUseCase(device);
    setLoading(false);
    if (result is Failure) {
      emit(state.copyWithS(
        effect: ShowErrorSnackBar(result.message),
      ));
    }
  }

  Future<void> loadPairState(String macAddress) async {
    final result = await getPairStateUseCase(macAddress);
    if (result is Success<PairState>) {
      emit(state.copyWithS(pairState: result.data));
    }
  }

  Future<void> pair(String macAddress) async {
    emit(state.copyWithS(pairing: true));
    final result = await pairDeviceUseCase(macAddress);
    emit(state.copyWithS(pairing: false));
    if (result is Failure) {
      emit(state.copyWithS(effect: ShowErrorSnackBar(result.toString())));
    }
  }

  Future<void> unPair(String macAddress) async {
    emit(state.copyWithS(unPairing: true));
    final result = await unPairDeviceUseCase(macAddress);
    emit(state.copyWithS(unPairing: false));
    if (result is Failure) {
      emit(state.copyWithS(effect: ShowErrorSnackBar(result.toString())));
    }
  }

  void _startMonitoring(BluetoothDevice device) {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = device.connectionState.listen((connectionState) {
      emit(state.copyWithS(connectionState: connectionState));
    });
  }

  void _startMonitoringPairState() {
    _pairStateSubscription?.cancel();
    _pairStateSubscription = getPairStateStreamUseCase().listen((pairState) {
      emit(state.copyWithS(pairState: pairState));
    });
  }

  @override
  ConnectDeviceState mapBaseToConcrete(BaseState base) {
    return state.copyFromBase(base);
  }

  @override
  void clearEffect() {
    emit(state.copyWithS(clearEffect: true));
  }

  @override
  Future<void> close() {
    _connectionStateSubscription?.cancel();
    _pairStateSubscription?.cancel();
    return super.close();
  }
}
