import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../cubit/connect_device_cubit.dart';
import '../cubit/connect_device_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';

class ConnectDeviceScreen extends StatelessWidget {
  const ConnectDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<BluetoothDeviceProvider>();
    final device = deviceProvider.selectedDevice;

    if (device == null) {
      return const AppScaffold(
        title: 'Connect Device',
        body: Center(child: Text('No device selected')),
      );
    }

    return AppScaffold(
      title: 'Connect Device',
      body: BlocConsumer<ConnectDeviceCubit, ConnectDeviceState>(
        listener: (context, state) {
          if (state is ConnectDeviceStatus && 
              state.connectionState == BluetoothConnectionState.connected) {
            // Optional: navigate to services screen automatically
            // Navigator.pushNamed(context, '/services');
          }
        },
        builder: (context, state) {
          if (state is ConnectDeviceLoading) {
            return const AppLoadingWidget(message: 'Processing...');
          }

          final connectionState = deviceProvider.connectionState;
          final isConnected = connectionState == BluetoothConnectionState.connected;

          return Padding(
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
                if (state is ConnectDeviceStatus && state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
