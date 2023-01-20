// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../sdk_helpers/bchat_call_manager.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/data/models/call_message_body.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
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
      'call_direction_type': CallDirectionType.outgoing,
      'direct': false
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
        user.image,
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
    AppSnackbar.instance.error(context, 'Error while making call');
    return null;
  }
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
      'call_direction_type': CallDirectionType.outgoing,
      'direct': false
    };
    // if (contact.fcmToken?.isNotEmpty == true) {
    //   FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
    //       callBody, user.id.toString(), user.name, user.image, true);
    // }
    hideLoading(ref);

    Navigator.pushNamed(context, RouteList.bChatVideoCall, arguments: map);
    return logCallEvent(
        ref,
        callBody.callId,
        user.name,
        user.image,
        contact.userId.toString(),
        contact.name,
        CallType.video,
        CallDirectionType.outgoing,
        user.fcmToken,
        contact.profileImage,
        callBody: callBody);
  } else {
    AppSnackbar.instance.error(context, 'Error while making call');
    hideLoading(ref);
  }
  return null;
}

Future<ChatMessage?> makeCall(
    CallListModel model, WidgetRef ref, BuildContext context) async {
  showLoading(ref);
  final results = await ref.read(bChatProvider).getContactsByIds(model.userId);
  hideLoading(ref);
  if (results?.isNotEmpty == true) {
    final Contact contact = results!.first;
    // model.body.callType==CallType.video;
    if (model.body.callType == CallType.video) {
      return await makeVideoCall(
          Contacts.fromContact(contact, ContactStatus.none), ref, context);
    } else {
      return await makeAudioCall(
          Contacts.fromContact(contact, ContactStatus.none), ref, context);
    }
  } else {
    AppSnackbar.instance.error(context, 'Error while making call');
    return null;
  }
}

Future<ChatMessage?> logCallEvent(
    WidgetRef ref,
    String callId,
    String fromName,
    String fromImage,
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
      toImage: image,
      fromImage: fromImage,
      toName: toName,
      status: status,
      callBody: callBody,
      ext: {'fcm': fcm},
    );

    final message = ChatMessage.createCustomSendMessage(
        targetId: toId, event: jsonEncode(callMessageBody.toJson()));

    message.attributes = {
      "em_apns_ext": {
        'type': NotiConstants.typeCall,
        'name': fromName,
        'content': jsonEncode(callMessageBody.toJson()),
        'content_type': message.body.type.name,
      },
      // "em_force_notification": true
    };
    message.attributes?.addAll({"em_force_notification": true});

    final msg = await ChatClient.getInstance.chatManager.sendMessage(message);
    CallListModel model = CallListModel(toId, callMessageBody.fromName,
        callMessageBody.toImage, true, msg.serverTime,msg.msgId, callMessageBody);
    ref.read(callListProvider.notifier).addCall(model);
    return msg;
// ref.read(chatConversationProvider).updateConversation(convId)
  } catch (e) {
    print('Error in logging call Event');
  }
  return null;
}
