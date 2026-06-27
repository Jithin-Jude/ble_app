import '../../../../../core/result/result.dart';
import '../repository/scan_devices_repository.dart';

class StartScanUseCase {
  final ScanDevicesRepository repository;

  StartScanUseCase(this.repository);

  Future<Result<void>> call() async {
    return await repository.startScan();
  }
}
