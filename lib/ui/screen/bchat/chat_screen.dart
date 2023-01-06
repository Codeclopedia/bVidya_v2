import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/controller/providers/bchat/chat_messeges_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

import '/core/helpers/call_helper.dart';
import '/core/helpers/bchat_handler.dart';
import '/core/utils.dart';
// import '/core/utils/chat_utils.dart';

// import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '/ui/dialog/image_picker_dialog.dart';

import '/controller/providers/chat_messagelist_provider.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';
import '../../widget/chat_input_box.dart';
import 'dash/models/attach_type.dart';
import 'dash/models/reply_model.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/typing_indicator.dart';

final selectedChatMessageListProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
        (ref) => ChatMessageNotifier());

final attachedFile = StateProvider.autoDispose<AttachedFile?>((_) => null);

// ignore: must_be_immutable
class ChatScreen extends HookConsumerWidget {
  final ConversationModel model;
  ChatScreen({Key? key, required this.model}) : super(key: key);

  // late String _myChatPeerUserId;
  late final ScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  late Contacts _me;

  // User? _me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // print('useEffect Called');
      _scrollController = ScrollController();
      ref.read(bhatMessagesProvider(model)).init();
      _loadMe();
      _scrollController.addListener(() => _onScroll(_scrollController, ref));
      registerForNewMessage('chat_screen', (msg) {
        onMessagesReceived(msg, ref);
      });
      return () {
        unregisterForNewMessage('chat_screen');
        _scrollController.dispose();
      };
    }, const []);

    ref.listen(bhatMessagesProvider(model), (previous, next) {
      _isLoadingMore = next.isLoadingMore;
      _hasMoreData = next.hasMoreData;
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
              : _topBar(context, ref),
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
      // _myChatPeerUserId =
      //     ChatClient.getInstance.currentUserId ?? user.id.toString();
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
                      bool isLoadingMore = ref.watch(bhatMessagesProvider(model)
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
        // _buildChatInputBox(),
        _buildAttachedFile()
      ],
    );
  }

  Widget _buildAttachedFile() {
    return Consumer(
      builder: (context, ref, child) {
        AttachedFile? attFile = ref.watch(attachedFile);
        return attFile == null
            ? _buildChatInputBox()
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
                          targetId: model.contact.userId.toString(),
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      } else if (attFile.messageType == MessageType.VIDEO) {
                        msg = ChatMessage.createVideoSendMessage(
                          targetId: model.contact.userId.toString(),
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      } else {
                        msg = ChatMessage.createFileSendMessage(
                          targetId: model.contact.userId.toString(),
                          filePath: attFile.file.absolute.path,
                          fileSize: await attFile.file.length(),
                        );
                      }

                      await _sendMessage(msg, ref);
                      ref.read(attachedFile.notifier).state = null;
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

  Widget _buildChatInputBox() {
    return Consumer(
      builder: (context, ref, child) {
        return ChatInputBox(
          onSend: (input) async {
            final ChatMessage msg = ChatMessage.createTxtSendMessage(
                targetId: model.contact.userId.toString(), content: input);
            // ..from = _myChatPeerUserId;

            // ref.read(chatMessageListProvider.notifier).addChat(msg);
            return await _sendMessage(msg, ref);
          },
          onAttach: (type) => _pickFiles(type, ref),
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
          ref.read(attachedFile.notifier).state =
              AttachedFile(file, MessageType.IMAGE);
        }
        return;
      case AttachType.media:
        File? file = await imgFromGallery(_picker);
        if (file != null) {
          ref.read(attachedFile.notifier).state =
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
        .watch(bhatMessagesProvider(model).select((value) => value.messages))
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

        bool isOwnMessage = message.from != model.id;
        if (!isOwnMessage) _markRead(message);

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
                ref.read(chatModelProvider.notifier).setReplyOn(
                    message,
                    isOwnMessage
                        ? S.current.bmeet_user_you
                        : model.contact.name);
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
    msg.attributes?.addAll({"em_force_notification": true});
    ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
    if (replyOf != null) {
      msg.attributes?.addAll({'reply_of': replyOf.toJson()});
      ref.read(chatModelProvider).clearReplyBox();
    }

    msg.setMessageStatusCallBack(
      MessageStatusCallBack(
        onSuccess: () {
          hideLoading(ref);
          // FCMApiService.instance.sendChatPush(
          //     msg, 'toToken', _myUserId, _me!.name, NotificationType.chat);
          // Occurs when the message sending succeeds. You can update the message and add other operations in this callback.
        },
        onError: (error) {
          hideLoading(ref);
          // Occurs when the message sending fails. You can update the message status and add other operations in this callback.
        },
        onProgress: (progress) {
          showLoading(ref);
          // For attachment messages such as image, voice, file, and video, you can get a progress value for uploading or downloading them in this callback.
        },
      ),
    );
    // final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
    final chat =
        await ref.read(bhatMessagesProvider(model).notifier).sendMessage(msg);
    if (chat != null) {
      ref
          .read(chatConversationProvider.notifier)
          .updateConversationMessage(msg);
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return null;
    }
    return 'Error while sending message';
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

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    ref.read(bhatMessagesProvider(model)).addChats(messages);
    for (var msg in messages) {
      // print('msg: ${msg.from}');
      if (msg.chatType == ChatType.Chat) {
        ref.read(chatConversationProvider).updateConversationMessage(msg);
      }
      // ref.read()
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
        ref.watch(bhatMessagesProvider(model).notifier).loadMore();
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
                ref
                    .read(bhatMessagesProvider(model).notifier)
                    .deleteMessages(selectedItems);
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

  Widget _topBar(BuildContext context, WidgetRef ref) {
    // final value = ref.watch(onlineStatusProvier);
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (() => Navigator.pop(context)),
              icon: getSvgIcon('arrow_back.svg', width: 6.w),
            ),
            // SizedBox(width: 2.w),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 2.w),
            //   child: ,
            // ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteList.contactProfile,
                      arguments: model.contact);
                },
                child: Row(
                  children: [
                    SizedBox(width: 2.w),
                    getRectFAvatar(
                      model.contact.name,
                      model.contact.profileImage,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
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
                          Text(
                            ref.watch(bhatMessagesProvider(model)
                                .select((value) => value.onlineStatus)),
                            // parseChatPresenceToReadable(value),
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
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                makeAudioCall(model.contact, ref, context);
                // Navigator.pushNamed(context, RouteList.bChatAudioCall);
              },
              icon: getSvgIcon(
                'icon_audio_call.svg',
                width: 6.w,
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: () {
                // receiveAudioCall(
                //   'YcJ5uHP31M8sMyAZ1msC',
                //   model.contact.profileImage,
                //   ref,
                //   context,
                // );
                makeVideoCall(model.contact, ref, context);
                // Navigator.pushNamed(context, RouteList.bChatVideoCall);
                // makeFakeCallInComing();
              },
              icon: getSvgIcon(
                'icon_video_call.svg',
                width: 6.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markRead(ChatMessage message) async {
    if (!message.hasRead) {
      await model.conversation?.markMessageAsRead(message.msgId);
    }
  }
}
