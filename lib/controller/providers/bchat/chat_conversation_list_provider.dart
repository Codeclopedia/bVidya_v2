// import 'dart:js_util';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/constants/agora_config.dart';

import '/core/utils/chat_utils.dart';
import '/data/models/models.dart';
import '/core/state.dart';
import 'contact_list_provider.dart';

final conversationLoadingStateProvider = StateProvider<bool>((ref) => false);

final chatConversationProvider = StateNotifierProvider<
    ChatConversationChangeNotifier,
    List<ConversationModel>>((ref) => ChatConversationChangeNotifier());

Future loadChats(WidgetRef ref, {bool updateStatus = false}) async {
  final list = await ref.read(contactListProvider.notifier).setup(ref);
  await ref
      .read(chatConversationProvider.notifier)
      .setup(ref, list, updateStatus);
}

Future<ConversationModel?> addNewContact(
    Contacts contact, WidgetRef ref) async {
  ref.read(contactListProvider.notifier).addContactItem(contact);
  return await ref
      .read(chatConversationProvider.notifier)
      .addConversationByContact(contact);
}

// Future<Contacts?> addNewFriendById(int contactId, WidgetRef ref) async {
//   return await ref
//       .read(contactListProvider.notifier)
//       .addContact(contactId, ContactStatus.friend);
// }

Future<ConversationModel?> onNewChatMessage(
    ChatMessage message, WidgetRef ref) async {
  // int startTime = DateTime.now().millisecondsSinceEpoch;
  int id = int.parse(message.conversationId!);
  Contacts? contact = await ref
      .read(contactListProvider.notifier)
      .addContact(id, ContactStatus.invited);
  if (contact != null) {
    final model = await ref
        .read(chatConversationProvider.notifier)
        .addConversationMessageTo(contact, message);
    // int diff = DateTime.now().millisecondsSinceEpoch - startTime;
    // print('Diff=> $diff');
    return model;
  }
  // int diff = DateTime.now().millisecondsSinceEpoch - startTime;
  // print('Diff NULL=> $diff');
  return null;
}

Future<Contacts?> deleteContact(int id, WidgetRef ref) async {
  if (id == AgoraConfig.bViydaAdmitUserId) return null;
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

  Future registerPresence(
    WidgetRef ref,
  ) async {
    try {
      final List<String> ids = ref
          .read(contactListProvider)
          .where((element) => element.status == ContactStatus.friend)
          .map((e) => e.userId.toString())
          .toList();

      List<String> onbserveList = [...ids];
      onbserveList.removeWhere(
          (element) => element == AgoraConfig.bViydaAdmitUserId.toString());
      ChatClient.getInstance.presenceManager
          .subscribe(members: onbserveList, expiry: 60 * 30); //30 minutes
      // print('register for pressence=>$onbserveList');
      ChatClient.getInstance.presenceManager.addEventHandler(
        "user_presence_home_screen",
        ChatPresenceEventHandler(
          onPresenceStatusChanged: (list) async {
            for (ChatPresence s in list) {
              if (s.publisher == AgoraConfig.bViydaAdmitUserId.toString()) {
                continue;
              }
              print('changed pressence=>${s.publisher}');

              final model = _chatConversationMap[s.publisher];

              if (model != null) {
                try {
                  if (model.conversation?.latestMessage() == null &&
                      model.contact.status == ContactStatus.friend) return;
                  final lastMessage = await model.conversation!.latestMessage();
                  final newModel = ConversationModel(
                      id: model.id,
                      badgeCount: await model.conversation?.unreadCount() ?? 0,
                      contact: model.contact,
                      conversation: model.conversation,
                      lastMessage: lastMessage,
                      isOnline: s,
                      mute: model.mute);
                  _chatConversationMap.addAll({model.id: newModel});
                  state = _chatConversationMap.values.toList();
                } catch (e) {
                  break;
                }
              }
            }
          },
        ),
      );
    } on ChatError catch (e) {
      print('error in subscribe presence : $e');
    }
  }

  @override
  void dispose() {
    unRegisterPresence();
    super.dispose();
  }

  bool isDestroyed = false;
  void unRegisterPresence() {
    try {
      if (isDestroyed) return;
      isDestroyed = true;
      final List<String> ids = _chatConversationMap.values
          .where((element) => element.contact.status == ContactStatus.friend)
          .map((e) => e.id)
          .toList();
      // List<String> ids = _chatConversationMap.keys.toList();
      ChatClient.getInstance.presenceManager.unsubscribe(members: ids);
    } on ChatError catch (e) {
      print('error in unsubscribe presence: $e');
    }
  }

  Future setup(
      WidgetRef ref, List<Contacts> contacts, bool updateStatus) async {
    if (_isLoading) return;
    _isLoading = true;
    // final contacts = ref.read(contactListProvider);
    // ref.read(conversationLoadingStateProvider.notifier).state = _isLoading;

    final List<ChatPresence?> statuses;
    if (updateStatus) {
      List<String> ids = contacts.map((e) => e.userId.toString()).toList();
      statuses = await fetchOnlineStatuses(ids);
      // registerPresence(ref, ids);
    } else {
      statuses = [];
    }
    int index = -1;
    for (Contacts contact in contacts) {
      index++;
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
            isOnline: updateStatus ? statuses[index] : null,
            mute: (await BChatContactManager.fetchChatMuteStateFor(
                    contact.userId.toString()) !=
                ChatPushRemindType.NONE));
      } catch (e) {
        // print('error $e');
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
        if (model.conversation?.latestMessage() == null &&
            model.contact.status == ContactStatus.friend) return;
        final lastMessage = await model.conversation!.latestMessage();
        final newModel = ConversationModel(
            id: model.id,
            badgeCount: await model.conversation?.unreadCount() ?? 0,
            contact: model.contact,
            conversation: model.conversation,
            lastMessage: lastMessage,
            isOnline: model.isOnline,
            mute: model.mute);
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        // print('error $e');
        return;
      }
      state = _chatConversationMap.values.toList();
    }
  }

  Future updateConversationPin(String id, bool pinned) async {
    final model = _chatConversationMap[id];
    if (model != null) {
      try {
        if (model.conversation?.latestMessage() == null &&
            model.contact.status == ContactStatus.friend) return;
        final lastMessage = await model.conversation!.latestMessage();
        final contact = model.contact;
        contact.ispinned = pinned;
        // contact.ispinned = model.contact.ispinned;

        final newModel = ConversationModel(
            id: model.id,
            badgeCount: await model.conversation?.unreadCount() ?? 0,
            contact: contact,
            conversation: model.conversation,
            lastMessage: lastMessage,
            isOnline: model.isOnline,
            mute: model.mute);
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        // print('error $e');
        return;
      }
      state = _chatConversationMap.values.toList();
    }
  }

  Future updateConversationMute(String id, bool muted) async {
    final model = _chatConversationMap[id];
    if (model != null) {
      try {
        if (model.conversation?.latestMessage() == null &&
            model.contact.status == ContactStatus.friend) return;
        final lastMessage = await model.conversation!.latestMessage();

        final newModel = ConversationModel(
            id: model.id,
            badgeCount: await model.conversation?.unreadCount() ?? 0,
            contact: model.contact,
            conversation: model.conversation,
            lastMessage: lastMessage,
            isOnline: model.isOnline,
            mute: muted);
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        // print('error $e');
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
          isOnline: await fetchOnlineStatus(model.id),
          mute: (await BChatContactManager.fetchChatMuteStateFor(
                  model.id.toString()) !=
              ChatPushRemindType.NONE),
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
            isOnline: model.isOnline,
            mute: model.mute);
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
          isOnline: await fetchOnlineStatus(contact.userId.toString()),
          mute: (await BChatContactManager.fetchChatMuteStateFor(
                  contact.userId.toString()) !=
              ChatPushRemindType.NONE),
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
        isOnline: await fetchOnlineStatus(contact.userId.toString()),
        mute: (await BChatContactManager.fetchChatMuteStateFor(
                contact.userId.toString()) !=
            ChatPushRemindType.NONE),
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
        if (model.conversation?.latestMessage() == null &&
            model.contact.status == ContactStatus.friend) continue;
        final lastMessage = await model.conversation!.latestMessage();
        final newModel = ConversationModel(
          id: model.id,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          contact: model.contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
          isOnline: model.isOnline,
          mute: model.mute,
        );
        _chatConversationMap.addAll({model.id: newModel});
      } catch (e) {
        print('error $e');
        continue;
      }
    }
    state = _chatConversationMap.values.toList();
  }

  void clear() {
    _chatConversationMap.clear();
    state = [];
  }
}
