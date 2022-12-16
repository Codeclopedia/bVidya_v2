import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../controller/bchat_providers.dart';
import '../../core/constants/agora_config.dart';
import '../../core/constants/data.dart';
import '../../core/state.dart';
import '../../firebase_options.dart';
import '../models/models.dart';
import '../services/bchat_api_service.dart';

class BChatRepository {
  static const successfull = 'successfull';

  final BChatApiService api;
  final User _currentUser;
  // final List<ConversationModel> conversations = [];

  WidgetRef? _ref;

  BChatRepository(this.api, this._currentUser);

  initChatSDK(ref) async {
    _ref ??= ref;
    // _currentUser = await getMeAsUser();
    ChatOptions options = ChatOptions(
      appKey: AgoraConfig.appKey,
      autoLogin: false,
    );
    options.enableFCM(DefaultFirebaseOptions.currentPlatform.appId);
    await ChatClient.getInstance.init(options);

    bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
    if (alreadyLoggedIn) {
      loadConversations();
      return;
    }
    String myUserId = _currentUser.id.toString();
    final agoraToken = userTokenMap[myUserId] ?? '';
    _signIn(myUserId, agoraToken);
  }

  void _signIn(String userId, String agoraToken) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        userId,
        agoraToken,
      );
      print("login succeed, userId: ${userId}");
      loadConversations();
    } on ChatError catch (e) {
      if (e.code == 200 || e.code == 202) {
        loadConversations();
      }
      print("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void signOut() async {
    try {
      await ChatClient.getInstance.logout(false);
      print("sign out succeed");
    } on ChatError catch (e) {
      print("sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  Future signOutAsync() async {
    try {
      await ChatClient.getInstance.logout(true);
      print("sign out succeed");
    } on ChatError catch (e) {
      print("sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void loadConversations() async {
    List<ConversationModel> conversations = [];
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
            final unread = await conv.unreadCount();
            final fromId = (await conv.lastReceivedMessage())?.from ??
                (myUserId == 24 ? 1 : 24);

            ChatMessage? message = await conv.latestMessage();
            ConversationModel model = ConversationModel(
              id: fromId.toString(),
              badgeCount: unread,
              user: usersMap[fromId.toString()]!,
              conversation: conv,
              lastMessage: message,
            );
            conversations.add(model);
          }
        } else {
          // print('Conversation is blank');
          final fromId = myUserId == 24 ? 1 : 24;
          ConversationModel model = ConversationModel(
            id: fromId.toString(),
            badgeCount: 0,
            user: usersMap[fromId.toString()]!,
            conversation: null,
            lastMessage: null,
          );
          conversations.add(model);
        }
      }
    } on ChatError catch (e) {
      print(e);
      // recall failed, code: e.code, reason: e.description
    }
    if (conversations.isNotEmpty) {
      try {
        _ref
            ?.read(chatConversationListProvider.notifier)
            .addConversations(conversations);
      } catch (e) {
        print(e);
      }
    }
  }
}
