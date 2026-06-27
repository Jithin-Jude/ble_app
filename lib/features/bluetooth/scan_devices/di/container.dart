import 'package:get_it/get_it.dart';
import '../data/datasource/scan_devices_remote_datasource.dart';
import '../data/repository/scan_devices_repository_impl.dart';
import '../domain/repository/scan_devices_repository.dart';
import '../domain/usecase/get_scan_results_usecase.dart';
import '../domain/usecase/start_scan_usecase.dart';
import '../domain/usecase/stop_scan_usecase.dart';
import '../presentation/cubit/scan_devices_cubit.dart';

Future<void> init(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<ScanDevicesRemoteDataSource>(
    () => ScanDevicesRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ScanDevicesRepository>(
    () => ScanDevicesRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => StartScanUseCase(sl()));
  sl.registerLazySingleton(() => StopScanUseCase(sl()));
  sl.registerLazySingleton(() => GetScanResultsUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ScanDevicesCubit(
      startScanUseCase: sl(),
      stopScanUseCase: sl(),
      getScanResultsUseCase: sl(),
    ),
  );
}
