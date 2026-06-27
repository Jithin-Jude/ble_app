import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/list_device_services_cubit.dart';
import '../cubit/list_device_services_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';
import '../../../../../core/presentation/base_screen.dart';

class ListDeviceServicesScreen extends StatelessWidget {
  const ListDeviceServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ListDeviceServicesScreenView();
  }
}

class _ListDeviceServicesScreenView extends BaseScreen<ListDeviceServicesCubit, ListDeviceServicesState> {
  const _ListDeviceServicesScreenView();

  @override
  void onInitState(BuildContext context) {
    final device = context.read<BluetoothDeviceProvider>().connectedDevice;
    if (device != null) {
      context.read<ListDeviceServicesCubit>().discoverServices(device);
    }
  }

  @override
  Widget buildScreen(BuildContext context, ListDeviceServicesState state) {
    return AppScaffold(
      title: 'Device Services',
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, ListDeviceServicesState state) {
    if (state.services.isEmpty && !state.loading) {
       return AppErrorWidget(
          message: 'No services discovered',
          onRetry: () {
            final device = context.read<BluetoothDeviceProvider>().connectedDevice;
            if (device != null) {
              context.read<ListDeviceServicesCubit>().discoverServices(device);
            }
          },
        );
    }

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
}
