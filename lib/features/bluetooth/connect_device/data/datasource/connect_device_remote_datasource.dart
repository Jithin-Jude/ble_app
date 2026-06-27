import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/bluetooth/bluetooth_manager.dart';

abstract class ConnectDeviceRemoteDataSource {
  Future<void> connect(BluetoothDevice device);
  Future<void> disconnect(BluetoothDevice device);
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device);
}

class ConnectDeviceRemoteDataSourceImpl implements ConnectDeviceRemoteDataSource {
  final BluetoothManager bluetoothManager;

  ConnectDeviceRemoteDataSourceImpl(this.bluetoothManager);

  @override
  Future<void> connect(BluetoothDevice device) async {
    await bluetoothManager.connect(device);
  }

  @override
  Future<void> disconnect(BluetoothDevice device) async {
    await bluetoothManager.disconnect(device);
  }

  @override
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device) {
    return bluetoothManager.connectionState(device);
  }
}
