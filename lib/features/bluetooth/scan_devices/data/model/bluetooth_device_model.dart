import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entity/bluetooth_scan_device_entity.dart';

class BluetoothDeviceModel extends BluetoothScanDeviceEntity {
  const BluetoothDeviceModel({
    required super.remoteId,
    required super.name,
    required super.rssi,
  });

  factory BluetoothDeviceModel.fromScanResult(ScanResult result) {
    return BluetoothDeviceModel(
      remoteId: result.device.remoteId.str,
      name: result.device.platformName.isEmpty 
          ? 'Unknown Device' 
          : result.device.platformName,
      rssi: result.rssi,
    );
  }
}
