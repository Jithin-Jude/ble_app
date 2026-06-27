import 'package:get_it/get_it.dart';
import '../data/datasource/bluetooth_permission_remote_datasource.dart';
import '../data/repository/bluetooth_permission_repository_impl.dart';
import '../domain/repository/bluetooth_permission_repository.dart';
import '../domain/usecase/monitor_bluetooth_state_usecase.dart';
import '../domain/usecase/request_bluetooth_permission_usecase.dart';
import '../presentation/cubit/bluetooth_permission_cubit.dart';

Future<void> init(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<BluetoothPermissionRemoteDataSource>(
    () => BluetoothPermissionRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<BluetoothPermissionRepository>(
    () => BluetoothPermissionRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => RequestBluetoothPermissionUseCase(sl()));
  sl.registerLazySingleton(() => MonitorBluetoothStateUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => BluetoothPermissionCubit(
      requestPermissionsUseCase: sl(),
      monitorStateUseCase: sl(),
    ),
  );
}
