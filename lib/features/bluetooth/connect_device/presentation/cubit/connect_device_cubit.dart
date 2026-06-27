import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/connect_device_usecase.dart';
import '../../domain/usecase/disconnect_device_usecase.dart';
import 'connect_device_state.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_cubit.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class ConnectDeviceCubit extends BaseCubit<ConnectDeviceState> {
  final ConnectDeviceUseCase connectUseCase;
  final DisconnectDeviceUseCase disconnectUseCase;
  final BluetoothDeviceProvider deviceProvider;

  StreamSubscription? _connectionStateSubscription;

  ConnectDeviceCubit({
    required this.connectUseCase,
    required this.disconnectUseCase,
    required this.deviceProvider,
  }) : super(const ConnectDeviceState());

  Future<void> connect(BluetoothDevice device) async {
    setLoading(true);
    
    final result = await connectUseCase(device);

    setLoading(false);
    if (result is Success) {
      deviceProvider.setConnectedDevice(device);
      _startMonitoring(device);
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

  void _startMonitoring(BluetoothDevice device) {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = device.connectionState.listen((connectionState) {
      emit(state.copyWithS(connectionState: connectionState));
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
    return super.close();
  }
}
