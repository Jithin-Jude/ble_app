import '../../../../../core/result/result.dart';
import '../entity/bluetooth_permission_entity.dart';
import '../repository/bluetooth_permission_repository.dart';

class RequestBluetoothPermissionUseCase {
  final BluetoothPermissionRepository repository;

  RequestBluetoothPermissionUseCase(this.repository);

  Future<Result<BluetoothPermissionEntity>> call() async {
    return await repository.requestPermissions();
  }
}
