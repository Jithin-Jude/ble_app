import '../repository/scan_devices_repository.dart';

class GetIsScanningUseCase {
  final ScanDevicesRepository repository;

  GetIsScanningUseCase(this.repository);

  Stream<bool> call() {
    return repository.isScanning;
  }
}
