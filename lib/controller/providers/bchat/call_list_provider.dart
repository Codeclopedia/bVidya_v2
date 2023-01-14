import '/core/sdk_helpers/bchat_call_manager.dart';
import '/core/state.dart';

// final callListLoading = StateProvider<bool>((ref) => true);
final callListProvider =
    StateNotifierProvider<CallMessageNotifier, List<CallListModel>>(
        (ref) => CallMessageNotifier());

final groupCallListProvider =
    StateNotifierProvider<CallMessageNotifier, List<CallListModel>>(
        (ref) => CallMessageNotifier());


class CallMessageNotifier extends StateNotifier<List<CallListModel>> {
  CallMessageNotifier() : super([]); //listMessages.reversed.toList()

  String? _cursor;
  String? get cursor => _cursor;

  CallListModel? getLast() {
    if (state.isEmpty) return null;
    return state[0];
    // int length = state.length;
    // return state[length - 1];
  }

  void addCall(CallListModel todo) {
    state = [...state, todo];
  }

  void addCalls(List<CallListModel> chats, String? cur) {
    for (var c in chats) {
      state = [...state, c];
    }
    _cursor = cur;
  }

  // void addCallOnly(List<CallListModel> chats) {
  //   for (var c in chats) {
  //     state = [...state, c];
  //   }
  // }

  void remove(CallListModel message) {
    List<CallListModel> newState = [];
    for (var c in state) {
      if (c.body.callId != message.body.callId) {
        newState.add(c);
      }
    }
    state = newState;
    // state = [...state, todo];
  }

  void clear() {
    state = [];
  }

  setup() async {
    state = [...await getCallList()];
    // ref.read(callListLoading.notifier).state = false;
  }

  setupGroup() async {
    state = [...await getCallList()];
    // ref.read(callListLoading.notifier).state = false;
  }
}
