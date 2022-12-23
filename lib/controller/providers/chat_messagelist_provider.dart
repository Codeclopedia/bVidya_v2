import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/state.dart';

class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessageNotifier() : super([]); //listMessages.reversed.toList()

  String? _cursor;
  String? get cursor => _cursor;

  ChatMessage? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void addChat(ChatMessage todo) {
    state = [...state, todo];
  }

  void addChats(List<ChatMessage> chats, String? cur) {
    for (var c in chats) {
      state = [...state, c];
    }
    _cursor = cur;
    // state = [chats.reversed, ...state];
  }
}
