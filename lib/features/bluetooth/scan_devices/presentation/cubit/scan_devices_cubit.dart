import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/usecase/get_scan_results_usecase.dart';
import '../../domain/usecase/start_scan_usecase.dart';
import '../../domain/usecase/stop_scan_usecase.dart';
import 'scan_devices_state.dart';
import '../../../../../core/result/result.dart';

class ScanDevicesCubit extends Cubit<ScanDevicesState> {
  final StartScanUseCase startScanUseCase;
  final StopScanUseCase stopScanUseCase;
  final GetScanResultsUseCase getScanResultsUseCase;

  StreamSubscription? _scanResultsSubscription;
  StreamSubscription? _isScanningSubscription;
  
  List<ScanResult> _currentResults = [];
  bool _isScanning = false;

  ScanDevicesCubit({
    required this.startScanUseCase,
    required this.stopScanUseCase,
    required this.getScanResultsUseCase,
  }) : super(ScanDevicesInitial());

  void init() {
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      _emitLoaded();
    });

    _scanResultsSubscription = getScanResultsUseCase().listen((results) {
      _currentResults = results;
      _emitLoaded();
    });
  }

  Future<void> startScanning() async {
    final result = await startScanUseCase();
    if (result is Failure) {
      _emitLoaded(errorMessage: result.message);
    }
  }

  Future<void> stopScanning() async {
    final result = await stopScanUseCase();
    if (result is Failure) {
      _emitLoaded(errorMessage: result.message);
    }
  }

  void _emitLoaded({String? errorMessage}) {
    emit(ScanDevicesLoaded(
      scanResults: List.from(_currentResults),
      isScanning: _isScanning,
      errorMessage: errorMessage,
    ));
  }

  @override
  Future<void> close() {
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
    return super.close();
  }
}
