import 'package:lottie/lottie.dart';

import '/core/state.dart';
import '/core/ui_core.dart';

showLoading(WidgetRef ref) {
  try {
    ref.watch(loadingStateProvider.notifier).state = true;
  } catch (_) {}

  // EasyLoading.show();

  EasyLoading.show(
    indicator: SizedBox(
        height: 10.w,
        child: LottieBuilder.asset(
          "assets/icons/lottie/99109-loading.json",
          fit: BoxFit.cover,
        )),
  );
}

hideLoading(WidgetRef ref) {
  try {
    ref.watch(loadingStateProvider.notifier).state = false;
  } catch (_) {}

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
