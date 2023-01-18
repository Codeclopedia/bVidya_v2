// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/core/helpers/call_helper.dart';
import '/data/models/call_message_body.dart';
import '/data/models/response/bchat/p2p_call_response.dart';

import '../constants.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/utils.dart';
import '/app.dart';
import '../routes.dart';
import '../ui_core.dart';
import 'callkit_utils.dart';
import 'chat_utils.dart';

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
              channelKey: 'chat_channel',
              channelName: 'chat_channel',
              groupKey: 'call_key',
              channelDescription: 'Show Chat Notification'),
          NotificationChannel(
              channelKey: 'call_channel',
              channelName: 'call_channel',
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
        .getInitialNotificationAction(removeFromActionEvents: false);

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
        // String? type = receivedAction.payload?['type'];
        // String? from = receivedAction.payload?['from'];
        // if (type == 'contact_invite' && from != null) {
        //   // debugPrint('${receivedAction.buttonKeyPressed} ');
        //   if (receivedAction.buttonKeyPressed == 'ACCEPT_CONTACT') {
        //     await BChatContactManager.acceptRequest(from);
        //   } else if (receivedAction.buttonKeyPressed == 'DECLINE_CONTACT') {
        //     await BChatContactManager.declineRequest(from);
        //   }
        // }
        return;
      }

      clickAction = receivedAction;
      clearPool(receivedAction.id ?? 0);

      BuildContext? context = navigatorKey.currentContext;
      // debugPrint(
      //     'onAction context:${context != null}  payload: ${receivedAction.payload}');
      if (context != null && Routes.currentScreen.isNotEmpty) {
        handleChatNotificationAction(receivedAction.payload!, context, true);
      } else {
        // debugPrint(
        //     'Context is null key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
        //
      }
    } else {
      debugPrint(
          'key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
    }

    // if (receivedAction.actionType == ActionType.SilentAction ||
    //     receivedAction.actionType == ActionType.SilentBackgroundAction) {
    //   // For background actions, you must hold the execution until the end
    //   print(
    //       'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    //   // await executeLongTaskInBackground();
    // } else {
    //   //   MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //   //       '/notification-page',
    //   //           (route) =>
    //   //       (route.settings.name != '/notification-page') || route.isFirst,
    //   //       arguments: receivedAction);
    // }
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

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  // static Future<void> executeLongTaskInBackground() async {
  //   print("starting long task");
  //   await Future.delayed(const Duration(seconds: 4));
  //   final url = Uri.parse("http://google.com");
  //   final re = await http.get(url);
  //   print(re.body);
  //   print("long task done");
  // }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  // static Future<void> createNewNotification() async {
  //   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  //   if (!isAllowed) isAllowed = await displayNotificationRationale();
  //   if (!isAllowed) return;

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: -1, // -1 is replaced by a random number
  //           channelKey: 'alerts',
  //           title: 'Huston! The eagle has landed!',
  //           body:
  //               "A small step for a man, but a giant leap to Flutter's community!",
  //           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
  //           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  //           //'asset://assets/images/balloons-in-sky.jpg',
  //           notificationLayout: NotificationLayout.BigPicture,
  //           payload: {'notificationId': '1234567890'}),
  //       actionButtons: [
  //         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
  //         NotificationActionButton(
  //             key: 'REPLY',
  //             label: 'Reply Message',
  //             requireInputText: true,
  //             actionType: ActionType.SilentAction),
  //         NotificationActionButton(
  //             key: 'DISMISS',
  //             label: 'Dismiss',
  //             actionType: ActionType.DismissAction,
  //             isDangerousOption: true)
  //       ]);
  // }

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

  // static Future shouldShowChatNotification(RemoteMessage message) async {
  //   try {
  //     if (message.data.isNotEmpty &&
  //         message.data['alert'] != null &&
  //         message.data['e'] != null) {
  //       String title = message.notification?.title ?? '';
  //       String content = message.notification?.body ?? '';
  //       String? type = jsonDecode(message.data['e'])['type'];
  //       // print('type: $type');
  //       dynamic from = message.data['f'];
  //       // print('From $from');

  //       if (title.isNotEmpty &&
  //           content.isNotEmpty &&
  //           from != null &&
  //           type != null) {
  //         bool showNotification = false;
  //         if (type == 'chat') {
  //           showNotification = !Routes.isChatScreen(from.toString());
  //         } else if (type == 'group_chat') {
  //           showNotification = !Routes.isGroupChatScreen(from.toString());
  //         }
  //         if (showNotification) {
  //           BuildContext? context = navigatorKey.currentContext;
  //           if (context != null) {
  //             showTopSnackBar(
  //               Overlay.of(context)!,
  //               CustomSnackBar.info(
  //                 message: "$title\n$content",
  //               ),
  //               onTap: () {
  //                 handleChatNotificationAction({
  //                   'type': type,
  //                   'from': from.toString(),
  //                 }, context, false);
  //               },
  //             );
  //             return;
  //           }

  //           bool isAllowed =
  //               await AwesomeNotifications().isNotificationAllowed();
  //           if (!isAllowed) isAllowed = await displayNotificationRationale();
  //           if (!isAllowed) return;
  //           if ((await getMeAsUser()) == null) {
  //             return;
  //           }

  //           int id = DateTime.now().hashCode;
  //           // print('  showing notification id $id');
  //           AwesomeNotifications().createNotification(
  //             content: NotificationContent(
  //               id: id,
  //               channelKey: 'chat_channel',
  //               title: title,
  //               icon: 'resource://mipmap/ic_launcher',
  //               body: content,
  //               wakeUpScreen: true,
  //               fullScreenIntent: false,
  //               notificationLayout: NotificationLayout.BigText,
  //               payload: {
  //                 'type': type,
  //                 'from': from.toString(),
  //               },
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   } catch (e) {}
  // }

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

  // static Future<void> scheduleNewNotification() async {
  //   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  //   if (!isAllowed) isAllowed = await displayNotificationRationale();
  //   if (!isAllowed) return;

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: -1, // -1 is replaced by a random number
  //           channelKey: 'alerts',
  //           title: "Huston! The eagle has landed!",
  //           body:
  //               "A small step for a man, but a giant leap to Flutter's community!",
  //           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
  //           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  //           //'asset://assets/images/balloons-in-sky.jpg',
  //           notificationLayout: NotificationLayout.BigPicture,
  //           payload: {
  //             'notificationId': '1234567890'
  //           }),
  //       actionButtons: [
  //         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
  //         NotificationActionButton(
  //             key: 'DISMISS',
  //             label: 'Dismiss',
  //             actionType: ActionType.DismissAction,
  //             isDangerousOption: true)
  //       ],
  //       schedule: NotificationCalendar.fromDate(
  //           date: DateTime.now().add(const Duration(seconds: 10))));
  // }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  static handleForegroundMessage(ChatMessage message) async {
    String contentText = '';

    switch (message.body.type) {
      case MessageType.TXT:
        contentText = (message.body as ChatTextMessageBody).content;
        break;
      default:
        contentText = message.body.type.name;
        break;
    }

    bool showForegroudNotification = false;
    if (message.chatType == ChatType.Chat) {
      showForegroudNotification =
          !Routes.isChatScreen(message.from!.toString());
      // content = '$groupName : $name sent you\n$contentText';
    } else if (message.chatType == ChatType.GroupChat) {
      showForegroudNotification =
          !Routes.isGroupChatScreen(message.conversationId.toString());
    } else {
      return;
    }
    BuildContext? context = navigatorKey.currentContext;
    if (showForegroudNotification && context != null) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.info(
          message: contentText,
        ),
        onTap: () {
          handleChatNotificationAction({
            'type': message.chatType == ChatType.Chat ? 'chat' : 'group_chat',
            'from': message.conversationId!,
          }, context, false);
        },
      );
    }
  }

  static handleRemoteMessage(RemoteMessage message, bool isForeground) async {
    if ((await getMeAsUser()) == null) {
      //Not a valid user to
      return;
    }
    if (message.data.isNotEmpty &&
        message.data['alert'] != null &&
        message.data['e'] != null) {
      final extra = jsonDecode(message.data['e']);
      String? type = extra['type'];
      if (type == NotiConstants.typeCall) {
        _showCallingNotification(message);
        return;
      }
      String? name = extra['name'];
      String? image = extra['image'];
      String? contentType = extra['content_type'];
      MessageType msgType = getType(contentType);
      dynamic from = message.data['f'];
      dynamic m = message.data['m'];
      String? groupName;
      String? groupId;

      BuildContext? context = navigatorKey.currentContext;

      if (isForeground && context != null) {
        String contentText = '';
        switch (msgType) {
          case MessageType.TXT:
            ChatMessage? msg = await ChatClient.getInstance.chatManager
                .loadMessage(m.toString());
            if (msg == null) {
              return;
            }
            contentText = (msg.body as ChatTextMessageBody).content;
            break;
          default:
            contentText = msgType.name;
            break;
        }
        bool showForegroudNotification = false;
        String content = '';
        if (type == 'group_chat') {
          groupName = extra['group_name'];
          groupId = message.data['g'];
          content = '$groupName : $name sent you\n$contentText';
          showForegroudNotification =
              !Routes.isGroupChatScreen(groupId.toString());
        } else if (type == 'chat') {
          showForegroudNotification = !Routes.isChatScreen(from.toString());
          content = '$name sent you\n$contentText';
        }

        if (showForegroudNotification) {
          showTopSnackBar(
            Overlay.of(context)!,
            CustomSnackBar.info(
              message: content,
            ),
            onTap: () {
              handleChatNotificationAction({
                'type': type,
                'from':
                    type == 'group_chat' ? groupId.toString() : from.toString(),
              }, context, false);
            },
          );
        }
        return;
      }
      String contentText = '';
      String url;
      switch (msgType) {
        case MessageType.TXT:
          ChatMessage? msg = await ChatClient.getInstance.chatManager
              .loadMessage(m.toString());
          if (msg == null) {
            return;
          }
          contentText = (msg.body as ChatTextMessageBody).content;
          break;
        case MessageType.IMAGE:
          ChatMessage? msg = await ChatClient.getInstance.chatManager
              .loadMessage(m.toString());
          if (msg == null) {
            return;
          }
          final body = msg.body as ChatImageMessageBody;
          url = body.remotePath ?? body.thumbnailRemotePath ?? '';
          if (url.isNotEmpty) {
            if (type == 'group_chat') {
              groupName = extra['group_name'];
              groupId = message.data['g'];
              _showGroupMediaMessageNotification(
                  groupId!, name!, groupName!, url, image!);
            } else if (type == 'chat') {
              _showMediaMessageNotification(from, name!, url, image!);
            }
            return;
          }
          contentText = 'New image file';
          break;
        default:
          contentText = 'New ${msgType.name} file';
          break;
      }
      //Show notification
      if (type == 'group_chat') {
        groupName = extra['group_name'] ?? '';
        groupId = message.data['g'] ?? '';
        _showGroupTextMessageNotification(
            groupId!, name!, groupName!, image!, contentText);
      } else if (type == 'chat') {
        _showTextMessageNotification(from, name!, image!, contentText);
      }
    }
  }

  static final Map<int, int> _messagePool = {};
  static final Map<int, String> _messageBodyPool = {};

  static void clearPool(int id) async {
    if (_messagePool.containsKey(id)) {
      _messagePool.remove(id);
      _messageBodyPool.remove(id);
      await AwesomeNotifications().cancel(id);
    }
  }

  static void clean() {}

  static _showTextMessageNotification(
      String fromId, String fromName, String fromImage, String message) async {
    int id = fromId.hashCode;
    if (_messagePool.containsKey(id)) {
      _messageBodyPool.update(id, (value) => "$message <br/>$value");
      _messagePool.update(id, (value) {
        return value + 1;
      });
    } else {
      _messageBodyPool.putIfAbsent(id, () => message);
      _messagePool.putIfAbsent(id, () => 1);
    }
    String title = '$fromName sent you a message';
    String body = _messageBodyPool[id] ?? message;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: title,
        icon: 'resource://mipmap/ic_launcher',
        body: body,
        wakeUpScreen: true,
        fullScreenIntent: false,
        largeIcon: '$baseImageApi$fromImage',
        notificationLayout: NotificationLayout.BigText,
        payload: {
          'type': 'chat',
          'from': fromId,
        },
      ),
    );
  }

  static _showMediaMessageNotification(
      String fromId, String fromName, String url, String fromImage) {
    int id = (fromId + url).hashCode;
    // if (_messagePool.containsKey(id)) {
    //   _messageBodyPool.update(id, (value) => "$message <br/>$value");
    //   _messagePool.update(id, (value) {
    //     return value + 1;
    //   });
    // } else {
    //   _messageBodyPool.putIfAbsent(id, () => message);
    //   _messagePool.putIfAbsent(id, () => 1);
    // }
    String title = '$fromName sent you a photo';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: title,
        icon: 'resource://mipmap/ic_launcher',
        body: 'New Photo',
        wakeUpScreen: true,
        fullScreenIntent: false,
        bigPicture: url,
        largeIcon: '$baseImageApi$fromImage',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {
          'type': 'chat',
          'from': fromId,
        },
      ),
    );
  }

  // static _showDocMessageNotification(
  //     String fromId, String fromName, String fromImage, String message) {
  //   int id = fromId.hashCode;
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
  //         'type': 'chat',
  //         'from': fromId,
  //       },
  //     ),
  //   );
  // }

  static _showGroupTextMessageNotification(String groupId, String fromName,
      String groupName, String fromImage, String message) {
    int id = groupId.hashCode;
    if (_messagePool.containsKey(id)) {
      _messageBodyPool.update(id, (value) => "$message <br/>$value");
      _messagePool.update(id, (value) {
        return value + 1;
      });
    } else {
      _messageBodyPool.putIfAbsent(id, () => message);
      _messagePool.putIfAbsent(id, () => 1);
    }
    String body = _messageBodyPool[id] ?? message;

    String title = '$fromName sent you a message in $groupName';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: title,
        icon: 'resource://mipmap/ic_launcher',
        body: body,
        largeIcon: '$baseImageApi$fromImage',
        wakeUpScreen: true,
        fullScreenIntent: false,
        notificationLayout: NotificationLayout.BigText,
        payload: {
          'type': 'group_chat',
          'from': groupId,
        },
      ),
    );
  }

  static _showGroupMediaMessageNotification(String groupId, String fromName,
      String groupName, String url, String fromImage) {
    int id = (groupId + url).hashCode;
    // if (_messagePool.containsKey(id)) {
    //   _messageBodyPool.update(id, (value) => "$message <br/>$value");
    //   _messagePool.update(id, (value) {
    //     return value + 1;
    //   });
    // } else {
    //   _messageBodyPool.putIfAbsent(id, () => message);
    //   _messagePool.putIfAbsent(id, () => 1);
    // }

    String title = '$fromName sent you a photo in $groupName';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: title,
        icon: 'resource://mipmap/ic_launcher',
        body: 'New Photo',
        wakeUpScreen: true,
        fullScreenIntent: false,
        bigPicture: url,
        largeIcon: '$baseImageApi$fromImage',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {
          'type': 'group_chat',
          'from': groupId,
        },
      ),
    );
  }

  static MessageType getType(String? contentType) {
    if (contentType == MessageType.TXT.name) {
      return MessageType.TXT;
    }
    if (contentType == MessageType.FILE.name) {
      return MessageType.FILE;
    }

    if (contentType == MessageType.IMAGE.name) {
      return MessageType.IMAGE;
    }
    if (contentType == MessageType.VIDEO.name) {
      return MessageType.VIDEO;
    }
    if (contentType == MessageType.VIDEO.name) {
      return MessageType.VIDEO;
    }
    return MessageType.CUSTOM;
  }

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

  static _showCallingNotification(RemoteMessage message) async {
    // final data = jsonDecode(message.data['e']);
    dynamic mId = message.data['m'];
    final msg =
        await ChatClient.getInstance.chatManager.loadMessage(mId.toString());
    if (msg == null || msg.body.type != MessageType.CUSTOM) {
      return;
    }
    try {
      final body = CallMessegeBody.fromJson(
          jsonDecode((msg.body as ChatCustomMessageBody).event));
      // CallBody? body = callBodys.callId;
      // if (body == null) {
      //   return;
      // }

      String fromId = message.data["f"].toString();
      String fromName = body.fromName;
      String fromFCM = body.ext['fcm'];
      CallBody callBody = CallBody.fromJson(jsonDecode(body.ext['call_body']));
      String image = body.image ?? '';
      bool hasVideo = body.callType == CallType.video;
      // makeFakeCallInComing();
      await showIncomingCallScreen(
          callBody, fromName, fromId, fromFCM, image, hasVideo);
    } catch (e) {
      print('Error in call notification');
    }

    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: id,
    //     channelKey: 'chat_channel',
    //     title: (data['name'] ?? '') + 'Calling you',
    //     icon: 'resource://mipmap/ic_launcher',
    //     body: body,
    //     wakeUpScreen: true,
    //     fullScreenIntent: false,
    //     notificationLayout: NotificationLayout.BigText,
    //     payload: {
    //       'type': 'group_chat',
    //       'from': groupId,
    //     },
    //   ),
    // );
  }
}


//{senderId: null, category: null, collapseKey: hyphenate_chatuidemo_notification, contentAvailable: false, data: {t: 3, e: {"image":"eilni_P6TzaDwV5Z3SvuuS:APA91bEr_PHNAxQ0zW9-dOPv-kvJ7f6htqSW9VRmWpxcpiXcFmrugUdwR5oMTpWCnsFYZXzbWQ-TWrDzVe07guvOQtuRikbFjLWHVVUs7dboM7LGMwLGWx8VEXHlzZ72JsNQxHg6-XaS","content_type":"CUSTOM","name":"KUNAL PANDEY","type":"p2p_call"}, alert: You've got a new message, f: 1, m: 1100787828750552000, EPush: {"provider":"ANDROID","origin":"im-push","msg_id":"1100787828750552000"}}, from: 556221488660, messageId: 0:1673861938812849%005650c8f4b2283c, messageType: null, mutableContent: false, notification: null, sentTime: 1673861938806, threadId: null, ttl: 2419200}