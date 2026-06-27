import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class BluetoothPermissionState extends BaseState {
  final bool isGranted;
  final BluetoothAdapterState adapterState;

  const BluetoothPermissionState({
    super.loading = false,
    super.effect = const NoEffect(),
    this.isGranted = false,
    this.adapterState = BluetoothAdapterState.unknown,
  });

  BluetoothPermissionState copyFromBase(BaseState base) {
    return copyWithS(
      loading: base.loading,
      effect: base.effect,
    );
  }

  BluetoothPermissionState copyWithS({
    bool? loading,
    UiEffect? effect,
    bool? isGranted,
    BluetoothAdapterState? adapterState,
    bool clearEffect = false,
  }) {
    return BluetoothPermissionState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : effect ?? this.effect,
      isGranted: isGranted ?? this.isGranted,
      adapterState: adapterState ?? this.adapterState,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        isGranted,
        adapterState,
      ];
}
