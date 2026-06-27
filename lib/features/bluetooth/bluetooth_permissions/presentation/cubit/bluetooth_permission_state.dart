import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothPermissionState extends Equatable {
  const BluetoothPermissionState();

  @override
  List<Object?> get props => [];
}

class BluetoothPermissionInitial extends BluetoothPermissionState {}

class BluetoothPermissionLoading extends BluetoothPermissionState {}

class BluetoothPermissionStatus extends BluetoothPermissionState {
  final bool isGranted;
  final BluetoothAdapterState adapterState;
  final String? errorMessage;

  const BluetoothPermissionStatus({
    required this.isGranted,
    required this.adapterState,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isGranted, adapterState, errorMessage];
}
