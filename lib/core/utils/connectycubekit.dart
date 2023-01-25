import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import '/data/models/response/auth/login_response.dart';
import '/data/models/response/bchat/p2p_call_response.dart';
import '/data/services/fcm_api_service.dart';

import '../routes.dart';
import '/core/helpers/extensions.dart';
import '/app.dart';
import '../constants.dart';
import '../helpers/call_helper.dart';
import '../ui_core.dart';
import '../utils.dart';

bool appLoaded = false;

Map? _activeCallMap;
String? _activeCallId;
String? _lastCallId;
String? _onGoingCallId;

Map? get activeCallMap => _activeCallMap;
String? get activeCallId => _activeCallId;
String? get lastCallId => _lastCallId;

String? get onGoingCallId => _onGoingCallId;

setOnGoing(String? callId) {
  // _onGoingCallId = callId;
}
Future loadCallOnInit() async {
  var sessionId = await ConnectycubeFlutterCallKit.getLastCallId();
  if (sessionId == null) return;
  // print('sessionId=> $sessionId');
  var callState =
      await ConnectycubeFlutterCallKit.getCallState(sessionId: sessionId);
  // print('callState=> $callState');
  final data =
      await ConnectycubeFlutterCallKit.getCallData(sessionId: sessionId);
  // print('data=> $data');
  _lastCallId = sessionId;
  if (callState == 'pending') {
    _activeCallId = sessionId;
    _activeCallMap = jsonDecode(data!['user_info']!);
  } else {}
}

clearCall() {
  print('clear Call Called => active: $_activeCallId last:$_lastCallId');
  if (_activeCallId != null) {
    _lastCallId = _activeCallId;
  }
  _activeCallId = null;
  _activeCallMap = null;
}

Future setupCallKit() async {
  ConnectycubeFlutterCallKit.instance.updateConfig(
      ringtone: 'custom_ringtone',
      icon: 'ic_launcher',
      notificationIcon: 'ic_launcher',
      color: '#07711e');

  ConnectycubeFlutterCallKit.instance.init(
    onCallAccepted: _onCallAccepted,
    onCallRejected: _onCallRejected,
  );

  ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
      onCallRejectedWhenTerminated;
  ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
      onCallAcceptedWhenTerminated;
}

Future<void> _onCallAccepted(CallEvent callEvent) async {
  // the call was accepted
  ConnectycubeFlutterCallKit.reportCallAccepted(sessionId: callEvent.sessionId);

  final map = callEvent.userInfo;
  if (map == null) {
    print('map is null');
    return;
  }

  _activeCallMap = map;
  _activeCallId = callEvent.sessionId;

  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print(' Context is NULL');
    return;
  }
  String fromId = map['from_id']!;
  String fromName = map['from_name']!;
  String callerFCM = map['caller_fcm']!;
  String image = map['image']!;
  CallBody body = CallBody.fromJson(jsonDecode(map['body']!));
  bool hasVideo = map['has_video'] == 'true';

  Map<String, dynamic> usermap = {
    'name': fromName,
    'fcm_token': callerFCM,
    'image': image,
    'call_info': body,
    'call_direction_type': CallDirectionType.incoming,
    'direct': false,
    'user_id': fromId
  };

  if (Routes.getCurrentScreen() == RouteList.bChatAudioCall ||
      Routes.getCurrentScreen() == RouteList.bChatVideoCall) {
    print(' Already on call screen');
    return;
  }
  Navigator.pushNamed(
      context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
      arguments: usermap);
}

Future<void> _onCallRejected(CallEvent callEvent) async {
  // the call was rejected
  print('declining call');
  User? user = await getMeAsUser();
  String userId;
  String userName;
  final map = callEvent.userInfo;
  if (map == null) {
    print('map is null');
    return;
  }
  _lastCallId = callEvent.sessionId;
  String senderFCM = map['caller_fcm']!;
  CallBody body = CallBody.fromJson(jsonDecode(map['body']!));
  bool hasVideo = map['has_video'] == 'true';

  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    userName = body.calleeName;
    // return;
  } else {
    userId = user.id.toString();
    userName = user.name;
  }
  ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  FCMApiService.instance.sendCallEndPush(senderFCM,
      NotiConstants.actionCallDecline, body, userId, userName, hasVideo);
  ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callEvent.sessionId);
  clearCall();
}

Future<void> onCallRejectedWhenTerminated(CallEvent callEvent) async {
  // the call was accepted
  User? user = await getMeAsUser();
  String userId;
  String userName;
  final map = callEvent.userInfo;
  if (map == null) {
    print('map is null');
    return;
  }
  _lastCallId = callEvent.sessionId;

  String senderFCM = map['caller_fcm']!;
  CallBody body = CallBody.fromJson(jsonDecode(map['body']!));
  bool hasVideo = map['has_video'] == 'true';

  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    userName = body.calleeName;
    // return;
  } else {
    userId = user.id.toString();
    userName = user.name;
  }
  ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  FCMApiService.instance.sendCallEndPush(senderFCM,
      NotiConstants.actionCallDecline, body, userId, userName, hasVideo);
  ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callEvent.sessionId);
  clearCall();
}

Future<void> onCallAcceptedWhenTerminated(CallEvent callEvent) async {
  // the call was rejected

  ConnectycubeFlutterCallKit.reportCallAccepted(sessionId: callEvent.sessionId);
  final map = callEvent.userInfo;
  _activeCallMap = map;
  _activeCallId = callEvent.sessionId;
}

Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
  CallBody? callBody = remoteMessage.payload();

  if (callBody == null) {
    // clearCall();
    // await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  _lastCallId = callBody.callId;
  ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callBody.callId);
  clearCall();
  // ConnectycubeFlutterCallKit.clearCallData(sessionId: callBody.callId);
}

showIncomingCallScreen(CallBody callBody, String callerName, String fromId,
    String fromFCM, String image, bool hasVideo, bool background) async {
  print(
      'showIncomingCallScreen Call Called => active: $_activeCallId last:$_lastCallId');
  if (_activeCallId != null) {
    if (_activeCallId == callBody.callId) {
      return;
    }
  }
  if (callBody.callId == lastCallId) {
    return;
  }
  _activeCallId = callBody.callId;
  _lastCallId = _activeCallId;
  print('valid call Call Called => active: $_activeCallId last:$_lastCallId');
  CallEvent callEvent = CallEvent(
      sessionId: callBody.callId,
      callType: hasVideo ? 1 : 0,
      callerId: int.parse(fromId),
      callerName: 'Caller Name',
      opponentsIds: {
        int.parse(fromId)
      },
      userInfo: {
        'no_listen': 'false',
        'from_id': fromId,
        'from_name': callerName,
        'caller_fcm': fromFCM,
        'image': image,
        'has_video': hasVideo ? 'true' : 'false',
        'body': jsonEncode(callBody.toJson())
      });
  ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
  ConnectycubeFlutterCallKit.showCallNotification(callEvent);
}

onDeclineCallBusy(String senderFCM, String callerIdFrom, String callerName,
    String image, CallBody callBody, bool hasVideo) async {
  _lastCallId = callBody.callId;

  ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callBody.callId);
  // print('declining call');
  User? user = await getMeAsUser();
  String userId;
  String userName;

  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    userName = callBody.calleeName;
    // return;
  } else {
    userId = user.id.toString();
    userName = user.name;
  }

  FCMApiService.instance.sendCallEndPush(
      senderFCM,
      NotiConstants.actionCallDeclineBusy,
      callBody,
      userId,
      userName,
      hasVideo);
}
