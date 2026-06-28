import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/characteristic_entity.dart';
import '../cubit/list_device_services_cubit.dart';
import 'write_characteristic_bottom_sheet.dart';

class CharacteristicActions extends StatelessWidget {
  final CharacteristicEntity characteristic;

  const CharacteristicActions({super.key, required this.characteristic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (characteristic.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              characteristic.error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        Row(
          children: [
            if (characteristic.canRead)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: OutlinedButton.icon(
                    onPressed: characteristic.isReading
                        ? null
                        : () => context
                            .read<ListDeviceServicesCubit>()
                            .readCharacteristic(characteristic),
                    icon: characteristic.isReading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.read_more, size: 18),
                    label: const Text('Read'),
                  ),
                ),
              ),
            if (characteristic.canWrite || characteristic.canWriteWithoutResponse)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: ElevatedButton.icon(
                    onPressed: characteristic.isWriting
                        ? null
                        : () => _showWriteBottomSheet(context),
                    icon: characteristic.isWriting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.edit, size: 18),
                    label: const Text('Write'),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showWriteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ListDeviceServicesCubit>(),
        child: WriteCharacteristicBottomSheet(characteristic: characteristic),
      ),
    );
  }
}
