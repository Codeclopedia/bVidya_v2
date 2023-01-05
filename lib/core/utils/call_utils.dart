// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '/core/helpers/extensions.dart';
import '/app.dart';
import '/data/models/response/auth/login_response.dart';
import '/data/models/response/bchat/p2p_call_response.dart';
import '/data/services/fcm_api_service.dart';
import '../constants.dart';
import '../helpers/call_helper.dart';
import '../ui_core.dart';
import '../utils.dart';

setupCallKit() {
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
    if (event == null) {
      print('onCall Event Null');
      return;
    }
    final map = event.body['extra'];
    if (map == null) {
      return;
    }
    String? fromId = map['from_id'];
    if (fromId == null) {
      print('from_id is null so-> $map');
      return;
    }

    String fromName = map['from_name'];
    String callerFCM = map['caller_fcm'];
    String image = map['image'];
    CallBody body = CallBody.fromJson(jsonDecode(map['body']));
    bool hasVideo = map['has_video'];

    print('onCall Event ${event.event}  - ${event.body}');

    switch (event.event) {
      case Event.ACTION_CALL_ACCEPT:
        onCallAccept(fromId, callerFCM, fromName, image, body, hasVideo);
        break;
      case Event.ACTION_CALL_DECLINE:
        onDeclineCall(callerFCM, fromId, fromName, image, body, hasVideo);
        break;
      case Event.ACTION_CALL_START:
        break;
      case Event.ACTION_CALL_ENDED:
        break;
      default:
    }
  });
}

Future<void> showIncomingCall(
  RemoteMessage remoteMessage,
  // FlutterCallkeep callKeep,
) async {
  // String uuid = remoteMessage.payload()["call_id"] as String;
  CallBody? body = remoteMessage.payload();
  if (body == null) {
    return;
  }

  String callerIdFrom = remoteMessage.data["from_id"];
  String callerName = remoteMessage.data["from_name"];
  String senderFCM = remoteMessage.data['caller_fcm'];
  String callerImage = remoteMessage.data['image'];
  bool hasVideo = remoteMessage.data['has_video'] == 'true';
  // makeFakeCallInComing();
  showIncomingCallScreen(
      body, callerName, callerIdFrom, senderFCM, callerImage, hasVideo);
}

Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
  CallBody? callBody = remoteMessage.payload();
  if (callBody == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }

  String callerId = remoteMessage.data["from_id"];
  String callerName = remoteMessage.data["from_name"];
  // String callerFCM = remoteMessage.data['caller_fcm'];
  String callerImage = remoteMessage.data['image'];
  bool hasVideo = remoteMessage.data['has_video'] == 'true';

  await FlutterCallkitIncoming.endCall(callBody.callId);
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '$baseImageApi$callerImage',
    id: callBody.callId,
    nameCaller: callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': false,
      'from_id': callerId,
      'from_name': callerName,
      'caller_fcm': '',
      'image': callerImage,
      'has_video': hasVideo,
      'body': jsonEncode(callBody.toJson())
    },
    android: const AndroidParams(
      // backgroundUrl: '$baseImageApi$callerImage',
      isShowLogo: true,
      incomingCallNotificationChannelName: 'call_channel',
      missedCallNotificationChannelName: 'call_channel',
      ringtonePath: 'system_ringtone_default',
      isShowCallback: false,
      isCustomNotification: false,

      isShowMissedCallNotification: true,
      // actionColor: AppColors.primaryColor,
    ),
    ios: IOSParams(
      ringtonePath: 'system_ringtone_default',
      supportsVideo: hasVideo,
    ),
    type: hasVideo ? 1 : 0,
    handle: callerName,
  );
  FlutterCallkitIncoming.showMissCallNotification(kitParam);
}

showIncomingCallScreen(CallBody callBody, String callerName, String callerId,
    String callerFCM, String callerImage, bool hasVideo) async {
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '$baseImageApi$callerImage',
    id: callBody.callId,
    nameCaller: callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': false,
      'from_id': callerId,
      'from_name': callerName,
      'caller_fcm': callerFCM,
      'image': callerImage,
      'has_video': hasVideo,
      'body': jsonEncode(callBody.toJson())
    },
    android: const AndroidParams(
      // backgroundUrl: '$baseImageApi$callerImage',
      isShowLogo: true,
      incomingCallNotificationChannelName: 'call_channel',
      missedCallNotificationChannelName: 'call_channel',
      ringtonePath: 'system_ringtone_default',
      isShowCallback: false,
      isCustomNotification: false,

      isShowMissedCallNotification: true,
      // actionColor: AppColors.primaryColor,
    ),
    ios: IOSParams(
      ringtonePath: 'system_ringtone_default',
      supportsVideo: hasVideo,
    ),
    type: hasVideo ? 1 : 0,
    handle: callerName,
  );
  try {
    await FlutterCallkitIncoming.showCallkitIncoming(kitParam);
    // print(' showing UI : $result');
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      print('Build Context is NULL');
      return;
    }
    // pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();
  } catch (e) {
    print('error showing UI : $e');
  }
}

showOutGoingCall(CallBody callBody, bool hasVideo) async {
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '',
    id: callBody.callId,
    nameCaller: callBody.callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': true,
      'from_id': '',
      'from_name': callBody.calleeName,
      'caller_fcm': '',
      'image': '',
      'has_video': hasVideo,
      'body': jsonEncode(callBody.toJson())
    },
    android: const AndroidParams(
      // backgroundUrl: '$baseImageApi$callerImage',
      isShowLogo: true,
      incomingCallNotificationChannelName: 'call_channel',
      missedCallNotificationChannelName: 'call_channel',
      ringtonePath: 'system_ringtone_default',
      isShowCallback: false,
      isCustomNotification: false,
      isShowMissedCallNotification: true,
      // actionColor: AppColors.primaryColor,
    ),
    ios: IOSParams(
      ringtonePath: 'system_ringtone_default',
      supportsVideo: hasVideo,
    ),
    type: hasVideo ? 1 : 0,
    handle: callBody.callerName,
  );
  try {
    await FlutterCallkitIncoming.startCall(kitParam);
  } catch (_) {}
}

onCallAccept(String callerIdFrom, String fcmToken, String callerName,
    String callerImage, CallBody body, bool hasVideo) async {
  User? user = await getMeAsUser();
  if (user == null) {
    print('User is NULL');

    return;
  }
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print(' Context is NULL');
    return;
  }
  Map<String, dynamic> map = {
    'name': callerName,
    'fcm_token': fcmToken,
    'image': callerImage,
    'call_info': body,
    'call_direction_type': CallDirectionType.incoming
  };

  Navigator.pushNamed(
      context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
      arguments: map);
}

// onHoldAnswer(
//     String callerIdFrom, String callerName, CallBody body, bool hasVideo) {}

// onMuteCall(
//     String callerIdFrom, String callerName, CallBody uuid, bool hasVideo) {}

onDeclineCall(String senderFCM, String callerIdFrom, String callerName,
    String image, CallBody body, bool hasVideo) async {
  print('declining call');
  User? user = await getMeAsUser();
  if (user == null) {
    return;
  }
  FCMApiService.instance.sendCallEndPush(
      senderFCM,
      NotiConstants.actionCallDecline,
      body,
      user.id.toString(),
      user.name,
      hasVideo);
  await FlutterCallkitIncoming.endAllCalls();
}
