import 'package:flutter_svg/flutter_svg.dart';

import '/controller/bchat_providers.dart';
import '/controller/providers/user_auth_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authLoadProvider,
      (previous, next) async {
        if (next.value != null) {
          ref.read(userAuthChangeProvider).loadUser();
          // ref.read(userAuthChangeProvider).setUserSigned(true);
          print('init from splash');
          await ref.read(bChatSDKControllerProvider).initChatSDK();
        }
        Future.delayed(Duration(seconds: next.value != null ? 4 : 2), () {
          if (next.value != null) {
            Navigator.pushReplacementNamed(context, RouteList.home);
          } else {
            Navigator.pushReplacementNamed(context, RouteList.login);
          }
        });
      },
      onError: (error, stackTrace) {
        // print('Error: $error');
        Navigator.pushReplacementNamed(context, RouteList.login);
      },
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: _splashScreen,
    );
    // return const Scaffold(
    //   body: SafeArea(child: CustomCalendar()),
    // );
  }

  Widget get _splashScreen => Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: AppColors.loginBgColor),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/svgs/splash_logo_full.svg",
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );
}
