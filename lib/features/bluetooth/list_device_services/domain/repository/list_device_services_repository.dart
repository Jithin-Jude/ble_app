import '../../../../../core/result/result.dart';
import '../entity/bluetooth_service_entity.dart';

abstract class ListDeviceServicesRepository {
  /// Discovers services for the given device.
  Future<Result<List<BluetoothServiceEntity>>> discoverServices(String deviceId);

  /// Reads the value of a characteristic.
  Future<Result<List<int>>> readCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  });

  /// Writes a value to a characteristic.
  Future<Result<void>> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
    required bool withResponse,
  });
}
