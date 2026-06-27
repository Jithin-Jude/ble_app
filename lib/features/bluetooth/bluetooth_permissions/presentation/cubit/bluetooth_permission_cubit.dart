import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/monitor_bluetooth_state_usecase.dart';
import '../../domain/usecase/request_bluetooth_permission_usecase.dart';
import 'bluetooth_permission_state.dart';
import '../../../../../core/result/result.dart';

class BluetoothPermissionCubit extends Cubit<BluetoothPermissionState> {
  final RequestBluetoothPermissionUseCase requestPermissionsUseCase;
  final MonitorBluetoothStateUseCase monitorStateUseCase;

  StreamSubscription? _adapterStateSubscription;
  bool _isPermissionGranted = false;

  BluetoothPermissionCubit({
    required this.requestPermissionsUseCase,
    required this.monitorStateUseCase,
  }) : super(BluetoothPermissionInitial());

  Future<void> checkAndRequestPermissions() async {
    emit(BluetoothPermissionLoading());

    final result = await requestPermissionsUseCase();

    if (result is Success) {
      _isPermissionGranted = (result as Success).data.isGranted;
      _startMonitoring();
    } else if (result is Failure) {
      emit(BluetoothPermissionStatus(
        isGranted: false,
        adapterState: monitorStateUseCase.currentAdapterState,
        errorMessage: (result as Failure).message,
      ));
    }
  }

  void _startMonitoring() {
    _adapterStateSubscription?.cancel();
    
    emit(BluetoothPermissionStatus(
      isGranted: _isPermissionGranted,
      adapterState: monitorStateUseCase.currentAdapterState,
    ));

    _adapterStateSubscription = monitorStateUseCase().listen((state) {
      emit(BluetoothPermissionStatus(
        isGranted: _isPermissionGranted,
        adapterState: state,
      ));
    });
  }

  @override
  Future<void> close() {
    _adapterStateSubscription?.cancel();
    return super.close();
  }
}
