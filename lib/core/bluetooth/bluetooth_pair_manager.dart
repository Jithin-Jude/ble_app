import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
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
  static const MethodChannel _methodChannel = MethodChannel('com.jithin.ble/pairing');
  static const EventChannel _eventChannel = EventChannel('com.jithin.ble/pairing/events');

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
      return const Failure(message: 'iOS manages pairing via the system settings.');
    }
    try {
      final int result = await _methodChannel.invokeMethod('getPairState', {'macAddress': macAddress});
      return Success(_mapIntToPairState(result), statusCode: 200, message: 'Success');
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? 'Failed to get pair state');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Initiates pairing with a device.
  Future<Result<bool>> pair(String macAddress) async {
    if (!Platform.isAndroid) {
      return const Failure(message: 'Bluetooth pairing is managed by iOS and cannot be initiated programmatically.');
    }
    try {
      final bool result = await _methodChannel.invokeMethod('pair', {'macAddress': macAddress});
      return Success(result, statusCode: 200, message: 'Success');
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? 'Failed to initiate pairing');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Removes pairing from a device.
  Future<Result<bool>> unPair(String macAddress) async {
    if (!Platform.isAndroid) {
      return const Failure(message: 'Bluetooth pairing is managed by iOS and cannot be initiated programmatically.');
    }
    try {
      final bool result = await _methodChannel.invokeMethod('unPair', {'macAddress': macAddress});
      return Success(result, statusCode: 200, message: 'Success');
    } on PlatformException catch (e) {
      return Failure(message: e.message ?? 'Failed to remove pairing');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  /// Maps Android's BluetoothDevice bond states to [PairState].
  PairState _mapIntToPairState(int value) {
    switch (value) {
      case 10: // BOND_NONE
        return PairState.notBonded;
      case 11: // BOND_BONDING
        return PairState.bonding;
      case 12: // BOND_BONDED
        return PairState.bonded;
      default:
        return PairState.unknown;
    }
  }
}
