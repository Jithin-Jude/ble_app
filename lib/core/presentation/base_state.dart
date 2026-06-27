import 'package:equatable/equatable.dart';
import 'ui_effect.dart';

abstract class BaseState extends Equatable {
  final bool loading;
  final UiEffect effect;

  const BaseState({
    required this.loading,
    required this.effect,
  });

  BaseState copyWith({
    bool? loading,
    UiEffect? effect,
    bool clearEffect = false,
  }) {
    // This is a generic copyWith, but concrete states will implement their own.
    // However, BaseCubit uses this.
    return GenericBaseState(
      loading: loading ?? this.loading,
      effect: clearEffect ? const NoEffect() : (effect ?? this.effect),
    );
  }

  @override
  List<Object?> get props => [loading, effect];
}

class GenericBaseState extends BaseState {
  const GenericBaseState({required super.loading, required super.effect});
}
