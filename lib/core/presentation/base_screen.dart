import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_cubit.dart';
import 'base_state.dart';
import 'ui_effect.dart';

abstract class BaseScreen<C extends BaseCubit<S>, S extends BaseState>
    extends StatefulWidget {
  const BaseScreen({super.key});

  // Child implements this to build the actual page UI
  Widget buildScreen(BuildContext context, S state);

  // Optional: decide extra rebuild conditions beyond loading changes
  bool shouldRebuild(S previous, S current) => true;

  void onInitState(BuildContext context) {}

  void onDisposeState(BuildContext context) {}

  bool showLoadingOverlay() => true;

  bool canPop(BuildContext context, C cubit, S state) => true;

  void onDeviceBackPressed(
    BuildContext context,
    C cubit,
    S state, {
    required bool didPop,
    Object? result,
  }) {}

  // Optional: customize how to render different effects globally for the app
  @protected
  void handleEffect(BuildContext context, C cubit, UiEffect effect) {
    switch (effect) {
      case ShowInfoSnackBar(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        cubit.clearEffect();
      case ShowErrorSnackBar(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
        cubit.clearEffect();
      case NavigationEffect(:final routeName, :final arguments):
        if (routeName.startsWith('/')) {
          Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
        } else {
          Navigator.pushNamed(context, routeName, arguments: arguments);
        }
        cubit.clearEffect();
      case NoEffect():
        break;
      default:
        break;
    }
  }

  @override
  State<BaseScreen<C, S>> createState() => _BaseScreenState<C, S>();
}

class _BaseScreenState<C extends BaseCubit<S>, S extends BaseState>
    extends State<BaseScreen<C, S>> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.onInitState(context);
    super.initState();
  }

  @override
  void dispose() {
    widget.onDisposeState(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listenWhen: (prev, curr) => prev.effect != curr.effect,
      listener: (context, state) {
        if (state.effect is NoEffect) return;

        // Only handle effects if the current screen is the top-most route
        // To prevent multiple snack bar effect.
        if (ModalRoute.of(context)?.isCurrent ?? true) {
          final cubit = context.read<C>();
          widget.handleEffect(context, cubit, state.effect);
        }
      },
      child: BlocBuilder<C, S>(
        buildWhen: (prev, curr) =>
            prev.loading != curr.loading || widget.shouldRebuild(prev, curr),
        builder: (context, state) {
          final cubit = context.read<C>();

          final content = PopScope(
            canPop: widget.canPop(context, cubit, state),
            onPopInvokedWithResult: (didPop, result) {
              widget.onDeviceBackPressed(
                context,
                cubit,
                state,
                didPop: didPop,
                result: result,
              );
            },
            child: widget.buildScreen(context, state),
          );

          if (!widget.showLoadingOverlay()) {
            return content;
          }
          return Stack(
            children: [
              content,
              if (state.loading)
                Positioned.fill(
                  child: AbsorbPointer(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
