import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../repository/connect_device_repository.dart';

class ConnectDeviceUseCase {
  final ConnectDeviceRepository repository;

  ConnectDeviceUseCase(this.repository);

  Future<Result<void>> call(BluetoothDevice device) async {
    return await repository.connect(device);
  }
}
