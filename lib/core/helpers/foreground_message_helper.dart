// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

// import '/core/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/colors.dart';
import '/core/helpers/group_member_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import '../utils/connectycubekit.dart';
import '../constants/notification_const.dart';
import '../utils/request_utils.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/data/models/conversation_model.dart';

import '../sdk_helpers/bchat_call_manager.dart';
import '../state.dart';
import '/app.dart';
import '/data/models/call_message_body.dart';
import '../constants/route_list.dart';
import '../routes.dart';
import '../ui_core.dart';
import '../utils/chat_utils.dart';
import 'background_helper.dart';

class ForegroundMessageHelper {
  static Future<bool> onMessageOpen(
      RemoteMessage message, BuildContext context) async {
    if (message.data.isNotEmpty &&
        message.data['alert'] != null &&
        message.data['e'] != null) {
      final extra = jsonDecode(message.data['e']);
      // BuildContext? context = navigatorKey.currentContext;
      // if (context == null) return fa;
      String? type = extra['type'];
      if (type == 'chat') {
        String? fromId = message.data['f']?.toString();
        if (fromId != null) {
          final model = await getConversationModel(fromId);
          if (model != null) {
            await Navigator.pushReplacementNamed(
                context, RouteList.chatScreenDirect,
                arguments: model);
            return true;
          }
        }
      } else if (type == 'group_chat') {
        String? groupId = message.data['g']?.toString();
        if (groupId != null) {
          final model = await getGroupConversationModel(groupId);
          if (model != null) {
            await Navigator.pushReplacementNamed(
                context, RouteList.groupChatScreenDirect,
                arguments: model);
            return true;
          }
        }
      }
    } else {
      if (message.data['type'] == NotiConstants.typeContact) {
        ContactAction? action = contactActionFrom(message.data['action']);
        final String? fromId = message.data['f'];
        if (action != null && fromId != null) {
          if (action == ContactAction.acceptRequest) {
            final model = await getConversationModel(fromId);
            if (model != null) {
              await Navigator.pushReplacementNamed(
                  context, RouteList.chatScreenDirect,
                  arguments: model);
              return true;
            }
          }
        }
      } else if (message.data['type'] == NotiConstants.typeGroupMemberUpdate) {
        final String? fromId = message.data['f'];
        final String? grpId = message.data['g'];
        GroupMemberAction? action = groupActionFrom(message.data['action']);
        if (action != null && fromId != null && grpId != null) {
          if (action == GroupMemberAction.added) {
            final model = await getGroupConversationModel(grpId);
            if (model != null) {
              await Navigator.pushReplacementNamed(
                  context, RouteList.groupChatScreenDirect,
                  arguments: model);
              return true;
            }
          }
          // GroupMemberHelper.handleNotification(
          //     message.notification, action, fromId, grpId, true,
          //     ref: ref);
        }
      }
    }
    return false;
  }

  static void showForegroundChatNotification(
      ConversationModel model, ChatMessage msg) async {
    String name = model.contact.name;
    // String image = model.contact.profileImage;
    String from = model.id;
    if (msg.from != model.id) return;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      String contentText = '';
      switch (msg.body.type) {
        case MessageType.TXT:
          contentText = (msg.body as ChatTextMessageBody).content;
          break;
        case MessageType.CUSTOM:
          return;
        default:
          contentText = msg.body.type.name;
          break;
      }

      bool showForegroudNotification = false;

      showForegroudNotification = !Routes.isChatScreen(from.toString());

      if (showForegroudNotification) {
        showMessage(context, '$name sent you a message', contentText, () {
          handleChatNotificationAction({
            'type': 'chat',
            'from': from.toString(),
          }, context, false);
        });
        // SmartSnackBars.showCustomSnackBar(
        //   context: context,

        //   animateFrom: AnimateFrom.fromTop,
        //   // duration: const Duration(seconds: 5),
        //   child: GestureDetector(
        //     onTap: () {
        //       handleChatNotificationAction({
        //         'type': 'chat',
        //         'from': from.toString(),
        //       }, context, false);
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        //       decoration: BoxDecoration(
        //         color: Colors.blueAccent,
        //         borderRadius: BorderRadius.circular(3.w),
        //       ),
        //       child: Row(
        //         children: [
        //           Container(
        //             margin: const EdgeInsets.only(right: 10),
        //             padding: const EdgeInsets.all(10),
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               color: Colors.white.withOpacity(0.2),
        //             ),
        //             child: const Icon(
        //               Icons.info_outline,
        //               color: Colors.white,
        //             ),
        //           ),
        //           Expanded(
        //             child: Column(
        //               children: [
        //                 Text(
        //                   '$name sent you a message',
        //                   style: TextStyle(
        //                     color: Colors.white,
        //                     fontFamily: kFontFamily,
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 11.sp,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(top: 2.w),
        //                   child: Text(
        //                     contentText,
        //                     style: TextStyle(
        //                       fontFamily: kFontFamily,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w600,
        //                       fontSize: 8.sp,
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //           GestureDetector(
        //             behavior: HitTestBehavior.opaque,
        //             onTap: () {},
        //             child: const Icon(
        //               Icons.close,
        //               color: Colors.white,
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // );
        // backgroundColor: Colors.blue,
        // leading: Container(
        //   margin: const EdgeInsets.only(right: 10),
        //   padding: const EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Colors.white.withOpacity(0.2),
        //   ),
        //   child: const Icon(
        //     Icons.info_outline,
        //     color: Colors.white,
        //   ),
        // ),
        // titleWidget: Text(
        //   '$name sent you a message',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontFamily: kFontFamily,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 11.sp,
        //   ),
        // ),
        // subTitleWidget: Padding(
        //   padding: EdgeInsets.only(top: 2.w),
        //   child: Text(
        //     contentText,
        //     style: TextStyle(
        //       fontFamily: kFontFamily,
        //       color: Colors.white,
        //       fontWeight: FontWeight.w600,
        //       fontSize: 8.sp,
        //     ),
        //   ),
        // ),
        // trailing: GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {},
        //   child: const Icon(
        //     Icons.close,
        //     color: Colors.white,
        //   ),
        // ),
        // );
        // String content = '$name sent you \n$contentText';
        // showTopSnackBar(
        //   Overlay.of(context)!,
        //   CustomSnackBar.info(
        //     message: content,
        //   ),
        //   onTap: () {
        //     handleChatNotificationAction({
        //       'type': 'chat',
        //       'from': from.toString(),
        //     }, context, false);
        //   },
        // );
        return;
      }
    }
  }

  static void showForegroundGroupChatNotification(
      GroupConversationModel model, ChatMessage msg) async {
    String from = model.id;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      String contentText = '';
      switch (msg.body.type) {
        case MessageType.TXT:
          contentText = (msg.body as ChatTextMessageBody).content;
          break;
        case MessageType.CUSTOM:
          return;
        default:
          contentText = msg.body.type.name;
          break;
      }
      bool showForegroudNotification = false;

      showForegroudNotification = !Routes.isGroupChatScreen(from.toString());

      if (showForegroudNotification) {
        String grpName = model.groupInfo.name ?? 'Group';
        String frmName = msg.attributes?['from_name'] ?? '';
        showMessage(
            context, '$frmName sent you a message in $grpName', contentText,
            () {
          handleChatNotificationAction({
            'type': 'group_chat',
            'from': from.toString(),
          }, context, false);
        });
        // String content = '$frmName sent you \n$contentText in $grpName';
        // showTopSnackBar(
        //   Overlay.of(context)!,
        //   CustomSnackBar.info(
        //     message: content,
        //   ),
        //   onTap: () {
        //     handleChatNotificationAction({
        //       'type': 'group_chat',
        //       'from': from.toString(),
        //     }, context, false);
        //   },
        // );
        return;
      }
    }
  }

  static void showMessage(
      BuildContext context, String title, String body, Function() onPressed) {
    SmartSnackBars.showCustomSnackBar(
      context: context,

      animateFrom: AnimateFrom.fromTop,
      // duration: const Duration(seconds: 5),
      child: GestureDetector(
        onTap: () {
          onPressed();
          // handleChatNotificationAction({
          //   'type': 'chat',
          //   'from': from.toString(),
          // }, context, false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      // '$name sent you a message'
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child: Text(
                        body,
                        // contentText,
                        style: TextStyle(
                          fontFamily: kFontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static void handleCallingNotificationForeground(RemoteMessage message) {
    if (message.data.isNotEmpty &&
        message.data['alert'] != null &&
        message.data['e'] != null) {
      final extra = jsonDecode(message.data['e']);
      String? type = extra['type'];
      // print('Type $type =>$extra');
      if (type == NotiConstants.typeCall) {
        debugPrint('InComing call=>  ');
        BackgroundHelper.showCallingNotification(message, false);
        return;
      }
      if (type == NotiConstants.typeGroupCall) {
        debugPrint('InComing Group call=>  ');
        BackgroundHelper.showGroupCallingNotification(message, false);
        return;
      }
    }
  }

  static void handleCallNotification(ChatMessage msg, WidgetRef ref) async {
    try {
      // final diff = lastCallTime?.millisecondsSinceEpoch ??
      //     DateTime.now().millisecondsSinceEpoch - msg.serverTime;
      // print(
      //     'foreground $diff ms  ${msg.serverTime}  ${DateTime.now().millisecondsSinceEpoch}  ${lastCallTime?.millisecondsSinceEpoch}');

      final body = CallMessegeBody.fromJson(
          jsonDecode((msg.body as ChatCustomMessageBody).event));
      // CallBody callBody = body.callBody;
      // // print(
      // //     'callId =>${callBody.callId} last->:$lastCallId  active:$activeCallId');
      // print(
      //     'lastCallId: $lastCallId  active: $activeCallId current:${callBody.callId}');

      // if (callBody.callId == lastCallId || callBody.callId == activeCallId) {
      //   return;
      // }

      // if (diff > 30000) return;

      String fromId = msg.from!;
      String fromName = body.fromName;
      // String fromFCM = body.ext['fcm'];
      String image = body.fromImage;
      // bool hasVideo = body.callType == CallType.video;
      // print('${body.toJson()}');
      // if (onGoingCallId != null) {
      //   if (onGoingCallId != callBody.callId) {
      //     await onDeclineCallBusy(
      //         fromFCM, fromId, fromName, image, callBody, hasVideo);
      //   }
      //   return;
      // }
      // await showIncomingCallScreen(
      //     callBody, fromName, fromId, fromFCM, image, hasVideo, false);
      CallListModel model = CallListModel(
        fromId,
        fromName,
        image,
        false,
        msg.serverTime,
        msg.msgId,
        body,
      );
      ref.read(callListProvider.notifier).addCall(model);
    } catch (e) {
      print('Error in calls=> $e');
    }
  }

  static Future<bool> handleChatNotificationAction(
      Map<String, String?> message, BuildContext context, bool replace) async {
    String? type = message['type'];
    try {
      if (type == 'chat') {
        String? from = message['from'];
        final model = await getConversationModel(from.toString());
        if (model != null) {
          if (replace) {
            await Navigator.pushReplacementNamed(
                context, RouteList.chatScreenDirect,
                arguments: model);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              context,
              RouteList.chatScreenDirect,
              arguments: model,
              (route) => route.isFirst,
            );
          }
          return true;
        }
      } else if (type == 'group_chat') {
        String? from = message['from'];
        final model = await getGroupConversationModel(from.toString());
        if (model != null) {
          if (replace) {
            await Navigator.pushReplacementNamed(
                context, RouteList.groupChatScreenDirect,
                arguments: model);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              context,
              RouteList.groupChatScreenDirect,
              arguments: model,
              (route) => route.isFirst,
            );
          }
          return true;
        }
      }
    } catch (e) {}
    return false;
  }
}
