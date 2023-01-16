// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../sdk_helpers/bchat_call_manager.dart';
import '/controller/providers/bchat/call_list_provider.dart';
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
    // if (contact.fcmToken?.isNotEmpty == true) {
    //   FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
    //       callBody, user.id.toString(), user.name, user.image, false);
    // }

    Navigator.pushNamed(context, RouteList.bChatAudioCall, arguments: map);
    return logCallEvent(
        ref,
        callBody.callId,
        user.name,
        contact.userId.toString(),
        contact.name,
        CallType.audio,
        CallDirectionType.outgoing,
        user.fcmToken,
        contact.profileImage,
        callBody: callBody
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
    // if (contact.fcmToken?.isNotEmpty == true) {
    //   FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
    //       callBody, user.id.toString(), user.name, user.image, true);
    // }
    hideLoading(ref);

    await Navigator.pushNamed(context, RouteList.bChatVideoCall,
        arguments: map);
    return logCallEvent(
        ref,
        callBody.callId,
        user.name,
        contact.userId.toString(),
        contact.name,
        CallType.video,
        CallDirectionType.outgoing,
        user.fcmToken,
        contact.profileImage,
        callBody: callBody
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
    WidgetRef ref,
    String callId,
    String fromName,
    String toId,
    String toName,
    CallType callType,
    CallDirectionType callDirectionType,
    String fcm,
    String image,
    {int duration = 0,
    CallStatus status = CallStatus.ongoing,
    required CallBody callBody}) async {
  try {
    final callMessageBody = CallMessegeBody(
      callId: callId,
      callType: callType,
      duration: duration,
      fromName: fromName,
      image: image,
      toName: toName,
      status: status,
      ext: {'fcm': fcm, 'call_body': jsonEncode(callBody)},
    );

    final message = ChatMessage.createCustomSendMessage(
        targetId: toId, event: jsonEncode(callMessageBody.toJson()));

    message.attributes = {
      "em_apns_ext": {
        'type': NotiConstants.typeCall,
        'name': fromName,
        'image': image,
        'content_type': message.body.type.name,
      },
      "em_force_notification": true
    };
    // message.attributes = {"em_force_notification": true};

    final msg = await ChatClient.getInstance.chatManager.sendMessage(message);
    CallListModel model = CallListModel(callMessageBody.fromName,
        callMessageBody.image ?? '', true, msg.serverTime, callMessageBody);
    ref.read(callListProvider.notifier).addCall(model);
    return msg;
// ref.read(chatConversationProvider).updateConversation(convId)
  } catch (e) {
    print('Error in logging call Event');
  }
  return null;
}
