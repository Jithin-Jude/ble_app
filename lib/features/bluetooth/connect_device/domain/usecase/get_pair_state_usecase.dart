import '../../../../../core/bluetooth/bluetooth_bond_manager.dart';
import '../../../../../core/result/result.dart';
import '../repository/pair_device_repository.dart';

class GetPairStateUseCase {
  final PairDeviceRepository repository;

  GetPairStateUseCase(this.repository);

  Future<Result<PairState>> call(String macAddress) async {
    return await repository.getPairState(macAddress);
  }
}
