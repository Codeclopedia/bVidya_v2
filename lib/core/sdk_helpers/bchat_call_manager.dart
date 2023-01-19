import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/utils.dart';
import '/data/models/call_message_body.dart';

class CallListModel {
  final String name;
  final String image;
  final int time;
  final bool outgoing;
  final CallMessegeBody body;

  CallListModel(this.name, this.image, this.outgoing, this.time, this.body);
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
            model = CallListModel(callBody.toName, callBody.image ?? '', true,
                m.serverTime, callBody);
          } else {
            model = CallListModel(callBody.fromName, callBody.image ?? '',
                false, m.serverTime, callBody);
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

Future<Map<String, CallListModel>> getGroupCallList() async {
  try {
    final me = (await getMeAsUser())!;
    final list =
        await ChatClient.getInstance.chatManager.loadAllConversations();
    Map<String, CallListModel> maps = {};
    for (var conv in list) {
      if (conv.type != ChatConversationType.GroupChat) {
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
            model = CallListModel(callBody.fromName, callBody.image ?? '', true,
                m.serverTime, callBody);
          } else {
            model =
                CallListModel(me.name, me.image, true, m.serverTime, callBody);
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
