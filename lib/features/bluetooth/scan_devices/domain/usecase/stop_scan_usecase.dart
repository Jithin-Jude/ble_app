import '../../../../../core/result/result.dart';
import '../repository/scan_devices_repository.dart';

class StopScanUseCase {
  final ScanDevicesRepository repository;

  StopScanUseCase(this.repository);

  Future<Result<void>> call() async {
    return await repository.stopScan();
  }
}
