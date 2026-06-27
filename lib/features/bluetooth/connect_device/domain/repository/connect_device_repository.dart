import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';

abstract class ConnectDeviceRepository {
  /// Connects to the device.
  Future<Result<void>> connect(BluetoothDevice device);

  /// Disconnects from the device.
  Future<Result<void>> disconnect(BluetoothDevice device);

  /// Stream of connection state for the device.
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device);
}
