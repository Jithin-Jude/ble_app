import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entity/bluetooth_service_entity.dart';
import '../../domain/repository/list_device_services_repository.dart';
import '../datasource/list_device_services_remote_datasource.dart';
import '../model/bluetooth_service_model.dart';

class ListDeviceServicesRepositoryImpl implements ListDeviceServicesRepository {
  final ListDeviceServicesRemoteDataSource remoteDataSource;

  ListDeviceServicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<BluetoothServiceEntity>>> discoverServices(BluetoothDevice device) async {
    try {
      final services = await remoteDataSource.discoverServices(device);
      final entities = services
          .map((s) => BluetoothServiceModel.fromBluetoothService(s))
          .toList();
      return Success(entities, statusCode: 200, message: 'Services discovered');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
