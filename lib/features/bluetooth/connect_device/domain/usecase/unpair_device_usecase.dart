import '../../../../../core/result/result.dart';
import '../repository/pair_device_repository.dart';

class UnPairDeviceUseCase {
  final PairDeviceRepository repository;

  UnPairDeviceUseCase(this.repository);

  Future<Result<bool>> call(String macAddress) async {
    return await repository.unPair(macAddress);
  }
}
