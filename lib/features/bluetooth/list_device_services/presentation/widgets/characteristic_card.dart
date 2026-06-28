import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/bluetooth_uuid_mapper.dart';
import '../../domain/entity/characteristic_entity.dart';
import 'characteristic_property_row.dart';
import 'characteristic_actions.dart';
import 'characteristic_value_widget.dart';

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
            Text(
              BluetoothUuidMapper.getCharacteristicName(characteristic.uuid),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.uuid,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SelectableText(
              characteristic.uuid,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.properties,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                CharacteristicPropertyRow(
                  label: AppStrings.read,
                  isSupported: characteristic.canRead,
                ),
                CharacteristicPropertyRow(
                  label: AppStrings.write,
                  isSupported: characteristic.canWrite ||
                      characteristic.canWriteWithoutResponse,
                ),
                CharacteristicPropertyRow(
                  label: AppStrings.notify,
                  isSupported: characteristic.canNotify,
                ),
                CharacteristicPropertyRow(
                  label: AppStrings.indicate,
                  isSupported: characteristic.canIndicate,
                ),
              ],
            ),
            CharacteristicValueWidget(
              uuid: characteristic.uuid,
              value: characteristic.value,
            ),
            const SizedBox(height: 16),
            CharacteristicActions(characteristic: characteristic),
          ],
        ),
      ),
    );
  }
}
