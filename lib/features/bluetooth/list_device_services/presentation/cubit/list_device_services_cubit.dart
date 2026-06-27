import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/discover_services_usecase.dart';
import 'list_device_services_state.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/presentation/base_cubit.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class ListDeviceServicesCubit extends BaseCubit<ListDeviceServicesState> {
  final DiscoverServicesUseCase discoverServicesUseCase;

  ListDeviceServicesCubit({
    required this.discoverServicesUseCase,
  }) : super(const ListDeviceServicesState());

  Future<void> discoverServices(BluetoothDevice device) async {
    setLoading(true);
    final result = await discoverServicesUseCase(device);

    setLoading(false);
    if (result is Success) {
      emit(state.copyWithS(services: (result as Success).data));
    } else if (result is Failure) {
      emit(state.copyWithS(
        effect: ShowErrorSnackBar((result as Failure).message),
      ));
    }
  }

  @override
  ListDeviceServicesState mapBaseToConcrete(BaseState base) {
    return state.copyFromBase(base);
  }

  @override
  void clearEffect() {
    emit(state.copyWithS(clearEffect: true));
  }
}
