import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entity/bluetooth_service_entity.dart';
import 'characteristic_model.dart';

class BluetoothServiceModel extends BluetoothServiceEntity {
  const BluetoothServiceModel({
    required super.uuid,
    required super.deviceId,
    required super.characteristicsCount,
    required super.characteristics,
  });

  factory BluetoothServiceModel.fromBluetoothService(BluetoothService service) {
    return BluetoothServiceModel(
      uuid: service.uuid.str,
      deviceId: service.remoteId.str,
      characteristicsCount: service.characteristics.length,
      characteristics: service.characteristics
          .map((c) => CharacteristicModel.fromBluetoothCharacteristic(c))
          .toList(),
    );
  }
}
