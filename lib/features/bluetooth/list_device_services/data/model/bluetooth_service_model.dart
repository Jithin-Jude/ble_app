import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entity/bluetooth_service_entity.dart';

class BluetoothServiceModel extends BluetoothServiceEntity {
  const BluetoothServiceModel({
    required super.uuid,
    required super.characteristicsCount,
  });

  factory BluetoothServiceModel.fromBluetoothService(BluetoothService service) {
    return BluetoothServiceModel(
      uuid: service.uuid.str,
      characteristicsCount: service.characteristics.length,
    );
  }
}
