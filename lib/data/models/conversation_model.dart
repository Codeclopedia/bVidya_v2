import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'contact_model.dart';

class ConversationModel {
  final Contacts contact;
  final String id;
  final ChatMessage? lastMessage;
  final int badgeCount;
  final ChatConversation? conversation;
  final bool mute;
  // final ChatPresence? isOnline;

  const ConversationModel(
      {required this.id,
      required this.contact,
      required this.badgeCount,
      required this.conversation,
      required this.lastMessage,
      // required this.isOnline,
      this.mute = false});
}

class GroupConversationModel {
  final ChatGroup groupInfo;
  final String image;
  final String id;
  final ChatMessage? lastMessage;
  final int badgeCount;
  final ChatConversation? conversation;
  final bool mute;
  // final ChatPresence? isOnline;

  const GroupConversationModel(
      {required this.id,
      required this.groupInfo,
      required this.badgeCount,
      required this.conversation,
      required this.lastMessage,
      required this.image,
      // required this.isOnline,
      this.mute = false});
}
