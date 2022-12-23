import '/core/state.dart';
import '/core/ui_core.dart';

showLoading(WidgetRef ref) {
  ref.watch(loadingStateProvider.notifier).state = true;
  EasyLoading.show();
}

hideLoading(WidgetRef ref) {
  ref.watch(loadingStateProvider.notifier).state = false;
  EasyLoading.dismiss();
}

class BaseWilPopupScreen extends ConsumerWidget {
  final Widget child;
  final Future<bool> Function() onBack;

  const BaseWilPopupScreen({
    Key? key,
    required this.child,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingStateProvider);
    return WillPopScope(
      onWillPop: () async {
        if (loading) return false;
        return onBack();
      },
      child: child,
    );
  }
}
