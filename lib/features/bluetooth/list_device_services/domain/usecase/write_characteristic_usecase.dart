import '../../../../../core/result/result.dart';
import '../repository/list_device_services_repository.dart';

class WriteCharacteristicUseCase {
  final ListDeviceServicesRepository repository;

  WriteCharacteristicUseCase(this.repository);

  Future<Result<void>> call({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
    required bool withResponse,
  }) async {
    return await repository.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      value: value,
      withResponse: withResponse,
    );
  }
}
