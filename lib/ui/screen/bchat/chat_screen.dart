import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
// import '/data/network/fcm_api_service.dart';
import '../../widgets.dart';
import 'dash/models/reply_model.dart';
import '../../widget/chat_input_box.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/typing_indicator.dart';

class ChatScreen extends HookConsumerWidget {
  // final int userId;
  final ConversationModel model;
  ChatScreen({Key? key, required this.model}) : super(key: key);

  late final String _myUserId;
  late final String _otherUserId;
  late final ScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  User? _me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // _initSDK();
      // if(_scrollController.i)

      _scrollController = ScrollController();
      _myUserId = ChatClient.getInstance.currentUserId ?? '24';
      _otherUserId = _myUserId == '24' ? '1' : '24';
      _scrollController.addListener(() => _onScroll(_scrollController, ref));
      _loadMe();
      _preLoadChat(ref);

      return disposeAll;
    }, []);

    ref.listen(chatLoadingPreviousProvider, (previous, next) {
      _isLoadingMore = next;
    });
    ref.listen(chatHasMoreOldMessageProvider, (previous, next) {
      _hasMoreData = next;
    });
    return Scaffold(
      body: ColouredBoxBar(
        topBar: _topBar(context),
        body: _chatList(context),
      ),
    );
  }

  _loadMe() async {
    _me = await getMeAsUser();
  }

  _preLoadChat(WidgetRef ref) async {
    try {
      if (model.badgeCount > 0) {
        await model.conversation?.markAllMessagesAsRead();
      }

      final value = await ChatClient.getInstance.chatManager
          .fetchHistoryMessages(conversationId: _otherUserId, pageSize: 20);

      final chats = value.data;
      if (chats.isNotEmpty) {
        debugPrint('preLoadChat cursor : ${value.cursor}');
        debugPrint('data list ${chats.length}');
        // ref.read(chatChatCursorMessageProvider.notifier).state = value.cursor;
        ref
            .read(chatMessageListProvider.notifier)
            .addChats(chats, value.cursor);
      }
      ChatClient.getInstance.chatManager.addEventHandler(
        'chat_screen',
        ChatEventHandler(
          onMessagesReceived: (msgs) => onMessagesReceived(msgs, ref),
        ),
      );
    } on ChatError catch (e) {}
  }

  void disposeAll() {
    ChatClient.getInstance.chatManager.removeEventHandler('chat_screen');
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    for (var msg in messages) {
      print('msg: ${msg.from}');
      ref.read(chatMessageListProvider.notifier).addChat(msg);
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
        // _buildReplyBox(),
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
                            Text('Chat content'),
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
                targetId: _otherUserId, content: input)
              ..from = _myUserId;

            // ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
            // if (replyOf != null) {
            //   // msg.attributes.addAll(replyOf)
            //   ref.read(chatModelProvider).clearReplyBox();
            // }
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
    print('Request Attach: $type');
    var fileExts = ['jpg', 'pdf', 'doc'];

    switch (type) {
      case AttachType.camera:
        final XFile? photo = await _picker.pickImage(
            source: ImageSource.camera, requestFullMetadata: false);
        return;
      case AttachType.media:
        fileExts = ['jpg', 'png', 'jpeg', 'mp4', 'mov'];
        break;
      // ;
      case AttachType.audio:
        fileExts = ['aac', 'mp3', 'wav'];
        break;
      case AttachType.docs:
        fileExts = ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'];
        break;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'],
    );
    if (result != null) {
      for (var file in result.files) {
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
      }
    }
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

        bool isOwnMessage = message.from == _myUserId;

        ChatUserInfo otherUser = _getUser();
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
            // SwipeTo(
            //   onRightSwipe: () {
            //     ref.read(chatModelProvider).setReplyOn(message, otherUser);
            //     print('open replyBox');
            //   },
            //   child:
            GestureDetector(
              onLongPress: () {
                _showMessageOption(message);
              },
              child: ChatMessageBubble(
                message: message,
                isOwnMessage: message.from == _myUserId,
                senderUser: otherUser,
                isPreviousSameAuthor: isPreviousSameAuthor,
                isNextSameAuthor: isNextSameAuthor,
                isAfterDateSeparator: isAfterDateSeparator,
                isBeforeDateSeparator: isBeforeDateSeparator,
                // ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showMessageOption(ChatMessage message) {
    // ChatClient.getInstance.chatManager.a
  }

  Future<String?> _sendMessage(ChatMessage msg, WidgetRef ref) async {
    if (_me == null) return 'User details not loaded yet';
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
      ref
          .read(chatMessageListProvider.notifier)
          .addChat(await ChatClient.getInstance.chatManager.sendMessage(msg));
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
    await Future.delayed(const Duration(seconds: 2));
    try {
      final message = ref.read(chatMessageListProvider.notifier).getLast();
      if (message == null) return;
      // ChatTextMessageBody body = message.body as ChatTextMessageBody;
      // print('last message ${body.content}');

      String? cursor = ref.read(chatMessageListProvider.notifier).cursor;
      if (cursor == null || cursor.isEmpty) return;
      final oldResult = await ChatClient.getInstance.chatManager
          .fetchHistoryMessages(
              conversationId: _otherUserId,
              pageSize: 20,
              startMsgId: message.msgId);

      debugPrint('older cursor :$cursor -  ${oldResult.cursor} ');
      if (oldResult.cursor == null ||
          cursor == oldResult.cursor ||
          oldResult.cursor?.isEmpty == true) {
        debugPrint('Not a new cursor : ${oldResult.cursor}');
        ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
        return;
      }
      // ref.read(chatChatCursorMessageProvider.notifier).state = oldResult.cursor;
      debugPrint('old data list ${oldResult.data.length}');
      if (oldResult.data.isNotEmpty) {
        ref.read(chatHasMoreOldMessageProvider.notifier).state =
            oldResult.data.length == 20;
        print('Set has More Data :${(oldResult.data.length == 20)})');
        ref
            .read(chatMessageListProvider.notifier)
            .addChats(oldResult.data, oldResult.cursor);
      } else {
        ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
        print('Set has More Data :false');
      }
    } catch (e) {}

    return;
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

  ChatUserInfo _getUser() {
    Map map = {
      'userId': '1',
      'nickName': model.user.name,
      'avatarUrl': model.user.image
    };

    //map["userId"],
    // nickName: map.getStringValue("nickName"),
    // avatarUrl: map.getStringValue("avatarUrl"),
    // mail: map.getStringValue("mail"),
    // phone: map.getStringValue("phone"),
    // gender: map.getIntValue("gender", defaultValue: 0)!,
    // sign: map.getStringValue("sign"),
    // birth: map.getStringValue("birth"),
    // ext: map.getStringValue("ext"),

    return ChatUserInfo.fromJson(map);
  }

  Widget _topBar(BuildContext context) {
    final ChatUserInfo otherUser = _getUser();
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
              otherUser.nickName ?? '',
              otherUser.avatarUrl ?? '',
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.contactProfile);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.nickName ?? '',
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: AppColors.yellowAccent,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: (() {}),
            icon: getSvgIcon('icon_audio_call.svg'),
          ),
          SizedBox(
            width: 1.w,
          ),
          IconButton(
            onPressed: (() {}),
            icon: getSvgIcon('icon_video_call.svg'),
          ),
        ],
      ),
    );
  }
}
