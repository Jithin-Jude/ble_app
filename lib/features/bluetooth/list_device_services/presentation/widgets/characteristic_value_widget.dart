import 'package:flutter/material.dart';
import '../../../../../core/bluetooth/bluetooth_value_formatter.dart';
import '../../../../../core/model/bluetooth_characteristic_value_entity.dart';

class CharacteristicValueWidget extends StatelessWidget {
  final String? uuid;
  final List<int>? value;

  const CharacteristicValueWidget({
    super.key,
    this.uuid,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final val = value;
    final id = uuid;
    if (val == null || id == null) return const SizedBox.shrink();

    final decoded = BluetoothValueFormatter.decode(id, val);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Current Value',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (decoded.isDecoded) ...[
          if (decoded.name != null)
            Text(
              decoded.name!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          Text(
            decoded.fullDisplayValue,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                'Raw Data',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildValueSection('Hex', BluetoothValueFormatter.formatHex(val)),
                _buildValueSection('Bytes', BluetoothValueFormatter.formatBytes(val)),
              ],
            ),
          ),
        ] else ...[
          _buildValueSection('Hex', BluetoothValueFormatter.formatHex(val)),
          _buildValueSection('Text', BluetoothValueFormatter.formatUtf8(val)),
          _buildValueSection('Bytes', BluetoothValueFormatter.formatBytes(val)),
        ],
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
