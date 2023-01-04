import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/state.dart';
import 'core/ui_core.dart';
import 'core/utils/call_utils.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
  runApp(
    const ProviderScope(
      child: ResponsiveApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint('listen a terminate message ${message.data}');

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  // setupCallKeep();
  setupCallKit();
  onNewFireabseMessage(message, false);
}

onNewFireabseMessage(RemoteMessage message, bool foreground) {
  try {
    print('onNewFirebaseMessage: ${message.data} $foreground');
    if (message.data['type'] == 'p2p_call') {
      final String? action = message.data['action'];
      print('action: $action');
      if (action == 'START_CALL') {
        showIncomingCall(message);
      } else if (action == 'END_CALL') {
        closeIncomingCall(message);
      }
    }
  } catch (e) {
    print('error $e');
  }
}

  // setupCall(BuildContext context) {
  //   final FlutterCallkeep callKeep = FlutterCallkeep();
  //   final callSetup = <String, dynamic>{
  //     'ios': {
  //       'appName': 'CallKeepDemo',
  //     },
  //     'android': {
  //       'alertTitle': 'Permissions required',
  //       'alertDescription':
  //           'This application needs to access your phone accounts',
  //       'cancelButton': 'Cancel',
  //       'okButton': 'ok',
  //       // Required to get audio in background when using Android 11
  //       'foregroundService': {
  //         'channelId': 'com.company.my',
  //         'channelName': 'Foreground service for my app',
  //         'notificationTitle': 'My app is running on background',
  //         'notificationIcon': 'mipmap/ic_notification_launcher',
  //       },
  //     },
  //   };
  //   callKeep.setup(context, callSetup, backgroundMode: true);
  // }
// }
