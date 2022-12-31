// ignore_for_file: avoid_print

import 'dart:convert';
// import 'package:collection/collection.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/helpers/bchat_group_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/bchat_api_service.dart';
import '/controller/bchat_providers.dart';

import '/core/state.dart';
import '../../firebase_options.dart';
import '../../data/models/models.dart';

class BChatSDKController {
  final User _currentUser;

  // WidgetRef? _ref;
  BChatSDKController(this._currentUser) {
    print('BChatSDKController initialized');
  }

  bool _initialized = false;
  bool shouldLoadRemote = false;

  loadChats(WidgetRef ref) async {
    print('loadinging chats $_initialized');
    if (!_initialized) {
      print('init from loadChats');
      await initChatSDK();
    }
    // _isFirstTimeLoading = true;
    await loadConversations(ref);
  }

  Future initChatSDK() async {
    // _ref = ref;
    print('initChatSDK $_initialized');
    if (_initialized) {
      return;
    }
    _initialized = true;
    print('_initialized');
    final pref = await SharedPreferences.getInstance();

    final token =
        await BChatApiService.instance.fetchChatToken(_currentUser.authToken);
    String? oldChatBody = pref.getString('chat_body');

    if (token.body != null) {
      bool shouldLogin = true;
      if (oldChatBody != null) {
        int? login = pref.getInt('last_login');
        ChatTokenBody oldBody = ChatTokenBody.fromJson(jsonDecode(oldChatBody));
        shouldLogin = oldBody.appKey != token.body!.appKey ||
            oldBody.userId != token.body!.userId ||
            (DateTime.now().millisecondsSinceEpoch - (login ?? 0)) >
                60 * 60 * 1000;
        // oldBody.userToken != token.body!.userToken;
      }

      print('shouldLogin -  $shouldLogin');
      print('oldChatBody -  $oldChatBody');
      print('newChatBody -  ${token.body!.toJson()}');
      // ${oldChatBody.toString()}
      ChatOptions options = ChatOptions(
        appKey: token.body!.appKey,
        autoLogin: false,
        acceptInvitationAlways: true,
        deleteMessagesAsExitGroup: false,
        requireAck: true,
        requireDeliveryAck: true,
      );

      options.enableFCM(DefaultFirebaseOptions.currentPlatform.appId);
      await ChatClient.getInstance.init(options);
      // showLoading(ref);
      bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();

      if (alreadyLoggedIn) {
        if (!shouldLogin) {
          return;
        }
        try {
          await ChatClient.getInstance.logout(false);
        } catch (e) {}
      }

      if (shouldLogin || !alreadyLoggedIn) {
        await _signIn(token.body!.userId.toString(), token.body!.userToken);
        await pref.setInt('last_login', DateTime.now().millisecondsSinceEpoch);
        await pref.setString('chat_body', jsonEncode(token.body!));
      }

      // print('token - ${token.body!.userId}');

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
      await ChatClient.getInstance.userInfoManager.updateUserInfo(
        avatarUrl: _currentUser.image,
        ext: _currentUser.fcmToken,
        nickname: _currentUser.name,
        mail: _currentUser.email,
        phone: _currentUser.phone,
      );
    } on ChatError catch (e) {
      print('Login Error: ${e.code}- ${e.description}');
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
        isOnline: null //await fetchOnlineStatus(m.contact.userId.toString()
        );
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
            isOnline:
                null //await BChatContactManager.fetchOnlineStatus(m.contact.userId.toString())
            );
        conversations.add(model);
      }

      if (conversations.isNotEmpty) {
        conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 0)
            .compareTo(a.lastMessage?.serverTime ?? 1));
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
      conversations = await ref
          .read(bChatSDKProvider)
          .loadContactsConversationsList(firstTime: shouldLoadRemote);
      shouldLoadRemote = false;
      print('conversations : ${conversations.length}');
      // conversations = ref
      //     .watch(bChatConvListProvider)
      //     .maybeWhen(data: (data) => data, orElse: () => []);
      // final response =
      //     await BChatApiService.instance.getContacts(_currentUser.authToken);
      // List<Contacts>? contacts = response.body?.contacts;
      // List<ChatConversation> list =
      //     await ChatClient.getInstance.chatManager.loadAllConversations();

      // if (contacts?.isNotEmpty == true) {
      //   print('contacts size =${contacts!.length}');
      //   if (list.isEmpty) {
      //     try {
      //       list = await ChatClient.getInstance.chatManager
      //           .getConversationsFromServer();
      //     } on ChatError catch (e) {
      //       print('Error while fetching conversations from Server: $e');
      //     }
      //   }

      //   final chatManager = ChatClient.getInstance.chatManager;
      //   final ids = contacts.map((e) => e.userId.toString()).toList();
      //   // final List<ChatPresence> onlineUsers =
      //   //     await BChatContactManager.fetchOnlineStatuses(ids);

      //   await ChatClient.getInstance.presenceManager.fetchPresenceStatus(
      //       members: contacts.map((e) => e.userId.toString()).toList());
      //   for (var cont in contacts) {
      //     print('${cont.name} - ${cont.userId}');
      //     final conv = await chatManager.getConversation(cont.userId.toString(),
      //         type: ChatConversationType.Chat);
      //     // final online = onlineUsers.firstWhereOrNull(
      //     //     (element) => element.publisher == cont.userId.toString());
      //     // final state = onlineUsers.retainWhere((e) => e.publisher== cont.peerId);
      //     print('Conversation is ${(conv == null) ? '' : 'Not'} Null');

      //     if (conv == null) continue;
      //     final lastMessage = await conv.latestMessage();
      //     if (lastMessage == null) continue;

      //     ConversationModel model = ConversationModel(
      //         id: cont.userId.toString(),
      //         badgeCount: await conv.unreadCount(),
      //         contact: cont,
      //         conversation: conv,
      //         lastMessage: lastMessage,
      //         isOnline: null); // online);
      //     conversations.add(model);
      //   }
      // } else {
      //   print('contacts list is empty');
      //   if (list.isNotEmpty) {
      //     // Found some conversations
      //   }
      // }
    } catch (e) {
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
    List<GroupConversationModel> conversations = [];
    // conversations.clear();
    try {
      conversations = await BchatGroupManager.loadGroupConversationsList();
    } catch (e) {
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
