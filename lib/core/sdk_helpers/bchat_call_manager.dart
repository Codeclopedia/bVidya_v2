import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/utils.dart';
import '/data/models/call_message_body.dart';

class CallListModel {
  final String userId;
  final String name;
  final String image;
  final int time;
  final bool outgoing;
  final String msgId;
  final CallMessegeBody body;

  CallListModel(this.userId, this.name, this.image, this.outgoing, this.time,
      this.msgId, this.body);
}

class GroupCallListModel {
  final String groupId;
  final String groupName;
  final String groupImage;
  final int time;
  final bool outgoing;
  final String msgId;
  final GroupCallMessegeBody body;

  GroupCallListModel(this.groupId, this.groupName, this.groupImage, this.outgoing,
      this.time, this.msgId, this.body);
}

Future<Map<String, CallListModel>> getCallList() async {
  try {
    final me = (await getMeAsUser())!;
    final list =
        await ChatClient.getInstance.chatManager.loadAllConversations();
    Map<String, CallListModel> maps = {};
    for (var conv in list) {
      if (conv.type != ChatConversationType.Chat) {
        continue;
      }
      List<ChatMessage> messages = await conv.loadMessagesWithMsgType(
          type: MessageType.CUSTOM, count: 5);
      for (var m in messages) {
        try {
          ChatCustomMessageBody body = m.body as ChatCustomMessageBody;
          final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
          bool isOwnMessage = m.from == me.id.toString();
          CallListModel model;
          if (isOwnMessage) {
            model = CallListModel(m.to.toString(), callBody.toName,
                callBody.toImage, true, m.serverTime, m.msgId, callBody);
          } else {
            model = CallListModel(m.from.toString(), callBody.fromName,
                callBody.fromImage, false, m.serverTime, m.msgId, callBody);
          }
          maps.addAll({callBody.callId: model});
        } catch (e) {
          print('Error in loading call ${m.body.toJson()}');
          break;
        }
      }
    }
    return maps;
  } catch (e) {}
  return {};
}

Future<Map<String, GroupCallListModel>> getGroupCallList() async {
  try {
    final me = (await getMeAsUser())!;
    final list =
        await ChatClient.getInstance.chatManager.loadAllConversations();
    Map<String, GroupCallListModel> maps = {};
    for (var conv in list) {
      if (conv.type != ChatConversationType.GroupChat) {
        continue;
      }
      List<ChatMessage> messages = await conv.loadMessagesWithMsgType(
          type: MessageType.CUSTOM, count: 5);
      for (var m in messages) {
        try {
          ChatCustomMessageBody body = m.body as ChatCustomMessageBody;
          final callBody =
              GroupCallMessegeBody.fromJson(jsonDecode(body.event));
          bool isOwnMessage = m.from == me.id.toString();
          GroupCallListModel model;
          if (isOwnMessage) {
            model = GroupCallListModel(m.to.toString(), callBody.groupName,
                callBody.groupImage, true, m.serverTime, m.msgId, callBody);
          } else {
            model = GroupCallListModel(m.from.toString(), callBody.groupName,
                callBody.groupImage, false, m.serverTime, m.msgId, callBody);
          }
          maps.addAll({callBody.callId: model});
        } catch (e) {
          break;
        }
      }
    }
    return maps;
  } catch (e) {}
  return {};
}
