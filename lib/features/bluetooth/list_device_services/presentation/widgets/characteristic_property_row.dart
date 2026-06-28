import 'package:flutter/material.dart';

class CharacteristicPropertyRow extends StatelessWidget {
  final String label;
  final bool isSupported;

  const CharacteristicPropertyRow({
    super.key,
    required this.label,
    required this.isSupported,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isSupported ? '✓' : '✗',
            style: TextStyle(
              color: isSupported ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
