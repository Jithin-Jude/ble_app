import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../repository/scan_devices_repository.dart';

class GetScanResultsUseCase {
  final ScanDevicesRepository repository;

  GetScanResultsUseCase(this.repository);

  Stream<List<ScanResult>> call() {
    return repository.scanResults;
  }
}
