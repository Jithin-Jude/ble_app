import 'package:equatable/equatable.dart';

class BluetoothScanDeviceEntity extends Equatable {
  final String remoteId;
  final String name;
  final int rssi;

  const BluetoothScanDeviceEntity({
    required this.remoteId,
    required this.name,
    required this.rssi,
  });

  @override
  List<Object?> get props => [remoteId, name, rssi];
}
