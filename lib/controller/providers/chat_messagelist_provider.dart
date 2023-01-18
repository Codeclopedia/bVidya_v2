import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/state.dart';

final selectedChatMessageListProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
        (ref) => ChatMessageNotifier());

class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessageNotifier() : super([]);

  ChatMessage? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void addChat(ChatMessage todo) {
    state = [...state, todo];
  }

  void addChatsOnly(List<ChatMessage> chats) {
    for (var c in chats) {
      state = [...state, c];
    }
  }

  void remove(ChatMessage message) {
    List<ChatMessage> newState = [];
    for (var c in state) {
      if (c.msgId != message.msgId) {
        newState.add(c);
      }
    }
    state = newState;
  }

  void clear() {
    state = [];
  }
}
