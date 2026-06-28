import 'package:flutter/material.dart';
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
        service.uuid,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text('Characteristics: ${service.characteristicsCount}'),
      leading: const Icon(Icons.settings_bluetooth),
      children: service.characteristics
          .map((c) => CharacteristicCard(characteristic: c))
          .toList(),
    );
  }
}
