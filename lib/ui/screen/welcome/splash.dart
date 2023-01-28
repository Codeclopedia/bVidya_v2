// ignore_for_file: use_build_context_synchronously

// import 'package:awesome_notifications/awesome_notifications.dart';

import 'dart:convert';

import 'package:bvidya/controller/providers/bchat/chat_conversation_list_provider.dart';
import 'package:bvidya/core/helpers/group_call_helper.dart';
import 'package:bvidya/core/sdk_helpers/bchat_handler.dart';
import 'package:bvidya/data/models/call_message_body.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import '/app.dart';
// import '../../../core/utils/connectycubekit.dart';
import '/core/helpers/call_helper.dart';
import '/core/helpers/foreground_message_helper.dart';
import '/core/routes.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/core/utils/callkit_utils.dart';
import '/data/models/models.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/utils/notification_controller.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

import '/controller/providers/user_auth_provider.dart';
// import '/controller/bchat_providers.dart';
// import '/controller/providers/bchat/chat_conversation_provider.dart';

final splashImageProvider = StateProvider<Widget>((ref) => SvgPicture.asset(
      "assets/icons/svgs/splash_logo_full.svg",
      fit: BoxFit.fitWidth,
    ));

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future _handleFirebaseMessages(
      BuildContext context, WidgetRef ref, User user) async {
    // if (user == null) {
    //   Future.delayed(const Duration(seconds: 6), () {
    //     Navigator.pushReplacementNamed(context, RouteList.login);
    //   });
    //   return;
    // }

    Navigator.pushReplacementNamed(context, RouteList.home);
    // final message = await FirebaseMessaging.instance.getInitialMessage();
    // if (message != null && message.data.isNotEmpty) {
    //   handleRemoteMessage(message, context);
    // } else {
    //   Navigator.pushReplacementNamed(context, RouteList.home);
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authLoadProvider,
      (previous, next) async {
        if (next.value != null) {
          final startTime = DateTime.now().millisecondsSinceEpoch;
          await ref.read(userAuthChangeProvider).loadUser();

          // ref.read(userAuthChangeProvider).setUserSigned(true);
          print('init from splash');
          // await BChatSDKController.instance.initChatSDK(next.value!);
          if (await _handleNotificationClickScreen(context, next.value!)) {
            final diff = DateTime.now().millisecondsSinceEpoch - startTime;
            print('Time taken: $diff ms Notification');
            appLoaded = true;
            return;
          }

          await loadChats(ref);

          await ref.read(groupConversationProvider.notifier).setup();
          await ref.read(callListProvider.notifier).setup();

          final diff = DateTime.now().millisecondsSinceEpoch - startTime;
          print('Time taken: $diff ms');
          appLoaded = true;
          Navigator.pushReplacementNamed(context, RouteList.home);
        } else {
          ref.read(splashImageProvider.notifier).state = Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.fitWidth,
          );
          Future.delayed(const Duration(seconds: 6), () {
            Navigator.pushReplacementNamed(context, RouteList.login);
            appLoaded = true;
          });
        }
      },
      onError: (error, stackTrace) {
        // print('Error: $error');
        Navigator.pushReplacementNamed(context, RouteList.login);
      },
    );
    final widget = ref.watch(splashImageProvider);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: AppColors.loginBgColor),
          child: Center(
            child: widget,
          ),
        ),
      ),
    );
    // return const Scaffold(
    //   body: SafeArea(child: CustomCalendar()),
    // );
  }

  Future<bool> _handleNotificationClickScreen(
      BuildContext context, User user) async {
    await loadCallOnInit();
    if (activeCallMap != null && activeCallId != null) {
      String type = activeCallMap!['type'];
      if (type == NotiConstants.typeGroupCall) {
        // String fromId = activeCallMap!['from_id'];
        String grpId = activeCallMap!['grp_id'];
        GroupCallMessegeBody body =
            GroupCallMessegeBody.fromJson(jsonDecode(activeCallMap!['body']));
        return await receiveGroupCall(context, body.requestId, body.memberIds,
            body.callId, grpId, body.groupName, body.callType,true);
      } else if (type == NotiConstants.typeCall) {
        String fromId = activeCallMap!['from_id'];
        CallMessegeBody callMessegeBody =
            CallMessegeBody.fromJson(jsonDecode(activeCallMap!['body']));
        return await receiveCall(context, fromId, callMessegeBody, true);
      }
      // return false;
    } else {
      print('active callId => $activeCallId $lastUserId');
    }
    await BChatSDKController.instance.initChatSDK(user);
    final initialAction = NotificationController.clickAction;
    if (initialAction != null &&
        initialAction.payload != null &&
        initialAction.channelKey == 'chat_channel') {
      debugPrint(
          'welcome screen payload: ${initialAction.payload} --> ${initialAction.channelKey}');
      if (await ForegroundMessageHelper.handleChatNotificationAction(
          initialAction.payload!, context, true)) {
        NotificationController.clickAction = null;
        debugPrint('  initialAction is not null');
        return true;
      }
      NotificationController.clickAction = null;
    } else {
      debugPrint('  initialAction is null ${initialAction == null}');
    }

    return false;
  }

  // Widget get _splashScreen => Scaffold(
  //       body: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 6.w),
  //         width: double.infinity,
  //         height: double.infinity,
  //         decoration: const BoxDecoration(color: AppColors.loginBgColor),
  //         child: Center(
  //           child: SvgPicture.asset(
  //             "assets/icons/svgs/splash_logo_full.svg",
  //             fit: BoxFit.fitWidth,
  //           ),
  //         ),
  //       ),
  //     );
}
