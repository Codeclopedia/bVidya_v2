// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bvidya/core/utils/chat_utils.dart';
import 'package:bvidya/core/utils/notification_controller.dart';
// import 'package:bvidya/ui/base_back_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/sdk_helpers/bchat_sdk_controller.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/user_auth_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends ConsumerState<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   // "ref" can be used in all life-cycles of a StatefulWidget.

  // }

  Future _handleFirebaseMessages(
      BuildContext context, WidgetRef ref, user) async {
    if (user == null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, RouteList.login);
      });
      return;
    }
    final initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
    if (initialAction != null &&
        initialAction.payload != null &&
        initialAction.channelKey == 'chat_channel') {
      if (await NotificationController.handleChatNotificationAction(
          initialAction.payload!, context, true)) {
        return;
      }
    }
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && message.data.isNotEmpty) {
      handleRemoteMessage(message, context);
    } else {
      Navigator.pushReplacementNamed(context, RouteList.home);
    }
  }

// class SplashScreen extends ConsumerWidget {
//   const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authLoadProvider,
      (previous, next) async {
        if (next.value != null) {
          ref.read(userAuthChangeProvider).loadUser();
          // ref.read(userAuthChangeProvider).setUserSigned(true);
          print('init from splash');
          BChatSDKController.instance.initChatSDK(next.value!);
          await _handleFirebaseMessages(context, ref, next.value);
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, RouteList.login);
          });
        }
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
