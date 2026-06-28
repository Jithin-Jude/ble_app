import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';
import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';

class ConnectDeviceState extends BaseState {
  final BluetoothConnectionState connectionState;
  final PairState pairState;
  final bool pairing;
  final bool unPairing;

  const ConnectDeviceState({
    super.loading = false,
    super.effect = const NoEffect(),
    this.connectionState = BluetoothConnectionState.disconnected,
    this.pairState = PairState.unknown,
    this.pairing = false,
    this.unPairing = false,
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
    PairState? pairState,
    bool? pairing,
    bool? unPairing,
    bool clearEffect = false,
  }) {
    return ConnectDeviceState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : effect ?? this.effect,
      connectionState: connectionState ?? this.connectionState,
      pairState: pairState ?? this.pairState,
      pairing: pairing ?? this.pairing,
      unPairing: unPairing ?? this.unPairing,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        connectionState,
        pairState,
        pairing,
        unPairing,
      ];
}
