import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/monitor_bluetooth_state_usecase.dart';
import '../../domain/usecase/request_bluetooth_permission_usecase.dart';
import 'bluetooth_permission_state.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/presentation/base_cubit.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class BluetoothPermissionCubit extends BaseCubit<BluetoothPermissionState> {
  final RequestBluetoothPermissionUseCase requestPermissionsUseCase;
  final MonitorBluetoothStateUseCase monitorStateUseCase;

  StreamSubscription? _adapterStateSubscription;

  BluetoothPermissionCubit({
    required this.requestPermissionsUseCase,
    required this.monitorStateUseCase,
  }) : super(const BluetoothPermissionState());

  Future<void> checkAndRequestPermissions() async {
    setLoading(true);

    final result = await requestPermissionsUseCase();

    setLoading(false);

    if (result is Success) {
      final isGranted = (result as Success).data.isGranted;
      emit(state.copyWithS(isGranted: isGranted));
      _startMonitoring(isGranted);
    } else if (result is Failure) {
      emit(state.copyWithS(
        isGranted: false,
        adapterState: monitorStateUseCase.currentAdapterState,
        effect: ShowErrorSnackBar((result as Failure).message),
      ));
    }
  }

  void _startMonitoring(bool isGranted) {
    _adapterStateSubscription?.cancel();
    
    final currentState = state.copyWithS(
      isGranted: isGranted,
      adapterState: monitorStateUseCase.currentAdapterState,
    );

    if (isGranted && monitorStateUseCase.currentAdapterState == BluetoothAdapterState.on) {
      emit(currentState.copyWithS(effect: const NavigationEffect('/scan')));
    } else {
      emit(currentState);
    }

    _adapterStateSubscription = monitorStateUseCase().listen((adapterState) {
      if (isGranted && adapterState == BluetoothAdapterState.on) {
        emit(state.copyWithS(
          isGranted: isGranted,
          adapterState: adapterState,
          effect: const NavigationEffect('/scan'),
        ));
      } else {
        emit(state.copyWithS(
          isGranted: isGranted,
          adapterState: adapterState,
        ));
      }
    });
  }

  @override
  BluetoothPermissionState mapBaseToConcrete(BaseState base) {
    return state.copyFromBase(base);
  }

  @override
  void clearEffect() {
    emit(state.copyWithS(clearEffect: true));
  }

  @override
  Future<void> close() {
    _adapterStateSubscription?.cancel();
    return super.close();
  }
}
