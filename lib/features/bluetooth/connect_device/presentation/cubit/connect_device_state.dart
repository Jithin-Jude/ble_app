import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class ConnectDeviceState extends BaseState {
  final BluetoothConnectionState connectionState;

  const ConnectDeviceState({
    super.loading = false,
    super.effect = const NoEffect(),
    this.connectionState = BluetoothConnectionState.disconnected,
  });

  ConnectDeviceState copyFromBase(BaseState base) {
    return copyWithS(
      loading: base.loading,
      effect: base.effect,
    );
  }

  ConnectDeviceState copyWithS({
    bool? loading,
    UiEffect? effect,
    BluetoothConnectionState? connectionState,
    bool clearEffect = false,
  }) {
    return ConnectDeviceState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : effect ?? this.effect,
      connectionState: connectionState ?? this.connectionState,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        connectionState,
      ];
}
