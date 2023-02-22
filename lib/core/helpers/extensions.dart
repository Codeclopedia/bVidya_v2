import 'dart:convert';
import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../data/models/call_message_body.dart';

extension RemoteMessageExt on RemoteMessage {
  Map<String, dynamic> getContent() {
    return jsonDecode(data["content"]);
  }

  CallMessegeBody? payload() {
    return CallMessegeBody?.fromJson(getContent());
  }

  GroupCallMessegeBody? grpPayload() {
    return GroupCallMessegeBody?.fromJson(getContent());
  }
}

class ChatMessageExt {
  // CAN'T BE EMPTY LIST
  final List<ChatMessage> messages;
  //MUST PASS LIST OF AT LEAST ONE MESSAGE.
  const ChatMessageExt(this.messages);
  ChatMessage get msg => messages[0];
  bool get isGroupMedia => messages.length > 1;
}

class ChatGroupSharedFileEx {
  final File? filePath;
  final ChatGroupSharedFile fileInfo;
  ChatGroupSharedFileEx(this.filePath, this.fileInfo);
}
