import '/core/state.dart';
import '/data/models/models.dart';

class GroupChatConversationNotifier extends StateNotifier<List<GroupConversationModel>> {
  GroupChatConversationNotifier() : super([]);

  GroupConversationModel? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void clear() {
    state = [];
  }

  void addConversation(GroupConversationModel c) {
    state = [...state, c];
  }

  void addConversations(List<GroupConversationModel> chats) {
    state = [];
    for (var c in chats) {
      state = [...state, c];
    }
    // state = [chats.reversed, ...state];
  }
}
