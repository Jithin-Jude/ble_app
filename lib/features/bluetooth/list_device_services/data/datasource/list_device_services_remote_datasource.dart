import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/bluetooth/bluetooth_manager.dart';

abstract class ListDeviceServicesRemoteDataSource {
  Future<List<BluetoothService>> discoverServices(String deviceId);

  Future<List<int>> readCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  });

  Future<void> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
    required bool withResponse,
  });
}

class ListDeviceServicesRemoteDataSourceImpl
    implements ListDeviceServicesRemoteDataSource {
  final BluetoothManager bluetoothManager;

  ListDeviceServicesRemoteDataSourceImpl(this.bluetoothManager);

  @override
  Future<List<BluetoothService>> discoverServices(String deviceId) async {
    final device = BluetoothDevice.fromId(deviceId);
    return await bluetoothManager.discoverServices(device);
  }

  @override
  Future<List<int>> readCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) async {
    return await bluetoothManager.readCharacteristic(
      deviceId: deviceId,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
    );
  }

  @override
  Future<void> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
    required bool withResponse,
  }) async {
    await bluetoothManager.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      value: value,
      withResponse: withResponse,
    );
  }
}
