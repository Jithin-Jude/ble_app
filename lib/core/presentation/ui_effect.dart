sealed class UiEffect {
  const UiEffect();
}

class NoEffect extends UiEffect {
  const NoEffect();
}

class ShowInfoSnackBar extends UiEffect {
  final String message;
  const ShowInfoSnackBar(this.message);
}

class ShowErrorSnackBar extends UiEffect {
  final String message;
  final bool showActualError;
  const ShowErrorSnackBar(this.message, {this.showActualError = false});
}

class ShowLoader extends UiEffect {
  const ShowLoader();
}

class NavigationEffect extends UiEffect {
  final String routeName;
  final dynamic arguments;
  const NavigationEffect(this.routeName, {this.arguments});
}
