import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';

abstract class ScanDevicesRepository {
  /// Starts scanning for devices.
  Future<Result<void>> startScan();

  /// Stops scanning for devices.
  Future<Result<void>> stopScan();

  /// Stream of scan results.
  Stream<List<ScanResult>> get scanResults;

  /// Stream to check if scanning is in progress.
  Stream<bool> get isScanning;

  /// Returns a list of currently connected devices.
  List<BluetoothDevice> get connectedDevices;

  /// Disconnects from a specific [BluetoothDevice].
  Future<Result<void>> disconnect(BluetoothDevice device);
}
