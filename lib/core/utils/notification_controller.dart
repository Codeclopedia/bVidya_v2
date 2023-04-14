// import 'package:awesome_notifications/awesome_notifications.dart';

// ignore_for_file: use_build_context_synchronously

import '/ui/screens.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/controller/providers/bchat/contact_list_provider.dart';
import '/core/utils/request_utils.dart';

import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '../state.dart';
import '/data/models/contact_model.dart';
import '../constants/colors.dart';
import '../sdk_helpers/bchat_contact_manager.dart';
import '/app.dart';
import '../ui_core.dart';

class NotificationController {
  static Future showContactActionNotification(
      String userId, String title, String content, Color color) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: color,
        animateFrom: AnimateFrom.fromTop,
        leading: Container(
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
        titleWidget: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: kFontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          ),
        ),
        subTitleWidget: Padding(
          padding: EdgeInsets.only(top: 2.w),
          child: Text(
            content,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 8.sp,
            ),
          ),
        ),
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      );

      // showTopSnackBar(
      //   Overlay.of(context)!,
      //   CustomSnackBar.success(
      //     message: content,
      //   ),
      // );
      return;
    }
  }

  static Widget customizedSnackbar({
    required String userName,
    required String imageUrl,
    required Function() onDismiss,
    required Function() onAccept,
    required Function() onReject,
  }) {
    return Container(
      // color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
            margin: EdgeInsets.only(top: 3.w, right: 1.w),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(2.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 4.w,
                      backgroundColor: Colors.grey,
                      foregroundImage: getImageProvider(imageUrl),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '$userName want to connect with you.',
                        style: textStyleBlack.copyWith(
                            color: Colors.white, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: onReject,
                      child: Text(
                        'Decline',
                        style: textStyleHeading.copyWith(
                            color: Colors.white, fontSize: 12.5.sp),
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    InkWell(
                      onTap: onAccept,
                      child: Text(
                        'Accept',
                        style: textStyleHeading.copyWith(
                            color: Colors.white, fontSize: 12.5.sp),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: onDismiss,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black38,
                        spreadRadius: 1.w)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.5.w,
                  child: Icon(
                    Icons.close,
                    size: 4.w,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showNewInvitation(String userId, Contacts contact, String title,
      String content, WidgetRef ref) {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;

    OverlayEntry? snackBar;
    final child = customizedSnackbar(
        userName: contact.name,
        imageUrl: contact.profileImage,
        onDismiss: () {
          snackBar?.remove();
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        onAccept: () async {
          snackBar?.remove();
          showLoading(ref);
          await BChatContactManager.sendRequestResponse(
              ref,
              contact.userId.toString(),
              contact.fcmToken,
              ContactAction.acceptRequest);
          final contacts = await ref
              .read(contactListProvider.notifier)
              .addContact(contact.userId, ContactStatus.friend);
          if (contacts != null) {
            await ref
                .read(chatConversationProvider.notifier)
                .addConversationByContact(contacts);
          }
          hideLoading(ref);
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        onReject: () async {
          snackBar?.remove();
          showLoading(ref);

          await BChatContactManager.sendRequestResponse(
              ref,
              contact.userId.toString(),
              contact.fcmToken,
              ContactAction.declineRequest);

          ref.read(contactListProvider.notifier).removeContact(contact.userId);
          ref
              .read(chatConversationProvider.notifier)
              .removeConversation(contact.userId.toString());
          hideLoading(ref);
          // snackBar?.remove();
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        });
    snackBar = SmartSnackBars.showCustomSnackBar(
        context: context,
        persist: true,
        // duration: const Duration(milliseconds: 1000),
        animationCurve: Curves.bounceOut,
        animateFrom: AnimateFrom.fromTop,
        child: child);
  }
}
//   static ReceivedAction? initialAction;
//   static ReceivedAction? clickAction;

//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   ///
//   static Future<void> initializeLocalNotifications() async {
//     AwesomeNotifications().initialize(
//         null,
//         [
//           NotificationChannel(
//               playSound: true,
//               defaultColor: AppColors.primaryColor,
//               criticalAlerts: true,
//               enableLights: true,
//               enableVibration: true,
//               importance: NotificationImportance.High,
//               defaultPrivacy: NotificationPrivacy.Public,
//               channelShowBadge: true,
//               channelKey: 'chat_channel',
//               channelName: 'bChat Channel',
//               groupKey: 'call_key',
//               channelDescription: 'Show Chat Notification'),
//           NotificationChannel(
//               playSound: true,
//               defaultColor: AppColors.primaryColor,
//               criticalAlerts: true,
//               enableLights: true,
//               enableVibration: true,
//               importance: NotificationImportance.High,
//               defaultPrivacy: NotificationPrivacy.Public,
//               channelShowBadge: true,
//               channelKey: 'call_channel',
//               channelName: 'Call Channel',
//               groupKey: 'call_key',
//               channelDescription: 'Show Call Notification'),
//         ],
//         channelGroups: [
//           NotificationChannelGroup(
//             channelGroupKey: 'call_key',
//             channelGroupName: 'bChat Call',
//           ),
//         ],
//         debug: true);

//     // await instance.setForegroundNotificationPresentationOptions(alert: false, badge: true, sound: true);

//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: true);
//     // AwesomeNotifications().showNotificationConfigPage()

//     // Get initial notification action is optional
//   }

//   static Future<void> startListeningNotificationEvents() async {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       // onNotificationCreatedMethod: onNotificationCreatedMethod,
//       // onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//     );
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     print(
//         'On Displayed ${receivedNotification.title} : ${receivedNotification.toMap()}');
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     print(
//         'On Created ${receivedNotification.title} : ${receivedNotification.toMap()}');
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint(
//         'onActionReceivedMethod:actionType ${receivedAction.actionType} , payload ${receivedAction.payload},key: ${receivedAction.channelKey}');

//     if (receivedAction.payload != null &&
//         receivedAction.channelKey == 'chat_channel') {
//       // if ((await getMeAsUser()) == null) {
//       //   return;
//       // }
//       if (receivedAction.actionType == ActionType.SilentAction ||
//           receivedAction.actionType == ActionType.SilentBackgroundAction) {
//         return;
//       }

//       clickAction = receivedAction;
//       BackgroundHelper.clearPool(receivedAction.id ?? 0);

//       BuildContext? context = navigatorKey.currentContext;
//       // debugPrint(
//       //     'onAction context:${context != null}  payload: ${receivedAction.payload}');
//       if (context != null && Routes.getCurrentScreen().isNotEmpty) {
//         ForegroundMessageHelper.handleChatNotificationAction(
//             receivedAction.payload!, context, true);
//       } else {
//         // debugPrint(
//         //     'Context is null key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
//         //
//       }
//     } else {
//       debugPrint(
//           'key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
//     }
//   }

//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//   ///
//   ///
//   static Future<bool> displayNotificationRationale() async {
//     BuildContext context = navigatorKey.currentContext!;
//     return await displayNotification(context);
//   }

//   static Future<bool> displayNotification(BuildContext context) async {
//     bool userAuthorized = false;

//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text('Get Notified!',
//                 style: Theme.of(context).textTheme.titleLarge),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: Image.asset(
//                 //         'assets/animated-bell.gif',
//                 //         height: MediaQuery.of(context).size.height * 0.3,
//                 //         fit: BoxFit.fitWidth,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 const Text('bViyda'),
//                 SizedBox(height: 2.h),
//                 const Text('Allow Notifications to receive notifications!'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     userAuthorized = true;
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Allow',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.deepPurple),
//                   )),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }

//   static Future<bool> isAllowedPermission() async {
//     return await AwesomeNotifications().isNotificationAllowed();
//   }

//   static Future showContactActionNotification(
//       String userId, String title, String content) async {
//     BuildContext? context = navigatorKey.currentContext;
//     if (context != null) {
//       showTopSnackBar(
//         Overlay.of(context)!,
//         CustomSnackBar.success(
//           message: content,
//         ),
//       );
//       return;
//     }

//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//     if ((await getMeAsUser()) == null) {
//       return;
//     }
//     // int id = DateTime.now().hashCode;
//     int id = '$content$userId'.hashCode;
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'chat_channel',
//         title: title,
//         icon: 'resource://mipmap/ic_launcher',
//         body: content,
//         wakeUpScreen: true,
//         fullScreenIntent: false,
//         notificationLayout: NotificationLayout.BigText,
//         payload: {
//           // 'type': 'contact_invite',
//           'from': userId,
//           // 'msgId': message.data['m'] ?? ''
//         },
//       ),
//     );
//   }


//   static Future showContactInviteNotification(
//       String userId, String content) async {
//     BuildContext? context = navigatorKey.currentContext;
//     if (context != null) {
//       showNewInvitation(context, userId);
//       return;
//     }

//     // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     // if (!isAllowed) isAllowed = await displayNotificationRationale();
//     // if (!isAllowed) return;
//     // if ((await getMeAsUser()) == null) {
//     //   return;
//     // }
//     // int id = 'contact_invite$userId'.hashCode;
//     // AwesomeNotifications().createNotification(
//     //   content: NotificationContent(
//     //     id: id,
//     //     channelKey: 'chat_channel',
//     //     title: 'You have received an invitation',
//     //     icon: 'resource://mipmap/ic_launcher',
//     //     body: content,
//     //     wakeUpScreen: true,
//     //     fullScreenIntent: false,
//     //     notificationLayout: NotificationLayout.BigText,
//     //     payload: {
//     //       'type': 'contact_invite',
//     //       'from': userId,
//     //       // 'msgId': message.data['m'] ?? ''
//     //     },
//     //   ),
//     //   actionButtons: [
//     //     NotificationActionButton(
//     //       key: 'ACCEPT_CONTACT',
//     //       label: 'Accept',
//     //       actionType: ActionType.SilentAction,
//     //     ),
//     //     NotificationActionButton(
//     //         key: 'DECLINE_CONTACT',
//     //         label: 'Decline',
//     //         actionType: ActionType.SilentAction,
//     //         isDangerousOption: true)
//     //   ],
//     // );
//   }

//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }

//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }

//   // static handleForegroundMessage(ChatMessage message) async {
//   //   String contentText = '';
//   //   switch (message.body.type) {
//   //     case MessageType.TXT:
//   //       contentText = (message.body as ChatTextMessageBody).content;
//   //       break;
//   //     default:
//   //       contentText = message.body.type.name;
//   //       break;
//   //   }

//   //   bool showForegroudNotification = false;
//   //   if (message.chatType == ChatType.Chat) {
//   //     showForegroudNotification =
//   //         !Routes.isChatScreen(message.from!.toString());
//   //     // content = '$groupName : $name sent you\n$contentText';
//   //   } else if (message.chatType == ChatType.GroupChat) {
//   //     showForegroudNotification =
//   //         !Routes.isGroupChatScreen(message.conversationId.toString());
//   //   } else {
//   //     return;
//   //   }
//   //   BuildContext? context = navigatorKey.currentContext;
//   //   if (showForegroudNotification && context != null) {
//   //     showTopSnackBar(
//   //       Overlay.of(context)!,
//   //       CustomSnackBar.info(
//   //         message: contentText,
//   //       ),
//   //       onTap: () {
//   //         handleChatNotificationAction({
//   //           'type': message.chatType == ChatType.Chat ? 'chat' : 'group_chat',
//   //           'from': message.conversationId!,
//   //         }, context, false);
//   //       },
//   //     );
//   //   }
//   // }

//   // static handleForegroundRemoteMessage(RemoteMessage message) async {
//   //   if ((await getMeAsUser()) == null) {
//   //     //Not a valid user to
//   //     return;
//   //   }
//   //   if (message.data.isNotEmpty &&
//   //       message.data['alert'] != null &&
//   //       message.data['e'] != null) {
//   //     final extra = jsonDecode(message.data['e']);
//   //     String? type = extra['type'];
//   //     if (type == NotiConstants.typeCall) {
//   //       debugPrint('InComin call => abort  ');
//   //       // _showCallingNotification(message);
//   //       return;
//   //     }
//   //     String? name = extra['name'];
//   //     String? image = extra['image'];
//   //     String? contentType = extra['content_type'];
//   //     MessageType msgType = getType(contentType);
//   //     dynamic from = message.data['f'];
//   //     dynamic m = message.data['m'];
//   //     String? groupName;
//   //     String? groupId;

//   //     BuildContext? context = navigatorKey.currentContext;
//   //     if (context != null) {
//   //       String contentText = '';
//   //       switch (msgType) {
//   //         case MessageType.TXT:
//   //           ChatMessage? msg = await ChatClient.getInstance.chatManager
//   //               .loadMessage(m.toString());
//   //           if (msg == null) {
//   //             return;
//   //           }
//   //           contentText = (msg.body as ChatTextMessageBody).content;
//   //           break;
//   //         default:
//   //           contentText = msgType.name;
//   //           break;
//   //       }
//   //       bool showForegroudNotification = false;
//   //       String content = '';
//   //       if (type == 'group_chat') {
//   //         groupName = extra['group_name'];
//   //         groupId = message.data['g'];
//   //         content = '$groupName : $name sent you\n$contentText';
//   //         showForegroudNotification =
//   //             !Routes.isGroupChatScreen(groupId.toString());
//   //       } else if (type == 'chat') {
//   //         showForegroudNotification = !Routes.isChatScreen(from.toString());
//   //         content = '$name sent you\n$contentText';
//   //       }

//   //       if (showForegroudNotification) {
//   //         showTopSnackBar(
//   //           Overlay.of(context)!,
//   //           CustomSnackBar.info(
//   //             message: content,
//   //           ),
//   //           onTap: () {
//   //             handleChatNotificationAction({
//   //               'type': type,
//   //               'from':
//   //                   type == 'group_chat' ? groupId.toString() : from.toString(),
//   //             }, context, false);
//   //           },
//   //         );
//   //         return;
//   //       }
//   //     }

//   //     String contentText = '';
//   //     String url;
//   //     switch (msgType) {
//   //       case MessageType.TXT:
//   //         ChatMessage? msg = await ChatClient.getInstance.chatManager
//   //             .loadMessage(m.toString());
//   //         if (msg == null) {
//   //           return;
//   //         }
//   //         contentText = (msg.body as ChatTextMessageBody).content;
//   //         break;
//   //       case MessageType.IMAGE:
//   //         ChatMessage? msg = await ChatClient.getInstance.chatManager
//   //             .loadMessage(m.toString());
//   //         if (msg == null) {
//   //           return;
//   //         }
//   //         final body = msg.body as ChatImageMessageBody;
//   //         url = body.remotePath ?? body.thumbnailRemotePath ?? '';
//   //         if (url.isNotEmpty) {
//   //           if (type == 'group_chat') {
//   //             groupName = extra['group_name'];
//   //             groupId = message.data['g'];
//   //             _showGroupMediaMessageNotification(
//   //                 groupId!, name!, groupName!, url, image!);
//   //           } else if (type == 'chat') {
//   //             _showMediaMessageNotification(from, name!, url, image!);
//   //           }
//   //           return;
//   //         }
//   //         contentText = 'New image file';
//   //         break;
//   //       default:
//   //         contentText = 'New ${msgType.name} file';
//   //         break;
//   //     }
//   //     //Show notification
//   //     if (type == 'group_chat') {
//   //       groupName = extra['group_name'] ?? '';
//   //       groupId = message.data['g'] ?? '';
//   //       _showGroupTextMessageNotification(
//   //           groupId!, name!, groupName!, image!, contentText);
//   //     } else if (type == 'chat') {
//   //       _showTextMessageNotification(from, name!, image!, contentText);
//   //     }
//   //   }
//   // }

//   // static _showGroupDocMessageNotification(String groupId, String fromName,
//   //     String groupName, String fromImage, String message) {
//   //   int id = groupId.hashCode;
//   //   String title = '';
//   //   AwesomeNotifications().createNotification(
//   //     content: NotificationContent(
//   //       id: id,
//   //       channelKey: 'chat_channel',
//   //       title: title,
//   //       icon: 'resource://mipmap/ic_launcher',
//   //       body: message,
//   //       wakeUpScreen: true,
//   //       fullScreenIntent: false,
//   //       notificationLayout: NotificationLayout.BigText,
//   //       payload: {
//   //         'type': 'group_chat',
//   //         'from': groupId,
//   //       },
//   //     ),
//   //   );
//   // }

//   // static showErrorMessage(String message) async {
//   //   int id = 10000;
//   //   if (_messagePool.containsKey(id)) {
//   //     _messageBodyPool.update(id, (value) => "$message <br/>$value");
//   //     _messagePool.update(id, (value) {
//   //       return value + 1;
//   //     });
//   //   } else {
//   //     _messageBodyPool.putIfAbsent(id, () => message);
//   //     _messagePool.putIfAbsent(id, () => 1);
//   //   }
//   //   String title = 'Error';
//   //   String body = _messageBodyPool[id] ?? message;

//   //   AwesomeNotifications().createNotification(
//   //     content: NotificationContent(
//   //       id: id,
//   //       channelKey: 'chat_channel',
//   //       title: title,
//   //       icon: 'resource://mipmap/ic_launcher',
//   //       body: body,
//   //       wakeUpScreen: true,
//   //       fullScreenIntent: false,
//   //       notificationLayout: NotificationLayout.BigText,
//   //       payload: {
//   //         'type': 'error',
//   //       },
//   //     ),
//   //   );
//   // }
// }

// //{senderId: null, category: null, collapseKey: hyphenate_chatuidemo_notification, contentAvailable: false, data: {t: 3, e: {"image":"eilni_P6TzaDwV5Z3SvuuS:APA91bEr_PHNAxQ0zW9-dOPv-kvJ7f6htqSW9VRmWpxcpiXcFmrugUdwR5oMTpWCnsFYZXzbWQ-TWrDzVe07guvOQtuRikbFjLWHVVUs7dboM7LGMwLGWx8VEXHlzZ72JsNQxHg6-XaS","content_type":"CUSTOM","name":"KUNAL PANDEY","type":"p2p_call"}, alert: You've got a new message, f: 1, m: 1100787828750552000, EPush: {"provider":"ANDROID","origin":"im-push","msg_id":"1100787828750552000"}}, from: 556221488660, messageId: 0:1673861938812849%005650c8f4b2283c, messageType: null, mutableContent: false, notification: null, sentTime: 1673861938806, threadId: null, ttl: 2419200}
