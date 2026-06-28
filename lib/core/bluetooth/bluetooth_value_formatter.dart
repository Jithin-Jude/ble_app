import 'dart:convert';

/// A utility class for formatting Bluetooth characteristic values.
class BluetoothValueFormatter {
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
