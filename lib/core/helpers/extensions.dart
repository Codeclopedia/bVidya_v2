import 'dart:convert';
import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../data/models/call_message_body.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

class ChatGroupSharedFileEx {
  final File? filePath;
  final ChatGroupSharedFile fileInfo;

  ChatGroupSharedFileEx(this.filePath, this.fileInfo);

  // ChatGroupSharedFileEx.fromJson(super.map)
  //     : filePath = map!['filepath'],
  //       super.fromJson();
}
