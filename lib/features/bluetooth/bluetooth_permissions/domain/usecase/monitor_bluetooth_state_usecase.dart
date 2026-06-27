import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../repository/bluetooth_permission_repository.dart';

class MonitorBluetoothStateUseCase {
  final BluetoothPermissionRepository repository;

  MonitorBluetoothStateUseCase(this.repository);

  Stream<BluetoothAdapterState> call() {
    return repository.monitorAdapterState();
  }

  BluetoothAdapterState get currentAdapterState => repository.currentAdapterState;
}
