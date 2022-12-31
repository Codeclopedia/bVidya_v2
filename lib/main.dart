import 'dart:io';

import 'package:bvidya/core/helpers/extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/state.dart';
import 'core/ui_core.dart';
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
  // if (message.data.containsKey('p2p_call')) {
  //   final String? action = message.payload()['action'];
  //   if (action == 'START_CALL') {
  //     showIncomingCall(context, remoteMessage, callKeep);
  //   }
  // }
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
