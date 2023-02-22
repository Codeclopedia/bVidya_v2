// import '/core/state.dart';
// import '/core/sdk_helpers/bchat_contact_manager.dart';
// import '/data/models/models.dart';

// class ChatConversationNotifier extends StateNotifier<List<ConversationModel>> {
//   ChatConversationNotifier() : super([]);

//   final Map<String, ConversationModel> models = {};

//   setup(WidgetRef ref) async {
//     models.clear();

//     final conversations = await BChatContactManager.getChatConversationsIds();
//     if (conversations.isNotEmpty) {
//       for (var conv in conversations) {}
//     }
//   }
// }
