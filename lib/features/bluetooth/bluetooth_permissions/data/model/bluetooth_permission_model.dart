import '../../domain/entity/bluetooth_permission_entity.dart';

class BluetoothPermissionModel extends BluetoothPermissionEntity {
  const BluetoothPermissionModel({
    required super.isGranted,
    required super.message,
  });

  factory BluetoothPermissionModel.fromBool(bool isGranted) {
    return BluetoothPermissionModel(
      isGranted: isGranted,
      message: isGranted ? 'Permissions granted' : 'Permissions denied',
    );
  }
}
