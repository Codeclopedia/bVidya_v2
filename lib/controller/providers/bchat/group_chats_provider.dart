import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/helpers/extensions.dart';
import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'chat_messeges_provider.dart';

final loadingMoreStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final hasMoreStateProvider = StateProvider.autoDispose<bool>((ref) => true);

final groupChatProvider = StateNotifierProvider.autoDispose.family<
    GroupChatChangeNotifier,
    List<ChatMessageExt>,
    GroupConversationModel>((ref, model) => GroupChatChangeNotifier(model));

class GroupChatChangeNotifier extends StateNotifier<List<ChatMessageExt>> {
  GroupChatChangeNotifier(this.grpModel) : super([]);

// class GroupChatChangeProvider extends ChangeNotifier {
  final Map<String, ChatMessage> _messagesMap = {};

  // List<ChatMessage> get messages => _messagesMap.values.toList();

  bool _isLoadingMore = false;
  bool _hasMoreData = false;

  // bool get hasMoreData => _hasMoreData;

  // bool get isLoadingMore => _isLoadingMore;

  final GroupConversationModel grpModel;
  // GroupChatChangeProvider(this.grpModel);

  init(WidgetRef ref) async {
    // grpModel = model;
    if (grpModel.conversation != null) {
      // BackgroundHelper.clearPool(grpModel.id.hashCode);
      try {
        try {
          await grpModel.conversation?.markAllMessagesAsRead();
          await ChatClient.getInstance.chatManager
              .sendConversationReadAck(grpModel.id);
        } catch (_) {}

        final chats = await grpModel.conversation?.loadMessages(loadCount: 20);
        if (chats != null) {
          for (var e in chats) {
            _messagesMap.addAll({e.msgId: e});
          }
        }
        _hasMoreData = chats?.length == 20;
        if (mounted) {
          ref.read(hasMoreStateProvider.notifier).state = _hasMoreData;
        }
        // _hasMoreData = chats?.length == 20;
      } catch (e) {
        print('Error in loading chats $e');
      }
      updateMessageList();
      // state = _messagesMap.values.toList();
    }
  }

  addChat(ChatMessage e) {
    if (e.conversationId == grpModel.id && e.chatType == ChatType.GroupChat) {
      _messagesMap.addAll({e.msgId: e});
      // notifyListeners();
    }
    // state = _messagesMap.values.toList();
    updateMessageList();
  }

  void updateMessageList() {
    final chatList = _messagesMap.values.toList().reversed.toList();

    List<ChatMessageExt> messages = [];
    int i = 0;
    while (i < chatList.length) {
      final item = chatList[i];
      if (item.body.type == MessageType.IMAGE ||
          item.body.type == MessageType.VIDEO) {
        final album = getAlbum(chatList, i);
        messages.add(album);
        i += album.messages.length;
      } else {
        messages.add(ChatMessageExt([item]));
        i++;
      }
    }

    state = messages;
  }

  addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == grpModel.id && e.chatType == ChatType.GroupChat) {
        // print('New Group Message=> ${e.msgId}');
        _messagesMap.addAll({e.msgId: e});
      }
    }
    updateMessageList();
  }

  loadMore(WidgetRef ref) async {
    try {
      if (grpModel.conversation != null &&
          _messagesMap.isNotEmpty &&
          _hasMoreData &&
          !_isLoadingMore) {
        _isLoadingMore = true;
        // notifyListeners();
        ref.read(loadingMoreStateProvider.notifier).state = true;
        final message = _messagesMap.values.toList()[0];
        // print('next_chat_id ${message.msgId}');
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
        _hasMoreData = chats?.length == 20;
        ref.read(loadingMoreStateProvider.notifier).state = false;

        ref.read(hasMoreStateProvider.notifier).state = chats?.length == 20;

        // ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
        // ref.read(chatHasMoreOldMessageProvider.notifier).state =
        //     chats?.length == 20;
        updateMessageList();
        // state = _messagesMap.values.toList();
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
    // state = _messagesMap.values.toList();
    updateMessageList();
  }

  void updateUi() {
    // state = _messagesMap.values.toList();
    updateMessageList();
  }
}
