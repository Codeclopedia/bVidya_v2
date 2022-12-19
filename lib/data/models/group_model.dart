import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class GroupModel {
  final String name;
  final String image;
  final int badgeCount;
  ChatMessage? lastMessage;
  ChatConversation? conversation;

  GroupModel(this.name, this.image,
      {this.badgeCount = 0, this.lastMessage, this.conversation});
}
