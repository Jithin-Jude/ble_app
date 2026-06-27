import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/discover_services_usecase.dart';
import 'list_device_services_state.dart';
import '../../../../../core/result/result.dart';

class ListDeviceServicesCubit extends Cubit<ListDeviceServicesState> {
  final DiscoverServicesUseCase discoverServicesUseCase;

  ListDeviceServicesCubit({
    required this.discoverServicesUseCase,
  }) : super(ListDeviceServicesInitial());

  Future<void> discoverServices(BluetoothDevice device) async {
    emit(ListDeviceServicesLoading());
    final result = await discoverServicesUseCase(device);

    if (result is Success) {
      emit(ListDeviceServicesLoaded((result as Success).data));
    } else if (result is Failure) {
      emit(ListDeviceServicesError((result as Failure).message));
    }
  }
}
