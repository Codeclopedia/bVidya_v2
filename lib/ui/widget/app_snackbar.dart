import '../../core/ui_core.dart';

class AppSnackbar {
  // final BuildContext context;

  AppSnackbar._();
  static final AppSnackbar instance = AppSnackbar._();

  // ThemeData get _theme => Theme.of(context);

  // TextTheme get _styles => _theme.textTheme;

  // ColorScheme get _scheme => _theme.colorScheme;

  void error(BuildContext context, Object e) {
    ThemeData theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.errorContainer,
      ),
    );
  }

  void message(BuildContext context, Object e) {
    ThemeData theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.tertiaryContainer,
      ),
    );
  }
}
