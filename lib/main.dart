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
import 'core/utils/request_utils.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BChatSDKController.instance.setup();

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    try {
      await Firebase.initializeApp(
          options: isReleaseBuild
              ? DefaultFirebaseOptions.currentPlatformRelease
              : DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      // print('Error init firebase $e');
      // await Firebase.initializeApp();
    }
  }

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // await NotificationController.initializeLocalNotifications();
  runApp(
    const ProviderScope(
      child: ResponsiveApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  // print('firebase: onBackgroundMessage -> ${message.toMap()}');
  await BChatSDKController.instance.setup();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    SharedPreferencesAndroid.registerWith();
  } else {
    await Firebase.initializeApp(
      options: isReleaseBuild
          ? DefaultFirebaseOptions.currentPlatformRelease
          : DefaultFirebaseOptions.currentPlatform,
    );
  }
  // setupCallKeep();

  setupCallKit();
  // await NotificationController.initializeLocalNotifications();
  try {
    final String? action = message.data['action'];
    if (message.data['type'] == NotiConstants.typeCall) {
      if (action == NotiConstants.actionCallStart) {
        showCallingNotification(message.data, true);
      } else if (action == NotiConstants.actionCallEnd) {
        closeIncomingCall(message.data);
      }
    } else if (message.data['type'] == NotiConstants.typeGroupCall) {
      // final String? action = message.data['action'];
      if (action == NotiConstants.actionCallStart) {
        showGroupCallingNotification(message.data, true);
      } else if (action == NotiConstants.actionCallEnd) {
        closeIncomingGroupCall(message.data);
      }
    } else if (message.data['type'] == NotiConstants.typeContact) {
      ContactAction? cAction = contactActionFrom(action);
      final String? fromId = message.data['f'];
      if (cAction != null && fromId != null) {
        ContactRequestHelper.handleNotification(message.notification?.title,
            message.notification?.body, cAction, fromId, false);
      } else if (message.data['type'] == NotiConstants.typeGroupMemberUpdate) {
        // final String? fromId = message.data['f'];
        // final String? grpId = message.data['g'];
        // GroupMemberAction? action = groupActionFrom(message.data['action']);
        // if (action != null && fromId != null && grpId != null) {
        //   GroupMemberHelper.handleNotification(
        //       message.notification, action, fromId, grpId, true,
        //       ref: ref);
        // }
      }
      // NotificationController.showErrorMessage('New Background : ${message.senderId}');
      // await BChatSDKController.instance.loginOnlyInBackground();
      // BackgroundHelper.handleRemoteMessageBackground(message);
    }
  } catch (e) {
    // print('error $e');
  }
}

onBackgroundMessage(Map<String, dynamic> data) async {
  if (Platform.isIOS) {
    final String? action = data['action'];
    if (data['type'] == NotiConstants.typeCall) {
      if (action == NotiConstants.actionCallStart) {
        showCallingNotification(data, true);
      } else if (action == NotiConstants.actionCallEnd) {
        closeIncomingCall(data);
      }
    } else if (data['type'] == NotiConstants.typeGroupCall) {
      if (action == NotiConstants.actionCallStart) {
        showGroupCallingNotification(data, true);
      } else if (action == NotiConstants.actionCallEnd) {
        closeIncomingGroupCall(data);
      }
    } else if (data['type'] == NotiConstants.typeContact) {
      ContactAction? cAction = contactActionFrom(action);
      final String? fromId = data['f'];
      if (cAction != null && fromId != null) {
        ContactRequestHelper.handleNotification(
            null, null, cAction, fromId, false);
      } else if (data['type'] == NotiConstants.typeGroupMemberUpdate) {}
    }
  }
}
