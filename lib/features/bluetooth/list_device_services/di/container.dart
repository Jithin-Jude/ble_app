import 'package:get_it/get_it.dart';
import '../data/datasource/list_device_services_remote_datasource.dart';
import '../data/repository/list_device_services_repository_impl.dart';
import '../domain/repository/list_device_services_repository.dart';
import '../domain/usecase/discover_services_usecase.dart';
import '../domain/usecase/read_characteristic_usecase.dart';
import '../domain/usecase/write_characteristic_usecase.dart';
import '../presentation/cubit/list_device_services_cubit.dart';

Future<void> init(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<ListDeviceServicesRemoteDataSource>(
    () => ListDeviceServicesRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ListDeviceServicesRepository>(
    () => ListDeviceServicesRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => DiscoverServicesUseCase(sl()));
  sl.registerLazySingleton(() => ReadCharacteristicUseCase(sl()));
  sl.registerLazySingleton(() => WriteCharacteristicUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ListDeviceServicesCubit(
      discoverServicesUseCase: sl(),
      readCharacteristicUseCase: sl(),
      writeCharacteristicUseCase: sl(),
    ),
  );
}
