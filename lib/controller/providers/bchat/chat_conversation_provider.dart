import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/data/repository/bchat_respository.dart';
import '/data/services/bchat_api_service.dart';

import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/core/utils.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/data/models/models.dart';

import '/core/ui_core.dart';
import '/core/state.dart';

final chatConversationProvider =
    ChangeNotifierProvider((ref) => ChatConversationChangeProvider.instance);

class ChatConversationChangeProvider extends ChangeNotifier {
  static ChatConversationChangeProvider instance =
      ChatConversationChangeProvider._();

  ChatConversationChangeProvider._();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final Map<int, Contacts> _contactsMap = {};

  List<Contacts> get contacts => _contactsMap.values.toList();

  final Map<String, ConversationModel> _chatConversationMap = {};

  List<ConversationModel> get chatConversationList =>
      _chatConversationMap.values.toList();

  bool _initialized = false;

  Future setup(BChatRepository reader, User user) async {
    if (_initialized) {
      return;
    }
    await BChatSDKController.instance.initChatSDK(user);
    
    _initialized = true;
    _chatConversationMap.clear();
    try {
      _isLoading = true;
      // try{}catch()
      final User? loginUser = await getMeAsUser();
      if (loginUser == null) {
        _isLoading = false;
        return;
      }

      List<Contacts> contacts = [];
      final ids = await BChatContactManager.getContacts();
      if (ids.isNotEmpty) {
        // BChatRepository reader = ref.read(bChatProvider);
        List<Contact> friends = await reader.getContactsByIds(ids) ?? [];
        contacts = friends
            .map((e) => Contacts.fromContact(e, ContactStatus.friend))
            .toList();
      }

      for (Contacts contact in contacts) {
        _contactsMap.addAll({contact.userId: contact});
        final ConversationModel model;
        try {
          final conv = await ChatClient.getInstance.chatManager.getConversation(
              contact.userId.toString(),
              type: ChatConversationType.Chat);
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
        // conversations.add(model);
      }
    } catch (e) {
      print('error $e');
    }
    _isLoading = false;
  }

  Future init(BChatRepository reader) async {
    if (_initialized && _contactsMap.isNotEmpty) {
      return;
    }
    await BChatSDKController.instance.init();
    _initialized = true;
    _chatConversationMap.clear();
    try {
      _isLoading = true;

      List<Contacts> contacts = [];
      final ids = await BChatContactManager.getContacts();
      if (ids.isNotEmpty) {
        // BChatRepository reader = ref.read(bChatProvider);
        List<Contact> friends = await reader.getContactsByIds(ids) ?? [];
        contacts = friends
            .map((e) => Contacts.fromContact(e, ContactStatus.friend))
            .toList();
      }

      for (Contacts contact in contacts) {
        _contactsMap.addAll({contact.userId: contact});
        final ConversationModel model;
        try {
          final conv = await ChatClient.getInstance.chatManager.getConversation(
              contact.userId.toString(),
              type: ChatConversationType.Chat);
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
        // conversations.add(model);
      }
    } catch (e) {
      print('error $e');
    }
    _isLoading = false;
    updateUi();
  }

  Future addOrUpdateConversation(ConversationModel model) async {
    _contactsMap.addAll({model.contact.userId: model.contact});
    _chatConversationMap.update(model.id, (v) => model, ifAbsent: () => model);
    updateUi();
  }

  Future updateConversation(String convId) async {
    ConversationModel newModel;
    try {
      final model = _chatConversationMap[convId];
      if (model != null) {
        final conv = model.conversation;
        // final conv = await ChatClient.getInstance.chatManager
        //     .getConversation(convId, type: ChatConversationType.Chat);
        if (conv == null) return;
        final lastMessage = await conv.latestMessage();
        if (lastMessage == null) return;
        newModel = ConversationModel(
          id: convId.toString(),
          badgeCount: await conv.unreadCount(),
          contact: model.contact,
          conversation: conv,
          lastMessage: lastMessage,
        );
        _chatConversationMap.update(convId, (v) => newModel,
            ifAbsent: () => newModel);
      }
    } catch (e) {
      return;
    }

    // notifyListeners();
  }

  Future<Contacts?> removedContact(int userId) async {
    try {
      final user = await getMeAsUser();
      if (user == null || userId <= 0) {
        return null;
      }
      _chatConversationMap.remove(userId.toString());
      final cont = _contactsMap[userId];
      _contactsMap.remove(userId);
      updateUi();
      return cont;
    } catch (_) {}
    return null;
  }

  Future<Contacts?> addContact(String userId, ContactStatus status) async {
    try {
      final user = await getMeAsUser();
      if (user == null) {
        return null;
      }
      if (_contactsMap.containsKey(userId)) {
        //Already in listadded
        updateUi();
        return null;
      }

      final Contacts contact;

      final result = await BChatApiService.instance
          .getContactsByIds(user.authToken, userId);
      if (result.body?.contacts?.isNotEmpty == true) {
        contact = Contacts.fromContact(result.body!.contacts![0], status);
        _contactsMap.addAll({contact.userId: contact});
        updateUi();
        return contact;
      } else {
        return null;
      }
    } catch (e) {
      print('Error while loadin chats $e');
    }
    return null;
  }

  Future addConveration(Contacts contact) async {
    try {
      _contactsMap.addAll({contact.userId: contact});

      final conv = await ChatClient.getInstance.chatManager.getConversation(
          contact.userId.toString(),
          type: ChatConversationType.Chat);
      if (conv == null) return;
      final lastMessage = await conv.latestMessage();
      if (lastMessage == null) return;
      ConversationModel model = ConversationModel(
        id: contact.userId.toString(),
        badgeCount: await conv.unreadCount(),
        contact: contact,
        conversation: conv,
        lastMessage: lastMessage,
        // isOnline: null,
      );
      _chatConversationMap.addAll({model.id: model});
    } catch (e) {
      return;
    }
  }

  Future updateConversationMessage(ChatMessage lastMessage,
      {bool update = false}) async {
    try {
      final id = lastMessage.conversationId;
      if (id == null) {
        print('Conversation id is null');
        return;
      }

      final model = _chatConversationMap[id];
      if (model != null) {
        print('Conversation id  ${model.lastMessage!.from.toString()} $update');
        final newModel = ConversationModel(
          id: model.id,
          badgeCount: (await model.conversation?.unreadCount()) ?? 0,
          contact: model.contact,
          conversation: model.conversation,
          lastMessage: lastMessage,
          // isOnline: null,
        );
        _chatConversationMap.update(id, (v) => newModel,
            ifAbsent: () => newModel);
        if (update) {
          updateUi();
        }
      } else {
        final user = await getMeAsUser();
        if (user == null) {
          return;
        }
        final Contacts contact;
        if (_contactsMap.containsKey(id)) {
          contact = _contactsMap[id]!;
        } else {
          final result = await BChatApiService.instance
              .getContactsByIds(user.authToken, id);
          if (result.body?.contacts?.isNotEmpty == true) {
            contact = Contacts.fromContact(
                result.body!.contacts![0], ContactStatus.invited);
            _contactsMap.addAll({contact.userId: contact});
          } else {
            return;
          }
          final conv = await ChatClient.getInstance.chatManager
              .getConversation(id, type: ChatConversationType.Chat);
          ConversationModel newModel = ConversationModel(
            id: id,
            badgeCount: (await conv?.unreadCount()) ?? 0,
            contact: contact,
            conversation: conv,
            lastMessage: await conv?.latestMessage(),
          );
          _chatConversationMap.addAll({id: newModel});
        }
      }
    } catch (e) {
      return;
    }
    if (update) {
      updateUi();
    }
    //
  }

  void updateUi() {
    try {
      notifyListeners();
    } catch (e) {
      print('Error in notify the ui');
    }
  }

  void updateConversationOnly(String id) async {
    await updateConversation(id);
    updateUi();
  }

  void deleteConversationOnly(String id) {
    ConversationModel? model = _chatConversationMap.remove(id);
    if (model != null) {
      updateUi();
    }
  }
}
