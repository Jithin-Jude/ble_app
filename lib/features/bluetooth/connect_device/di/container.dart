import 'package:get_it/get_it.dart';
import '../data/datasource/connect_device_remote_datasource.dart';
import '../data/repository/connect_device_repository_impl.dart';
import '../domain/repository/connect_device_repository.dart';
import '../domain/usecase/connect_device_usecase.dart';
import '../domain/usecase/disconnect_device_usecase.dart';
import '../presentation/cubit/connect_device_cubit.dart';
import '../../../../../core/provider/bluetooth_device_provider.dart';

Future<void> init(GetIt sl) async {
  // We need to register BluetoothDeviceProvider if it's not registered elsewhere.
  // Actually, I'll register it in core/di/app_container.dart for global access.

  // Data sources
  sl.registerLazySingleton<ConnectDeviceRemoteDataSource>(
    () => ConnectDeviceRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ConnectDeviceRepository>(
    () => ConnectDeviceRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => ConnectDeviceUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectDeviceUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ConnectDeviceCubit(
      connectUseCase: sl(),
      disconnectUseCase: sl(),
      deviceProvider: sl(),
      pairManager: sl(),
    ),
  );
}
