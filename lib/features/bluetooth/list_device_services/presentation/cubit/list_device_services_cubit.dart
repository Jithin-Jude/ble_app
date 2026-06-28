import '../../domain/usecase/discover_services_usecase.dart';
import '../../domain/usecase/read_characteristic_usecase.dart';
import '../../domain/usecase/write_characteristic_usecase.dart';
import 'list_device_services_state.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/presentation/base_cubit.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';
import '../../domain/entity/characteristic_entity.dart';

class ListDeviceServicesCubit extends BaseCubit<ListDeviceServicesState> {
  final DiscoverServicesUseCase discoverServicesUseCase;
  final ReadCharacteristicUseCase readCharacteristicUseCase;
  final WriteCharacteristicUseCase writeCharacteristicUseCase;

  ListDeviceServicesCubit({
    required this.discoverServicesUseCase,
    required this.readCharacteristicUseCase,
    required this.writeCharacteristicUseCase,
  }) : super(const ListDeviceServicesState());

  Future<void> discoverServices(String deviceId) async {
    setLoading(true);
    final result = await discoverServicesUseCase(deviceId);

    setLoading(false);
    if (result is Success) {
      emit(state.copyWithS(services: (result as Success).data));
    } else if (result is Failure) {
      emit(state.copyWithS(
        effect: ShowErrorSnackBar((result as Failure).message),
      ));
    }
  }

  Future<void> readCharacteristic(CharacteristicEntity characteristic) async {
    _updateCharacteristic(
      characteristic.copyWith(isReading: true, error: null),
    );

    final result = await readCharacteristicUseCase(
      deviceId: characteristic.deviceId,
      serviceUuid: characteristic.serviceUuid,
      characteristicUuid: characteristic.uuid,
    );

    if (result is Success<List<int>>) {
      _updateCharacteristic(
        characteristic.copyWith(
          isReading: false,
          value: result.data,
        ),
      );
    } else if (result is Failure) {
      _updateCharacteristic(
        characteristic.copyWith(
          isReading: false,
          error: (result as Failure).message,
        ),
      );
    }
  }

  Future<void> writeCharacteristic({
    required CharacteristicEntity characteristic,
    required List<int> value,
  }) async {
    _updateCharacteristic(
      characteristic.copyWith(isWriting: true, error: null),
    );

    // Automatic selection of write method:
    // If canWrite is true, use withResponse.
    // Otherwise, if canWriteWithoutResponse is true, use withoutResponse.
    final bool withResponse = characteristic.canWrite;

    final result = await writeCharacteristicUseCase(
      deviceId: characteristic.deviceId,
      serviceUuid: characteristic.serviceUuid,
      characteristicUuid: characteristic.uuid,
      value: value,
      withResponse: withResponse,
    );

    if (result is Success) {
      _updateCharacteristic(
        characteristic.copyWith(
          isWriting: false,
          value: value, // Update local value after successful write
        ),
      );
      emit(state.copyWithS(effect: const ShowInfoSnackBar('Write Successful')));
    } else if (result is Failure) {
      final message = (result as Failure).message;
      _updateCharacteristic(
        characteristic.copyWith(
          isWriting: false,
          error: message,
        ),
      );
      emit(state.copyWithS(effect: ShowErrorSnackBar('Write Failed: $message')));
    }
  }

  void _updateCharacteristic(CharacteristicEntity updatedCharacteristic) {
    final updatedServices = state.services.map((service) {
      if (service.uuid == updatedCharacteristic.serviceUuid) {
        final updatedCharacteristics = service.characteristics.map((c) {
          return c.uuid == updatedCharacteristic.uuid ? updatedCharacteristic : c;
        }).toList();

        return service.copyWith(characteristics: updatedCharacteristics);
      }
      return service;
    }).toList();

    emit(state.copyWithS(services: updatedServices));
  }

  @override
  ListDeviceServicesState mapBaseToConcrete(BaseState base) {
    return state.copyFromBase(base);
  }

  @override
  void clearEffect() {
    emit(state.copyWithS(clearEffect: true));
  }
}
