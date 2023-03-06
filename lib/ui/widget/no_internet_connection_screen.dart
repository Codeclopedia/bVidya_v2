import 'package:lottie/lottie.dart';

import '../../core/ui_core.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset("assets/icons/lottie/90478-disconnect .json"),
        SizedBox(height: 2.w),
        Text(
          S.current.internet_error,
          textAlign: TextAlign.center,
          style: textStyleBlack.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}
