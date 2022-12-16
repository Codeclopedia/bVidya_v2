import '../../core/state.dart';
import '../../data/models/conversation_model.dart';

class ChatConversationNotifier extends StateNotifier<List<ConversationModel>> {
  ChatConversationNotifier() : super([]);

  ConversationModel? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void clear() {
    state = [];
  }

  void addConversation(ConversationModel c) {
    state = [...state, c];
  }

  void addConversations(List<ConversationModel> chats) {
    state = [];
    for (var c in chats) {
      state = [...state, c];
    }
    // state = [chats.reversed, ...state];
  }
}
