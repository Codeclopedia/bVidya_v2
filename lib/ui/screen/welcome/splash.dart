// ignore_for_file: use_build_context_synchronously

// import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/controller/providers/bchat/call_list_provider.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/utils/chat_utils.dart';
import '/core/utils/notification_controller.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

import '/controller/providers/user_auth_provider.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future _handleFirebaseMessages(
      BuildContext context, WidgetRef ref, user) async {
    if (user == null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, RouteList.login);
      });
      return;
    }
    final initialAction = NotificationController.initialAction;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authLoadProvider,
      (previous, next) async {
        if (next.value != null) {
          await ref.read(userAuthChangeProvider).loadUser();
          // ref.read(userAuthChangeProvider).setUserSigned(true);
          print('init from splash');
          // await BChatSDKController.instance.initChatSDK(next.value!);

          await ref
              .read(chatConversationProvider.notifier)
              .setup(ref.read(bChatProvider), next.value!);

          await ref.read(groupConversationProvider.notifier).setup();
          await ref.read(callListProvider.notifier).setup();

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
