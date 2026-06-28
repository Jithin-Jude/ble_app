import '../../../../../core/result/result.dart';
import '../repository/list_device_services_repository.dart';

class ReadCharacteristicUseCase {
  final ListDeviceServicesRepository repository;

  ReadCharacteristicUseCase(this.repository);

  Future<Result<List<int>>> call({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) async {
    return await repository.readCharacteristic(
      deviceId: deviceId,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
    );
  }
}
