import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/scan_devices_cubit.dart';
import '../cubit/scan_devices_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_empty_widget.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';

class ScanDevicesScreen extends StatefulWidget {
  const ScanDevicesScreen({super.key});

  @override
  State<ScanDevicesScreen> createState() => _ScanDevicesScreenState();
}

class _ScanDevicesScreenState extends State<ScanDevicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScanDevicesCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanDevicesCubit, ScanDevicesState>(
      builder: (context, state) {
        bool isScanning = false;
        if (state is ScanDevicesLoaded) {
          isScanning = state.isScanning;
        }

        return AppScaffold(
          title: 'Scan Devices',
          actions: [
            if (isScanning)
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
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ScanDevicesState state) {
    if (state is ScanDevicesInitial) {
      return const Center(child: Text('Press search to start scanning'));
    }

    if (state is ScanDevicesLoaded) {
      if (state.scanResults.isEmpty) {
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

    return const SizedBox.shrink();
  }
}
