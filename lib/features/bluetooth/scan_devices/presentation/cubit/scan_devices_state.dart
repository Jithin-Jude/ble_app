import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class ScanDevicesState extends Equatable {
  const ScanDevicesState();

  @override
  List<Object?> get props => [];
}

class ScanDevicesInitial extends ScanDevicesState {}

class ScanDevicesLoading extends ScanDevicesState {}

class ScanDevicesLoaded extends ScanDevicesState {
  final List<ScanResult> scanResults;
  final bool isScanning;
  final String? errorMessage;

  const ScanDevicesLoaded({
    required this.scanResults,
    required this.isScanning,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [scanResults, isScanning, errorMessage];
}
