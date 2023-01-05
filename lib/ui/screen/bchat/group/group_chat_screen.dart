import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../controller/providers/bchat/groups_conversation_provider.dart';
import '../../../../controller/providers/bchat/group_chats_provider.dart';
import '../../../dialog/image_picker_dialog.dart';
import '../dash/models/attach_type.dart';
import '/core/helpers/bchat_handler.dart';
import '../chat_screen.dart';
// import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '../../../widgets.dart';
import '../dash/models/reply_model.dart';
import '../../../widget/chat_input_box.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/typing_indicator.dart';

final attachedGroupFile = StateProvider.autoDispose<AttachedFile?>((_) => null);

class GroupChatScreen extends HookConsumerWidget {
  final GroupConversationModel model;
  GroupChatScreen({Key? key, required this.model}) : super(key: key);

  String _myUserId = '';
  late final ScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  // User? _me;
  late Contacts _me;

  final List<Contacts> _memberList = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(groupChatProvider(model.id));
    useEffect(() {
      ref.read(groupChatProvider(model.id)).init(model);

      _scrollController = ScrollController();
      _myUserId = ChatClient.getInstance.currentUserId ?? '';

      _scrollController
          .addListener(() => _onScroll(_scrollController, provider));
      _loadMe();
      _loadMembers(ref);
      _addHandler(ref);

      return disposeAll;
    }, []);

    ref.listen(groupChatProvider(model.id), (previous, next) {
      _hasMoreData = next.hasMoreData;
      _isLoadingMore = next.isLoadingMore;
    });
    // ref.listen(chatHasMoreOldMessageProvider, (previous, next) {
    //   _hasMoreData = next;
    // });
    return Scaffold(
      body: ColouredBoxBar(
        topBar: _topBar(context),
        body: _chatList(context),
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
      _myUserId = _me.userId.toString();
      // _memberList =

    }
  }

  _loadMembers(WidgetRef ref) async {
    // _memberList.clear();
    // final list =
    //     await BchatGroupManager.loadGroupMemebers(model.groupInfo, ref);
    // _memberList.addAll(list);
  }

  _addHandler(WidgetRef ref) async {
    registerForNewMessage('group_chat_screen', (msg) {
      onMessagesReceived(msg, ref);
    });
  }

  void disposeAll() {
    ChatClient.getInstance.chatManager.removeEventHandler('group_chat_screen');
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    ref.read(groupChatProvider(model.id)).addChats(messages);
    for (var msg in messages) {
      print('msg: ${msg.from}');
      if (msg.chatType == ChatType.GroupChat &&
           msg.conversationId!=null) {
        ref
            .read(groupConversationProvider)
            .updateConversationMessage(msg, msg.conversationId!);
      }
      // ref.read()
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
                      bool isLoadingMore = ref.watch(groupChatProvider(model.id)
                          .select((value) => value.isLoadingMore));
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
        _buildAttachedFile()
        // _buildChatInputBox(),
      ],
    );
  }

  Widget _buildChatInputBox(WidgetRef ref) {
    return ChatInputBox(
      onSend: (input) async {
        final msg = ChatMessage.createTxtSendMessage(
            targetId: model.id, content: input, chatType: ChatType.GroupChat);
        // ..from = _myUserId;

        ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
        if (replyOf != null) {
          msg.attributes?.addAll({'reply_of': replyOf.toJson()});
          ref.read(chatModelProvider).clearReplyBox();
        }

        return await _sendMessage(msg, ref);
      },
      onAttach: (type) => _pickFiles(type, ref),
    );
  }

  Widget _buildAttachedFile() {
    return Consumer(
      builder: (context, ref, child) {
        AttachedFile? attFile = ref.watch(attachedGroupFile);
        return attFile == null
            ? _buildChatInputBox(ref)
            : Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(3.w))),
                      child: attFile.messageType == MessageType.IMAGE
                          ? Image(image: FileImage(attFile.file))
                          : (attFile.messageType == MessageType.VIDEO
                              ? getSvgIcon('icon_chat_media.svg')
                              : getSvgIcon('icon_chat_doc.svg')),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final ChatMessage msg;

                      if (attFile.messageType == MessageType.IMAGE) {
                        msg = ChatMessage.createImageSendMessage(
                          targetId: model.id,
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      } else if (attFile.messageType == MessageType.VIDEO) {
                        msg = ChatMessage.createVideoSendMessage(
                          targetId: model.id,
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      } else {
                        msg = ChatMessage.createFileSendMessage(
                          targetId: model.id,
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      }

                      msg.attributes?.addAll({"em_force_notification": true});
                      ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
                      if (replyOf != null) {
                        msg.attributes?.addAll({'reply_of': replyOf.toJson()});
                        ref.read(chatModelProvider).clearReplyBox();
                      }
                      await _sendMessage(msg, ref);
                      ref.read(attachedGroupFile.notifier).state = null;
                    },
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();
  _pickFiles(AttachType type, WidgetRef ref) async {
    // print('Request Attach: $type');
    // var fileExts = ['jpg', 'pdf', 'doc'];

    switch (type) {
      case AttachType.camera:
        File? file = await imgFromCamera(_picker);
        if (file != null) {
          ref.read(attachedGroupFile.notifier).state =
              AttachedFile(file, MessageType.IMAGE);
        }
        return;
      case AttachType.media:
        File? file = await imgFromGallery(_picker);
        if (file != null) {
          ref.read(attachedGroupFile.notifier).state =
              AttachedFile(file, MessageType.IMAGE);
        }
        // fileExts = ['jpg', 'png', 'jpeg', 'mp4', 'mov'];
        break;
      // ;
      case AttachType.audio:
        // fileExts = ['aac', 'mp3', 'wav'];
        break;
      case AttachType.docs:
        // fileExts = ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'];
        break;
    }
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
    final chatList = ref
        .watch(groupChatProvider(model.id).select((value) => value.messages))
        .reversed
        .toList();
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

        bool isOwnMessage = message.from == _myUserId;
        if (!isOwnMessage) _markRead(message);

        String name = message.attributes?['from_name'] ?? '';
        String image = message.attributes?['from_image'] ?? '';
        Contacts contact = Contacts(
            userId: int.parse(message.from!), name: name, profileImage: image);

        return Column(
          // crossAxisAlignment:
          //     isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isAfterDateSeparator)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  formatDateSeparator(
                      DateTime.fromMillisecondsSinceEpoch(message.serverTime)),
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.grey,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            SwipeTo(
              onRightSwipe: () {
                ref.read(chatModelProvider.notifier).setReplyOn(message,
                    isOwnMessage ? S.current.bmeet_user_you : contact.name);
                // print('open replyBox');
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
                    senderUser: isOwnMessage ? _me : contact,
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

  _showMessageOption(ChatMessage message) {
    // ChatClient.getInstance.chatManager.a
  }

  Future<String?> _sendMessage(ChatMessage msg, WidgetRef ref) async {
    try {
      msg.attributes?.addAll({'from_name': _me.name});
      msg.attributes?.addAll({'from_image': _me.profileImage});
      msg.attributes?.addAll({"em_force_notification": true});

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

      final sentMessage =
          await ChatClient.getInstance.chatManager.sendMessage(msg);
      ref
          .read(groupConversationProvider)
          .updateConversationMessage(sentMessage, model.id);

      ref.read(groupChatProvider(model.id).notifier).addChat(sentMessage);
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

  // Future<void> onLoadEarlier(WidgetRef ref) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   try {
  //     final message = ref.read(chatMessageListProvider.notifier).getLast();
  //     if (message == null) return;
  //     if (model.conversation != null) {
  //       print('next_chat_id ${message.msgId}');
  //       await Future.delayed(const Duration(seconds: 2));
  //       final chats = await model.conversation
  //           ?.loadMessages(loadCount: 20, startMsgId: message.msgId);
  //       ref.read(chatMessageListProvider.notifier).addChatsOnly(chats ?? []);
  //       ref.read(chatHasMoreOldMessageProvider.notifier).state =
  //           chats?.length == 20;
  //       return;
  //     }

  //     // final message = ref.read(chatMessageListProvider.notifier).getLast();
  //     // if (message == null) return;
  //     // // ChatTextMessageBody body = message.body as ChatTextMessageBody;
  //     // // print('last message ${body.content}');

  //     // String? cursor = ref.read(chatMessageListProvider.notifier).cursor;
  //     // if (cursor == null || cursor.isEmpty) return;
  //     // final oldResult = await ChatClient.getInstance.chatManager
  //     //     .fetchHistoryMessages(
  //     //         conversationId: _otherUserId,
  //     //         pageSize: 20,
  //     //         startMsgId: message.msgId);

  //     // debugPrint('older cursor :$cursor -  ${oldResult.cursor} ');
  //     // if (oldResult.cursor == null ||
  //     //     cursor == oldResult.cursor ||
  //     //     oldResult.cursor?.isEmpty == true) {
  //     //   debugPrint('Not a new cursor : ${oldResult.cursor}');
  //     //   ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
  //     //   return;
  //     // }
  //     // // ref.read(chatChatCursorMessageProvider.notifier).state = oldResult.cursor;
  //     // debugPrint('old data list ${oldResult.data.length}');
  //     // if (oldResult.data.isNotEmpty) {
  //     //   ref.read(chatHasMoreOldMessageProvider.notifier).state =
  //     //       oldResult.data.length == 20;
  //     //   print('Set has More Data :${(oldResult.data.length == 20)})');
  //     //   ref
  //     //       .read(chatMessageListProvider.notifier)
  //     //       .addChats(oldResult.data, oldResult.cursor);
  //     // } else {
  //     //   ref.read(chatHasMoreOldMessageProvider.notifier).state = false;
  //     //   print('Set has More Data :false');
  //     // }
  //   } catch (e) {}

  //   return;
  // }

  Future<void> _onScroll(ScrollController scrollController,
      GroupChatChangeProvider provider) async {
    // print('has _isLoadingMore :$_isLoadingMore');
    // print('has More Data :$_hasMoreData');
    if (!_isLoadingMore && _hasMoreData) {
      bool topReached = scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange;
      if (topReached) {
        provider.loadMore();
        // ref.watch(chatLoadingPreviousProvider.notifier).state = true;
        // showScrollToBottom();
        // await onLoadEarlier(ref);
        // ref.watch(chatLoadingPreviousProvider.notifier).state = false;
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

  Widget _topBar(BuildContext context) {
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
              model.groupInfo.name ?? '',
              model.image,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.groupInfo,
                    arguments: model);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.groupInfo.name ?? '',
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    S.current.grp_chat_members(
                        model.groupInfo.memberCount.toString()),
                    // '${model.groupInfo.memberCount} Members',
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

  Widget _buildReplyBox() {
    return Consumer(
      builder: (context, ref, child) {
        bool show = ref.watch(chatModelProvider).isReplyBoxVisible;
        if (show) {
          ReplyModel replyOf = ref.watch(chatModelProvider).replyOn!;
          return Container(
            width: 90.w,
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.chatBoxBackgroundMine,
              borderRadius: BorderRadius.all(Radius.circular(3.w)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.chat_replying(replyOf.fromName),
                      // 'Replying to ${replyOf.fromName}',
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
                Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppColors.chatBoxBackgroundOthers,
                      borderRadius: BorderRadius.all(Radius.circular(2.w)),
                    ),
                    child: ChatMessageBodyWidget(message: replyOf.message)
                    //  Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     ChatMessageBodyWidget(message: replyOf.message)
                    //   ],
                    // ),
                    ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _markRead(ChatMessage message) async {
    if (!message.hasRead) {
      await model.conversation?.markMessageAsRead(message.msgId);
    }
  }
}
