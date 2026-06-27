import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDeviceEntity extends Equatable {
  final String remoteId;
  final String name;
  final BluetoothConnectionState connectionState;

  const ConnectedDeviceEntity({
    required this.remoteId,
    required this.name,
    required this.connectionState,
  });

  @override
  List<Object?> get props => [remoteId, name, connectionState];
}
