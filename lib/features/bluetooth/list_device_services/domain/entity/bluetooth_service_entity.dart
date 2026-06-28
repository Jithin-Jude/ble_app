import 'package:equatable/equatable.dart';
import 'characteristic_entity.dart';

class BluetoothServiceEntity extends Equatable {
  final String uuid;
  final String deviceId;
  final int characteristicsCount;
  final List<CharacteristicEntity> characteristics;

  const BluetoothServiceEntity({
    required this.uuid,
    required this.deviceId,
    required this.characteristicsCount,
    required this.characteristics,
  });

  BluetoothServiceEntity copyWith({
    List<CharacteristicEntity>? characteristics,
  }) {
    return BluetoothServiceEntity(
      uuid: uuid,
      deviceId: deviceId,
      characteristicsCount: characteristicsCount,
      characteristics: characteristics ?? this.characteristics,
    );
  }

  @override
  List<Object?> get props => [uuid, deviceId, characteristicsCount, characteristics];
}
