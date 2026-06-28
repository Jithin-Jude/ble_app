import 'dart:convert';
import 'dart:typed_data';
import 'bluetooth_uuid_mapper.dart';
import 'bluetooth_decoded_value.dart';

/// A utility class for formatting Bluetooth characteristic values.
class BluetoothValueFormatter {
  /// Decodes a characteristic value based on its UUID.
  static BluetoothDecodedValue decode(String uuid, List<int> value) {
    if (value.isEmpty) {
      return const BluetoothDecodedValue(
        displayValue: 'No data',
        isDecoded: false,
      );
    }

    final normalizedUuid = BluetoothUuidMapper.normalize(uuid);
    final name = BluetoothUuidMapper.getCharacteristicName(uuid);

    switch (normalizedUuid) {
      case '2A19': // Battery Level
        return _decodeBatteryLevel(value, name);
      case '2A00': // Device Name
      case '2A29': // Manufacturer Name String
      case '2A24': // Model Number String
      case '2A25': // Serial Number String
      case '2A26': // Firmware Revision String
      case '2A27': // Hardware Revision String
      case '2A28': // Software Revision String
        return _decodeString(value, name);
      case '2A37': // Heart Rate Measurement
        return _decodeHeartRate(value, name);
      case '2A9B': // Weight
      case '2A9D': // Weight Measurement
        return _decodeWeight(value, name);
      case '2A6E': // Temperature
        return _decodeTemperature(value, name);
      case '2A2B': // Current Time
        return _decodeCurrentTime(value, name);
      default:
        return BluetoothDecodedValue(
          displayValue: formatHex(value),
          name: name,
          isDecoded: false,
        );
    }
  }

  static BluetoothDecodedValue _decodeBatteryLevel(List<int> value, String name) {
    if (value.isEmpty) return _fallback(value, name);
    return BluetoothDecodedValue(
      displayValue: value[0].toString(),
      unit: '%',
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _decodeString(List<int> value, String name) {
    return BluetoothDecodedValue(
      displayValue: formatUtf8(value),
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _decodeHeartRate(List<int> value, String name) {
    if (value.isEmpty) return _fallback(value, name);

    final flags = value[0];
    final isUint16 = (flags & 0x01) != 0;

    int heartRate;
    if (isUint16) {
      if (value.length < 3) return _fallback(value, name);
      heartRate = ByteData.sublistView(Uint8List.fromList(value))
          .getUint16(1, Endian.little);
    } else {
      if (value.length < 2) return _fallback(value, name);
      heartRate = value[1];
    }

    return BluetoothDecodedValue(
      displayValue: heartRate.toString(),
      unit: ' BPM',
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _decodeWeight(List<int> value, String name) {
    if (value.length < 3) return _fallback(value, name);

    final flags = value[0];
    final isImperial = (flags & 0x01) != 0;
    final weightRaw = ByteData.sublistView(Uint8List.fromList(value))
        .getUint16(1, Endian.little);

    double weight;
    String unit;

    if (isImperial) {
      weight = weightRaw * 0.01;
      unit = ' lb';
    } else {
      weight = weightRaw * 0.005;
      unit = ' kg';
    }

    return BluetoothDecodedValue(
      displayValue: weight.toStringAsFixed(2),
      unit: unit,
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _decodeTemperature(List<int> value, String name) {
    if (value.length < 2) return _fallback(value, name);

    final tempRaw = ByteData.sublistView(Uint8List.fromList(value))
        .getInt16(0, Endian.little);
    final temperature = tempRaw * 0.01;

    return BluetoothDecodedValue(
      displayValue: temperature.toStringAsFixed(1),
      unit: ' °C',
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _decodeCurrentTime(List<int> value, String name) {
    if (value.length < 7) return _fallback(value, name);

    final data = ByteData.sublistView(Uint8List.fromList(value));
    final year = data.getUint16(0, Endian.little);
    final month = value[2];
    final day = value[3];
    final hour = value[4];
    final minute = value[5];
    final second = value[6];

    // Basic validation
    if (month < 1 || month > 12 || day < 1 || day > 31) {
       return _fallback(value, name);
    }

    final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';

    return BluetoothDecodedValue(
      displayValue: '$dateStr $timeStr',
      name: name,
      isDecoded: true,
    );
  }

  static BluetoothDecodedValue _fallback(List<int> value, String name) {
    return BluetoothDecodedValue(
      displayValue: formatHex(value),
      name: name,
      isDecoded: false,
    );
  }

  /// Formats bytes as a space-separated hexadecimal string.
  /// Example: [72, 101, 108, 108, 111] -> "48 65 6C 6C 6F"
  static String formatHex(List<int> value) {
    if (value.isEmpty) return '';
    return value
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
  }

  /// Formats bytes as a UTF-8 string.
  /// Returns "Invalid UTF-8" if conversion fails.
  static String formatUtf8(List<int> value) {
    if (value.isEmpty) return '';
    try {
      return utf8.decode(value);
    } catch (_) {
      return 'Invalid UTF-8';
    }
  }

  /// Formats bytes as a comma-separated decimal list.
  /// Example: [72, 101, 108, 108, 111] -> "[72, 101, 108, 108, 111]"
  static String formatBytes(List<int> value) {
    return value.toString();
  }

  /// Decodes a hexadecimal string into bytes.
  /// Throws FormatException if the input is not a valid hex string.
  static List<int> decodeHex(String hexString) {
    String cleanHex = hexString.replaceAll(' ', '').replaceAll(':', '');
    if (cleanHex.length % 2 != 0) {
      throw const FormatException('Hex string must have an even length');
    }

    try {
      final List<int> bytes = [];
      for (int i = 0; i < cleanHex.length; i += 2) {
        bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
      }
      return bytes;
    } catch (_) {
      throw const FormatException('Invalid hexadecimal characters');
    }
  }

  /// Decodes a UTF-8 string into bytes.
  static List<int> decodeUtf8(String text) {
    return utf8.encode(text);
  }
}
