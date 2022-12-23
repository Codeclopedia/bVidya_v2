import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../core/state.dart';
import '/data/models/models.dart';
import '/data/repository/bchat_repository.dart';
import '/data/services/bchat_api_service.dart';
import 'providers/chat_conversations_provider.dart';
import 'providers/chat_messagelist_provider.dart';
import 'providers/group_chat_conversations_provider.dart';

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

final groupChatConversationListProvider = StateNotifierProvider.autoDispose<
    GroupChatConversationNotifier,
    List<GroupModel>>((ref) => GroupChatConversationNotifier());

//Loading Previous Chat
final chatLoadingPreviousProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

//Loading Previous Chat
final chatHasMoreOldMessageProvider = StateProvider.autoDispose<bool>(
  ((ref) => true),
);

final chatMessageListProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
        (ref) => ChatMessageNotifier());
