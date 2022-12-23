import '/core/state.dart';
import '/data/models/models.dart';

class GroupChatConversationNotifier extends StateNotifier<List<GroupModel>> {
  GroupChatConversationNotifier() : super([]);

  GroupModel? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void clear() {
    state = [];
  }

  void addConversation(GroupModel c) {
    state = [...state, c];
  }

  void addConversations(List<GroupModel> chats) {
    state = [];
    for (var c in chats) {
      state = [...state, c];
    }
    // state = [chats.reversed, ...state];
  }
}
