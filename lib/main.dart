import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import 'core/helpers/background_helper.dart';
import 'core/sdk_helpers/bchat_sdk_controller.dart';
import 'core/constants/notification_const.dart';
import 'core/state.dart';
import 'core/ui_core.dart';
import 'core/utils/callkit_utils.dart';
// import 'core/utils/connectycubekit.dart';
import 'core/utils/notification_controller.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BChatSDKController.instance.setup();

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await NotificationController.initializeLocalNotifications();
  runApp(
    const ProviderScope(
      child: ResponsiveApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  // debugPrint('firebase: onBackgroundMessage -> ${message.toMap()}');
  await BChatSDKController.instance.setup();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    SharedPreferencesAndroid.registerWith();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  // setupCallKeep();

  setupCallKit();
  await NotificationController.initializeLocalNotifications();
  try {
    if (message.data['type'] == NotiConstants.typeCall) {
      final String? action = message.data['action'];
      // if (action == NotiConstants.actionCallStart) {
      //   // handlShowIncomingCallNotification(message);
      // } else
      if (action == NotiConstants.actionCallEnd) {
        closeIncomingCall(message);
      }
    } else {
      // NotificationController.showErrorMessage('New Background : ${message.senderId}');
      // await BChatSDKController.instance.loginOnlyInBackground();
      BackgroundHelper.handleRemoteMessageBackground(message);
    }
  } catch (e) {
    // print('error $e');
  }
}
