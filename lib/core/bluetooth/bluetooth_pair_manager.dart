import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../result/result.dart';

/// Enum representing the pairing state of a Bluetooth device.
enum PairState {
  notBonded,
  bonding,
  bonded,
  unknown,
}

/// Manager for handling Bluetooth pairing operations via Method Channels.
/// This is independent of FlutterBluePlus and supports Android native pairing.
class BluetoothPairManager {
  static const MethodChannel _methodChannel = MethodChannel(AppConstants.pairingMethodChannel);
  static const EventChannel _eventChannel = EventChannel(AppConstants.pairingEventChannel);

  /// Stream to monitor bond state changes from Android.
  Stream<PairState> get pairStateStream {
    if (!Platform.isAndroid) {
      return Stream.value(PairState.unknown);
    }
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      return _mapIntToPairState(event as int);
    });
  }

  /// Returns the current pairing state of a device by its MAC address.
  Future<Result<PairState>> getPairState(String macAddress) async {
    if (!Platform.isAndroid) {
      return const Failure(message: AppStrings.iosPairingMessage);
    }
    try {
      final int result = await _methodChannel.invokeMethod(AppConstants.methodGetPairState, {AppConstants.argMacAddress: macAddress});
      return Success(_mapIntToPairState(result), statusCode: AppConstants.statusCodeSuccess, message: AppStrings.success);
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? AppStrings.failedToGetPairState);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Initiates pairing with a device.
  Future<Result<bool>> pair(String macAddress) async {
    if (!Platform.isAndroid) {
      return const Failure(message: AppStrings.iosPairingProgrammaticMessage);
    }
    try {
      final bool result = await _methodChannel.invokeMethod(AppConstants.methodPair, {AppConstants.argMacAddress: macAddress});
      return Success(result, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.success);
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? AppStrings.failedToInitiatePairing);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Removes pairing from a device.
  Future<Result<bool>> unPair(String macAddress) async {
    if (!Platform.isAndroid) {
      return const Failure(message: AppStrings.iosPairingProgrammaticMessage);
    }
    try {
      final bool result = await _methodChannel.invokeMethod(AppConstants.methodUnPair, {AppConstants.argMacAddress: macAddress});
      return Success(result, statusCode: AppConstants.statusCodeSuccess, message: AppStrings.success);
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? AppStrings.failedToRemovePairing);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Maps Android's BluetoothDevice bond states to [PairState].
  PairState _mapIntToPairState(int value) {
    switch (value) {
      case AppConstants.bondNone: // BOND_NONE
        return PairState.notBonded;
      case AppConstants.bondBonding: // BOND_BONDING
        return PairState.bonding;
      case AppConstants.bondBonded: // BOND_BONDED
        return PairState.bonded;
      default:
        return PairState.unknown;
    }
  }
}
