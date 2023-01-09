import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

final groupChatProvider = ChangeNotifierProvider.autoDispose
    .family<GroupChatChangeProvider, GroupConversationModel>(
        (ref, id) => GroupChatChangeProvider(id));

class GroupChatChangeProvider extends ChangeNotifier {
  final Map<String, ChatMessage> _messagesMap = {};

  List<ChatMessage> get messages => _messagesMap.values.toList();

  bool _isLoadingMore = false;
  bool _hasMoreData = false;

  bool get hasMoreData => _hasMoreData;

  bool get isLoadingMore => _isLoadingMore;
  // final String conversationId;
  final GroupConversationModel grpModel;
  GroupChatChangeProvider(this.grpModel);

  

  addMessage() {}

  init() async {
    // grpModel = model;
    if (grpModel.conversation != null) {
      try {
        await grpModel.conversation?.markAllMessagesAsRead();
        final chats = await grpModel.conversation?.loadMessages(loadCount: 20);
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

  addChat(ChatMessage e) {
    if (e.conversationId == grpModel.id &&
        e.chatType == ChatType.GroupChat) {
      _messagesMap.addAll({e.msgId: e});
      notifyListeners();
    }
  }

  addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == grpModel.id &&
          e.chatType == ChatType.GroupChat) {
        _messagesMap.addAll({e.msgId: e});
      }
    }
    notifyListeners();
  }

  loadMore() async {
    try {
      if (grpModel.conversation != null && messages.isNotEmpty) {
        _isLoadingMore = true;
        notifyListeners();

        final message = messages[0];
        print('next_chat_id ${message.msgId}');
        // await Future.delayed(const Duration(seconds: 2));
        final chats = await grpModel.conversation
            ?.loadMessages(loadCount: 20, startMsgId: message.msgId);
        if (chats != null) {
          for (var e in chats) {
            _messagesMap.addAll({e.msgId: e});
          }
        }
        _isLoadingMore = false;
        _hasMoreData = chats?.length == 20;
        // ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
        // ref.read(chatHasMoreOldMessageProvider.notifier).state =
        //     chats?.length == 20;
        notifyListeners();
      }
    } catch (e) {}
  }

  // setIsLoadingMore(bool value) {
  //   _isLoadingMore = value;
  //   notifyListeners();
  // }

  // setHasMoreData(bool value) {
  //   _hasMoreData = value;
  //   notifyListeners();
  // }
}
