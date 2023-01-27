import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/data/models/models.dart';
import '/core/state.dart';
import 'contact_list_provider.dart';

final conversationLoadingStateProvider = StateProvider<bool>((ref) => false);

final chatConversationProvider = StateNotifierProvider<
    ChatConversationChangeNotifier,
    List<ConversationModel>>((ref) => ChatConversationChangeNotifier());

Future loadChats(WidgetRef ref) async {
  final list = await ref.read(contactListProvider.notifier).setup(ref);
  await ref.read(chatConversationProvider.notifier).setup(ref, list);
}

Future<ConversationModel?> addNewContact(
    Contacts contact, WidgetRef ref) async {
  ref.read(contactListProvider.notifier).addContactItem(contact);
  return await ref
      .read(chatConversationProvider.notifier)
      .addConversationByContact(contact);
}

Future<Contacts?> addNewContactById(int contactId, WidgetRef ref) async {
  return await ref.read(contactListProvider.notifier).addContact(contactId);
}

Future<ConversationModel?> onNewChatMessage(
    ChatMessage message, WidgetRef ref) async {
  int startTime = DateTime.now().millisecondsSinceEpoch;
  int id = int.parse(message.conversationId!);
  Contacts? contact =
      await ref.read(contactListProvider.notifier).addContact(id);
  if (contact != null) {
    final model = await ref
        .read(chatConversationProvider.notifier)
        .addConversationMessageTo(contact, message);
    int diff = DateTime.now().millisecondsSinceEpoch - startTime;
    print('Diff=> $diff');
    return model;
  }
  int diff = DateTime.now().millisecondsSinceEpoch - startTime;
  print('Diff NULL=> $diff');
  return null;
}

Future<Contacts?> deleteContact(int id, WidgetRef ref) async {
  final deleted = ref.read(contactListProvider.notifier).removeContact(id);
  if (deleted != null) {
    ref
        .read(chatConversationProvider.notifier)
        .removeConversation(id.toString());
  }
  return deleted;
}

class ChatConversationChangeNotifier
    extends StateNotifier<List<ConversationModel>> {
  ChatConversationChangeNotifier() : super([]);
  bool _isLoading = false;
  // bool get isLoading => _isLoading;

  final Map<String, ConversationModel> _chatConversationMap = {};

  Future setup(WidgetRef ref, List<Contacts> contacts) async {
    if (_isLoading) return;
    _isLoading = true;
    // final contacts = ref.read(contactListProvider);
    // ref.read(conversationLoadingStateProvider.notifier).state = _isLoading;

    for (Contacts contact in contacts) {
      final ConversationModel model;
      try {
        final conv = await ChatClient.getInstance.chatManager.getConversation(
            contact.userId.toString(),
            type: ChatConversationType.Chat,
            createIfNeed: true);
        if (conv == null) continue;
        final lastMessage = await conv.latestMessage();
        if (lastMessage == null) continue;
        model = ConversationModel(
          id: contact.userId.toString(),
          badgeCount: await conv.unreadCount(),
          contact: contact,
          conversation: conv,
          lastMessage: lastMessage,
        );
      } catch (e) {
        print('error $e');
        continue;
      }
      _chatConversationMap.addAll({model.id: model});
    }
    state = _chatConversationMap.values.toList();
    _isLoading = false;
    // ref.read(conversationLoadingStateProvider.notifier).state = _isLoading;
  }

  void removeConversation(String id) {
    _chatConversationMap.remove(id);
    state = _chatConversationMap.values.toList();
  }

  void addConversation(ConversationModel model) {
    _chatConversationMap.addAll({model.id: model});
    state = _chatConversationMap.values.toList();
  }

  Future updateConversation(String id) async {
    final model = _chatConversationMap[id];
    if (model != null) {
      try {
        if (model.conversation?.latestMessage() == null) return;
        final lastMessage = await model.conversation!.latestMessage();
        final newModel = ConversationModel(
          id: model.id,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          contact: model.contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
        );
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        print('error $e');
        return;
      }
      state = _chatConversationMap.values.toList();
    }
  }

  Future addConversationMessage(ChatMessage lastMessage) async {
    final model = _chatConversationMap[lastMessage.conversationId!];
    if (model != null) {
      try {
        // if (model.conversation?.latestMessage() == null) return;
        // final lastMessage = await model.conversation!.latestMessage();
        final newModel = ConversationModel(
          id: model.id,
          badgeCount: 0,
          contact: model.contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
        );
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        print('error $e');
        return;
      }
      state = _chatConversationMap.values.toList();
    }
  }

  Future<ConversationModel?> addConversationMessageTo(
      Contacts contact, ChatMessage lastMessage) async {
    final model = _chatConversationMap[contact.userId.toString()];
    ConversationModel newModel;
    if (model != null) {
      try {
        newModel = ConversationModel(
          id: model.id,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          contact: contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
        );
      } catch (e) {
        print('error $e');
        return model;
      }
    } else {
      try {
        final conv = await ChatClient.getInstance.chatManager.getConversation(
            contact.userId.toString(),
            type: ChatConversationType.Chat,
            createIfNeed: true);
        if (conv == null) return null;
        newModel = ConversationModel(
          id: contact.userId.toString(),
          badgeCount: await conv.unreadCount(),
          contact: contact,
          conversation: conv,
          lastMessage: lastMessage,
        );
      } catch (e) {
        print('error $e');
        return null;
      }
    }
    _chatConversationMap.addAll({newModel.id: newModel});
    state = _chatConversationMap.values.toList();
    return newModel;
  }

  Future<ConversationModel?> addConversationByContact(
    Contacts contact,
  ) async {
    final ConversationModel model;
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
          contact.userId.toString(),
          type: ChatConversationType.Chat,
          createIfNeed: true);
      if (conv == null) return null;
      final lastMessage = await conv.latestMessage();
      // if (lastMessage == null) return null;
      model = ConversationModel(
        id: contact.userId.toString(),
        badgeCount: await conv.unreadCount(),
        contact: contact,
        conversation: conv,
        lastMessage: lastMessage,
      );
    } catch (e) {
      print('error $e');
      return null;
    }
    _chatConversationMap.addAll({model.id: model});
    state = _chatConversationMap.values.toList();
    return model;
  }

  Future updateUnread() async {
    for (var model in _chatConversationMap.values) {
      try {
        if (model.conversation?.latestMessage() == null) continue;
        final lastMessage = await model.conversation!.latestMessage();
        final newModel = ConversationModel(
          id: model.id,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          contact: model.contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
        );
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        print('error $e');
        continue;
      }
    }
    state = _chatConversationMap.values.toList();
  }
}
