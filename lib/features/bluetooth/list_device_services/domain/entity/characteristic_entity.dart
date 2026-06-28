import 'package:equatable/equatable.dart';

class CharacteristicEntity extends Equatable {
  final String uuid;
  final String serviceUuid;
  final String deviceId;
  final bool canRead;
  final bool canWrite;
  final bool canWriteWithoutResponse;
  final bool canNotify;
  final bool canIndicate;
  final bool canBroadcast;
  final bool canAuthenticateSignedWrites;
  final bool hasExtendedProperties;

  // Operation State
  final List<int>? value;
  final bool isReading;
  final bool isWriting;
  final String? error;

  const CharacteristicEntity({
    required this.uuid,
    required this.serviceUuid,
    required this.deviceId,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required this.canIndicate,
    required this.canBroadcast,
    required this.canAuthenticateSignedWrites,
    required this.hasExtendedProperties,
    this.value,
    this.isReading = false,
    this.isWriting = false,
    this.error,
  });

  CharacteristicEntity copyWith({
    List<int>? value,
    bool? isReading,
    bool? isWriting,
    String? error,
  }) {
    return CharacteristicEntity(
      uuid: uuid,
      serviceUuid: serviceUuid,
      deviceId: deviceId,
      canRead: canRead,
      canWrite: canWrite,
      canWriteWithoutResponse: canWriteWithoutResponse,
      canNotify: canNotify,
      canIndicate: canIndicate,
      canBroadcast: canBroadcast,
      canAuthenticateSignedWrites: canAuthenticateSignedWrites,
      hasExtendedProperties: hasExtendedProperties,
      value: value ?? this.value,
      isReading: isReading ?? this.isReading,
      isWriting: isWriting ?? this.isWriting,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        serviceUuid,
        deviceId,
        canRead,
        canWrite,
        canWriteWithoutResponse,
        canNotify,
        canIndicate,
        canBroadcast,
        canAuthenticateSignedWrites,
        hasExtendedProperties,
        value,
        isReading,
        isWriting,
        error,
      ];
}
