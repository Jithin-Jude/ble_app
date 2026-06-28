import '../../../../../core/bluetooth/bluetooth_pair_manager.dart';
import '../repository/pair_device_repository.dart';

class GetPairStateStreamUseCase {
  final PairDeviceRepository repository;

  GetPairStateStreamUseCase(this.repository);

  Stream<PairState> call() {
    return repository.pairStateStream;
  }
}
