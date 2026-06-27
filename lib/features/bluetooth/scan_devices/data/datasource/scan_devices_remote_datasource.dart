import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/bluetooth/bluetooth_manager.dart';

abstract class ScanDevicesRemoteDataSource {
  Future<void> startScan();
  Future<void> stopScan();
  Stream<List<ScanResult>> get scanResults;
  Stream<bool> get isScanning;
}

class ScanDevicesRemoteDataSourceImpl implements ScanDevicesRemoteDataSource {
  final BluetoothManager bluetoothManager;

  ScanDevicesRemoteDataSourceImpl(this.bluetoothManager);

  @override
  Future<void> startScan() async {
    await bluetoothManager.startScan();
  }

  @override
  Future<void> stopScan() async {
    await bluetoothManager.stopScan();
  }

  @override
  Stream<List<ScanResult>> get scanResults => bluetoothManager.scanResults;

  @override
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;
}
