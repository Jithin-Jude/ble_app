/// A model representing a decoded Bluetooth characteristic value.
class BluetoothCharacteristicValueEntity {
  /// The formatted value to display to the user.
  final String displayValue;

  /// The name of the characteristic (e.g., "Battery Level").
  final String? name;

  /// The unit of the value (e.g., "%", "BPM", "kg").
  final String? unit;

  /// Whether the value was successfully decoded using a standard decoder.
  final bool isDecoded;

  const BluetoothCharacteristicValueEntity({
    required this.displayValue,
    this.name,
    this.unit,
    this.isDecoded = false,
  });

  /// Returns the full display string including the unit if available.
  String get fullDisplayValue => unit != null ? '$displayValue$unit' : displayValue;
}
