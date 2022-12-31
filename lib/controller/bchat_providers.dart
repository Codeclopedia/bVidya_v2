import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:bvidya/core/helpers/bchat_group_manager.dart';

import '/core/helpers/bchat_contact_manager.dart';
import '/core/helpers/duration.dart';
import '/core/state.dart';
import '/data/repository/bchat_sdk_repository.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';
import '/data/repository/bchat_respository.dart';

import 'providers/p2p_call_provider.dart';
import 'providers/bchat_sdk_controller.dart';
import 'providers/chat_conversations_provider.dart';
import 'providers/chat_messagelist_provider.dart';
import 'providers/group_chat_conversations_provider.dart';

final apiBChatProvider = Provider<BChatApiService>(
  (_) => BChatApiService.instance,
);

final bChatSDKControllerProvider = Provider<BChatSDKController>((ref) {
  User? user = ref.read(loginRepositoryProvider).user;
  return BChatSDKController(user!);
});

final bChatSDKProvider = Provider<BChatSDKRepository>((ref) {
  User? user = ref.read(loginRepositoryProvider).user;
  final api = ref.read(apiBChatProvider);
  return BChatSDKRepository(api, user?.authToken ?? '');
});

// final bChatConvListProvider = FutureProvider<List<ConversationModel>>((ref) {
//   return ref.read(bChatSDKProvider).getConversations();
// });

// final bChatListProvider = StateProvider<List<ConversationModel>>((ref) {
//   return ref.watch(bChatRepositoryProvider).conversations;
// });

final chatConversationListProvider =
    StateNotifierProvider<ChatConversationNotifier, List<ConversationModel>>(
        (ref) => ChatConversationNotifier());

final groupChatConversationListProvider = StateNotifierProvider<
    GroupChatConversationNotifier,
    List<GroupConversationModel>>((ref) => GroupChatConversationNotifier());

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

final loadingChatProvider = StateProvider<bool>(
  (_) => true,
);

//Chat API CALLS

final bChatProvider = Provider<BChatRepository>((ref) {
  User? user = ref.read(loginRepositoryProvider).user;
  return BChatRepository(ref.read(apiBChatProvider), user?.authToken ?? '');
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchChatContact =
    FutureProvider.autoDispose<List<SearchContactResult>>((ref) async {
  final term = ref.watch(searchQueryProvider).trim();
  User? user = ref.read(loginRepositoryProvider).user;
  if (term.isNotEmpty && user != null) {
    // print('searching contact of name $term from ${user.id}');
    // final results = [];
    final result = await ref.read(bChatProvider).searchContact(term);
    if (result?.contacts?.isNotEmpty == true) {
      return result!.contacts!
          .where((element) => element.userId != user.id)
          .toList();
    }
    return [];
  } else {
    return [];
  }
});

// final myContactIds = FutureProvider<List<Contacts>>((ref) {});

final myContactsList = FutureProvider<List<Contacts>>((ref) async {
  final ids = await BChatContactManager.getContacts();
  final contacts = await ref.read(bChatProvider).getContactsByIds(ids);
  return contacts ?? [];
});

// final myGroupsList = FutureProvider<List<GroupConversationModel>>((ref) async {
//   // final ids = await BChatContactManager.getContacts();
//   // final contacts = await ref.read(bChatProvider).getContactsByIds(ids);
//   return BchatGroupManager.loadGroupConversationsList();
// });

final chatContactsList =
    FutureProvider.autoDispose<List<Contacts>>((ref) async {
  final result = await ref.read(bChatProvider).getContacts();
  if (result?.contacts?.isNotEmpty == true) {
    return result!.contacts!;
  }
  return [];
});

final audioCallTimerProvider =
    StateNotifierProvider.autoDispose<DurationNotifier, DurationModel>(
  (_) => DurationNotifier(),
);

final audioCallChangeProvider =
    ChangeNotifierProvider.autoDispose<P2PCallProvider>(
        (ref) => P2PCallProvider(ref.read(audioCallTimerProvider.notifier)));
