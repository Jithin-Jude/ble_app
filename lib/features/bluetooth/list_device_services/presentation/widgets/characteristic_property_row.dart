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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            isSupported ? '✓' : '✗',
            style: TextStyle(
              color: isSupported ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
