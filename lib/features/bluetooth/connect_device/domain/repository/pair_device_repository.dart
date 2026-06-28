import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';
import '../../../../../core/result/result.dart';

abstract class PairDeviceRepository {
  Future<Result<PairState>> getPairState(String macAddress);
  Future<Result<bool>> pair(String macAddress);
  Future<Result<bool>> unPair(String macAddress);
  Stream<PairState> get pairStateStream;
}
