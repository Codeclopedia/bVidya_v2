import 'package:bvidya/data/models/conversation_model.dart';

import '../core/state.dart';
import '../data/models/response/auth/login_response.dart';
import '../data/repository/bchat_repository.dart';
import '../data/services/bchat_api_service.dart';
import 'providers/chat_conversations_provider.dart';

final apiBChatProvider = Provider<BChatApiService>(
  (_) => BChatApiService.instance,
);

final bChatRepositoryProvider = Provider<BChatRepository>((ref) {
  User? user = ref.read(loginRepositoryProvider).user;
  return BChatRepository(ref.read(apiBChatProvider), user!);
});

// final bChatListProvider = StateProvider<List<ConversationModel>>((ref) {
//   return ref.watch(bChatRepositoryProvider).conversations;
// });

final chatConversationListProvider = StateNotifierProvider.autoDispose<
    ChatConversationNotifier,
    List<ConversationModel>>((ref) => ChatConversationNotifier());
