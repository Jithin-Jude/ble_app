import 'package:flutter/material.dart';
import '../../../../../core/bluetooth/bluetooth_value_formatter.dart';

class CharacteristicValueWidget extends StatelessWidget {
  final List<int>? value;

  const CharacteristicValueWidget({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    final val = value;
    if (val == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Current Value',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _buildValueSection('Hex', BluetoothValueFormatter.formatHex(val)),
        _buildValueSection('Text', BluetoothValueFormatter.formatUtf8(val)),
        _buildValueSection('Bytes', BluetoothValueFormatter.formatBytes(val)),
      ],
    );
  }

  Widget _buildValueSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
