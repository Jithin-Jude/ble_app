import '../../../../../core/result/result.dart';
import '../repository/pair_device_repository.dart';

class PairDeviceUseCase {
  final PairDeviceRepository repository;

  PairDeviceUseCase(this.repository);

  Future<Result<bool>> call(String macAddress) async {
    return await repository.pair(macAddress);
  }
}
