import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/characteristic_entity.dart';
import '../cubit/list_device_services_cubit.dart';
import '../../../../../core/utils/bluetooth_value_formatter.dart';

enum WriteInputType { utf8, hex }

class WriteCharacteristicBottomSheet extends StatefulWidget {
  final CharacteristicEntity characteristic;

  const WriteCharacteristicBottomSheet({
    super.key,
    required this.characteristic,
  });

  @override
  State<WriteCharacteristicBottomSheet> createState() =>
      _WriteCharacteristicBottomSheetState();
}

class _WriteCharacteristicBottomSheetState
    extends State<WriteCharacteristicBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  WriteInputType _inputType = WriteInputType.utf8;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onWrite() {
    setState(() => _error = null);
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() => _error = 'Input cannot be empty');
      return;
    }

    try {
      List<int> bytes;
      if (_inputType == WriteInputType.utf8) {
        bytes = BluetoothValueFormatter.decodeUtf8(input);
      } else {
        bytes = BluetoothValueFormatter.decodeHex(input);
      }

      context.read<ListDeviceServicesCubit>().writeCharacteristic(
            characteristic: widget.characteristic,
            value: bytes,
          );
      Navigator.pop(context);
    } on FormatException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Invalid input');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Write Characteristic',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Input Type', style: TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Expanded(
                child: RadioListTile<WriteInputType>(
                  title: const Text('UTF-8 Text'),
                  value: WriteInputType.utf8,
                  groupValue: _inputType,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() => _inputType = value!),
                ),
              ),
              Expanded(
                child: RadioListTile<WriteInputType>(
                  title: const Text('Hex'),
                  value: WriteInputType.hex,
                  groupValue: _inputType,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() => _inputType = value!),
                ),
              ),
            ],
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Input',
              hintText: _inputType == WriteInputType.utf8
                  ? 'e.g. Hello'
                  : 'e.g. 48 65 6C 6C 6F',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onWrite,
                child: const Text('Write'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
