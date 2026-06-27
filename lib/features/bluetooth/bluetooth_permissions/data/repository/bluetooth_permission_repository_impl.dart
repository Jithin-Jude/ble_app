import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entity/bluetooth_permission_entity.dart';
import '../../domain/repository/bluetooth_permission_repository.dart';
import '../datasource/bluetooth_permission_remote_datasource.dart';
import '../model/bluetooth_permission_model.dart';

class BluetoothPermissionRepositoryImpl implements BluetoothPermissionRepository {
  final BluetoothPermissionRemoteDataSource remoteDataSource;

  BluetoothPermissionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<BluetoothPermissionEntity>> requestPermissions() async {
    try {
      final isGranted = await remoteDataSource.requestPermissions();
      return Success(
        BluetoothPermissionModel.fromBool(isGranted),
        statusCode: 200,
        message: 'Success',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Stream<BluetoothAdapterState> monitorAdapterState() {
    return remoteDataSource.monitorAdapterState();
  }

  @override
  BluetoothAdapterState get currentAdapterState => remoteDataSource.currentAdapterState;
}
