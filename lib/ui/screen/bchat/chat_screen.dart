import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

import '/core/helpers/bchat_handler.dart';
import '/core/utils.dart';
import '/core/utils/chat_utils.dart';
import 'dash/models/reply_model.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';

import '/controller/providers/chat_messagelist_provider.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';
import '../../widget/chat_input_box.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/typing_indicator.dart';

final selectedChatMessageListProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
        (ref) => ChatMessageNotifier());

final onlineStatusProvier =
    StateProvider.autoDispose<ChatPresence?>((_) => null);

// ignore: must_be_immutable
class ChatScreen extends HookConsumerWidget {
  // final int userId;
  final ConversationModel model;
  ChatScreen({Key? key, required this.model}) : super(key: key);

  late String _myChatPeerUserId;
  late final ScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  late Contacts _me;

  // User? _me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _scrollController = ScrollController();
      _myChatPeerUserId = ChatClient.getInstance.currentUserId ?? '1';
      _loadMe();

      _scrollController.addListener(() => _onScroll(_scrollController, ref));

      _preLoadChat(ref);

      return disposeAll;
    }, []);

    ref.listen(chatLoadingPreviousProvider, (previous, next) {
      _isLoadingMore = next;
    });
    ref.listen(chatHasMoreOldMessageProvider, (previous, next) {
      _hasMoreData = next;
    });

    final selectedItems = ref.watch(selectedChatMessageListProvider);
    return BaseWilPopupScreen(
      onBack: () async {
        if (selectedItems.isNotEmpty) {
          ref.read(selectedChatMessageListProvider.notifier).clear();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: ColouredBoxBar(
          topBar: selectedItems.isNotEmpty
              ? _menuBar(context, selectedItems, ref)
              : _topBar(context),
          body: _chatList(context),
        ),
      ),
    );
  }

  _loadMe() async {
    final user = await getMeAsUser();
    if (user != null) {
      _me = Contacts(
        name: user.name,
        profileImage: user.image,
        userId: user.id,
        email: user.email,
        fcmToken: user.fcmToken,
        phone: user.phone,
      );
      _myChatPeerUserId =
          ChatClient.getInstance.currentUserId ?? user.id.toString();
    }
  }

  Widget _chatList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return _buildMessageList(ref);
                        },
                      ),
                    ),
                    // if (typingUsers != null && typingUsers!.isNotEmpty)
                    //   ...typingUsers!.map((ChatUserInfo user) {
                    //     return _buildUserTyping(user.nickName ?? user.userId);
                    //   }).toList(),
                  ],
                ),
                Positioned(
                  top: 8.0,
                  right: 0,
                  left: 0,
                  child: Consumer(
                    builder: (context, ref, child) {
                      bool isLoadingMore =
                          ref.watch(chatLoadingPreviousProvider);
                      return isLoadingMore
                          ? const Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        _buildReplyBox(),
        _buildChatInputBox(),
      ],
    );
  }

  Widget _buildReplyBox() {
    return Consumer(
      builder: (context, ref, child) {
        bool show = ref.watch(chatModelProvider).isReplyBoxVisible;
        if (show) {
          ReplyModel replyOf = ref.watch(chatModelProvider).replyOn!;
          return Center(
            child: Container(
              height: 12.h,
              width: 90.w,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppColors.chatBoxBackgroundMine,
                borderRadius: BorderRadius.all(Radius.circular(4.w)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(
                      //   width: 1.w,
                      // ),
                      Text(
                        'Replying to ${replyOf.fromName}',
                        style: textStyleWhite,
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(chatModelProvider).clearReplyBox();
                        },
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppColors.chatBoxBackgroundOthers,
                          borderRadius: BorderRadius.all(Radius.circular(4.w)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatMessageBodyWidget(message: replyOf.message)
                            // Text(replyOf.),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChatInputBox() {
    return Consumer(
      builder: (context, ref, child) {
        return ChatInputBox(
          onSend: (input) async {
            final msg = ChatMessage.createTxtSendMessage(
                targetId: model.contact.userId.toString(), content: input);
            // ..from = _myChatPeerUserId;

            msg.attributes = {"em_force_notification": true};

            ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
            if (replyOf != null) {
              msg.attributes?.addAll({'reply_of': replyOf.toJson()});
              ref.read(chatModelProvider).clearReplyBox();
            }
            // ref.read(chatMessageListProvider.notifier).addChat(msg);
            return await _sendMessage(msg, ref);
          },
          onAttach: _pickFiles,
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();
  _pickFiles(AttachType type) async {
    // print('Request Attach: $type');
    // var fileExts = ['jpg', 'pdf', 'doc'];

    // switch (type) {
    //   case AttachType.camera:
    //     final XFile? photo = await _picker.pickImage(
    //         source: ImageSource.camera, requestFullMetadata: false);
    //     return;
    //   case AttachType.media:
    //     fileExts = ['jpg', 'png', 'jpeg', 'mp4', 'mov'];
    //     break;
    //   // ;
    //   case AttachType.audio:
    //     fileExts = ['aac', 'mp3', 'wav'];
    //     break;
    //   case AttachType.docs:
    //     fileExts = ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'];
    //     break;
    // }
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'],
    // );
    // if (result != null) {
    //   for (var file in result.files) {
    //     print(file.name);
    //     print(file.bytes);
    //     print(file.size);
    //     print(file.extension);
    //     print(file.path);
    //   }
    // }
  }

  Widget _buildMessageList(WidgetRef ref) {
    final chatList = ref.watch(chatMessageListProvider).reversed.toList();
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      controller: _scrollController,
      itemCount: chatList.length,
      itemBuilder: (context, i) {
        final ChatMessage? previousMessage =
            i < chatList.length - 1 ? chatList[i + 1] : null;
        final ChatMessage? nextMessage = i > 0 ? chatList[i - 1] : null;
        final ChatMessage message = chatList[i];
        final bool isAfterDateSeparator =
            shouldShowDateSeparator(previousMessage, message);
        bool isBeforeDateSeparator = false;
        if (nextMessage != null) {
          isBeforeDateSeparator = shouldShowDateSeparator(message, nextMessage);
        }
        bool isPreviousSameAuthor = false;
        bool isNextSameAuthor = false;
        if (previousMessage?.from == message.from) {
          isPreviousSameAuthor = true;
        }
        if (nextMessage?.from == message.from) {
          isNextSameAuthor = true;
        }
        final selectedItems = ref.watch(selectedChatMessageListProvider);
        bool isSelected = selectedItems.contains(message);

        bool isOwnMessage = message.from == _myChatPeerUserId;

        // ChatUserInfo otherUser = _getUser();
        return Column(
          crossAxisAlignment:
              isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isAfterDateSeparator)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  formatDateSeparator(
                      DateTime.fromMillisecondsSinceEpoch(message.serverTime)),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            SwipeTo(
              onRightSwipe: () {
                ref.read(chatModelProvider.notifier).setReplyOn(
                    message,
                    isOwnMessage
                        ? S.current.bmeet_user_you
                        : model.contact.name);
                print('open replyBox');
              },
              child: GestureDetector(
                onLongPress: () =>
                    _onMessageLongPress(message, isSelected, ref),
                onTap: () => selectedItems.isNotEmpty
                    ? _onMessageTap(message, isSelected, ref)
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(top: 2, bottom: 4),
                  width: double.infinity,
                  color: isSelected ? Colors.grey.shade200 : Colors.transparent,
                  child: ChatMessageBubble(
                    message: message,
                    isOwnMessage: isOwnMessage,
                    senderUser: isOwnMessage ? _me : model.contact,
                    isPreviousSameAuthor: isPreviousSameAuthor,
                    isNextSameAuthor: isNextSameAuthor,
                    isAfterDateSeparator: isAfterDateSeparator,
                    isBeforeDateSeparator: isBeforeDateSeparator,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _onMessageLongPress(ChatMessage message, bool selected, WidgetRef ref) {
    // ChatClient.getInstance.chatManager.a
    if (selected) {
      ref.read(selectedChatMessageListProvider.notifier).remove(message);
    } else {
      ref.read(selectedChatMessageListProvider.notifier).addChat(message);
    }
  }

  _onMessageTap(ChatMessage message, bool selected, WidgetRef ref) {
    if (selected) {
      ref.read(selectedChatMessageListProvider.notifier).remove(message);
    } else {
      ref.read(selectedChatMessageListProvider.notifier).addChat(message);
    }
  }

  Future<String?> _sendMessage(ChatMessage msg, WidgetRef ref) async {
    // if (_me == null) return 'User details not loaded yet';
    try {
      msg.setMessageStatusCallBack(
        MessageStatusCallBack(
          onSuccess: () {
            // FCMApiService.instance.sendChatPush(
            //     msg, 'toToken', _myUserId, _me!.name, NotificationType.chat);
            // Occurs when the message sending succeeds. You can update the message and add other operations in this callback.
          },
          onError: (error) {
            // Occurs when the message sending fails. You can update the message status and add other operations in this callback.
          },
          onProgress: (progress) {
            // For attachment messages such as image, voice, file, and video, you can get a progress value for uploading or downloading them in this callback.
          },
        ),
      );
      final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
      ref.read(chatMessageListProvider.notifier).addChat(chat);
    } on ChatError catch (e) {
      print("send failed, code: ${e.code}, desc: ${e.description}");
      return e.description;
    }
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    return null;
  }

  Widget _buildUserTyping(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 2),
            child: TypingIndicator(),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
                const TextSpan(
                  text: ' is typing',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // bool isLoadingMore = false;

  Future<void> onLoadEarlier(WidgetRef ref) async {
    try {
      final message = ref.read(chatMessageListProvider.notifier).getLast();
      if (message == null) return;

      if (model.conversation != null) {
        print('next_chat_id ${message.msgId}');
        await Future.delayed(const Duration(seconds: 2));
        final chats = await model.conversation
            ?.loadMessages(loadCount: 20, startMsgId: message.msgId);
        ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
        ref.read(chatHasMoreOldMessageProvider.notifier).state =
            chats?.length == 20;
        return;
      }

      // String? cursor = ref.read(chatMessageListProvider.notifier).cursor;
      // if (cursor == null || cursor.isEmpty) return;

      // final oldResult = await ChatClient.getInstance.chatManager
      //     .fetchHistoryMessages(
      //         conversationId: model.id.toString(),
      //         pageSize: 20,
      //         startMsgId: message.msgId);

      // // debugPrint('older cursor :$cursor -  ${oldResult.cursor} ');
      // if (oldResult.cursor == null ||
      //     cursor == oldResult.cursor ||
      //     oldResult.cursor?.isEmpty == true) {
      //   // debugPrint('Not a new cursor : ${oldResult.cursor}');
      //   ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
      //   return;
      // }
      // // ref.read(chatChatCursorMessageProvider.notifier).state = oldResult.cursor;
      // // debugPrint('old data list ${oldResult.data.length}');
      // if (oldResult.data.isNotEmpty) {
      //   ref.read(chatHasMoreOldMessageProvider.notifier).state =
      //       oldResult.data.length == 20;
      //   ref
      //       .read(chatMessageListProvider.notifier)
      //       .addChats(oldResult.data, oldResult.cursor);
      // } else {
      //   ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
      //   // print('Set has More Data :false');
      // }
    } catch (e) {}

    return;
  }

  Future _loadPresence(WidgetRef ref) async {
    try {
      ref.read(onlineStatusProvier.notifier).state =
          await fetchOnlineStatus(model.contact.userId.toString());
      // print(
      //     'Online status =${model.isOnline?.statusDetails} ${model.isOnline?.lastTime} ${model.isOnline?.statusDescription}  ${model.isOnline?.expiryTime}');
      ChatClient.getInstance.presenceManager
          .subscribe(members: [model.contact.userId.toString()], expiry: 100);

      ChatClient.getInstance.presenceManager.addEventHandler(
        "user_presence_home_screen",
        ChatPresenceEventHandler(
          onPresenceStatusChanged: (list) {
            for (var s in list) {
              if (s.publisher == model.contact.userId.toString()) {
                ref.read(onlineStatusProvier.notifier).state = s;
                // print(
                //     'Update status =${s.statusDetails} ${s.lastTime} ${s.statusDescription}  ${s.expiryTime}');
                break;
              }
            }
            print('onPresenceStatusChanged: ${list.toList()}');
          },
        ),
      );
    } catch (e) {
      print('Presence error $e');
    }
  }

  _preLoadChat(WidgetRef ref) async {
    try {
      // if (model.badgeCount > 0) {
      //   await model.conversation?.markAllMessagesAsRead();
      // }
      registerForNewMessage('chat_screen', (msg) {
        onMessagesReceived(msg, ref);
      });
      if (model.conversation != null) {
        await model.conversation?.markAllMessagesAsRead();
        final chats = await model.conversation?.loadMessages(loadCount: 20);
        // print('next_chat_id ${chats![0].msgId}');
        ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
        // return;
      }

      // final value = await ChatClient.getInstance.chatManager
      //     .fetchHistoryMessages(
      //         conversationId: model.id.toString(), pageSize: 20);

      // final chats = value.data;
      // if (chats.isNotEmpty) {
      //   debugPrint('preLoadChat cursor : ${value.cursor}');
      //   debugPrint('data list ${chats.length}');
      //   ref
      //       .read(chatMessageListProvider.notifier)
      //       .addChats(chats, value.cursor);
      // } else {
      //   // final list =
      //   //     await ChatClient.getInstance.contactManager.getAllContactsFromDB();
      //   // if (!list.contains(model.contact.userId.toString())) {
      //   //   ChatClient.getInstance.contactManager
      //   //       .addContact(model.contact.userId.toString(), reason: 'Hi');
      //   // }
      // }

    } on ChatError catch (e) {
      debugPrint('error: ${e.code}- ${e.description}');
    }
    await _loadPresence(ref);
  }

  void disposeAll() {
    ChatClient.getInstance.chatManager.removeEventHandler('chat_screen');
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    for (var msg in messages) {
      if (msg.to == model.contact.userId.toString()) {
        ref.read(chatMessageListProvider.notifier).addChat(msg);
      }
    }
  }

  Future<void> _onScroll(
      ScrollController scrollController, WidgetRef ref) async {
    // print('has _isLoadingMore :$_isLoadingMore');
    // print('has More Data :$_hasMoreData');
    if (!_isLoadingMore && _hasMoreData) {
      bool topReached = scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange;
      if (topReached) {
        ref.watch(chatLoadingPreviousProvider.notifier).state = true;
        // showScrollToBottom();
        await onLoadEarlier(ref);
        ref.watch(chatLoadingPreviousProvider.notifier).state = false;
      }
    }

    // bool topReached =
    //     scrollController.offset >= scrollController.position.maxScrollExtent &&
    //         !scrollController.position.outOfRange;
    // if (topReached && !_isLoadingMore && _hasMoreData) {
    //   ref.watch(chatLoadingPreviousProvider.notifier).state = true;
    //   // showScrollToBottom();
    //   await onLoadEarlier(ref);
    //   ref.watch(chatLoadingPreviousProvider.notifier).state = false;
    // }
    //  else if (scrollController.offset > 200) {
    //   showScrollToBottom();
    // } else {
    //   hideScrollToBottom();
    // }
  }

  void showScrollToBottom() {
    // if (!scrollToBottomIsVisible) {
    //   setState(() {
    //     scrollToBottomIsVisible = true;
    //   });
    // }
  }

  void hideScrollToBottom() {
    // if (scrollToBottomIsVisible) {
    //   setState(() {
    //     scrollToBottomIsVisible = false;
    //   });
    // }
  }

  // _navigateBack(BuildContext context) {
  //   Navigator.pop(context);
  // }

  // ChatUserInfo _getUser() {
  //   Map map = {
  //     'userId': '1',
  //     'nickName': model.contact.name??'',
  //     'avatarUrl': model.contact.profileImage??''
  //   };

  //   //map["userId"],
  //   // nickName: map.getStringValue("nickName"),
  //   // avatarUrl: map.getStringValue("avatarUrl"),
  //   // mail: map.getStringValue("mail"),
  //   // phone: map.getStringValue("phone"),
  //   // gender: map.getIntValue("gender", defaultValue: 0)!,
  //   // sign: map.getStringValue("sign"),
  //   // birth: map.getStringValue("birth"),
  //   // ext: map.getStringValue("ext"),

  //   return ChatUserInfo.fromJson(map);
  // }
  Widget _menuBar(BuildContext context, final List<ChatMessage> selectedItems,
      WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      // color: AppColors.primaryColor,
      child: Row(
        children: [
          // SizedBox(width: 6.w,)
          Text(
            selectedItems.length > 1
                ? '${selectedItems.length} Messages selected'
                : '${selectedItems.length} Message selected',
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () async {
                // print('conversation is NULL =${model.conversation == null} ');
                for (var m in selectedItems) {
                  try {
                    await model.conversation?.deleteMessage(m.msgId);
                    // ref
                    //     .read(selectedChatMessageListProvider.notifier)
                    //     .remove(m);
                    ref.read(chatMessageListProvider.notifier).remove(m);
                  } on ChatError catch (e) {
                    print('Error- ${e.code} :${e.description}');
                  }
                }
                ref.read(selectedChatMessageListProvider.notifier).clear();
                // ChatClient.getInstance.chatManager.del
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    // final Contacts otherUser = _getUser();
    // _otherUser = ChatUser(
    //   id: otherUser.id.toString(),
    //   firstName: otherUser.name,
    //   profileImage: otherUser.image,
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: (() => Navigator.pop(context)),
            icon: getSvgIcon('arrow_back.svg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: getRectFAvatar(
              model.contact.name,
              model.contact.profileImage,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.contactProfile,
                    arguments: model.contact);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.contact.name,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.3.h),
                  Consumer(builder: (context, ref, child) {
                    final value = ref.watch(onlineStatusProvier);
                    return Text(
                      parseChatPresenceToReadable(value),
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        color: AppColors.yellowAccent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w200,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteList.bChatAudioCall);
            },
            icon: getSvgIcon('icon_audio_call.svg'),
          ),
          SizedBox(
            width: 1.w,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteList.bChatVideoCall);
            },
            icon: getSvgIcon('icon_video_call.svg'),
          ),
        ],
      ),
    );
  }
}
