import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../cubit/connect_device_cubit.dart';
import '../cubit/connect_device_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_screen.dart';

class ConnectDeviceScreen extends StatelessWidget {
  const ConnectDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ConnectDeviceScreenView();
  }
}

class _ConnectDeviceScreenView extends BaseScreen<ConnectDeviceCubit, ConnectDeviceState> {
  const _ConnectDeviceScreenView();

  @override
  Widget buildScreen(BuildContext context, ConnectDeviceState state) {
    final deviceProvider = context.read<BluetoothDeviceProvider>();
    final device = deviceProvider.selectedDevice;

    if (device == null) {
      return const AppScaffold(
        title: 'Connect Device',
        body: Center(child: Text('No device selected')),
      );
    }

    final connectionState = state.connectionState;
    final isConnected = connectionState == BluetoothConnectionState.connected;

    return AppScaffold(
      title: 'Connect Device',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device: ${device.platformName.isEmpty ? 'Unknown' : device.platformName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('ID: ${device.remoteId.str}'),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  connectionState.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isConnected) ...[
              PrimaryButton(
                label: 'Discover Services',
                onPressed: () => Navigator.pushNamed(context, '/services'),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Disconnect',
                onPressed: () => context.read<ConnectDeviceCubit>().disconnect(device),
              ),
            ] else ...[
              PrimaryButton(
                label: 'Connect',
                onPressed: () => context.read<ConnectDeviceCubit>().connect(device),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
