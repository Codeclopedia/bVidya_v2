// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '/data/models/call_message_body.dart';
import '/data/services/fcm_api_service.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';
import '/ui/base_back_screen.dart';
import '../state.dart';
import '../ui_core.dart';
import '../utils.dart';
import 'bmeet_helper.dart';

enum CallDirectionType {
  incoming,
  outgoing;
}

enum CallType { audio, video }

Future<ChatMessage?> makeAudioCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final user = await getMeAsUser();
  if (user == null) {
    return null;
  }
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return null;
    }
  }
  // pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();

  showLoading(ref);
  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'name': contact.name,
      'image': contact.profileImage,
      'fcm_token': contact.fcmToken,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing
    };
    hideLoading(ref);
    if (contact.fcmToken?.isNotEmpty == true) {
      FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
          callBody, user.id.toString(), user.name, user.image, false);
    }

    Navigator.pushNamed(context, RouteList.bChatAudioCall, arguments: map);
    return logCallEvent(
        callBody.callId,
        user.name,
        contact.userId.toString(),
        contact.name,
        CallType.audio,
        CallDirectionType.outgoing,
        contact.fcmToken!
        // fromFCM: user.fcmToken,
        // toFCM: contact.fcmToken ?? '',
        // image: contact.profileImage,
        );
  } else {
    hideLoading(ref);
    return null;
  }
  // ref.read(fcm)
  // FCMApiService.instance
  //     .sendChatPush(chat, toToken, fromUserId, senderName, type);
}

Future<ChatMessage?> makeVideoCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final user = await getMeAsUser();
  if (user == null) {
    return null;
  }
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return null;
    }
  }
  if (!await handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return null;
    }
  }
  showLoading(ref);
  // pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();

  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'name': contact.name,
      'fcm_token': contact.fcmToken,
      'image': contact.profileImage,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing
    };
    if (contact.fcmToken?.isNotEmpty == true) {
      FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
          callBody, user.id.toString(), user.name, user.image, true);
    }
    hideLoading(ref);

    await Navigator.pushNamed(context, RouteList.bChatVideoCall,
        arguments: map);
    return logCallEvent(
        callBody.callId,
        user.name,
        contact.userId.toString(),
        contact.name,
        CallType.video,
        CallDirectionType.outgoing,
        contact.fcmToken!
        // fromFCM: user.fcmToken,
        // toFCM: contact.fcmToken ?? '',
        // image: contact.profileImage,
        );
  } else {
    hideLoading(ref);
  }
  return null;
  // ref.read(fcm)
  // FCMApiService.instance
  //     .sendChatPush(chat, toToken, fromUserId, senderName, type);
}

Future receiveCall(String authToken, String fcmToken, String callId,
    String image, bool hasVideo, BuildContext context) async {
  final response =
      await BChatApiService.instance.receiveCall(authToken, callId);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'fcm_token': fcmToken,
      'name': callBody.callerName,
      'image': image,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.incoming
    };

    await Navigator.pushNamed(
        context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
        arguments: map);
  }
}

// Future receiveAudioCall(
//     String callId, String image, WidgetRef ref, BuildContext context) async {
//   if (!await handleCameraAndMic(Permission.microphone)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need microphone permission');
//       return;
//     }
//   }

//   final user = await getMeAsUser();
//   if (user == null) {
//     return;
//   }
//   final response =
//       await ref.read(apiBChatProvider).receiveCall(user.authToken, callId);
//   if (response.status == 'successfull' && response.body != null) {
//     final CallBody callBody = response.body!;
//     Map<String, dynamic> map = {
//       'name': callBody.callerName,
//       'image': '',
//       // 'caller': user,
//       'call_info': callBody,
//       'call_direction_type': CallDirectionType.incoming
//     };
//     hideLoading(ref);
//     Navigator.pushNamed(context, RouteList.bChatAudioCall, arguments: map);
//   } else {
//     hideLoading(ref);
//   }
// }

// Future receiveVideoCall(
//     String callId, String image, WidgetRef ref, BuildContext context) async {
//   if (!await handleCameraAndMic(Permission.microphone)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need microphone permission');
//       return;
//     }
//   }
//   if (!await handleCameraAndMic(Permission.camera)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need camera permission');
//       return;
//     }
//   }
//   final user = await getMeAsUser();
//   if (user == null) {
//     return;
//   }
//   final response =
//       await ref.read(apiBChatProvider).receiveCall(user.authToken, callId);
//   if (response.status == 'successfull' && response.body != null) {
//     final CallBody callBody = response.body!;
//     Map<String, dynamic> map = {
//       'name': callBody.callerName,
//       'image': image,
//       'call_info': callBody,
//       'call_direction_type': CallDirectionType.incoming
//     };

//     hideLoading(ref);
//     Navigator.pushNamed(context, RouteList.bChatVideoCall, arguments: map);
//   } else {
//     hideLoading(ref);
//   }
// }

Future<ChatMessage?> logCallEvent(
    String callId,
    String fromName,
    String toId,
    String toName,
    CallType callType,
    CallDirectionType callDirectionType,
    String fcm,
    {
    //   required String fromFCM,
    // required String toFCM,
    // required String image,
    int duration = 0,
    CallStatus status = CallStatus.ongoing}) async {
  try {
    final callMessageBody = CallMessegeBody(
      callId: callId,
      callType: callType,
      // callDirectionType: callDirectionType,
      duration: duration,
      fromName: fromName,
      // fromFCM: fromFCM,
      // toFCM: toFCM,
      // image: image,
      toName: toName,
      status: status,
      ext: {},
    );

    // try {
    //   Map content = {
    //     'type': NotiConstants.typeCall,
    //     'action': NotiConstants.actionCallDecline,
    //     'content': jsonEncode(callMessageBody.toJson()),
    //     'from_id': ChatClient.getInstance.currentUserId,
    //     'from_name': fromName,
    //     'image': '',
    //     'has_video': callType == CallType.video ? 'true' : 'false',
    //     'caller_fcm': fcm,
    //   };
    //   final message = ChatMessage.createCmdSendMessage(
    //       targetId: toId, action: jsonEncode(content));
    //   print('toID :$toId  ${ChatClient.getInstance.currentUserId}');
    //   message.attributes = {"em_force_notification": true};

    //   ChatClient.getInstance.chatManager.sendMessage(message);
    // } catch (e) {
    //   print('Error in sending command message $e');
    // }

    final message = ChatMessage.createCustomSendMessage(
        targetId: toId, event: jsonEncode(callMessageBody.toJson()));
    // final conv = await ChatClient.getInstance.chatManager.getConversation(toId);
    // if(conv!=null){
    // }
    message.attributes = {"em_force_notification": false};

    return await ChatClient.getInstance.chatManager.sendMessage(message);

// ref.read(chatConversationProvider).updateConversation(convId)
  } catch (e) {
    print('Error in logging call Event');
  }
  return null;
}
