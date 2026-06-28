import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/result/result.dart';
import '../../domain/repository/scan_devices_repository.dart';
import '../datasource/scan_devices_remote_datasource.dart';

class ScanDevicesRepositoryImpl implements ScanDevicesRepository {
  final ScanDevicesRemoteDataSource remoteDataSource;

  ScanDevicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<void>> startScan() async {
    try {
      await remoteDataSource.startScan();
      return Success(null, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.scanStarted);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Future<Result<void>> stopScan() async {
    try {
      await remoteDataSource.stopScan();
      return Success(null, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.scanStopped);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Stream<List<ScanResult>> get scanResults => remoteDataSource.scanResults;

  @override
  Stream<bool> get isScanning => remoteDataSource.isScanning;

  @override
  List<BluetoothDevice> get connectedDevices => remoteDataSource.connectedDevices;

  @override
  Future<Result<void>> disconnect(BluetoothDevice device) async {
    try {
      await remoteDataSource.disconnect(device);
      return Success(null, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.disconnected);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
