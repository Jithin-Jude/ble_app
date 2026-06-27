import '../../../../../core/result/result.dart';
import '../entity/bluetooth_permission_entity.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothPermissionRepository {
  /// Requests necessary Bluetooth and Location permissions.
  Future<Result<BluetoothPermissionEntity>> requestPermissions();

  /// Checks the current Bluetooth adapter state.
  Stream<BluetoothAdapterState> monitorAdapterState();
  
  /// Returns the current adapter state.
  BluetoothAdapterState get currentAdapterState;
}
