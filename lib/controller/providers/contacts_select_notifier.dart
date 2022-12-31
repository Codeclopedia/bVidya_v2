import '/core/state.dart';
import '/data/models/models.dart';

final selectedContactProvider =
    StateNotifierProvider.autoDispose<GroupContactNotifier, List<Contacts>>(
        (ref) => GroupContactNotifier());

class GroupContactNotifier extends StateNotifier<List<Contacts>> {
  GroupContactNotifier() : super([]);

  Contacts? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void clear() {
    state = [];
  }

  void addContact(Contacts c) {
    state = [...state, c];
  }

  void removeContact(Contacts c) {
    state = state.where((element) => c.userId != element.userId).toList();
    // state = [...state, c];
  }

  // void addContacts(List<ContactModel> chats) {
  //   state = [];
  //   for (var c in chats) {
  //     state = [...state, c];
  //   }
  //   // state = [chats.reversed, ...state];
  // }
}
