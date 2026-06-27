import 'package:equatable/equatable.dart';
import '../../domain/entity/bluetooth_service_entity.dart';

abstract class ListDeviceServicesState extends Equatable {
  const ListDeviceServicesState();

  @override
  List<Object?> get props => [];
}

class ListDeviceServicesInitial extends ListDeviceServicesState {}

class ListDeviceServicesLoading extends ListDeviceServicesState {}

class ListDeviceServicesLoaded extends ListDeviceServicesState {
  final List<BluetoothServiceEntity> services;

  const ListDeviceServicesLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ListDeviceServicesError extends ListDeviceServicesState {
  final String message;

  const ListDeviceServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
