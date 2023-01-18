import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

// final groupChatProvider = ChangeNotifierProvider.autoDispose
//     .family<GroupChatChangeProvider, GroupConversationModel>(
//         (ref, id) => GroupChatChangeProvider(id));

final loadingMoreStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final hasMoreStateProvider = StateProvider.autoDispose<bool>((ref) => false);

final groupChatProvider = StateNotifierProvider.autoDispose
    .family<GroupChatChangeNotifier, List<ChatMessage>, GroupConversationModel>(
        (ref, model) => GroupChatChangeNotifier(model));

class GroupChatChangeNotifier extends StateNotifier<List<ChatMessage>> {
  GroupChatChangeNotifier(this.grpModel) : super([]);

// class GroupChatChangeProvider extends ChangeNotifier {
  final Map<String, ChatMessage> _messagesMap = {};

  // List<ChatMessage> get messages => _messagesMap.values.toList();

  bool _isLoadingMore = false;
  // bool _hasMoreData = false;

  // bool get hasMoreData => _hasMoreData;

  // bool get isLoadingMore => _isLoadingMore;

  final GroupConversationModel grpModel;
  // GroupChatChangeProvider(this.grpModel);

  addMessage() {}

  init(WidgetRef ref) async {
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
        ref.read(hasMoreStateProvider.notifier).state = chats?.length == 20;
        // _hasMoreData = chats?.length == 20;
      } catch (e) {
        print('Error in loading chats');
      }
      // notifyListeners();
      state = _messagesMap.values.toList();
    }
  }

  addChat(ChatMessage e) {
    if (e.conversationId == grpModel.id && e.chatType == ChatType.GroupChat) {
      _messagesMap.addAll({e.msgId: e});
      // notifyListeners();
    }
    state = _messagesMap.values.toList();
  }

  addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == grpModel.id && e.chatType == ChatType.GroupChat) {
        _messagesMap.addAll({e.msgId: e});
      }
    }
    // notifyListeners();
    state = _messagesMap.values.toList();
  }

  loadMore(WidgetRef ref) async {
    try {
      if (grpModel.conversation != null &&
          _messagesMap.isNotEmpty &&
          !_isLoadingMore) {
        _isLoadingMore = true;
        // notifyListeners();
        ref.read(loadingMoreStateProvider.notifier).state = true;
        final message = state[0];
        print('next_chat_id ${message.msgId}');
        // await Future.delayed(const Duration(seconds: 2));
        final chats = await grpModel.conversation
            ?.loadMessages(loadCount: 20, startMsgId: message.msgId);
        if (chats != null) {
          // for (var e in chats) {
          //   _messagesMap.addAll({e.msgId: e});
          // }
          final newMaps = {};
          for (var e in chats) {
            newMaps.addAll({e.msgId: e});
          }
          newMaps.addAll({..._messagesMap});
          // _messagesMap = {...newMaps,..._messagesMap};
          // final oldMap = _messagesMap;
          _messagesMap.clear();
          _messagesMap.addAll({
            ...newMaps,
          });
        }
        ref.read(loadingMoreStateProvider.notifier).state = false;

        ref.read(hasMoreStateProvider.notifier).state = chats?.length == 20;

        // _hasMoreData = chats?.length == 20;
        // ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
        // ref.read(chatHasMoreOldMessageProvider.notifier).state =
        //     chats?.length == 20;
        // notifyListeners();
        state = _messagesMap.values.toList();
      }
    } catch (e) {}
    _isLoadingMore = false;
  }

  // void deleteMessages(List<ChatMessage> selectedItems) {}

  void deleteMessages(List<ChatMessage> msgs) {
    for (ChatMessage m in msgs) {
      try {
        grpModel.conversation?.deleteMessage(m.msgId);
        _messagesMap.remove(m.msgId);
      } on ChatError catch (e) {
        debugPrint('error in deleting chat: $e');
      } catch (e) {
        debugPrint('other error in deleting chat: $e');
      }
    }
    state = _messagesMap.values.toList();
    // notifyListeners();
  }
}
