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
      // Step 1: Bluetooth permissions
      final bluetoothStatuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();

      final bluetoothGranted =
      bluetoothStatuses.values.every((status) => status.isGranted);

      if (!bluetoothGranted) {
        return false;
      }

      // Step 2: Location permission
      final locationStatus = await Permission.location.request();

      return locationStatus.isGranted;
    }

    if (Platform.isIOS) {
      final bluetoothStatus = await Permission.bluetooth.request();
      return bluetoothStatus.isGranted;
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
