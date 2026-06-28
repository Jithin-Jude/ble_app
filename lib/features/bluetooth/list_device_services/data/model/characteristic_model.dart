import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entity/characteristic_entity.dart';

class CharacteristicModel extends CharacteristicEntity {
  const CharacteristicModel({
    required super.uuid,
    required super.serviceUuid,
    required super.deviceId,
    required super.canRead,
    required super.canWrite,
    required super.canWriteWithoutResponse,
    required super.canNotify,
    required super.canIndicate,
    required super.canBroadcast,
    required super.canAuthenticateSignedWrites,
    required super.hasExtendedProperties,
  });

  factory CharacteristicModel.fromBluetoothCharacteristic(
      BluetoothCharacteristic characteristic) {
    return CharacteristicModel(
      uuid: characteristic.uuid.str,
      serviceUuid: characteristic.serviceUuid.str,
      deviceId: characteristic.remoteId.str,
      canRead: characteristic.properties.read,
      canWrite: characteristic.properties.write,
      canWriteWithoutResponse: characteristic.properties.writeWithoutResponse,
      canNotify: characteristic.properties.notify,
      canIndicate: characteristic.properties.indicate,
      canBroadcast: characteristic.properties.broadcast,
      canAuthenticateSignedWrites:
          characteristic.properties.authenticatedSignedWrites,
      hasExtendedProperties: characteristic.properties.extendedProperties,
    );
  }
}
