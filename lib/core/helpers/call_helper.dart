// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/data/repository/auth_repository.dart';
import 'package:permission_handler/permission_handler.dart';

// import '/data/services/fcm_api_service.dart';
import '/data/services/push_api_service.dart';
import '../routes.dart';
import '/core/utils/callkit_utils.dart';
import '../constants.dart';
import '../sdk_helpers/bchat_call_manager.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/data/models/call_message_body.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
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

sendMissedCallMessage(String tId, String msgId, CallMessegeBody callBody,
    CallStatus status) async {
  callBody.status = status;
  try {
    callBody.ext.addAll({'m': msgId});
  } catch (e) {
    debugPrint('Error in updating call record $e');
  }
}

markCallMessageToMissed(String tId, String msgId, CallStatus status) async {
  try {
    // final msg = await (await ChatClient.getInstance.chatManager
    //         .getConversation(tId, createIfNeed: true))
    //     ?.loadMessage(msgId);
    var msg = await ChatClient.getInstance.chatManager.loadMessage(msgId);
    if (msg == null) {
      final messages =
          await (await ChatClient.getInstance.chatManager.getConversation(tId))
              ?.loadMessagesWithMsgType(type: MessageType.CUSTOM, count: 1);
      if (messages?.isNotEmpty == true) {
        msg = messages!.first;
      }
    }

    if (msg != null &&
        msg.chatType == ChatType.Chat &&
        msg.body.type == MessageType.CUSTOM &&
        msg.to != null) {
      ChatCustomMessageBody body = msg.body as ChatCustomMessageBody;
      final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
      callBody.status = status;
      callBody.ext.addAll({'m': msg.msgId});

      // await conv?.appendMessage(message)
      try {
        final conv = await ChatClient.getInstance.chatManager
            .getConversation(msg.to!, createIfNeed: false);
        // await ChatClient.getInstance.chatManager.recallMessage(msgId);

        await conv?.deleteMessage(msg.msgId);
      } on ChatError catch (e) {
        debugPrint('Error in deleting message $e');
      }

      final message = ChatMessage.createCustomSendMessage(
        targetId: msg.to!,
        event: jsonEncode(callBody.toJson()),
      );
      await ChatClient.getInstance.chatManager.sendMessage(message);
    } else {
      debugPrint(
          'Error in loading message-> $tId, $msgId,  ->${msg?.toJson()}');
    }
  } catch (e) {
    debugPrint('Error in updating call record $e');
  }
}

Future<ChatMessage?> makeAudioCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final blocked =
      await BChatContactManager.isUserBlocked(contact.userId.toString());
  if (blocked) return null;
  if (activeCallId != null) {
    AppSnackbar.instance.error(context, 'Already on call');
    return null;
  }
  final user = await getMeAsUser();
  if (user == null) {
    return null;
  }
  if (!await handleCameraAndMic(Permission.microphone)) {
    // if (Platform.isAndroid) {
    AppSnackbar.instance.error(context, 'Need microphone permission');
    return null;
    // }
  }
  // pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();

  showLoading(ref);
  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;

    hideLoading(ref);

    // if (contact.fcmToken?.isNotEmpty == true) {
    //   FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
    //       callBody, user.id.toString(), user.name, user.image, false);
    // }

    final myToken = await AuthRepository.getIOSAPN() ?? user.fcmToken;

    final chat = await logCallEvent(
        user.authToken,
        // false,
        contact.apnToken != null,
        ref,
        callBody.callId,
        user.name,
        user.image,
        contact.userId.toString(),
        contact.name,
        CallType.audio,
        CallDirectionType.outgoing,
        myToken,
        contact.profileImage,
        contact.apnToken ?? (contact.fcmToken ?? ''),
        user.id.toString(),
        callBody: callBody
        // fromFCM: user.fcmToken,
        // toFCM: contact.fcmToken ?? '',
        // image: contact.profileImage,
        );
    Map<String, dynamic> map = {
      'name': contact.name,
      'image': contact.profileImage,
      'token': contact.apnToken ?? contact.fcmToken,
      'is_ios': contact.apnToken != null,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing,
      'prev_screen': Routes.getCurrentScreen(),
      'user_id': contact.userId.toString(),
      'msg_id': chat?.msgId,
    };
    await Navigator.pushNamed(context, RouteList.bChatAudioCall,
        arguments: map);
    return chat;
  } else {
    hideLoading(ref);
    AppSnackbar.instance.error(context, 'Error while making call');
    return null;
  }
}

Future<bool> receiveCall(BuildContext context, String fromId,
    CallMessegeBody callMessegeBody, bool direct) async {
  Map<String, dynamic> callMap = {
    'name': callMessegeBody.fromName,
    'token': callMessegeBody.ext['token'],
    'is_ios': callMessegeBody.ext['is_ios'] ?? false,
    'image': callMessegeBody.fromImage,
    'call_info': callMessegeBody.callBody,
    'call_direction_type': CallDirectionType.incoming,
    'prev_screen': direct ? '' : Routes.getCurrentScreen(),
    'user_id': fromId
  };

  if (Routes.getCurrentScreen() == RouteList.bChatAudioCall ||
      Routes.getCurrentScreen() == RouteList.bChatVideoCall) {
    // BuildContext ctx = navigatorKey.currentContext ?? context;

    // print('Already on call screen');
    // Navigator.pop(ctx);
    return true;
  }
  Navigator.pushReplacementNamed(
      context,
      callMessegeBody.callType == CallType.video
          ? RouteList.bChatVideoCall
          : RouteList.bChatAudioCall,
      arguments: callMap);
  return true;
}

Future<ChatMessage?> makeVideoCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final blocked =
      await BChatContactManager.isUserBlocked(contact.userId.toString());
  if (blocked) return null;
  if (onGoingCallId != null) {
    AppSnackbar.instance.error(context, 'Already on call');
    return null;
  }

  final user = await getMeAsUser();
  if (user == null) {
    return null;
  }
  if (!await handleCameraAndMic(Permission.microphone)) {
    // if (Platform.isAndroid) {
    AppSnackbar.instance.error(context, 'Need microphone permission');
    return null;
    // }
  }
  if (!await handleCameraAndMic(Permission.camera)) {
    // if (Platform.isAndroid) {
    AppSnackbar.instance.error(context, 'Need camera permission');
    return null;
    // }
  }
  showLoading(ref);
  // pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();

  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;

    // if (contact.fcmToken?.isNotEmpty == true) {
    //   FCMApiService.instance.sendCallPush(contact.fcmToken ?? '', user.fcmToken,
    //       callBody, user.id.toString(), user.name, user.image, true);
    // }
    hideLoading(ref);
    final myToken = await AuthRepository.getIOSAPN() ?? user.fcmToken;

    final chat = await logCallEvent(
        user.authToken,
        // false,
        contact.apnToken != null,
        ref,
        callBody.callId,
        user.name,
        user.image,
        contact.userId.toString(),
        contact.name,
        CallType.video,
        CallDirectionType.outgoing,
        myToken,
        contact.profileImage,
        contact.apnToken ?? (contact.fcmToken ?? ''),
        user.id.toString(),
        callBody: callBody);
    Map<String, dynamic> map = {
      'name': contact.name,
      // 'fcm_token': contact.fcmToken,
      'token': contact.apnToken ?? contact.fcmToken,
      'is_ios': contact.apnToken != null,
      'image': contact.profileImage,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing,
      'prev_screen': Routes.getCurrentScreen(),
      'user_id': contact.userId.toString(),
      'msg_id': chat?.msgId
    };
    await Navigator.pushNamed(context, RouteList.bChatVideoCall,
        arguments: map);
    return chat;
  } else {
    AppSnackbar.instance.error(context, 'Error while making call');
    hideLoading(ref);
  }
  return null;
}

Future<ChatMessage?> makeCall(
    CallListModel model, WidgetRef ref, BuildContext context) async {
  if (onGoingCallId != null) {
    AppSnackbar.instance.error(context, 'Already on call');
    return null;
  }
  final blocked = await BChatContactManager.isUserBlocked(model.userId);
  if (blocked) return null;
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
    String authToken,
    bool isIos,
    WidgetRef ref,
    String callId,
    String fromName,
    String fromImage,
    String toId,
    String toName,
    CallType callType,
    CallDirectionType callDirectionType,
    String myToken,
    String image,
    String toToken,
    String fromId,
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
      ext: {'token': myToken, 'is_ios': Platform.isIOS},
    );

    print('callBody ${callMessageBody.toJson()}');
    final message = ChatMessage.createCustomSendMessage(
        targetId: toId, event: jsonEncode(callMessageBody.toJson()));

    // message.attributes = {
    //   "em_apns_ext": {
    //     'type': NotiConstants.typeCall,
    //     'name': fromName,
    //     'content': jsonEncode(callMessageBody.toJson()),
    //     'content_type': message.body.type.name,
    //   },
    //   // "em_force_notification": true
    // };
    // message.attributes?.addAll({"em_force_notification": true});

    var msg = await ChatClient.getInstance.chatManager.sendMessage(message);

    final messages =
        await (await ChatClient.getInstance.chatManager.getConversation(toId))
            ?.loadMessagesWithMsgType(type: MessageType.CUSTOM, count: 1);
    if (messages?.isNotEmpty == true) {
      msg = messages!.first;
      print('Message ID =>${msg.msgId}, $toId');
    } else {
      print('Not found: ${messages?.length}');
    }
    CallListModel model = CallListModel(
        toId,
        callMessageBody.fromName,
        callMessageBody.toImage,
        true,
        msg.serverTime,
        msg.msgId,
        callMessageBody);
    ref.read(callListProvider.notifier).addCall(model);

    // FCMApiService.instance
    PushApiService.instance.sendCallStartPush(authToken, isIos, toToken, fromId,
        callId, message.msgId, callMessageBody);
    print('Message ID =>${msg.msgId}, $toId');

    return msg;
// ref.read(chatConversationProvider).updateConversation(convId)
  } catch (e) {
    print('Error in logging call Event');
  }
  return null;
}
