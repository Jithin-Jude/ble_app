import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../entity/bluetooth_service_entity.dart';
import '../repository/list_device_services_repository.dart';

class DiscoverServicesUseCase {
  final ListDeviceServicesRepository repository;

  DiscoverServicesUseCase(this.repository);

  Future<Result<List<BluetoothServiceEntity>>> call(BluetoothDevice device) async {
    return await repository.discoverServices(device);
  }
}
