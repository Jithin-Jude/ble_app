import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/bluetooth/bluetooth_manager.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothPermissionRemoteDataSource {
  Future<bool> requestPermissions();
  Stream<BluetoothAdapterState> monitorAdapterState();
  BluetoothAdapterState get currentAdapterState;
}

class BluetoothPermissionRemoteDataSourceImpl implements BluetoothPermissionRemoteDataSource {
  final BluetoothManager bluetoothManager;

  BluetoothPermissionRemoteDataSourceImpl(this.bluetoothManager);

  @override
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Handle Android 12+ (API 31+)
      if (await Permission.bluetoothScan.status.isRestricted || 
          await Permission.bluetoothConnect.status.isRestricted) {
          // Some devices might need this check, but usually we just request.
      }

      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.location,
      ].request();

      return statuses.values.every((status) => status.isGranted);
    } else if (Platform.isIOS) {
      // iOS permissions are usually handled by the system when the app tries to use the API,
      // but we can request bluetooth permission explicitly.
      PermissionStatus status = await Permission.bluetooth.request();
      return status.isGranted;
    }
    return true;
  }

  @override
  Stream<BluetoothAdapterState> monitorAdapterState() {
    return bluetoothManager.adapterState;
  }

  @override
  BluetoothAdapterState get currentAdapterState => bluetoothManager.currentAdapterState;
}
