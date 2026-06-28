import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/scan_devices_cubit.dart';
import '../cubit/scan_devices_state.dart';
import '../../../../../core/constants/app_constants.dart';
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
    final deviceProvider = context.watch<BluetoothDeviceProvider>();

    return AppScaffold(
      title: AppStrings.scanDevices,
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
      body: _buildBody(context, state, deviceProvider),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScanDevicesState state,
    BluetoothDeviceProvider deviceProvider,
  ) {
    if (state.scanResults.isEmpty) {
      if (!state.isScanning) {
        return const Center(child: Text(AppStrings.pressSearchToStart));
      }
      return const AppEmptyWidget(message: AppStrings.noDevicesFound);
    }

    return ListView.separated(
      itemCount: state.scanResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = state.scanResults[index];
        final device = result.device;
        final deviceName = device.platformName.isEmpty ? AppStrings.unknown : device.platformName;

        final isConnectedToThisDevice = deviceProvider.connectedDevice?.remoteId == device.remoteId;
        final connectionStatus = isConnectedToThisDevice
            ? deviceProvider.connectionState.toString().split('.').last.toUpperCase()
            : (device.isConnected ? AppConstants.connected : AppConstants.disconnected);
        final isConnected = connectionStatus == AppConstants.connected;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            context.read<BluetoothDeviceProvider>().setSelectedDevice(device);
            Navigator.pushNamed(context, '/connect');
          },
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deviceName),
                Text("Connectable: ${result.advertisementData.connectable}"),
              ],
            ),
            subtitle: Text(device.remoteId.str),
            trailing: Text(
              connectionStatus,
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
