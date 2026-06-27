import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../entity/bluetooth_service_entity.dart';

abstract class ListDeviceServicesRepository {
  /// Discovers services for the given device.
  Future<Result<List<BluetoothServiceEntity>>> discoverServices(BluetoothDevice device);
}
