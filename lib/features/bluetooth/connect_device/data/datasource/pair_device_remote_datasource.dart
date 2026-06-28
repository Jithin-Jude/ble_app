import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';
import '../../../../../core/result/result.dart';

abstract class PairDeviceRemoteDataSource {
  Future<Result<PairState>> getPairState(String macAddress);
  Future<Result<bool>> pair(String macAddress);
  Future<Result<bool>> unPair(String macAddress);
  Stream<PairState> get pairStateStream;
}

class PairDeviceRemoteDataSourceImpl implements PairDeviceRemoteDataSource {
  final BluetoothPairManager pairManager;

  PairDeviceRemoteDataSourceImpl(this.pairManager);

  @override
  Future<Result<PairState>> getPairState(String macAddress) {
    return pairManager.getPairState(macAddress);
  }

  @override
  Future<Result<bool>> pair(String macAddress) {
    return pairManager.pair(macAddress);
  }

  @override
  Future<Result<bool>> unPair(String macAddress) {
    return pairManager.unPair(macAddress);
  }

  @override
  Stream<PairState> get pairStateStream => pairManager.pairStateStream;
}
