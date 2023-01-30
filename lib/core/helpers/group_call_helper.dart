// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '../routes.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/core/constants/route_list.dart';
import '/core/helpers/bmeet_helper.dart';
import '/core/helpers/call_helper.dart';
import '/core/utils.dart';
import '/data/models/call_message_body.dart';
import '/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/bmeet_providers.dart';
import '../../ui/screens.dart';
import '../constants/notification_const.dart';
import '../sdk_helpers/bchat_call_manager.dart';
import '../sdk_helpers/bchat_group_manager.dart';
import '../state.dart';
import '../ui_core.dart';

Future joinGroupCall(BuildContext context, WidgetRef ref, String callId,
    CallType callType) async {
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  if (!await handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return;
    }
  }
  showLoading(ref);
}

Future<bool> receiveGroupCall(BuildContext context,
    {required int requestId,
    required String membersIds,
    required String callId,
    required String groupId,
    required String grpName,
    required String grpImage,
    required CallType callType,
    required bool direct}) async {
  User? user = await getMeAsUser();
  if (user == null) return false;

  // final response =
  //     await BMeetApiService.instance.joinMeet(user.authToken, callId);
  // if (response.body?.meeting != null) {
  //   JoinMeeting joinMeeting = response.body!.meeting!;
  //   Meeting smeeting = Meeting(joinMeeting.appid, joinMeeting.channel,
  //       joinMeeting.token, 'audience', joinMeeting.audienceLatency);

  //   final userRTMToken = await BMeetApiService.instance
  //       .fetchUserToken(user.authToken, 1000000 + user.id, user.name);

  //   if (userRTMToken != null) {
  Map<String, dynamic> args = {
    'group_id': groupId,
    'group_name': grpName,
    'request_call_id': requestId,
    'call_id': callId,
    'call_type': callType,
    // 'call_direction': CallDirectionType.incoming,
    'user': user,
    'group_image': grpImage,
    'members_ids': membersIds,
    'prev_screen': direct ? '' : Routes.getCurrentScreen()
  };
  Navigator.pushNamed(context, RouteList.groupCallScreenReceive,
      arguments: args);
  return true;
  //   }
  // }
}

Future<ChatMessage?> makeGroupCall(WidgetRef ref, BuildContext context,
    ChatGroup group, CallType callType) async {
  User? me = await getMeAsUser();
  if (me == null) {
    return null;
  }

  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return null;
    }
  }
  if (callType == CallType.video &&
      !await handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return null;
    }
  }

  showLoading(ref);
  final grpInfo = ref.read(groupMembersInfo(group.groupId)).valueOrNull;
  final List<Contacts> contacts = [];
  if (grpInfo == null || grpInfo.members.isEmpty) {
    final contactList =
        await BchatGroupManager.fetchContactsOfGroup(ref, group.groupId);
    contacts.addAll(
        contactList.map((e) => Contacts.fromContact(e, ContactStatus.group)));
  } else {
    contacts.addAll(grpInfo.members);
  }

  if (contacts.isEmpty) {
    hideLoading(ref);
    return null;
  }

  final scheduledMeeting =
      await ref.read(bMeetRepositoryProvider).createInstantMeeting();
  if (scheduledMeeting != null) {
    final meeting = await ref
        .read(bMeetRepositoryProvider)
        .startHostMeeting(scheduledMeeting.id);

    // final userRTMToken = await ref
    //     .read(bMeetRepositoryProvider)
    //     .fetchUserToken(1000000 + me.id, me.name);
    hideLoading(ref);
    // if (userRTMToken != null) {
    if (meeting != null) {
      final callMessageBody = GroupCallMessegeBody(
        requestId: scheduledMeeting.id,
        callId: scheduledMeeting.meetingId,
        callType: callType,
        fromName: me.name,
        groupImage: BchatGroupManager.getGroupImage(group),
        fromImage: me.name,
        groupName: group.name ?? '',
        status: CallStatus.ongoing,
        meeting: meeting,
        fromFCM: me.fcmToken,
        memberIds: contacts.map((e) => e.userId.toString()).join(','),
        duration: 0,
        // ext: {},
      );

      final msg = await _logGroupCallEvent(
          ref, me.name, me.image, group.groupId, callMessageBody);

      Map<String, dynamic> args = {
        'group_id': group.groupId,
        'group_name': group.name,
        'members': contacts,
        'request_call_id': callMessageBody.requestId,
        'call_id': callMessageBody.callId,
        'meeting': meeting,
        'call_type': callType,
        'group_image': callMessageBody.groupImage,
        // 'rtm_token': userRTMToken,
        'call_direction': CallDirectionType.outgoing,
        'user': me,
        'prev_screen': Routes.getCurrentScreen()
      };
      await Navigator.pushNamed(context, RouteList.groupCallScreen,
          arguments: args);

      return msg;
    }
  } else {
    hideLoading(ref);
  }
  return null;
}

Future<ChatMessage?> _logGroupCallEvent(
  WidgetRef ref,
  String fromName,
  String fromImage,
  String groupId,
  GroupCallMessegeBody callMessageBody,
) async {
  try {
    final message = ChatMessage.createCustomSendMessage(
      targetId: groupId,
      event: jsonEncode(callMessageBody.toJson()),
      chatType: ChatType.GroupChat,
    );

    message.attributes = {
      "em_apns_ext": {
        'type': NotiConstants.typeGroupCall,
        'from_name': fromName,
        'from_image': fromImage,
        'content': jsonEncode(callMessageBody.toJson()),
        'content_type': message.body.type.name,
      },
    };
    message.attributes?.addAll({'from_name': fromName});
    message.attributes?.addAll({'from_image': fromImage});

    message.attributes?.addAll({"em_force_notification": true});

    final msg = await ChatClient.getInstance.chatManager.sendMessage(message);
    GroupCallListModel model = GroupCallListModel(
        groupId,
        callMessageBody.groupName,
        callMessageBody.groupImage,
        true,
        msg.serverTime,
        msg.msgId,
        callMessageBody);
    ref.read(groupCallListProvider.notifier).addCall(model);
    return msg;
// ref.read(chatConversationProvider).updateConversation(convId)
  } catch (e) {
    print('Error in logging call Event');
  }
  return null;
}

//     required this.callType,
//     required this.rtmTokem,
//     required this.callDirectionType,
//     required this.me,
