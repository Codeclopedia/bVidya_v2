import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/state.dart';

class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessageNotifier() : super([]); //listMessages.reversed.toList()

  String? _cursor;
  String? get cursor => _cursor;

  ChatMessage? getLast() {
    if (state.isEmpty) return null;
    return state[0];
    // int length = state.length;
    // return state[length - 1];
  }

  void addChat(ChatMessage todo) {
    // int length = state.length;

    // if (length < 1 || state[length - 1].msgId != todo.msgId) {
    state = [...state, todo];
    // }
  }

  void addChats(List<ChatMessage> chats, String? cur) {
    for (var c in chats) {
      state = [...state, c];
    }
    _cursor = cur;
    // state = [chats.reversed, ...state];
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
    // state = [...state, todo];
  }

  void clear() {
    state = [];
  }
}
