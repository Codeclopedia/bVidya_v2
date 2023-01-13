// import 'package:callkeep/callkeep.dart';
// import 'package:bvidya/core/helpers/extensions.dart';
// import 'package:bvidya/data/models/models.dart';
// import 'package:bvidya/data/services/fcm_api_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import '../../app.dart';
// import '../constants.dart';
// import '../helpers/call_helper.dart';
// import '../ui_core.dart';
// import '../utils.dart';

// final FlutterCallkeep callKeep = FlutterCallkeep();
// bool callKeepStarted = false;
// Future setupCallKit() async {
//   if (callKeepStarted) {
//     return;
//   }
//   final callSetup = <String, dynamic>{
//     'ios': {
//       'appName': 'bVidya2',
//     },
//     'android': {
//       'alertTitle': 'Permissions required',
//       'alertDescription':
//           'This application needs to access your phone accounts',
//       'cancelButton': 'Cancel',
//       'okButton': 'ok',
//       // Required to get audio in background when using Android 11
//       'foregroundService': {
//         'channelId': 'call_channel',
//         'channelName': 'Foreground service for my app',
//         'notificationTitle': 'My app is running on background',
//         'notificationIcon': 'mipmap/ic_launcher',
//       },
//     },
//   };

//   await callKeep.setup(navigatorKey.currentContext, callSetup);
//   callKeepStarted = true;
// }

// Future<void> handlShowIncomingCallNotification(
//   RemoteMessage remoteMessage,
//   // FlutterCallkeep callKeep,
// ) async {
//   // String uuid = remoteMessage.payload()["call_id"] as String;
//   CallBody? body = remoteMessage.payload();
//   if (body == null) {
//     return;
//   }

//   String fromId = remoteMessage.data["from_id"];
//   String fromName = remoteMessage.data["from_name"];
//   String fromFCM = remoteMessage.data['caller_fcm'];
//   String image = remoteMessage.data['image'];
//   bool hasVideo = remoteMessage.data['has_video'] == 'true';

//   callKeep.on(CallKeepDidToggleHoldAction(), onHold);
//   callKeep.on(
//       CallKeepPerformAnswerCallAction(),
//       (_) async =>
//           await onCallAccept(fromId, fromFCM, fromName, image, body, hasVideo));
//   callKeep.on(CallKeepPerformEndCallAction(),
//       (_) async => await closeIncomingCall(remoteMessage));
//   callKeep.on(CallKeepDidPerformSetMutedCallAction(), setMuted);

//   await callKeep.displayIncomingCall(body.callId, fromId,
//       localizedCallerName: fromName, hasVideo: hasVideo);
//   callKeep.backToForeground();
//   // makeFakeCallInComing();
//   // _showIncomingCallScreen(body, fromName, fromId, fromFCM, image, hasVideo);
// }

// // Function(CallKeepPerformAnswerCallAction) answerAction = (event) async {
// //   print('CallKeepPerformAnswerCallAction ${event.callUUID}');
// //   // notify to your call P-C-M the answer action
// // };

// Function(CallKeepPerformEndCallAction) endAction = (event) async {
//   print('CallKeepPerformEndCallAction ${event.callUUID}');
//   // notify to your call P-C-M the end action
// };

// Function(CallKeepDidPerformSetMutedCallAction) setMuted = (event) async {
//   print('CallKeepDidPerformSetMutedCallAction ${event.callUUID}');
//   // notify to your call P-C-M the muted switch action
// };

// Function(CallKeepDidToggleHoldAction) onHold = (event) async {
//   print('CallKeepDidToggleHoldAction ${event.callUUID}');
//   // notify to your call P-C-M the hold switch action
// };
// Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
//   CallBody? callBody = remoteMessage.payload();
//   if (callBody == null) {
//     // await FlutterCallkitIncoming.endAllCalls();
//     return;
//   }

//   String fromId = remoteMessage.data["from_id"];
//   String callerName = remoteMessage.data["from_name"];
//   String callerImage = remoteMessage.data['image'];
//   bool hasVideo = remoteMessage.data['has_video'] == 'true';

//   print('from ID $fromId');
//   // await FlutterCallkitIncoming.endCall(callBody.callId);
// }

// _showIncomingCallScreen(CallBody callBody, String callerName, String fromId,
//     String fromFCM, String image, bool hasVideo) async {}

// onCallAccept(String fromId, String fcmToken, String callerName,
//     String callerImage, CallBody body, bool hasVideo) async {
//   User? user = await getMeAsUser();
//   if (user == null) {
//     print('User is NULL');
//     return;
//   }
//   BuildContext? context = navigatorKey.currentContext;
//   if (context == null) {
//     print(' Context is NULL');
//     return;
//   }
//   Map<String, dynamic> map = {
//     'name': callerName,
//     'fcm_token': fcmToken,
//     'image': callerImage,
//     'call_info': body,
//     'call_direction_type': CallDirectionType.incoming
//   };
//   print('hasVideo:::: > $hasVideo');

//   Navigator.pushNamed(
//       context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
//       arguments: map);
// }

// // onHoldAnswer(
// //     String callerIdFrom, String callerName, CallBody body, bool hasVideo) {}

// // onMuteCall(
// //     String callerIdFrom, String callerName, CallBody uuid, bool hasVideo) {}

// onDeclineCall(String senderFCM, String callerIdFrom, String callerName,
//     String image, CallBody body, bool hasVideo) async {
//   print('declining call');
//   User? user = await getMeAsUser();
//   if (user == null) {
//     return;
//   }

//   FCMApiService.instance.sendCallEndPush(
//       senderFCM,
//       NotiConstants.actionCallDecline,
//       body,
//       user.id.toString(),
//       user.name,
//       hasVideo);
//   await callKeep.endAllCalls();
//   // await FlutterCallkitIncoming.endAllCalls();
// }
