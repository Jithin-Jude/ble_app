import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Provider to manage the global state of the connected Bluetooth device.
class BluetoothDeviceProvider extends ChangeNotifier {
  BluetoothDevice? _selectedDevice;
  BluetoothDevice? _connectedDevice;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  StreamSubscription<BluetoothConnectionState>? _stateSubscription;

  /// The currently selected device from the scan list.
  BluetoothDevice? get selectedDevice => _selectedDevice;

  /// The currently connected device.
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// The current connection state of the device.
  BluetoothConnectionState get connectionState => _connectionState;

  /// Sets the selected device.
  void setSelectedDevice(BluetoothDevice? device) {
    _selectedDevice = device;
    notifyListeners();
  }

  /// Updates the connected device and listens to its connection state.
  void setConnectedDevice(BluetoothDevice? device) {
    _stateSubscription?.cancel();
    _connectedDevice = device;
    
    if (device != null) {
      _stateSubscription = device.connectionState.listen((state) {
        _connectionState = state;
        if (state == BluetoothConnectionState.disconnected) {
          _connectedDevice = null;
        }
        notifyListeners();
      });
    } else {
      _connectionState = BluetoothConnectionState.disconnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }
}
