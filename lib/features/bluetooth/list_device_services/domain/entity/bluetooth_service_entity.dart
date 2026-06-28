import 'package:equatable/equatable.dart';
import 'characteristic_entity.dart';

class BluetoothServiceEntity extends Equatable {
  final String uuid;
  final int characteristicsCount;
  final List<CharacteristicEntity> characteristics;

  const BluetoothServiceEntity({
    required this.uuid,
    required this.characteristicsCount,
    required this.characteristics,
  });

  @override
  List<Object?> get props => [uuid, characteristicsCount, characteristics];
}
