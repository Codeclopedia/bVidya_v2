import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class ReplyModel {
  final ChatMessage message;
  final String fromName;

  ReplyModel({required this.message, required this.fromName});

  ReplyModel.fromJson(Map<String, dynamic> json)
      : message = ChatMessage.fromJson(json["message"]),
        fromName = json["from_name"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message.toJson();
    data['from_name'] = fromName;
    return data;
  }
}
