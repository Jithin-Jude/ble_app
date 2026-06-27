import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/list_device_services_cubit.dart';
import '../cubit/list_device_services_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';

class ListDeviceServicesScreen extends StatefulWidget {
  const ListDeviceServicesScreen({super.key});

  @override
  State<ListDeviceServicesScreen> createState() => _ListDeviceServicesScreenState();
}

class _ListDeviceServicesScreenState extends State<ListDeviceServicesScreen> {
  @override
  void initState() {
    super.initState();
    final device = context.read<BluetoothDeviceProvider>().connectedDevice;
    if (device != null) {
      context.read<ListDeviceServicesCubit>().discoverServices(device);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Device Services',
      body: BlocBuilder<ListDeviceServicesCubit, ListDeviceServicesState>(
        builder: (context, state) {
          if (state is ListDeviceServicesLoading) {
            return const AppLoadingWidget(message: 'Discovering services...');
          }

          if (state is ListDeviceServicesError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                final device = context.read<BluetoothDeviceProvider>().connectedDevice;
                if (device != null) {
                  context.read<ListDeviceServicesCubit>().discoverServices(device);
                }
              },
            );
          }

          if (state is ListDeviceServicesLoaded) {
            return ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return ListTile(
                  title: Text('Service UUID: ${service.uuid}'),
                  subtitle: Text('Characteristics: ${service.characteristicsCount}'),
                  leading: const Icon(Icons.settings_bluetooth),
                );
              },
            );
          }

          return const Center(child: Text('No services discovered'));
        },
      ),
    );
  }
}
