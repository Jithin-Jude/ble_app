import 'package:get_it/get_it.dart';
import '../bluetooth/bluetooth_manager.dart';
import '../bluetooth/bluetooth_pair_manager.dart';
import '../provider/bluetooth_device_provider.dart';
import '../../features/bluetooth/bluetooth_permissions/di/container.dart' as permissions_di;
import '../../features/bluetooth/scan_devices/di/container.dart' as scan_di;
import '../../features/bluetooth/connect_device/di/container.dart' as connect_di;
import '../../features/bluetooth/list_device_services/di/container.dart' as services_di;

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => BluetoothManager());
  sl.registerLazySingleton(() => BluetoothPairManager());
  sl.registerLazySingleton(() => BluetoothDeviceProvider());

  // Features
  await permissions_di.init(sl);
  await scan_di.init(sl);
  await connect_di.init(sl);
  await services_di.init(sl);
}
