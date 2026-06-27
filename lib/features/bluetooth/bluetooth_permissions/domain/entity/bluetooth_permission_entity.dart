import 'package:equatable/equatable.dart';

class BluetoothPermissionEntity extends Equatable {
  final bool isGranted;
  final String message;

  const BluetoothPermissionEntity({
    required this.isGranted,
    required this.message,
  });

  @override
  List<Object?> get props => [isGranted, message];
}
