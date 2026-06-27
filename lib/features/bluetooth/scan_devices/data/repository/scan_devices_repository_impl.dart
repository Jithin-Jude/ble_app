import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
      return Success(null, statusCode: 200, message: 'Scan started');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Future<Result<void>> stopScan() async {
    try {
      await remoteDataSource.stopScan();
      return Success(null, statusCode: 200, message: 'Scan stopped');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Stream<List<ScanResult>> get scanResults => remoteDataSource.scanResults;

  @override
  Stream<bool> get isScanning => remoteDataSource.isScanning;
}
