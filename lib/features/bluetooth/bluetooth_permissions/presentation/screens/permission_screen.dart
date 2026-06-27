import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../cubit/bluetooth_permission_cubit.dart';
import '../cubit/bluetooth_permission_state.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../core/widgets/app_error_widget.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BluetoothPermissionCubit>().checkAndRequestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Bluetooth Permissions',
      body: BlocConsumer<BluetoothPermissionCubit, BluetoothPermissionState>(
        listener: (context, state) {
          if (state is BluetoothPermissionStatus) {
            if (state.isGranted && state.adapterState == BluetoothAdapterState.on) {
              Navigator.pushReplacementNamed(context, '/scan');
            }
          }
        },
        builder: (context, state) {
          if (state is BluetoothPermissionLoading) {
            return const AppLoadingWidget(message: 'Requesting permissions...');
          }

          if (state is BluetoothPermissionStatus) {
            if (!state.isGranted) {
              return AppErrorWidget(
                message: state.errorMessage ?? 'Bluetooth permissions are required to use this app.',
                onRetry: () => context.read<BluetoothPermissionCubit>().checkAndRequestPermissions(),
              );
            }

            if (state.adapterState != BluetoothAdapterState.on) {
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
                      label: 'I turned it ON',
                      onPressed: () {
                        // Cubit is already monitoring, but user can manually trigger a check if needed
                      },
                    ),
                  ],
                ),
              );
            }
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
