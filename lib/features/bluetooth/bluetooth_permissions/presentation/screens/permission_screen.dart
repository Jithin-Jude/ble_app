import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../cubit/bluetooth_permission_cubit.dart';
import '../cubit/bluetooth_permission_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../../../../core/presentation/base_screen.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PermissionScreenView();
  }
}

class _PermissionScreenView extends BaseScreen<BluetoothPermissionCubit, BluetoothPermissionState> {
  const _PermissionScreenView();

  @override
  void onInitState(BuildContext context) {
    context.read<BluetoothPermissionCubit>().checkAndRequestPermissions();
  }

  @override
  Widget buildScreen(BuildContext context, BluetoothPermissionState state) {
    return AppScaffold(
      title: 'Bluetooth Permissions',
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, BluetoothPermissionState state) {
    if (!state.isGranted && !state.loading) {
      return AppErrorWidget(
        message: 'Bluetooth permissions are required to use this app.',
        onRetry: () => context.read<BluetoothPermissionCubit>().checkAndRequestPermissions(),
      );
    }

    if (state.adapterState != BluetoothAdapterState.on && !state.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bluetooth_disabled, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Bluetooth is ${state.adapterState.toString().split('.').last.toUpperCase()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please turn on Bluetooth to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Retry',
              onPressed: () {
                 context.read<BluetoothPermissionCubit>().checkAndRequestPermissions();
              },
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
