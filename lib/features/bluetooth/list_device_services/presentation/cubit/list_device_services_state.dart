import '../../domain/entity/bluetooth_service_entity.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class ListDeviceServicesState extends BaseState {
  final List<BluetoothServiceEntity> services;

  const ListDeviceServicesState({
    super.loading = false,
    super.effect = const NoEffect(),
    this.services = const [],
  });

  ListDeviceServicesState copyFromBase(BaseState base) {
    return copyWithS(
      loading: base.loading,
      effect: base.effect,
    );
  }

  ListDeviceServicesState copyWithS({
    bool? loading,
    UiEffect? effect,
    List<BluetoothServiceEntity>? services,
    bool clearEffect = false,
  }) {
    return ListDeviceServicesState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : effect ?? this.effect,
      services: services ?? this.services,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        services,
      ];
}
