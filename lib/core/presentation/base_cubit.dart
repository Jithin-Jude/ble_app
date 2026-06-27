import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  BaseCubit(super.initialState);

  // Child must implement how to map a BaseState to S
  @protected
  S mapBaseToConcrete(BaseState base);

  void setLoading(bool show) {
    final next = state.copyWith(loading: show);
    emit(mapBaseToConcrete(next));
  }

  void clearEffect() {
    emit(mapBaseToConcrete(state.copyWith(clearEffect: true)));
  }
}
