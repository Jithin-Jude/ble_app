import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/scan_devices_cubit.dart';
import '../cubit/scan_devices_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_empty_widget.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_screen.dart';

class ScanDevicesScreen extends StatelessWidget {
  const ScanDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScanDevicesScreenView();
  }
}

class _ScanDevicesScreenView extends BaseScreen<ScanDevicesCubit, ScanDevicesState> {
  const _ScanDevicesScreenView();

  @override
  void onInitState(BuildContext context) {
    context.read<ScanDevicesCubit>().init();
  }

  @override
  Widget buildScreen(BuildContext context, ScanDevicesState state) {
    return AppScaffold(
      title: 'Scan Devices',
      actions: [
        if (state.isScanning)
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => context.read<ScanDevicesCubit>().stopScanning(),
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.read<ScanDevicesCubit>().startScanning(),
          ),
      ],
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, ScanDevicesState state) {
    if (state.scanResults.isEmpty) {
      if (!state.isScanning) {
        return const Center(child: Text('Press search to start scanning'));
      }
      return const AppEmptyWidget(message: 'No devices found');
    }

    return ListView.builder(
      itemCount: state.scanResults.length,
      itemBuilder: (context, index) {
        final result = state.scanResults[index];
        final device = result.device;
        final deviceName = device.platformName.isEmpty ? 'Unknown' : device.platformName;

        return ListTile(
          title: Text(deviceName),
          subtitle: Text(device.remoteId.str),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${result.rssi} dBm'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  context.read<BluetoothDeviceProvider>().setSelectedDevice(device);
                  Navigator.pushNamed(context, '/connect');
                },
                child: const Text('Connect'),
              ),
            ],
          ),
        );
      },
    );
  }
}
