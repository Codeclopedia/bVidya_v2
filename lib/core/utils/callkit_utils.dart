// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:uuid/uuid.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/data/models/response/auth/login_response.dart';
import '/data/services/fcm_api_service.dart';
import '/core/utils/common.dart';
import '/core/helpers/group_call_helper.dart';
import '/data/models/call_message_body.dart';

import '../routes.dart';
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
DateTime? _lastCallTime;

Map? get activeCallMap => _activeCallMap;
String? get activeCallId => _activeCallId;
String? get lastCallId => _lastCallId;
String? get onGoingCallId => _onGoingCallId;

String? _uuid;

DateTime? get lastCallTime => _lastCallTime;

setOnGoing(String? callId) {
  _onGoingCallId = callId;
  if (callId != null) {
    _activeCallId = callId;
  }
}

clearCall() async {
  print('clear Call Called => active: $_activeCallId last:$_lastCallId');
  if (_activeCallId != null) {
    _lastCallId = _activeCallId;
  }
  await _futureClearPref();
  _activeCallId = null;
  _activeCallMap = null;
}

_futureClearPref() async {
  try {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('call_id', '');
    await pref.setString('call_extra', '');
    await pref.setString('call_accept_time', "0");
  } catch (e) {
    print('Error in writting to preferece');
  }
}

Future loadCallOnInit() async {
  final pref = await SharedPreferences.getInstance();

  final uuid = pref.getString('call_id');
  final callTime = pref.getString('call_accept_time');
  final callExra = pref.getString('call_extra');

  if (callExra?.isNotEmpty == true && uuid?.isNotEmpty == true) {
    print('Loaded calls=> $uuid');
    try {
      int diff =
          DateTime.now().millisecondsSinceEpoch - int.parse(callTime ?? '0');
      if (diff > 10000) {
        print('Very old call=> $diff ms');
        _activeCallId = null;
        _uuid = null;
        _activeCallMap = null;
        return;
      }
      print('Loaded calls=> $_activeCallId');

      _activeCallMap = jsonDecode(callExra!);
      _uuid = uuid;
      _activeCallId = _activeCallMap!['call_id'];
      _lastCallId = _activeCallId;
      return;
    } catch (e) {
      print('error $e');
    }
  }
}

Future setupCallKit() async {
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
    if (event == null) {
      print('onCall Event Null'); //
      return;
    }
    if (event.event == Event.ACTION_CALL_ENDED) {
      clearCall();
      return;
    }
    final map = event.body['extra'];
    if (map == null) {
      return;
    }
    String type = map['type'];
    if (type == NotiConstants.typeGroupCall) {
      String fromId = map['from_id'];
      String grpId = map['grp_id'];
      GroupCallMessegeBody body =
          GroupCallMessegeBody.fromJson(jsonDecode(map['body']));
      switch (event.event) {
        case Event.ACTION_CALL_ACCEPT:
          showOnLock(true);
          onGroupCallAccept(fromId, grpId, body);
          break;
        case Event.ACTION_CALL_DECLINE:
          onDeclineGroupCall(fromId, grpId, body);
          break;
        default:
      }

      return;
    }
    String? fromId = map['from_id'];
    if (fromId == null) {
      print('Event ${event.event}  from_id is null so-> $map');
      return;
    }
    CallMessegeBody body = CallMessegeBody.fromJson(jsonDecode(map['body']));
    switch (event.event) {
      case Event.ACTION_CALL_ACCEPT:
        showOnLock(true);
        _activeCallId = body.callId;
        _activeCallMap = map;
        _lastCallTime = DateTime.now();
        onCallAccept(body, fromId);
        break;
      case Event.ACTION_CALL_DECLINE:
        onDeclineCall(body, fromId);
        break;
      case Event.ACTION_CALL_START:
        break;
      case Event.ACTION_CALL_ENDED:
        break;
      default:
    }
  });
}

Future<void> closeIncomingGroupCall(RemoteMessage remoteMessage) async {
  int fromId = int.parse(remoteMessage.data['from_id']);
  final callId = remoteMessage.data['call_id'];
  final groupId = remoteMessage.data['grp_id'];
  final name = remoteMessage.data['name'];
  final image = remoteMessage.data['image'];
  final hasVideo = remoteMessage.data['has_video'] == 'true';
  if (callId == null) {
    clearCall();
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  // await _getActiveCall();
  if (_activeCallId == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  clearCall();
  _lastCallId = callId;
  _lastCallTime = remoteMessage.sentTime;

  String? avImage;
  if (image.isNotEmpty) {
    avImage = '$baseImageApi$image';
  } else {
    avImage = null;
  }
  // print('from ID $fromId');
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, callId);

  await FlutterCallkitIncoming.endCall(uid);
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: name,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'from_id': fromId.toString(),
      'grp_id': groupId,
      'call_id': callId,
      'type': NotiConstants.typeGroupCall,
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
    handle: '${hasVideo ? 'Video Call' : 'Audio Call'}-$name',
  );
  FlutterCallkitIncoming.showMissCallNotification(kitParam);
}

Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
  // CallMessegeBody? callBody = remoteMessage.payload();
  final callId = remoteMessage.data['call_id'];

  if (callId == null) {
    clearCall();
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  // await _getActiveCall();
  if (_activeCallId == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }
  clearCall();
  _lastCallId = callId;
  _lastCallTime = remoteMessage.sentTime;

  final fromId = remoteMessage.data['from_id'];
  final name = remoteMessage.data['name'];
  final image = remoteMessage.data['image'];
  final hasVideo = remoteMessage.data['has_video'] == 'true';
  String? avImage;
  if (image.isNotEmpty) {
    avImage = '$baseImageApi$image';
  } else {
    avImage = null;
  }
  // print('from ID $fromId');
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, callId);

  await FlutterCallkitIncoming.endCall(uid);
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: name,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'call_id': callId,
      'from_id': fromId,
      'type': NotiConstants.typeCall,
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
    // handle: name,
    handle: '${hasVideo ? 'Video Call' : 'Audio Call'}-$name',
  );
  FlutterCallkitIncoming.showMissCallNotification(kitParam);
}

showIncomingCallScreen(
    CallMessegeBody body, String fromId, bool background) async {
  print(
      'showIncomingCallScreen Call Called => active: $_activeCallId  c:${body.callId} last:$_lastCallId');

  if (_activeCallId != null) {
    if (_activeCallId == body.callId) {
      return;
    }
    FlutterCallkitIncoming.endAllCalls();
  }
  if (body.callId == lastCallId) {
    return;
  }
  _lastCallTime = DateTime.now();
  _activeCallId = body.callId;
  _lastCallId = _activeCallId;
  String? avImage;

  if (body.fromImage.isNotEmpty) {
    avImage = '$baseImageApi${body.fromImage}';
  } else {
    avImage = null;
  }
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, body.callId);

  print('valid call Call Called => active: $_activeCallId last:$_lastCallId');
  bool hasVideo = body.callType == CallType.video;
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: body.fromName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'call_id': body.callId,
      'from_id': fromId,
      'type': NotiConstants.typeCall,
      'body': jsonEncode(body..toJson())
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
    handle: '${hasVideo ? 'Video Call' : 'Audio Call'}-${body.fromName}',
    // handle: body.fromName,
  );
  try {
    await FlutterCallkitIncoming.showCallkitIncoming(kitParam);
  } catch (e) {
    print('error showing UI : $e');
  }
}

showIncomingGroupCallScreen(GroupCallMessegeBody callBody, String fromId,
    String grpId, bool background) async {
  print(
      'showIncomingCallScreen Call Group => active: $_activeCallId last:$_lastCallId');

  if (_activeCallId != null) {
    if (_activeCallId == callBody.callId) {
      return;
    }
    final uid = const Uuid().v5(Uuid.NAMESPACE_OID, _activeCallId);
    FlutterCallkitIncoming.endCall(uid);
  }
  if (callBody.callId == lastCallId) {
    return;
  }
  _lastCallTime = DateTime.now();
  _activeCallId = callBody.callId;
  _lastCallId = _activeCallId;
  String? avImage = callBody.groupImage;
  if (avImage.isEmpty) {
    avImage = callBody.fromImage;
  }
  if (avImage.isNotEmpty) {
    avImage = '$baseImageApi$avImage';
  } else {
    avImage = null;
  }
  bool hasVideo = callBody.callType == CallType.video;
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, callBody.callId);

  // print('valid group Call Called => active: $_activeCallId last:$_lastCallId');
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: callBody.fromName,
    textAccept: 'Accept',
    textDecline: 'Decline',

    // textCallback: 'Call back',
    extra: {
      'type': NotiConstants.typeGroupCall,
      'from_id': fromId,
      'grp_id': grpId,
      'call_id': callBody.callId,
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
    handle: '${hasVideo ? 'Video Call' : 'Audio Call'}-${callBody.groupName}',
  );
  try {
    await FlutterCallkitIncoming.showCallkitIncoming(kitParam);
  } catch (e) {
    print('error showing UI : $e');
  }
}

onGroupCallAccept(
  String fromId,
  String grpId,
  GroupCallMessegeBody body,
) async {
  _lastCallId = body.callId;
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print(' Context is NULL for grp ${DateTime.now().millisecondsSinceEpoch} ');
    return;
  }
  if (Routes.getCurrentScreen() == RouteList.groupCallScreen ||
      Routes.getCurrentScreen() == RouteList.groupCallScreenReceive) {
    print(' Already on group call screen');
    return;
  }
  _futureClearPref();
  receiveGroupCall(context,
      requestId: body.requestId,
      membersIds: body.memberIds,
      callId: body.callId,
      groupId: grpId,
      grpName: body.groupName,
      grpImage: body.groupImage,
      callType: body.callType,
      direct: false);
}

onCallAccept(
  CallMessegeBody callMessegeBody,
  String fromId,
) async {
  _lastCallId = callMessegeBody.callId;
  print('onCallAccept Call Called => active: $_activeCallId last:$_lastCallId');
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print(' Context is NULL ${DateTime.now().millisecondsSinceEpoch} ');

    return;
  }
  _futureClearPref();
  Map<String, dynamic> map = {
    'name': callMessegeBody.fromName,
    'fcm_token': callMessegeBody.ext['fcm'],
    'image': callMessegeBody.fromImage,
    'call_info': callMessegeBody.callBody,
    'call_direction_type': CallDirectionType.incoming,
    'prev_screen': Routes.getCurrentScreen(),
    'user_id': fromId
  };

  if (Routes.getCurrentScreen() == RouteList.bChatAudioCall ||
      Routes.getCurrentScreen() == RouteList.bChatVideoCall) {
    print(' Already on call screen');
    return;
  }
  Navigator.pushNamed(
      context,
      callMessegeBody.callType == CallType.video
          ? RouteList.bChatVideoCall
          : RouteList.bChatAudioCall,
      arguments: map);
}

// onHoldAnswer(
//     String callerIdFrom, String callerName, CallBody body, bool hasVideo) {}

// onMuteCall(
//     String callerIdFrom, String callerName, CallBody uuid, bool hasVideo) {}

onDeclineGroupCall(
    String fromId, String grpId, GroupCallMessegeBody body) async {
  print('declining group call');
  User? user = await getMeAsUser();
  String userId;

  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
  } else {
    userId = user.id.toString();
  }
  FCMApiService.instance.sendGroupCallEndPush(
      [body.fromFCM],
      NotiConstants.actionCallDecline,
      int.parse(userId),
      grpId,
      body.callId,
      body.groupName,
      body.groupImage,
      body.callType == CallType.video);
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, body.callId);

  await FlutterCallkitIncoming.endCall(uid);
  clearCall();
}

onDeclineGrpCallBusy(
    String fromId, String grpId, GroupCallMessegeBody body) async {
  User? user = await getMeAsUser();
  String userId;

  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    // return;
  } else {
    userId = user.id.toString();
  }
  FCMApiService.instance.sendGroupCallEndPush(
      [body.fromFCM],
      NotiConstants.actionCallDeclineBusy,
      int.parse(userId),
      grpId,
      body.callId,
      body.groupName,
      body.groupImage,
      body.callType == CallType.video);
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, body.callId);
  // await FlutterCallkitIncoming.endCall(uid);
  // clearCall();

  String? avImage = body.fromImage;
  if (avImage.isNotEmpty) {
    avImage = '$baseImageApi$avImage';
  } else {
    avImage = null;
  }
  bool hasVideo = body.callType == CallType.video;
  // await FlutterCallkitIncoming.endCall(uid);
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: body.fromName,
    textAccept: 'Accept',
    textDecline: 'Decline',

    // textCallback: 'Call back',
    extra: {
      'type': NotiConstants.typeGroupCall,
      'from_id': fromId,
      'grp_id': grpId,
      'call_id': body.callId,
      'body': jsonEncode(body.toJson())
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
    handle: '${hasVideo ? 'Video Call' : 'Audio Call'}-${body.groupName}',
  );
  FlutterCallkitIncoming.showMissCallNotification(kitParam);
}

onDeclineCall(
  CallMessegeBody callMessegeBody,
  String callerIdFrom,
) async {
  // print('declining call');
  User? user = await getMeAsUser();
  String userId;
  String name = '';
  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
  } else {
    userId = user.id.toString();
    name = user.name;
  }
  // callMessegeBody.callBody.

  FCMApiService.instance.sendCallEndPush(
    callMessegeBody.ext['fcm'],
    NotiConstants.actionCallDecline,
    userId,
    callMessegeBody.callId,
    user?.name ?? '',
    user?.image ?? '',
    callMessegeBody.callType == CallType.video,
  );
  await FlutterCallkitIncoming.endAllCalls();
  clearCall();
}

onDeclineCallBusy(
  CallMessegeBody callMessegeBody,
  String callerIdFrom,
) async {
  // print('declining call');
  User? user = await getMeAsUser();
  String userId;

  bool hasVideo = callMessegeBody.callType == CallType.video;
  if (user == null) {
    userId = ChatClient.getInstance.currentUserId ?? '';
    // userName = callMessegeBody.callBody.calleeName;
    // return;
  } else {
    userId = user.id.toString();
    // userName = user.name;
  }

  FCMApiService.instance.sendCallEndPush(
    callMessegeBody.ext['fcm'],
    NotiConstants.actionCallDeclineBusy,
    userId,
    callMessegeBody.callId,
    user?.name ?? '',
    user?.image ?? '',
    callMessegeBody.callType == CallType.video,
  );
  String? avImage = callMessegeBody.fromImage;
  if (avImage.isNotEmpty) {
    avImage = '$baseImageApi$avImage';
  } else {
    avImage = null;
  }
  final uid = const Uuid().v5(Uuid.NAMESPACE_OID, callMessegeBody.callId);

  // await FlutterCallkitIncoming.endCall(uid);
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: avImage,
    id: uid,
    nameCaller: callMessegeBody.fromName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'from_id': callerIdFrom,
      'call_id': callMessegeBody.callId,
      'type': NotiConstants.typeCall,
      'body': jsonEncode(callMessegeBody.toJson())
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
    handle:
        '${hasVideo ? 'Video Call' : 'Audio Call'}-${callMessegeBody.fromName}',
  );
  FlutterCallkitIncoming.showMissCallNotification(kitParam);
}
