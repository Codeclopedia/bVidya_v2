import 'package:awesome_notifications/awesome_notifications.dart';
import '/core/helpers/foreground_message_helper.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../helpers/background_helper.dart';

import '../constants.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/utils.dart';
import '/app.dart';
import '../routes.dart';
import '../ui_core.dart';

class NotificationController {
  static ReceivedAction? initialAction;
  static ReceivedAction? clickAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              playSound: true,
              defaultColor: AppColors.primaryColor,
              criticalAlerts: true,
              enableLights: true,
              enableVibration: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              channelShowBadge: true,
              channelKey: 'chat_channel',
              channelName: 'bChat Channel',
              groupKey: 'call_key',
              channelDescription: 'Show Chat Notification'),
          NotificationChannel(
              playSound: true,
              defaultColor: AppColors.primaryColor,
              criticalAlerts: true,
              enableLights: true,
              enableVibration: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              channelShowBadge: true,
              channelKey: 'call_channel',
              channelName: 'Call Channel',
              groupKey: 'call_key',
              channelDescription: 'Show Call Notification'),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'call_key',
            channelGroupName: 'bChat Call',
          ),
        ],
        debug: true);

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    // Get initial notification action is optional
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint(
        'onActionReceivedMethod:actionType ${receivedAction.actionType} , payload ${receivedAction.payload},key: ${receivedAction.channelKey}');

    if (receivedAction.payload != null &&
        receivedAction.channelKey == 'chat_channel') {
      // if ((await getMeAsUser()) == null) {
      //   return;
      // }
      if (receivedAction.actionType == ActionType.SilentAction ||
          receivedAction.actionType == ActionType.SilentBackgroundAction) {
        return;
      }

      clickAction = receivedAction;
      BackgroundHelper.clearPool(receivedAction.id ?? 0);

      BuildContext? context = navigatorKey.currentContext;
      // debugPrint(
      //     'onAction context:${context != null}  payload: ${receivedAction.payload}');
      if (context != null && Routes.getCurrentScreen().isNotEmpty) {
        ForegroundMessageHelper.handleChatNotificationAction(
            receivedAction.payload!, context, true);
      } else {
        // debugPrint(
        //     'Context is null key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
        //
      }
    } else {
      debugPrint(
          'key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  ///
  static Future<bool> displayNotificationRationale() async {
    BuildContext context = navigatorKey.currentContext!;
    return await displayNotification(context);
  }

  static Future<bool> displayNotification(BuildContext context) async {
    bool userAuthorized = false;

    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: Image.asset(
                //         'assets/animated-bell.gif',
                //         height: MediaQuery.of(context).size.height * 0.3,
                //         fit: BoxFit.fitWidth,
                //       ),
                //     ),
                //   ],
                // ),
                const Text('bViyda'),
                SizedBox(height: 2.h),
                const Text('Allow Notifications to receive notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<bool> isAllowedPermission()async{
      return await AwesomeNotifications().isNotificationAllowed();

  }

  static Future showContactActionNotification(
      String userId, String title, String content) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message: content,
        ),
      );
      return;
    }

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    if ((await getMeAsUser()) == null) {
      return;
    }
    // int id = DateTime.now().hashCode;
    int id = '$content$userId'.hashCode;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: title,
        icon: 'resource://mipmap/ic_launcher',
        body: content,
        wakeUpScreen: true,
        fullScreenIntent: false,
        notificationLayout: NotificationLayout.BigText,
        payload: {
          // 'type': 'contact_invite',
          'from': userId,
          // 'msgId': message.data['m'] ?? ''
        },
      ),
    );
  }

  static showNewInvitation(BuildContext context, String userId) {
    AnimationController? localAnimationController;
    showTopSnackBar(
      Overlay.of(context)!,
      Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.all(Radius.circular(3.w))),
        child: Column(
          children: [
            Text(
              'You have received an invitation',
              style: textStyleCaption,
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    style: textButtonStyle,
                    onPressed: () {
                      localAnimationController?.reverse();
                    },
                    child: const Text('Dismiss')),
                const Spacer(),
                TextButton(
                    style: textButtonStyle,
                    onPressed: () async {
                      await BChatContactManager.acceptRequest(userId);
                      localAnimationController?.reverse();
                    },
                    child: const Text('Accept')),
                TextButton(
                    style: textButtonStyle,
                    onPressed: () async {
                      await BChatContactManager.declineRequest(userId);
                      localAnimationController?.reverse();
                    },
                    child: const Text('Decline')),
              ],
            )
          ],
        ),
      ),
      persistent: true,
      dismissType: DismissType.onSwipe,
      onAnimationControllerInit: (controller) =>
          localAnimationController = controller,
      // const CustomSnackBar.info(
      //   message: 'You have received an invitation',
      // ),
    );
  }

  static Future showContactInviteNotification(
      String userId, String content) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      showNewInvitation(context, userId);
      return;
    }

    // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    // if (!isAllowed) return;
    // if ((await getMeAsUser()) == null) {
    //   return;
    // }
    // int id = 'contact_invite$userId'.hashCode;
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: id,
    //     channelKey: 'chat_channel',
    //     title: 'You have received an invitation',
    //     icon: 'resource://mipmap/ic_launcher',
    //     body: content,
    //     wakeUpScreen: true,
    //     fullScreenIntent: false,
    //     notificationLayout: NotificationLayout.BigText,
    //     payload: {
    //       'type': 'contact_invite',
    //       'from': userId,
    //       // 'msgId': message.data['m'] ?? ''
    //     },
    //   ),
    //   actionButtons: [
    //     NotificationActionButton(
    //       key: 'ACCEPT_CONTACT',
    //       label: 'Accept',
    //       actionType: ActionType.SilentAction,
    //     ),
    //     NotificationActionButton(
    //         key: 'DECLINE_CONTACT',
    //         label: 'Decline',
    //         actionType: ActionType.SilentAction,
    //         isDangerousOption: true)
    //   ],
    // );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // static handleForegroundMessage(ChatMessage message) async {
  //   String contentText = '';
  //   switch (message.body.type) {
  //     case MessageType.TXT:
  //       contentText = (message.body as ChatTextMessageBody).content;
  //       break;
  //     default:
  //       contentText = message.body.type.name;
  //       break;
  //   }

  //   bool showForegroudNotification = false;
  //   if (message.chatType == ChatType.Chat) {
  //     showForegroudNotification =
  //         !Routes.isChatScreen(message.from!.toString());
  //     // content = '$groupName : $name sent you\n$contentText';
  //   } else if (message.chatType == ChatType.GroupChat) {
  //     showForegroudNotification =
  //         !Routes.isGroupChatScreen(message.conversationId.toString());
  //   } else {
  //     return;
  //   }
  //   BuildContext? context = navigatorKey.currentContext;
  //   if (showForegroudNotification && context != null) {
  //     showTopSnackBar(
  //       Overlay.of(context)!,
  //       CustomSnackBar.info(
  //         message: contentText,
  //       ),
  //       onTap: () {
  //         handleChatNotificationAction({
  //           'type': message.chatType == ChatType.Chat ? 'chat' : 'group_chat',
  //           'from': message.conversationId!,
  //         }, context, false);
  //       },
  //     );
  //   }
  // }

  // static handleForegroundRemoteMessage(RemoteMessage message) async {
  //   if ((await getMeAsUser()) == null) {
  //     //Not a valid user to
  //     return;
  //   }
  //   if (message.data.isNotEmpty &&
  //       message.data['alert'] != null &&
  //       message.data['e'] != null) {
  //     final extra = jsonDecode(message.data['e']);
  //     String? type = extra['type'];
  //     if (type == NotiConstants.typeCall) {
  //       debugPrint('InComin call => abort  ');
  //       // _showCallingNotification(message);
  //       return;
  //     }
  //     String? name = extra['name'];
  //     String? image = extra['image'];
  //     String? contentType = extra['content_type'];
  //     MessageType msgType = getType(contentType);
  //     dynamic from = message.data['f'];
  //     dynamic m = message.data['m'];
  //     String? groupName;
  //     String? groupId;

  //     BuildContext? context = navigatorKey.currentContext;
  //     if (context != null) {
  //       String contentText = '';
  //       switch (msgType) {
  //         case MessageType.TXT:
  //           ChatMessage? msg = await ChatClient.getInstance.chatManager
  //               .loadMessage(m.toString());
  //           if (msg == null) {
  //             return;
  //           }
  //           contentText = (msg.body as ChatTextMessageBody).content;
  //           break;
  //         default:
  //           contentText = msgType.name;
  //           break;
  //       }
  //       bool showForegroudNotification = false;
  //       String content = '';
  //       if (type == 'group_chat') {
  //         groupName = extra['group_name'];
  //         groupId = message.data['g'];
  //         content = '$groupName : $name sent you\n$contentText';
  //         showForegroudNotification =
  //             !Routes.isGroupChatScreen(groupId.toString());
  //       } else if (type == 'chat') {
  //         showForegroudNotification = !Routes.isChatScreen(from.toString());
  //         content = '$name sent you\n$contentText';
  //       }

  //       if (showForegroudNotification) {
  //         showTopSnackBar(
  //           Overlay.of(context)!,
  //           CustomSnackBar.info(
  //             message: content,
  //           ),
  //           onTap: () {
  //             handleChatNotificationAction({
  //               'type': type,
  //               'from':
  //                   type == 'group_chat' ? groupId.toString() : from.toString(),
  //             }, context, false);
  //           },
  //         );
  //         return;
  //       }
  //     }

  //     String contentText = '';
  //     String url;
  //     switch (msgType) {
  //       case MessageType.TXT:
  //         ChatMessage? msg = await ChatClient.getInstance.chatManager
  //             .loadMessage(m.toString());
  //         if (msg == null) {
  //           return;
  //         }
  //         contentText = (msg.body as ChatTextMessageBody).content;
  //         break;
  //       case MessageType.IMAGE:
  //         ChatMessage? msg = await ChatClient.getInstance.chatManager
  //             .loadMessage(m.toString());
  //         if (msg == null) {
  //           return;
  //         }
  //         final body = msg.body as ChatImageMessageBody;
  //         url = body.remotePath ?? body.thumbnailRemotePath ?? '';
  //         if (url.isNotEmpty) {
  //           if (type == 'group_chat') {
  //             groupName = extra['group_name'];
  //             groupId = message.data['g'];
  //             _showGroupMediaMessageNotification(
  //                 groupId!, name!, groupName!, url, image!);
  //           } else if (type == 'chat') {
  //             _showMediaMessageNotification(from, name!, url, image!);
  //           }
  //           return;
  //         }
  //         contentText = 'New image file';
  //         break;
  //       default:
  //         contentText = 'New ${msgType.name} file';
  //         break;
  //     }
  //     //Show notification
  //     if (type == 'group_chat') {
  //       groupName = extra['group_name'] ?? '';
  //       groupId = message.data['g'] ?? '';
  //       _showGroupTextMessageNotification(
  //           groupId!, name!, groupName!, image!, contentText);
  //     } else if (type == 'chat') {
  //       _showTextMessageNotification(from, name!, image!, contentText);
  //     }
  //   }
  // }

  // static _showGroupDocMessageNotification(String groupId, String fromName,
  //     String groupName, String fromImage, String message) {
  //   int id = groupId.hashCode;
  //   String title = '';
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: message,
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       notificationLayout: NotificationLayout.BigText,
  //       payload: {
  //         'type': 'group_chat',
  //         'from': groupId,
  //       },
  //     ),
  //   );
  // }

  // static showErrorMessage(String message) async {
  //   int id = 10000;
  //   if (_messagePool.containsKey(id)) {
  //     _messageBodyPool.update(id, (value) => "$message <br/>$value");
  //     _messagePool.update(id, (value) {
  //       return value + 1;
  //     });
  //   } else {
  //     _messageBodyPool.putIfAbsent(id, () => message);
  //     _messagePool.putIfAbsent(id, () => 1);
  //   }
  //   String title = 'Error';
  //   String body = _messageBodyPool[id] ?? message;

  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: body,
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       notificationLayout: NotificationLayout.BigText,
  //       payload: {
  //         'type': 'error',
  //       },
  //     ),
  //   );
  // }
}

//{senderId: null, category: null, collapseKey: hyphenate_chatuidemo_notification, contentAvailable: false, data: {t: 3, e: {"image":"eilni_P6TzaDwV5Z3SvuuS:APA91bEr_PHNAxQ0zW9-dOPv-kvJ7f6htqSW9VRmWpxcpiXcFmrugUdwR5oMTpWCnsFYZXzbWQ-TWrDzVe07guvOQtuRikbFjLWHVVUs7dboM7LGMwLGWx8VEXHlzZ72JsNQxHg6-XaS","content_type":"CUSTOM","name":"KUNAL PANDEY","type":"p2p_call"}, alert: You've got a new message, f: 1, m: 1100787828750552000, EPush: {"provider":"ANDROID","origin":"im-push","msg_id":"1100787828750552000"}}, from: 556221488660, messageId: 0:1673861938812849%005650c8f4b2283c, messageType: null, mutableContent: false, notification: null, sentTime: 1673861938806, threadId: null, ttl: 2419200}
