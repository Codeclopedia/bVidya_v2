// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

// import 'package:flutter_svg/flutter_svg.dart';
// import '/ui/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spring/spring.dart';

import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/helpers/group_call_helper.dart';
import '/data/models/call_message_body.dart';
import '/core/helpers/apns_handler.dart';
import '/core/helpers/call_helper.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/core/utils/callkit_utils.dart';
import '/data/models/models.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/helpers/foreground_message_helper.dart';
import '/controller/providers/user_auth_provider.dart';

final splashImageProvider = StateProvider<Widget>((ref) => Image.asset(
          'assets/images/loader.gif',
          fit: BoxFit.fitWidth,
        )
    //  SvgPicture.asset(
    //   "assets/icons/svgs/splash_logo_full.svg",
    //   // 'assets/images/loader.gif',
    //   fit: BoxFit.fitWidth,
    // ),
    );

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authLoadProvider,
      (previous, next) async {
        if (next.value != null) {
          final startTime = DateTime.now().millisecondsSinceEpoch;
          await ref.read(userLoginStateProvider.notifier).loadUser();
          // ref.read(userAuthChangeProvider).setUserSigned(true);
          // print('init from splash');
          // await BChatSDKController.instance.initChatSDK(next.value!);
          if (await _handleNotificationClickScreen(context, next.value!)) {
            // print('Time taken: $diff ms Notification');
            appLoaded = true;
            return;
          }

          await loadChats(ref);

          await ref.read(groupConversationProvider.notifier).setup();
          // await ref.read(callListProvider.notifier).setup();
          // final diff = DateTime.now().millisecondsSinceEpoch - startTime;

          // appLoaded = true;
          // Navigator.pushReplacementNamed(context, RouteList.home);
          final diff = DateTime.now().millisecondsSinceEpoch - startTime;
          // print('Time taken: $diff ms');
          if (diff > 3800) {
            Navigator.pushReplacementNamed(context, RouteList.home);
            return;
          }
          // ref.read(splashImageProvider.notifier).state = Image.asset(
          //   'assets/images/loader.gif',
          //   fit: BoxFit.fitWidth,
          // );
          Future.delayed(Duration(milliseconds: 4000 - diff), () {
            Navigator.pushReplacementNamed(context, RouteList.home);
          });
        } else {
          ref.read(splashImageProvider.notifier).state = Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.fitWidth,
          );
          Future.delayed(const Duration(seconds: 4), () {
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
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.fitWidth,
                  cacheHeight: (60.w * devicePixelRatio).round(),
                  cacheWidth: (60.w * devicePixelRatio).round(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Spring.fadeIn(
                  delay: const Duration(seconds: 4),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: S.current.made_in,
                        style: textStyleBlack.copyWith(fontSize: 15.sp)),
                    TextSpan(
                        text: S.current.bharat,
                        style: textStyleBlack.copyWith(
                            color: const Color(0xFFd80000), fontSize: 15.sp))
                  ])),
                ),
              ),
            ],
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
        return await receiveGroupCall(context,
            groupId: grpId,
            grpName: body.groupName,
            grpImage: body.groupImage,
            requestId: body.requestId,
            membersIds: body.memberIds,
            callId: body.callId,
            callType: body.callType,
            direct: true);
      } else if (type == NotiConstants.typeCall) {
        String fromId = activeCallMap!['from_id'];
        CallMessegeBody callMessegeBody =
            CallMessegeBody.fromJson(jsonDecode(activeCallMap!['body']));
        return await receiveCall(context, fromId, callMessegeBody, true);
      }
    }
    await BChatSDKController.instance.initChatSDK(user);
    if (Platform.isAndroid) {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        return await ForegroundMessageHelper.onMessageOpen(message, context);
      }
    } else if (Platform.isIOS) {
      final msg = await ApnsPushConnectorOnly.instance.loadLaunchMessage();
      if (msg != null) {
        return await ApnsPushConnectorOnly.onMessageOpen(msg, context);
      }
    }

    //ForegroundMessageHelper
    // final initialAction = NotificationController.clickAction;
    // if (initialAction != null &&
    //     initialAction.payload != null &&
    //     initialAction.channelKey == 'chat_channel') {
    //   debugPrint(
    //       'welcome screen payload: ${initialAction.payload} --> ${initialAction.channelKey}');
    //   if (await ForegroundMessageHelper.handleChatNotificationAction(
    //       initialAction.payload!, context, true)) {
    //     NotificationController.clickAction = null;
    //     debugPrint('  initialAction is not null');
    //     return true;
    //   }
    //   NotificationController.clickAction = null;
    // } else {
    //   debugPrint('  initialAction is null ${initialAction == null}');
    // }

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
