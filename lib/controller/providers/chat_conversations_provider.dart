// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:collection/collection.dart';

// import '/core/state.dart';
// import '/data/models/conversation_model.dart';

// class ChatConversationNotifier extends StateNotifier<List<ConversationModel>> {
//   ChatConversationNotifier() : super([]);

//   ConversationModel? getLast() {
//     if (state.isEmpty) return null;
//     return state[0];
//   }

//   void clear() {
//     state = [];
//   }

//   void addConversation(ConversationModel c) {
//     state = [...state, c];
//   }

//   void addConversations(List<ConversationModel> chats) {
//     state = [];
//     for (var c in chats) {
//       state = [...state, c];
//     }
//     // newState.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
//     //     .compareTo(a.lastMessage?.serverTime ?? 0));
//     // state = [chats.reversed, ...state];
//   }

//   void updateStatus(List<ChatPresence> list) {
//     List<ConversationModel> newState = [];

//     for (var s in state) {
//       final value = list.firstWhereOrNull((e) => e.publisher == s.id);
//       newState.add(ConversationModel(
//           id: s.id,
//           contact: s.contact,
//           badgeCount: s.badgeCount,
//           conversation: s.conversation,
//           lastMessage: s.lastMessage,
//           // isOnline: value ?? s.isOnline,
//           ));
//     }
//     newState.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
//         .compareTo(a.lastMessage?.serverTime ?? 0));
//     state = newState;
//   }

//   void update(ConversationModel m) {
//     List<ConversationModel> newState = [];
//     for (var s in state) {
//       if (m.id == s.id) {
//         newState.add(m);
//       } else {
//         newState.add(ConversationModel(
//             id: s.id,
//             contact: s.contact,
//             badgeCount: s.badgeCount,
//             conversation: s.conversation,
//             lastMessage: s.lastMessage,
//             isOnline: s.isOnline));
//       }
//     }
//     newState.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
//         .compareTo(a.lastMessage?.serverTime ?? 0));
//     state = newState;
//   }
// }
