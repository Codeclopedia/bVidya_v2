import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

final bhatMessagesProvider = ChangeNotifierProvider.autoDispose
    .family<ChatMessagesChangeProvider, String>(
        (ref, id) => ChatMessagesChangeProvider(id));

class ChatMessagesChangeProvider extends ChangeNotifier {
  final Map<String, ChatMessage> _messagesMap = {};

  List<ChatMessage> get messages => _messagesMap.values.toList();

  bool _isLoadingMore = false;
  bool _hasMoreData = false;

  bool get hasMoreData => _hasMoreData;

  bool get isLoadingMore => _isLoadingMore;
  final String conversationId;

  ChatMessagesChangeProvider(this.conversationId);

  late ConversationModel _model;

  init(ConversationModel model) async {
    _model = model;
    if (model.conversation != null) {
      try {
        await _model.conversation?.markAllMessagesAsRead();
        final chats = await _model.conversation?.loadMessages(loadCount: 20);
        if (chats != null) {
          for (var e in chats) {
            _messagesMap.addAll({e.msgId: e});
          }
        }
        _hasMoreData = chats?.length == 20;
      } catch (e) {
        print('Error in loading chats');
      }
      notifyListeners();
    }
  }

  void addChat(ChatMessage e) {
    if (e.conversationId == conversationId && e.chatType == ChatType.Chat) {
      _messagesMap.addAll({e.msgId: e});
      notifyListeners();
    }
  }

  void addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == conversationId && e.chatType == ChatType.Chat) {
        _messagesMap.addAll({e.msgId: e});
      }
    }
    notifyListeners();
  }

  void loadMore() async {
    try {
      if (_model.conversation != null && messages.isNotEmpty) {
        _isLoadingMore = true;
        notifyListeners();

        final message = messages[0];

        final chats = await _model.conversation
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
    } catch (e) {}
  }

  void remove(ChatMessage m) {
    _messagesMap.remove(m.msgId);
    notifyListeners();
  }
}
