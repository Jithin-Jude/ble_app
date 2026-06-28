import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entity/bluetooth_service_entity.dart';
import '../../domain/repository/list_device_services_repository.dart';
import '../datasource/list_device_services_remote_datasource.dart';
import '../model/bluetooth_service_model.dart';

class ListDeviceServicesRepositoryImpl implements ListDeviceServicesRepository {
  final ListDeviceServicesRemoteDataSource remoteDataSource;

  ListDeviceServicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<BluetoothServiceEntity>>> discoverServices(
      String deviceId) async {
    try {
      final services = await remoteDataSource.discoverServices(deviceId);
      return Success(
        services
            .map((s) => BluetoothServiceModel.fromBluetoothService(s))
            .toList(),
        statusCode: 200,
        message: 'Services discovered successfully',
      );
    } on FlutterBluePlusException catch (e) {
      return Failure(
        statusCode: e.code,
        message: e.description ?? 'Failed to discover services',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Future<Result<List<int>>> readCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) async {
    try {
      final value = await remoteDataSource.readCharacteristic(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
      );
      return Success(
        value,
        statusCode: 200,
        message: 'Characteristic read successfully',
      );
    } on FlutterBluePlusException catch (e) {
      return Failure(
        statusCode: e.code,
        message: e.description ?? 'Failed to read characteristic',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  @override
  Future<Result<void>> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
    required bool withResponse,
  }) async {
    try {
      await remoteDataSource.writeCharacteristic(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        value: value,
        withResponse: withResponse,
      );
      return const Success(
        null,
        statusCode: 200,
        message: 'Characteristic write successful',
      );
    } on FlutterBluePlusException catch (e) {
      return Failure(
        statusCode: e.code,
        message: e.description ?? 'Failed to write characteristic',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
