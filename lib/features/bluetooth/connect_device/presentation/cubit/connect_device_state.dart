import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class ConnectDeviceState extends Equatable {
  const ConnectDeviceState();

  @override
  List<Object?> get props => [];
}

class ConnectDeviceInitial extends ConnectDeviceState {}

class ConnectDeviceLoading extends ConnectDeviceState {}

class ConnectDeviceStatus extends ConnectDeviceState {
  final BluetoothConnectionState connectionState;
  final String? errorMessage;

  const ConnectDeviceStatus({
    required this.connectionState,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [connectionState, errorMessage];
}
