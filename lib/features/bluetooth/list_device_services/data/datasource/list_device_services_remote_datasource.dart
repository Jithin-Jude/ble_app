import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/bluetooth/bluetooth_manager.dart';

abstract class ListDeviceServicesRemoteDataSource {
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device);
}

class ListDeviceServicesRemoteDataSourceImpl implements ListDeviceServicesRemoteDataSource {
  final BluetoothManager bluetoothManager;

  ListDeviceServicesRemoteDataSourceImpl(this.bluetoothManager);

  @override
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await bluetoothManager.discoverServices(device);
  }
}
