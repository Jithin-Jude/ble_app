import 'package:flutter/material.dart';
import '../../domain/entity/characteristic_entity.dart';
import 'characteristic_property_row.dart';

class CharacteristicCard extends StatelessWidget {
  final CharacteristicEntity characteristic;

  const CharacteristicCard({
    super.key,
    required this.characteristic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Characteristic',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('UUID:'),
            SelectableText(
              characteristic.uuid,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(),
            const Text(
              'Properties',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CharacteristicPropertyRow(
              label: 'Read',
              isSupported: characteristic.canRead,
            ),
            CharacteristicPropertyRow(
              label: 'Write',
              isSupported: characteristic.canWrite,
            ),
            CharacteristicPropertyRow(
              label: 'Write Without Response',
              isSupported: characteristic.canWriteWithoutResponse,
            ),
            CharacteristicPropertyRow(
              label: 'Notify',
              isSupported: characteristic.canNotify,
            ),
            CharacteristicPropertyRow(
              label: 'Indicate',
              isSupported: characteristic.canIndicate,
            ),
            CharacteristicPropertyRow(
              label: 'Broadcast',
              isSupported: characteristic.canBroadcast,
            ),
            CharacteristicPropertyRow(
              label: 'Signed Write',
              isSupported: characteristic.canAuthenticateSignedWrites,
            ),
            CharacteristicPropertyRow(
              label: 'Extended Properties',
              isSupported: characteristic.hasExtendedProperties,
            ),
          ],
        ),
      ),
    );
  }
}
