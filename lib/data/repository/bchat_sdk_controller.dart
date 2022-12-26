// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../services/bchat_api_service.dart';
import '/controller/bchat_providers.dart';

import '/core/state.dart';
import '../../firebase_options.dart';
import '../models/models.dart';

class BChatSDKController {
  final User _currentUser;

  WidgetRef? _ref;
  BChatSDKController(this._currentUser);

  initChatSDK(ref) async {
    _ref ??= ref;

    final token =
        await BChatApiService.instance.fetchChatToken(_currentUser.authToken);
    if (token.body != null) {
      ChatOptions options = ChatOptions(
        appKey: token.body!.appKey,
        autoLogin: false,
      );
      options.enableFCM(DefaultFirebaseOptions.currentPlatform.appId);
      await ChatClient.getInstance.init(options);
      bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
      if (alreadyLoggedIn) {
        await loadConversations();
        return;
      }
      _signIn(token.body!.userId.toString(), token.body!.userToken);
    }
  }

  void _signIn(String userId, String agoraToken) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        userId,
        agoraToken,
      );
      await loadConversations();
    } on ChatError catch (e) {
      if (e.code == 200 || e.code == 202) {
        await loadConversations();
      }
    }
  }

  Future loadConversations() async {
    List<ConversationModel> conversations = [];

    print('Start Loading conversations');
    try {
      final response =
          await BChatApiService.instance.getContacts(_currentUser.authToken);
      List<Contacts>? contacts = response.body?.contacts;
      List<ChatConversation> list =
          await ChatClient.getInstance.chatManager.loadAllConversations();

      if (contacts?.isNotEmpty == true) {
        print('contacts size =${contacts!.length}');
        if (list.isEmpty) {
          try {
            list = await ChatClient.getInstance.chatManager
                .getConversationsFromServer();
          } on ChatError catch (e) {
            print('Error while fetching conversations from Server: $e');
          }
        }

        final chatManager = ChatClient.getInstance.chatManager;
        for (var cont in contacts) {
          final conv = await chatManager.getConversation(cont.peerId,
              type: ChatConversationType.Chat);

          print('Conversation is ${(conv == null) ? '' : 'Not'} Null');

          if (conv == null) continue;
          final lastMessage = await conv.latestMessage();
          if (lastMessage == null) continue;
          ConversationModel model = ConversationModel(
            id: cont.peerId,
            badgeCount: await conv.unreadCount(),
            contact: cont,
            conversation: conv,
            lastMessage: lastMessage,
          );
          conversations.add(model);
        }
      } else {
        print('contacts list is empty');
        if (list.isNotEmpty) {
          // Found some conversations
        }
      }
    } on ChatError catch (e) {
      // recall failed, code: e.code, reason: e.description
    }
    if (conversations.isNotEmpty) {
      conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
          .compareTo(a.lastMessage?.serverTime ?? 0));
      try {
        _ref
            ?.read(chatConversationListProvider.notifier)
            .addConversations(conversations);
      } catch (e) {
        print('error while adding to conversations : $e');
      }
    }
  }

  void signOut() async {
    try {
      await ChatClient.getInstance.logout(false);
    } on ChatError catch (_) {}
  }

  Future signOutAsync() async {
    try {
      await ChatClient.getInstance.logout(true);
    } on ChatError catch (_) {}
  }

  void loadGroupConversations() async {
    List<GroupModel> conversations = [];
    // conversations.clear();
    try {
      List<ChatConversation> list =
          await ChatClient.getInstance.chatManager.loadAllConversations();

      if (list.isEmpty) {
        try {
          list = await ChatClient.getInstance.chatManager
              .getConversationsFromServer();
        } on ChatError catch (_) {
          // print(e);
          // recall failed, code: e.code, reason: e.description
        }
      }
      final myUserId = _currentUser.id;
      if (myUserId == 1 || myUserId == 24) {
        if (list.isNotEmpty) {
          for (var conv in list) {
            if (conv.type != ChatConversationType.GroupChat) {
              continue;
            }
            final unread = await conv.unreadCount();
            final fromId = (await conv.lastReceivedMessage())?.from;

            ChatMessage? message = await conv.latestMessage();
            GroupModel model = GroupModel(
              '', '',
              badgeCount: unread,
              lastMessage: message,

              // id: fromId.toString(),
              // badgeCount: unread,
              // user: usersMap[fromId.toString()]!,
              // conversation: conv,
              // lastMessage: message,
            );
            conversations.add(model);
          }
        } else {
          // print('Conversation is blank');
          final fromId = myUserId == 24 ? 1 : 24;
          GroupModel model = GroupModel(
            '', '',
            // id: fromId.toString(),
            // badgeCount: 0,
            // user: usersMap[fromId.toString()]!,
            // conversation: null,
            // lastMessage: null,
          );
          conversations.add(model);
        }
      }
    } on ChatError catch (e) {
      // recall failed, code: e.code, reason: e.description
    }
    if (conversations.isNotEmpty) {
      try {
        _ref
            ?.read(groupChatConversationListProvider.notifier)
            .addConversations(conversations);
      } catch (e) {}
    }
  }
}
