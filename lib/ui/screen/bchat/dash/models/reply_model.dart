import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class ReplyModel {
  final ChatMessage message;
  final String fromId;
  final String fromName;

  ReplyModel({required this.message,required  this.fromId,required  this.fromName});
}
