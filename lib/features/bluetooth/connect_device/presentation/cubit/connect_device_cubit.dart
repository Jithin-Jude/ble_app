import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/connect_device_usecase.dart';
import '../../domain/usecase/disconnect_device_usecase.dart';
import 'connect_device_state.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';

class ConnectDeviceCubit extends Cubit<ConnectDeviceState> {
  final ConnectDeviceUseCase connectUseCase;
  final DisconnectDeviceUseCase disconnectUseCase;
  final BluetoothDeviceProvider deviceProvider;

  StreamSubscription? _connectionStateSubscription;

  ConnectDeviceCubit({
    required this.connectUseCase,
    required this.disconnectUseCase,
    required this.deviceProvider,
  }) : super(ConnectDeviceInitial());

  Future<void> connect(BluetoothDevice device) async {
    emit(ConnectDeviceLoading());
    
    final result = await connectUseCase(device);

    if (result is Success) {
      deviceProvider.setConnectedDevice(device);
      _startMonitoring(device);
    } else if (result is Failure) {
      emit(ConnectDeviceStatus(
        connectionState: BluetoothConnectionState.disconnected,
        errorMessage: result.message,
      ));
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    emit(ConnectDeviceLoading());
    final result = await disconnectUseCase(device);
    if (result is Failure) {
      _emitStatus(device, errorMessage: result.message);
    }
  }

  void _startMonitoring(BluetoothDevice device) {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = device.connectionState.listen((state) {
      emit(ConnectDeviceStatus(connectionState: state));
    });
  }

  void _emitStatus(BluetoothDevice device, {String? errorMessage}) {
    // We can't easily get sync connection state from FBP without an active stream usually, 
    // but deviceProvider has it.
    emit(ConnectDeviceStatus(
      connectionState: deviceProvider.connectionState,
      errorMessage: errorMessage,
    ));
  }

  @override
  Future<void> close() {
    _connectionStateSubscription?.cancel();
    return super.close();
  }
}
