import '../../../../../core/bluetooth/bluetooth_bond_manager.dart';
import '../../../../../core/result/result.dart';

abstract class PairDeviceRemoteDataSource {
  Future<Result<PairState>> getPairState(String macAddress);
  Future<Result<bool>> pair(String macAddress);
  Future<Result<bool>> unPair(String macAddress);
  Stream<PairState> get pairStateStream;
}

class PairDeviceRemoteDataSourceImpl implements PairDeviceRemoteDataSource {
  final BluetoothBondManager bluetoothBondManager;

  PairDeviceRemoteDataSourceImpl(this.bluetoothBondManager);

  @override
  Future<Result<PairState>> getPairState(String macAddress) {
    return bluetoothBondManager.getPairState(macAddress);
  }

  @override
  Future<Result<bool>> pair(String macAddress) {
    return bluetoothBondManager.pair(macAddress);
  }

  @override
  Future<Result<bool>> unPair(String macAddress) {
    return bluetoothBondManager.unPair(macAddress);
  }

  @override
  Stream<PairState> get pairStateStream => bluetoothBondManager.pairStateStream;
}
