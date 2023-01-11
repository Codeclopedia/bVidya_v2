// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/utils.dart';
import '/app.dart';
// import '../constants/route_list.dart';
import '../routes.dart';
import '../ui_core.dart';
import 'chat_utils.dart';

class NotificationController {
  // static ReceivedAction? initialAction;

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

    if (receivedAction.payload != null &&
        receivedAction.channelKey == 'chat_channel') {
      if ((await getMeAsUser()) == null) {
        return;
      }
      if (receivedAction.actionType == ActionType.SilentAction
          //  ||receivedAction.actionType == ActionType.SilentBackgroundAction
          ) {
        String? type = receivedAction.payload?['type'];
        String? from = receivedAction.payload?['from'];
        if (type == 'contact_invite' && from != null) {
          // debugPrint('${receivedAction.buttonKeyPressed} ');
          if (receivedAction.buttonKeyPressed == 'ACCEPT_CONTACT') {
            await BChatContactManager.acceptRequest(from);
          } else if (receivedAction.buttonKeyPressed == 'DECLINE_CONTACT') {
            await BChatContactManager.declineRequest(from);
          }
        }
        return;
      }
      BuildContext? context = navigatorKey.currentContext;
      debugPrint('  payload: ${receivedAction.payload}');
      if (context != null) {
        handleChatNotificationAction(receivedAction.payload!, context, false);
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

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    if ((await getMeAsUser()) == null) {
      return;
    }
    int id = 'contact_invite$userId'.hashCode;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat_channel',
        title: 'You have received an invitation',
        icon: 'resource://mipmap/ic_launcher',
        body: content,
        wakeUpScreen: true,
        fullScreenIntent: false,
        notificationLayout: NotificationLayout.BigText,
        payload: {
          'type': 'contact_invite',
          'from': userId,
          // 'msgId': message.data['m'] ?? ''
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'ACCEPT_CONTACT',
          label: 'Accept',
          actionType: ActionType.SilentAction,
        ),
        NotificationActionButton(
            key: 'DECLINE_CONTACT',
            label: 'Decline',
            actionType: ActionType.SilentAction,
            isDangerousOption: true)
      ],
    );
  }

  static Future shouldShowChatNotification(RemoteMessage message) async {
    try {
      if (message.data.isNotEmpty &&
          message.data['alert'] != null &&
          message.data['e'] != null) {
        String title = message.notification?.title ?? '';
        String content = message.notification?.body ?? '';
        String? type = jsonDecode(message.data['e'])['type'];
        // print('type: $type');
        dynamic from = message.data['f'];
        // print('From $from');

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
            BuildContext? context = navigatorKey.currentContext;
            if (context != null) {
              showTopSnackBar(
                Overlay.of(context)!,
                CustomSnackBar.info(
                  message: "$title\n$content",
                ),
                onTap: () {
                  handleChatNotificationAction({
                    'type': type,
                    'from': from.toString(),
                  }, context, false);
                },
              );
              return;
            }

            bool isAllowed =
                await AwesomeNotifications().isNotificationAllowed();
            if (!isAllowed) isAllowed = await displayNotificationRationale();
            if (!isAllowed) return;
            if ((await getMeAsUser()) == null) {
              return;
            }

            int id = DateTime.now().hashCode;
            // print('  showing notification id $id');
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
                },
              ),
            );
          }
        }
      }
    } catch (e) {}
  }

  static Future<bool> handleChatNotificationAction(
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
