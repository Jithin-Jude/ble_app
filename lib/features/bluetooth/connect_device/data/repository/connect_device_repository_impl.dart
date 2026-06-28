import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/result/result.dart';
import '../../domain/repository/connect_device_repository.dart';
import '../datasource/connect_device_remote_datasource.dart';

class ConnectDeviceRepositoryImpl implements ConnectDeviceRepository {
  final ConnectDeviceRemoteDataSource remoteDataSource;

  ConnectDeviceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<void>> connect(BluetoothDevice device) async {
    try {
      await remoteDataSource.connect(device);
      return Success(null, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.connected);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Future<Result<void>> disconnect(BluetoothDevice device) async {
    try {
      await remoteDataSource.disconnect(device);
      return Success(null, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.disconnected);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device) {
    return remoteDataSource.connectionState(device);
  }
}
