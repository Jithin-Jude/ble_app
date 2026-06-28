import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/di/app_container.dart' as di;
import 'core/provider/bluetooth_device_provider.dart';
import 'features/bluetooth/bluetooth_permissions/presentation/cubit/bluetooth_permission_cubit.dart';
import 'features/bluetooth/bluetooth_permissions/presentation/screens/permission_screen.dart';
import 'features/bluetooth/scan_devices/presentation/cubit/scan_devices_cubit.dart';
import 'features/bluetooth/scan_devices/presentation/screens/scan_devices_screen.dart';
import 'features/bluetooth/connect_device/presentation/cubit/connect_device_cubit.dart';
import 'features/bluetooth/connect_device/presentation/screens/connect_device_screen.dart';
import 'features/bluetooth/list_device_services/presentation/cubit/list_device_services_cubit.dart';
import 'features/bluetooth/list_device_services/presentation/screens/list_device_services_screen.dart';
import 'core/theme/ble_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<BluetoothDeviceProvider>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<BluetoothPermissionCubit>()),
          BlocProvider(create: (_) => di.sl<ScanDevicesCubit>()),
        ],
        child: MaterialApp(
          title: 'BLE App Demo',
          themeMode: ThemeMode.dark,
          darkTheme: BleAppTheme.darkTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const PermissionScreen(),
            '/scan': (context) => const ScanDevicesScreen(),
            '/connect': (context) => const ConnectDeviceScreen(),
            '/services': (context) => const ListDeviceServicesScreen(),
          },
        ),
      ),
    );
  }
}
