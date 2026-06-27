import 'package:equatable/equatable.dart';

class BluetoothServiceEntity extends Equatable {
  final String uuid;
  final int characteristicsCount;

  const BluetoothServiceEntity({
    required this.uuid,
    required this.characteristicsCount,
  });

  @override
  List<Object?> get props => [uuid, characteristicsCount];
}
