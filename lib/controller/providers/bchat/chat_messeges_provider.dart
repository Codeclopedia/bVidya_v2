import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '../../../data/models/call_message_body.dart';
import '/core/helpers/extensions.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/chat_utils.dart';

import '/data/models/conversation_model.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

final bChatMessagesProvider = StateNotifierProvider.autoDispose.family<
    ChatMessagesChangeProvider,
    List<ChatMessageExt>,
    ConversationModel>((ref, model) => ChatMessagesChangeProvider(model));

final onlineStatusProvider = StateProvider.autoDispose<ChatPresence?>(
  (ref) => null,
);

class ChatMessagesChangeProvider extends StateNotifier<List<ChatMessageExt>> {
  ChatMessagesChangeProvider(this.convModel) : super([]);

  final Map<String, ChatMessage> _messagesMap = {};

  bool _isLoadingMore = false;

  bool _hasMoreData = false;

  bool get hasMoreData => _hasMoreData;

  bool get isLoadingMore => _isLoadingMore;

  final ConversationModel convModel;

  init(WidgetRef ref) async {
    // BackgroundHelper.clearPool(convModel.id.hashCode);
    _registerPresence(ref);
    await readAll();
    try {
      // await convModel.conversation?.markAllMessagesAsRead();
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
    updateMessageList();
  }

  void _registerPresence(WidgetRef ref) async {
    try {
      final status = await fetchOnlineStatus(convModel.id);
      ref.read(onlineStatusProvider.notifier).state = status;
      // ChatClient.getInstance.presenceManager
      //     .subscribe(members: [convModel.id], expiry: 60);
      ChatClient.getInstance.presenceManager.addEventHandler(
        "user_presence_chat_screen",
        ChatPresenceEventHandler(
          onPresenceStatusChanged: (list) {
            for (ChatPresence s in list) {
              if (s.publisher == convModel.id) {
                ref.read(onlineStatusProvider.notifier).state = s;
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
      // ChatClient.getInstance.presenceManager
      //     .unsubscribe(members: [convModel.id]);
      ChatClient.getInstance.presenceManager
          .removeEventHandler("user_presence_chat_screen");
    } on ChatError catch (e) {
      debugPrint('error in unsubscribe presence: $e');
    }
  }

  void addChat(ChatMessage e) {
    if (e.conversationId == convModel.id && e.chatType == ChatType.Chat) {
      _messagesMap.addAll({e.msgId: e});
      updateMessageList();
    }
  }

  void addChats(List<ChatMessage> chats) {
    for (var e in chats) {
      if (e.conversationId == convModel.id && e.chatType == ChatType.Chat) {
        _messagesMap.addAll({e.msgId: e});
      }
    }
    updateMessageList();
  }

  void loadMore() async {
    try {
      if (convModel.conversation != null && state.isNotEmpty) {
        _isLoadingMore = true;
        updateMessageList();

        final message = _messagesMap.values.toList()[0];

        final chats = await convModel.conversation
            ?.loadMessages(loadCount: 20, startMsgId: message.msgId);

        if (chats != null) {
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
        _isLoadingMore = false;
        _hasMoreData = chats?.length == 20;

        updateMessageList();
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
    updateMessageList();
  }

  Future readAll() async {
    try {
      await convModel.conversation?.markAllMessagesAsRead();

      await ChatClient.getInstance.chatManager
          .sendConversationReadAck(convModel.id);
    } catch (e) {}
  }

  @override
  void dispose() {
    readAll();
    _unRegisterPresence();
    super.dispose();
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
        if (item.body.type == MessageType.CUSTOM && !isMissedCall(item)) {
          i++;
          continue;
        }
        messages.add(ChatMessageExt([item]));
        i++;
      }
    }
    state = messages;
  }

  bool isMissedCall(ChatMessage msg) {
    try {
      ChatCustomMessageBody body = msg.body as ChatCustomMessageBody;
      final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
      if (callBody.isMissedType() && msg.from == convModel.id) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  void updateMessageDelivered(List<ChatMessage> message) {
    // state = _messagesMap.values.toList();
    updateMessageList();
  }

  void updateMessageRead(List<ChatMessage> message) {
    updateMessageList();
    // state = _messagesMap.values.toList();
  }
}

ChatMessageExt getAlbum(List<ChatMessage> feedList, int offset) {
  int i = offset;
  // final ChatMessage? preMsg =
  //     i < feedList.length - 1 ? feedList[i + 1] : null;
  final ChatMessage? nxtMsg = i > 0 ? feedList[i - 1] : null;
  final ChatMessage message = feedList[i];
  // final bool isAfterDateSeparator = shouldShowDateSeparator(preMsg, message);
  final bool isBeforeDateSeparator;
  if (nxtMsg != null) {
    isBeforeDateSeparator = shouldShowDateSeparator(message, nxtMsg);
  } else {
    isBeforeDateSeparator = false;
  }

  // bool isPreviousSameAuthor = false;
  // bool isNextSameAuthor = false;
  // if (preMsg?.from == message.from) {
  //   isPreviousSameAuthor = true;
  // }
  // if (nxtMsg?.from == message.from) {
  //   isNextSameAuthor = true;
  // }

  if (isBeforeDateSeparator
      // ||
      // isAfterDateSeparator ||
      // !isPreviousSameAuthor ||
      // !isNextSameAuthor
      ) {
    return ChatMessageExt([message]);
  }

  while (i < feedList.length &&
      (feedList[i].body.type == MessageType.IMAGE ||
          message.body.type == MessageType.VIDEO) &&
      feedList[i].from == message.from) {
    i++;
  }
  if (i - offset < 4) {
    return ChatMessageExt([message]);
  } else {
    return ChatMessageExt(feedList.sublist(offset, i));
  }

  // return (i - offset < 4) ? null : feedList.sublist(offset, i);
}
