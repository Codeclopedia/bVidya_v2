// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../routes.dart';
import '/core/helpers/extensions.dart';
import '/app.dart';
import '/data/models/response/auth/login_response.dart';
import '/data/models/response/bchat/p2p_call_response.dart';
import '/data/services/fcm_api_service.dart';
import '../constants.dart';
import '../helpers/call_helper.dart';
import '../ui_core.dart';
import '../utils.dart';

Map? _activeCallMap;
String? _activeCallId;
String? _lastCallId;

Map? get activeCallMap => _activeCallMap;
String? get activeCallId => _activeCallId;
String? get lastCallId => _lastCallId;

clearCall() {
  if (_activeCallId != null) {
    _lastCallId = _activeCallId;
  }
  _activeCallId = null;
  _activeCallMap = null;
}

_getActiveCall() async {
  try {
    print('loading active calls');

    final List<dynamic>? list = await FlutterCallkitIncoming.activeCalls();
    if (list?.isNotEmpty == true) {
      final id = list![0]['id'];
      print('id: $id -> ${list[0]}');
      final map = list[0]['extra'];
      if (map == null) {
        print('map: is null');
        _activeCallId = null;
        _activeCallMap = null;
        return;
      }
      print('map: $id -> $map');
      String? fromId = map['from_id'];
      if (fromId == null) {
        print('Not a valid Active calls');
        _activeCallId = null;
        _activeCallMap = null;
        return;
      }
      _activeCallMap = map;
      _activeCallId = id;

      return;
    } else {
      print('No Active calls');
    }
  } catch (e) {
    print('error in getting active calls');
  }
  _activeCallMap = null;
  _activeCallId = null;
}

setupCallKit() async {
  await _getActiveCall();
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
    if (event == null) {
      print('onCall Event Null'); //
      return;
    }
    if (event.event == Event.ACTION_CALL_ENDED) {
      return;
    }
    final map = event.body['extra'];
    if (map == null) {
      return;
    }
    String? fromId = map['from_id'];
    if (fromId == null) {
      print('Event ${event.event}  from_id is null so-> $map');
      return;
    }

    String fromName = map['from_name'];
    String callerFCM = map['caller_fcm'];
    String image = map['image'];
    CallBody body = CallBody.fromJson(jsonDecode(map['body']));
    bool hasVideo = map['has_video'];

    // print('onCall Event ${event.event}  - $map');

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

Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
  CallBody? callBody = remoteMessage.payload();
  if (callBody == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  await _getActiveCall();
  if (_activeCallId == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  _lastCallId = callBody.callId;
  String fromId = remoteMessage.data["from_id"];
  String callerName = remoteMessage.data["from_name"];
  String callerImage = remoteMessage.data['image'];
  bool hasVideo = remoteMessage.data['has_video'] == 'true';

  // print('from ID $fromId');
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
      'from_id': fromId,
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

showIncomingCallScreen(CallBody callBody, String callerName, String fromId,
    String fromFCM, String image, bool hasVideo) async {
  if (_activeCallId != null) {
    if (_activeCallId == callBody.callId) {
      return;
    }
    // if (_activeCallId == lastCallId) {
    //   return;
    // }
    FlutterCallkitIncoming.endAllCalls();
  }
  if (callBody.callId == lastCallId) {
    return;
  }
  _activeCallId = callBody.callId;
  _lastCallId = _activeCallId;
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '$baseImageApi$image',
    id: callBody.callId,
    nameCaller: callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': false,
      'from_id': fromId,
      'from_name': callerName,
      'caller_fcm': fromFCM,
      'image': image,
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
  } catch (e) {
    print('error showing UI : $e');
  }
}

// showOutGoingCall(CallBody callBody, bool hasVideo) async {
//   final kitParam = CallKitParams(
//     appName: 'bVidya',
//     avatar: '',
//     id: callBody.callId,
//     nameCaller: callBody.callerName,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     textCallback: 'Call back',
//     extra: {
//       'no_listen': true,
//       'from_id': '',
//       'from_name': callBody.calleeName,
//       'caller_fcm': '',
//       'image': '',
//       'has_video': hasVideo,
//       'body': jsonEncode(callBody.toJson())
//     },
//     android: const AndroidParams(
//       // backgroundUrl: '$baseImageApi$callerImage',
//       isShowLogo: true,
//       incomingCallNotificationChannelName: 'call_channel',
//       missedCallNotificationChannelName: 'call_channel',
//       ringtonePath: 'system_ringtone_default',
//       isShowCallback: false,
//       isCustomNotification: false,
//       isShowMissedCallNotification: true,
//       // actionColor: AppColors.primaryColor,
//     ),
//     ios: IOSParams(
//       ringtonePath: 'system_ringtone_default',
//       supportsVideo: hasVideo,
//     ),
//     type: hasVideo ? 1 : 0,
//     handle: callBody.callerName,
//   );
//   try {
//     await FlutterCallkitIncoming.startCall(kitParam);
//   } catch (_) {}
// }

onCallAccept(String fromId, String fcmToken, String callerName,
    String callerImage, CallBody body, bool hasVideo) async {
  // User? user = await getMeAsUser();
  // if (user == null) {
  //   print('User is NULL');
  //   return;
  // }

  _activeCallId = body.callId;
  _lastCallId = body.callId;

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
    'call_direction_type': CallDirectionType.incoming,
    'direct': false,
    'user_id': fromId
  };
  print('hasVideo:::: > $hasVideo');

  if (Routes.getCurrentScreen() == RouteList.bChatAudioCall ||
      Routes.getCurrentScreen() == RouteList.bChatVideoCall) {
    print(' Already on call screen');
    return;
  }
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
  String userId;
  String userName;
  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    userName = body.calleeName;
    // return;
  } else {
    userId = user.id.toString();
    userName = user.name;
  }

  FCMApiService.instance.sendCallEndPush(senderFCM,
      NotiConstants.actionCallDecline, body, userId, userName, hasVideo);
  await FlutterCallkitIncoming.endAllCalls();
}

endCall(CallBody callBody, String to) {
  try {
    final content = {
      'call_id': callBody.callId,
      'type': NotiConstants.typeCall,
      'action': NotiConstants.actionCallEnd
    };
    final message = ChatMessage.createCmdSendMessage(
        targetId: to, action: jsonEncode(content));
    message.attributes?.addAll({"em_force_notification": true});

    ChatClient.getInstance.chatManager.sendMessage(message);
  } catch (e) {
    print('sending command failed $e');
  }
}
