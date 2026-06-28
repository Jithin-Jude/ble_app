import '../../../../../core/result/result.dart';
import '../entity/bluetooth_service_entity.dart';
import '../repository/list_device_services_repository.dart';

class DiscoverServicesUseCase {
  final ListDeviceServicesRepository repository;

  DiscoverServicesUseCase(this.repository);

  Future<Result<List<BluetoothServiceEntity>>> call(String deviceId) async {
    return await repository.discoverServices(deviceId);
  }
}
