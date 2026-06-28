import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../cubit/connect_device_cubit.dart';
import '../cubit/connect_device_state.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_screen.dart';
import '../../../../../core/di/app_container.dart' as di;
import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';

class ConnectDeviceScreen extends StatelessWidget {
  const ConnectDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ConnectDeviceCubit>(),
      child: const _ConnectDeviceScreenView(),
    );
  }
}

class _ConnectDeviceScreenView extends BaseScreen<ConnectDeviceCubit, ConnectDeviceState> {
  const _ConnectDeviceScreenView();

  @override
  Widget buildScreen(BuildContext context, ConnectDeviceState state) {
    final deviceProvider = context.watch<BluetoothDeviceProvider>();
    final device = deviceProvider.selectedDevice;

    if (device == null) {
      return const AppScaffold(
        title: 'Connect Device',
        body: Center(child: Text('No device selected')),
      );
    }

    final connectionState = state.connectionState;
    final isConnected = connectionState == BluetoothConnectionState.connected;
    final isAnotherDeviceConnected = deviceProvider.isAnyDeviceConnected &&
        deviceProvider.connectedDevice?.remoteId != device.remoteId;

    return AppScaffold(
      title: 'Connect Device',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device: ${device.platformName.isEmpty ? AppStrings.unknown : device.platformName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('ID: ${device.remoteId.str}'),
            const SizedBox(height: 24),
            
            // Connection Section
            const Text('Connection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
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
            const SizedBox(height: 24),

            // Pairing Section
            const Text('Pairing (Android Only)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(
              children: [
                const Text('Pair Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  _getPairStateText(state.pairState),
                  style: TextStyle(
                    color: _getPairStateColor(state.pairState),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPairingButtons(context, state, device.remoteId.str),

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
              if (isAnotherDeviceConnected)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    AppStrings.anotherDeviceConnected,
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              PrimaryButton(
                label: 'Connect',
                onPressed: isAnotherDeviceConnected
                    ? null
                    : () => context.read<ConnectDeviceCubit>().connect(device),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPairStateText(PairState state) {
    switch (state) {
      case PairState.notBonded:
        return 'Not Bonded';
      case PairState.bonding:
        return 'Bonding...';
      case PairState.bonded:
        return 'Bonded';
      case PairState.unknown:
      default:
        return AppStrings.unknown;
    }
  }

  Color _getPairStateColor(PairState state) {
    switch (state) {
      case PairState.bonded:
        return Colors.green;
      case PairState.bonding:
        return Colors.orange;
      case PairState.notBonded:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPairingButtons(BuildContext context, ConnectDeviceState state, String macAddress) {
    if (state.pairState == PairState.bonding || state.pairing || state.unPairing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.pairState == PairState.bonded) {
      return PrimaryButton(
        label: 'Un-Pair',
        onPressed: () => context.read<ConnectDeviceCubit>().unPair(macAddress),
      );
    } else {
      return PrimaryButton(
        label: 'Pair',
        onPressed: () => context.read<ConnectDeviceCubit>().pair(macAddress),
      );
    }
  }
}
