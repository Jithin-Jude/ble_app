import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Shared Bluetooth Manager that wraps [FlutterBluePlus].
/// It acts as the single source of truth for all BLE operations.
class BluetoothManager {
  /// Stream to monitor the Bluetooth adapter state (ON/OFF).
  Stream<BluetoothAdapterState> get adapterState => FlutterBluePlus.adapterState;

  /// Returns the current adapter state.
  BluetoothAdapterState get currentAdapterState => FlutterBluePlus.adapterStateNow;

  /// Starts scanning for BLE devices.
  /// [withServices] can be used to filter devices by service UUIDs.
  Future<void> startScan({List<Guid>? withServices}) async {
    await FlutterBluePlus.startScan(
      withServices: withServices ?? List.empty(),
      androidUsesFineLocation: true,
      removeIfGone: null, // As per requirements: display every scan result.
    );
  }

  /// Stops the current BLE scan.
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  /// Returns a stream of scan results.
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /// Returns a list of currently connected devices.
  List<BluetoothDevice> get connectedDevices => FlutterBluePlus.connectedDevices;

  /// Connects to a specific [BluetoothDevice].
  Future<void> connect(BluetoothDevice device) async {
    await device.connect();
  }

  /// Disconnects from a specific [BluetoothDevice].
  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  /// Discovers GATT services for a specific [BluetoothDevice].
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await device.discoverServices();
  }

  /// Stream to monitor the connection state of a specific [BluetoothDevice].
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device) {
    return device.connectionState;
  }
}
