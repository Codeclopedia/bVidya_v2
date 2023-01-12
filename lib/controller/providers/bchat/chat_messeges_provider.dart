import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/utils/chat_utils.dart';

import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

final bhatMessagesProvider = ChangeNotifierProvider.autoDispose
    .family<ChatMessagesChangeProvider, ConversationModel>(
        (ref, id) => ChatMessagesChangeProvider(id));

class ChatMessagesChangeProvider extends ChangeNotifier {
  final Map<String, ChatMessage> _messagesMap = {};

  List<ChatMessage> get messages => _messagesMap.values.toList();

  bool _isLoadingMore = false;

  bool _hasMoreData = false;

  bool get hasMoreData => _hasMoreData;

  bool get isLoadingMore => _isLoadingMore;

  // final String conversationId;
  final ConversationModel convModel;

  ChatMessagesChangeProvider(this.convModel);

  ChatPresence? _chatPresence;

  String get onlineStatus => parseChatPresenceToReadable(_chatPresence);

  init() async {
    _chatPresence = await fetchOnlineStatus(convModel.id);
    _registerPresence();
    try {
      await convModel.conversation?.markAllMessagesAsRead();
      final chats = await convModel.conversation?.loadMessages(loadCount: 20);
      if (chats != null) {
        for (var e in chats) {
          _messagesMap.addAll({e.msgId: e});
        }
      }
      _hasMoreData = chats?.length == 20;
    } on ChatError catch (e) {
      debugPrint('error in chats: $e');
    } catch (e) {
      debugPrint('other error in chats: $e');
    }
    notifyListeners();
  }

  void _registerPresence() {
    try {
      ChatClient.getInstance.presenceManager
          .subscribe(members: [convModel.id], expiry: 100);
      ChatClient.getInstance.presenceManager.addEventHandler(
        "user_presence_chat_screen",
        ChatPresenceEventHandler(
          onPresenceStatusChanged: (list) {
            for (ChatPresence s in list) {
              if (s.publisher == convModel.id) {
                _chatPresence = s;
                notifyListeners();
                break;
              }
            }
          },
        ),
      );
    } on ChatError catch (e) {
      debugPrint('error in subscribe presence : $e');
    }
  }

  void _unRegisterPresence() {
    try {
      ChatClient.getInstance.presenceManager
          .unsubscribe(members: [convModel.id]);
      ChatClient.getInstance.presenceManager
          .removeEventHandler("user_presence_chat_screen");
    } on ChatError catch (e) {
      debugPrint('error in unsubscribe presence: $e');
    }
  }

  void addChat(ChatMessage e) {
    if (e.conversationId == convModel.id && e.chatType == ChatType.Chat) {
      _messagesMap.addAll({e.msgId: e});
      notifyListeners();
    }
  }

  void addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == convModel.id && e.chatType == ChatType.Chat) {
        _messagesMap.addAll({e.msgId: e});
      }
    }
    notifyListeners();
  }

  void loadMore() async {
    try {
      if (convModel.conversation != null && messages.isNotEmpty) {
        _isLoadingMore = true;
        notifyListeners();

        final message = messages[0];

        final chats = await convModel.conversation
            ?.loadMessages(loadCount: 20, startMsgId: message.msgId);
        if (chats != null) {
          for (var e in chats) {
            _messagesMap.addAll({e.msgId: e});
          }
        }
        _isLoadingMore = false;
        _hasMoreData = chats?.length == 20;

        notifyListeners();
      }
    } on ChatError catch (e) {
      debugPrint('error in more chats: $e');
    } catch (e) {
      debugPrint('other error in more chats: $e');
    }
  }

  // void remove(ChatMessage m) {
  //   _messagesMap.remove(m.msgId);
  //   notifyListeners();
  // }

  Future<ChatMessage?> sendMessage(ChatMessage message) async {
    try {
      final chat =
          await ChatClient.getInstance.chatManager.sendMessage(message);
      addChat(chat);
      return chat;
    } on ChatError catch (e) {
      debugPrint('error in sening chat: $e');
    } catch (e) {
      debugPrint('other error in deleting chat: $e');
    }
    return null;
  }

  void deleteMessages(List<ChatMessage> msgs) {
    print('before usersize :${_messagesMap.length}');
    for (ChatMessage m in msgs) {
      try {
        convModel.conversation?.deleteMessage(m.msgId);
        _messagesMap.remove(m.msgId);
      } on ChatError catch (e) {
        debugPrint('error in deleting chat: $e');
      } catch (e) {
        debugPrint('other error in deleting chat: $e');
      }
    }
    print('after usersize :${_messagesMap.length}');
    notifyListeners();
  }

  @override
  void dispose() {
    _unRegisterPresence();
    super.dispose();
  }
}
