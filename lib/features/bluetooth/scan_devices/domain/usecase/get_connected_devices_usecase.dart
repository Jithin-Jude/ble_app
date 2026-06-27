import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../repository/scan_devices_repository.dart';

class GetConnectedDevicesUseCase {
  final ScanDevicesRepository repository;

  GetConnectedDevicesUseCase(this.repository);

  List<BluetoothDevice> call() {
    return repository.connectedDevices;
  }
}
