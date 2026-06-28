import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';
import '../../../../../core/result/result.dart';
import '../../domain/repository/pair_device_repository.dart';
import '../datasource/pair_device_remote_datasource.dart';

class PairDeviceRepositoryImpl implements PairDeviceRepository {
  final PairDeviceRemoteDataSource remoteDataSource;

  PairDeviceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<PairState>> getPairState(String macAddress) {
    return remoteDataSource.getPairState(macAddress);
  }

  @override
  Future<Result<bool>> pair(String macAddress) {
    return remoteDataSource.pair(macAddress);
  }

  @override
  Future<Result<bool>> unPair(String macAddress) {
    return remoteDataSource.unPair(macAddress);
  }

  @override
  Stream<PairState> get pairStateStream => remoteDataSource.pairStateStream;
}
