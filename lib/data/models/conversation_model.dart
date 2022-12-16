import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'response/auth/login_response.dart';

class ConversationModel {
  final String id;
  final User user;
  final ChatMessage? lastMessage;
  final int badgeCount;
  final ChatConversation? conversation;
  final bool mute;

  const ConversationModel(
      {required this.id,
      required this.user,
      required this.badgeCount,
      required this.conversation,
      required this.lastMessage,
      this.mute = false});
}
