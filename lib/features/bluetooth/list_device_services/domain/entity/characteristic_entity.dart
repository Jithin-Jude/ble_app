import 'package:equatable/equatable.dart';

class CharacteristicEntity extends Equatable {
  final String uuid;
  final bool canRead;
  final bool canWrite;
  final bool canWriteWithoutResponse;
  final bool canNotify;
  final bool canIndicate;
  final bool canBroadcast;
  final bool canAuthenticateSignedWrites;
  final bool hasExtendedProperties;

  const CharacteristicEntity({
    required this.uuid,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required this.canIndicate,
    required this.canBroadcast,
    required this.canAuthenticateSignedWrites,
    required this.hasExtendedProperties,
  });

  @override
  List<Object?> get props => [
        uuid,
        canRead,
        canWrite,
        canWriteWithoutResponse,
        canNotify,
        canIndicate,
        canBroadcast,
        canAuthenticateSignedWrites,
        hasExtendedProperties,
      ];
}
