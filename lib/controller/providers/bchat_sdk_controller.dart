// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../data/services/bchat_api_service.dart';
import '/controller/bchat_providers.dart';

import '/core/state.dart';
import '../../firebase_options.dart';
import '../../data/models/models.dart';

class BChatSDKController {
  final User _currentUser;

  // WidgetRef? _ref;
  BChatSDKController(this._currentUser);

  bool _initialized = false;

  loadChats(WidgetRef ref) async {
    print('loadinging chats $_initialized');
    if (!_initialized) {
      await initChatSDK();
    }
    await loadConversations(ref);
  }

  Future initChatSDK() async {
    // _ref = ref;
    print('initChatSDK $_initialized');
    if (_initialized) {
      return;
    }
    _initialized = true;
    final token =
        await BChatApiService.instance.fetchChatToken(_currentUser.authToken);
    if (token.body != null) {
      ChatOptions options = ChatOptions(
        appKey: token.body!.appKey,
        autoLogin: false,
      );
      options.enableFCM(DefaultFirebaseOptions.currentPlatform.appId);
      await ChatClient.getInstance.init(options);
      // showLoading(ref);
      bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
      if (alreadyLoggedIn) {
        // registerForPresence(ref);

        return;
      }

      // print('token - ${token.body!.userId}');
      await _signIn(token.body!.userId.toString(), token.body!.userToken);
    }
  }

  Future _signIn(String userId, String agoraToken) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        userId,
        agoraToken,
      );

      await ChatClient.getInstance.pushManager
          .updateFCMPushToken(_currentUser.fcmToken);
      // registerForPresence();
      // await loadConversations(ref);
    } on ChatError catch (e) {
      if (e.code == 200 || e.code == 202) {
        // await loadConversations(ref);
      }
    }
  }

  // void registerForPresence() {
  //   ChatClient.getInstance.presenceManager.addEventHandler(
  //     "user_presence_home_screen",
  //     ChatPresenceEventHandler(
  //       onPresenceStatusChanged: (list) {
  //         _ref?.read(chatConversationListProvider.notifier).updateStatus(list);
  //       },
  //     ),
  //   );
  // }

  // Future updateOnlineStatus(){

  // }
  void reloadOnlyConversation(WidgetRef ref, ConversationModel m) async {
    ConversationModel model = ConversationModel(
        id: m.id,
        badgeCount: await m.conversation?.unreadCount() ?? 0,
        contact: m.contact,
        conversation: m.conversation,
        lastMessage: await m.conversation?.latestMessage(),
        isOnline: null);
    // conversations.add(model);
    try {
      ref.read(chatConversationListProvider.notifier).update(model);
    } catch (e) {
      print('error while adding to conversations : $e');
    }
  }

  void reloadConversation(WidgetRef ref, {bool reloadContacts = false}) async {
    final data = ref.read(chatConversationListProvider);
    if (data.isNotEmpty == true && !reloadContacts) {
      List<ConversationModel> conversations = [];
      for (var m in data) {
        final lastMessage = await m.conversation?.latestMessage();
        ConversationModel model = ConversationModel(
            id: m.id,
            badgeCount: await m.conversation?.unreadCount() ?? 0,
            contact: m.contact,
            conversation: m.conversation,
            lastMessage: lastMessage,
            isOnline: null);
        conversations.add(model);
      }

      if (conversations.isNotEmpty) {
        conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
            .compareTo(a.lastMessage?.serverTime ?? 0));
        try {
          ref
              .read(chatConversationListProvider.notifier)
              .addConversations(conversations);
        } catch (e) {
          print('error while adding to conversations : $e');
        }
      }
    } else {
      await loadConversations(ref);
    }
  }

  Future loadConversations(WidgetRef ref) async {
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
        // final List<ChatPresence> onlineUsers =
        //     await ChatClient.getInstance.presenceManager.fetchPresenceStatus(
        //         members: contacts.map((e) => e.peerId).toList());
        for (var cont in contacts) {
          print('${cont.name} - ${cont.userId}');
          final conv = await chatManager.getConversation(cont.userId.toString(),
              type: ChatConversationType.Chat);
          // final online = onlineUsers
          //     .firstWhere((element) => element.publisher == cont.peerId);
          // final state = onlineUsers.retainWhere((e) => e.publisher== cont.peerId);
          print('Conversation is ${(conv == null) ? '' : 'Not'} Null');

          if (conv == null) continue;
          final lastMessage = await conv.latestMessage();
          // if (lastMessage == null) continue;

          ConversationModel model = ConversationModel(
              id: cont.userId.toString(),
              badgeCount: await conv.unreadCount(),
              contact: cont,
              conversation: conv,
              lastMessage: lastMessage,
              isOnline: null);
          conversations.add(model);
        }
      } else {
        print('contacts list is empty');
        if (list.isNotEmpty) {
          // Found some conversations
        }
      }
    } on ChatError catch (e) {
      print('errorconversations : $e');
      // recall failed, code: e.code, reason: e.description
    }
    if (conversations.isNotEmpty) {
      conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
          .compareTo(a.lastMessage?.serverTime ?? 0));
      try {
        ref
            .read(chatConversationListProvider.notifier)
            .addConversations(conversations);
      } catch (e) {
        print('error while adding to conversations : $e');
      }
    }
    ref.read(loadingChatProvider.notifier).state = false;
    // hideLoading(_ref!);
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

  void loadGroupConversations(WidgetRef ref) async {
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
        ref
            .read(groupChatConversationListProvider.notifier)
            .addConversations(conversations);
      } catch (e) {}
    }
  }

  // void dispose() {
  //   ChatClient.getInstance.presenceManager
  //       .removeEventHandler("user_presence_home_screen");
  // }
}
