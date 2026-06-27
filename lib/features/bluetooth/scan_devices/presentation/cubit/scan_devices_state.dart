import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../../core/presentation/base_state.dart';
import '../../../../../core/presentation/ui_effect.dart';

class ScanDevicesState extends BaseState {
  final List<ScanResult> scanResults;
  final bool isScanning;

  const ScanDevicesState({
    super.loading = false,
    super.effect = const NoEffect(),
    this.scanResults = const [],
    this.isScanning = false,
  });

  ScanDevicesState copyFromBase(BaseState base) {
    return copyWithS(
      loading: base.loading,
      effect: base.effect,
    );
  }

  ScanDevicesState copyWithS({
    bool? loading,
    UiEffect? effect,
    List<ScanResult>? scanResults,
    bool? isScanning,
    bool clearEffect = false,
  }) {
    return ScanDevicesState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : effect ?? this.effect,
      scanResults: scanResults ?? this.scanResults,
      isScanning: isScanning ?? this.isScanning,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        scanResults,
        isScanning,
      ];
}
