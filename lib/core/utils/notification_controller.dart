// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bvidya/core/utils.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import '/app.dart';
import '../constants/route_list.dart';
import '../routes.dart';
import '../ui_core.dart';
import 'chat_utils.dart';

class NotificationController {
  static ReceivedAction? initialAction;

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

    // Get initial notification action is optional
    // await startListeningNotificationEvents();
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

    BuildContext? context = navigatorKey.currentContext;
    if (receivedAction.payload != null &&
        receivedAction.channelKey == 'chat_channel' &&
        context != null) {
      if ((await getMeAsUser()) == null) {
        return;
      }
      debugPrint('  payload: ${receivedAction.payload}');
      handleNotificationAction(receivedAction.payload!, context, false);
      // BuildContext context = navigatorKey.currentContext!;
    } else {
      debugPrint(
          'context: ${(context != null)}, key:${receivedAction.channelKey}, payload: ${receivedAction.payload}');
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
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
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

  static Future shouldShowNotification(RemoteMessage message) async {
    try {
      if (message.data.isNotEmpty &&
          message.data['alert'] != null &&
          message.data['e'] != null) {
        String title = message.notification?.title ?? '';
        String content = message.notification?.body ?? '';
        String? type = jsonDecode(message.data['e'])['type'];
        print('type: $type');
        dynamic from = message.data['f'];
        print('From $from');

        if (title.isNotEmpty &&
            content.isNotEmpty &&
            from != null &&
            type != null) {
          bool showNotification = false;
          if (type == 'chat') {
            showNotification = !Routes.isChatScreen(from.toString());
          } else if (type == 'group_chat') {
            showNotification = !Routes.isGroupChatScreen(from.toString());
          }
          if (showNotification) {
            bool isAllowed =
                await AwesomeNotifications().isNotificationAllowed();
            if (!isAllowed) isAllowed = await displayNotificationRationale();
            if (!isAllowed) return;
            if ((await getMeAsUser()) == null) {
              return;
            }

            int id = DateTime.now().hashCode;
            print('  showing notification id $id');
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
                  'type': type,
                  'from': from.toString(),
                  // 'msgId': message.data['m'] ?? ''
                },
              ),
            );
          }
        }
      }
    } catch (e) {}
  }

  static Future<bool> handleNotificationAction(
      Map<String, String?> message, BuildContext context, bool replace) async {
    String? type = message['type'];
    String? from = message['from'];

    try {
      if (type == 'chat') {
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
}
