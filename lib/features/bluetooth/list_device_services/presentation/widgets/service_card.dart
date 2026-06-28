import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/bluetooth_uuid_mapper.dart';
import '../../domain/entity/bluetooth_service_entity.dart';
import 'characteristic_card.dart';

class ServiceCard extends StatelessWidget {
  final BluetoothServiceEntity service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        BluetoothUuidMapper.getServiceName(service.uuid),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const Text('${AppStrings.uuid}:'),
          SelectableText(
            service.uuid,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text('Characteristics: ${service.characteristicsCount}'),
        ],
      ),
      leading: const Icon(Icons.settings_bluetooth),
      children: service.characteristics
          .map((c) => CharacteristicCard(characteristic: c))
          .toList(),
    );
  }
}
