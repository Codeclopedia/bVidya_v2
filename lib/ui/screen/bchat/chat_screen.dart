// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:swipe_to/swipe_to.dart';

import '/app.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/utils/request_utils.dart';
import '/core/constants/agora_config.dart';
import '/core/sdk_helpers/bchat_call_manager.dart';
import '/core/helpers/extensions.dart';

import '/core/sdk_helpers/typing_helper.dart';
import '/core/utils/common.dart';
import '/core/utils/chat_utils.dart';
import '/core/helpers/call_helper.dart';
import '/core/sdk_helpers/bchat_handler.dart';
import '/core/utils.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/controller/providers/bchat/contact_list_provider.dart';
import '/data/models/contact_model.dart';
import '/data/models/conversation_model.dart';
import '/controller/providers/chat_messagelist_provider.dart';
import '/controller/providers/bchat/chat_messeges_provider.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/group_chats_provider.dart';
import '/data/models/call_message_body.dart';
import '/ui/widget/chat_reply_body.dart';

import 'models/attach_type.dart';
import 'models/reply_model.dart';
import 'utils/attach_uihelper.dart';
import '/ui/dialog/message_menu_popup.dart';
import 'widgets/chat_message_bubble_ex.dart';
import 'widgets/typing_indicator.dart';

import '../../base_back_screen.dart';
import '../../widgets.dart';
import '../../dialog/forward_dialog.dart';
import '../../widget/chat_input_box.dart';

final sendingFileProgress =
    StateProvider.autoDispose.family<int, String>((_, id) => 0);

// ignore: must_be_immutable
class ChatScreen extends HookConsumerWidget {
  final ConversationModel model;
  final bool direct;
  ChatScreen({Key? key, required this.model, this.direct = false})
      : super(key: key);

  // late String _myChatPeerUserId;
  late final AutoScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  late Contacts _me;

  final videoInfo = FlutterVideoInfo();

  // User? _me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // print('useEffect Called');
      // _scrollController = ScrollController();
      _scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical,
      );
      final f = ref.read(bChatMessagesProvider(model).notifier);
      f.init(ref);
      _loadMe();
      addHandler(ref);
      _scrollController.addListener(() => _onScroll(_scrollController, ref));
      registerChatCallback('chat_screen', f, (msgs) {
        onMessagesReceived(msgs, ref);
      }, (messages) {
        for (var entry in messages.entries) {
          if (entry.value == TypingCommand.typingStart) {
            // print('command=>${entry.key}: ${entry.value}');
            ref.read(typingProvider(entry.key).notifier).beginTimer();
          }
        }
      });
      return () {
        try {
          ChatClient.getInstance.chatManager
              .removeMessageEvent("_chat_callback");
        } catch (_) {}

        unregisterChatCallback('chat_screen');
        _scrollController.dispose();
      };
    }, const []);

    ref.listen(hasMoreStateProvider, (previous, next) {
      _hasMoreData = next;
    });
    ref.listen(loadingMoreStateProvider, (previous, next) {
      _isLoadingMore = next;
    });
    // ref.listen(bhatMessagesProvider(model), (previous, next) {
    //   _isLoadingMore = next.isLoadingMore;
    //   _hasMoreData = next.hasMoreData;
    // });

    final selectedItems = ref.watch(selectedChatMessageListProvider);
    return BaseWilPopupScreen(
      onBack: () async {
        if (selectedItems.isNotEmpty) {
          ref.read(selectedChatMessageListProvider.notifier).clear();
          return false;
        }
        if (direct) {
          Navigator.pushReplacementNamed(context, RouteList.homeDirect);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: ColouredBoxBar(
          topBar: selectedItems.isNotEmpty
              ? _menuBar(context, selectedItems, ref)
              : _topBar(context, ref),
          body: model.contact.status == ContactStatus.invited
              ? _buildRequest(context)
              : model.contact.status == ContactStatus.sentInvite
                  ? _buildWaiting()
                  : _chatList(context),
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
          status: ContactStatus.self);
      // _myChatPeerUserId =
      //     ChatClient.getInstance.currentUserId ?? user.id.toString();
    }
  }

  addHandler(WidgetRef ref) {
    try {
      ChatClient.getInstance.chatManager.addMessageEvent(
          "_chat_callback",
          ChatMessageEvent(
            onSuccess: (msgId, msg) {
              ref.read(sendingFileProgress(msgId).notifier).state = 0;
              // _addLogToConsole("send message succeed");
            },
            onProgress: (msgId, progress) {
              ref.read(sendingFileProgress(msgId).notifier).state = progress;
              // _addLogToConsole("send message succeed");
            },
            onError: (msgId, msg, error) {
              ref.read(sendingFileProgress(msgId).notifier).state = 0;
              BuildContext? cntx = navigatorKey.currentContext;
              if (cntx != null
                  // && 505 != error.code
                  ) {
                AppSnackbar.instance.error(cntx, error.description);
              }
              // _addLogToConsole(
              //   "send message failed, code: ${error.code}, desc: ${error.description}",
              // );
            },
          ));
    } catch (_) {}
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
                    Consumer(
                      builder: (context, ref, child) {
                        final status = ref.watch(typingProvider(model.id));
                        if (status.status == TypingCommand.typingStart) {
                          return _buildUserTyping();
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 6.w, vertical: 2.h),
                          //   child: Row(
                          //     children: [
                          //        _buildUserTyping(),
                          //       Text('${model.contact.name} is Typing')
                          //     ],
                          //   ),
                          // );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
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
                      bool isLoadingMore = ref.watch(loadingMoreStateProvider);
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
        // if (model.contact.status == ContactStatus.sentInvite) _buildWaiting(),
        if (model.contact.status == ContactStatus.friend)
          buildAttachedFile(_buildChatInputBox(),
              (AttachedFile attFile, WidgetRef ref) async {
            return await _sendMediaFile(attFile, ref);
          })
      ],
    );
  }

  Widget _buildRequest(BuildContext context) {
    return Container(
      color: const Color(0xFFB0B0B0),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text('Chat Request', style: textStyleHeading)),
                SizedBox(height: 1.w),
                Center(
                  child: Text('Accept the request to join the chat',
                      style: textStyleTitle),
                ),
                SizedBox(height: 2.w),
                Consumer(builder: (context, ref, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: ElevatedButton(
                          style: elevatedButtonSecondaryStyle,
                          onPressed: () async {
                            showLoading(ref);
                            await BChatContactManager.sendRequestResponse(
                                ref,
                                model.id,
                                model.contact.fcmToken,
                                ContactAction.declineRequest);

                            ref
                                .read(contactListProvider.notifier)
                                .removeContact(model.contact.userId);
                            ref
                                .read(chatConversationProvider.notifier)
                                .removeConversation(
                                    model.contact.userId.toString());
                            hideLoading(ref);
                            if (direct) {
                              Navigator.pushReplacementNamed(
                                  context, RouteList.homeDirect);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Decline'.toUpperCase()),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 30.w,
                        child: ElevatedButton(
                          style: elevatedButtonStyle,
                          // style: dialogElevatedButtonStyle,
                          onPressed: () async {
                            showLoading(ref);
                            await BChatContactManager.sendRequestResponse(
                                ref,
                                model.id,
                                model.contact.fcmToken,
                                ContactAction.acceptRequest);
                            final contact = await ref
                                .read(contactListProvider.notifier)
                                .addContact(
                                    model.contact.userId, ContactStatus.friend);
                            if (contact != null) {
                              final model = await ref
                                  .read(chatConversationProvider.notifier)
                                  .addConversationByContact(contact);
                              hideLoading(ref);
                              if (model != null) {
                                await Navigator.pushReplacementNamed(
                                    context,
                                    direct
                                        ? RouteList.chatScreenDirect
                                        : RouteList.chatScreen,
                                    arguments: model);
                              }
                            } else {
                              hideLoading(ref);
                            }
                            //     if (direct) {
                            //   Navigator.pushReplacementNamed(
                            //       context, RouteList.homeDirect);
                            // } else {
                            //   Navigator.pop(context);
                            // }
                          },
                          child: Text('Accept'.toUpperCase()),
                        ),
                      )
                    ],
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaiting() {
    return Container(
      color: const Color(0xFFCCCCCC),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                ),
              ),
              child: const Text('Waiting for accept request')),
        ],
      ),
    );
  }

  Future _sendMediaFile(AttachedFile attFile, WidgetRef ref) async {
    final ChatMessage msg;
    String displayName = attFile.file.path.split('/').last;
    final String content;
    if (attFile.messageType == MessageType.IMAGE) {
      msg = ChatMessage.createImageSendMessage(
        targetId: model.contact.userId.toString(),
        filePath: attFile.file.path,
        displayName: displayName,
        fileSize: attFile.file.size.toInt(),
      );
      content = 'Photo';
    } else if (attFile.messageType == MessageType.VIDEO) {
      var info = await videoInfo.getVideoInfo(attFile.file.path);
      if (info != null) {
        print(
            'Video Info=> d:${info.duration}, w:${info.width}, h:${info.height} ${attFile.file.path}');
        print('Video FILEPATH=> ${attFile.file.path}');
        msg = ChatMessage.createVideoSendMessage(
          targetId: model.contact.userId.toString(),
          filePath: attFile.file.path,
          thumbnailLocalPath: attFile.file.thumbPath,
          displayName: displayName,
          fileSize: info.filesize ?? attFile.file.size.toInt(),
          duration: (info.duration ?? 0) ~/ 1000,
          width: (info.width ?? 0).toDouble(),
          height: (info.height ?? 0).toDouble(),
        );
      } else {
        msg = ChatMessage.createVideoSendMessage(
            targetId: model.contact.userId.toString(),
            filePath: attFile.file.path,
            thumbnailLocalPath: attFile.file.thumbPath,
            displayName: displayName,
            fileSize: attFile.file.size.toInt()
            // ,
            );
      }
      content = 'Video';
    } else if (attFile.messageType == MessageType.VOICE) {
      msg = ChatMessage.createVoiceSendMessage(
        targetId: model.contact.userId.toString(),
        filePath: attFile.file.path,
        displayName: displayName,
        fileSize: attFile.file.size.toInt(),
      );
      content = 'Audio';
    } else {
      msg = ChatMessage.createFileSendMessage(
        targetId: model.contact.userId.toString(),
        filePath: attFile.file.path,
        displayName: displayName,
        fileSize: attFile.file.size.toInt(),
      );
      content = 'File';
    }
    msg.attributes = {
      "em_apns_ext": {
        "em_push_title": "${_me.name} sent you a message",
        "em_push_content": 'A New $content',
        'type': 'chat',
        // 'name': _me.name,
        // 'image': _me.profileImage,
        // 'content_type': msg.body.type.name,
      },
    };

    await _sendMessage(msg, ref, isFile: true);
  }

  Widget _buildReplyBox() {
    return Consumer(
      builder: (context, ref, child) {
        bool show = ref.watch(chatModelProvider).isReplyBoxVisible;
        if (show) {
          ReplyModel replyOf = ref.watch(chatModelProvider).replyOn!;
          return ChatReplyBodyContent(
            replyOf: replyOf,
            isOwnMessage: replyOf.message.from == _me.userId.toString(),
            onClose: () {
              ref.read(chatModelProvider).clearReplyBox();
            },
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
          onTextChange: () {
            ref.read(typingProvider(model.id).notifier).textChange();
            // TypingHelper.instance.textChange(model.id);
          },
          onSend: (input) async {
            final ChatMessage msg = ChatMessage.createTxtSendMessage(
                targetId: model.id.toString(), content: input);
            // ..from = _myChatPeerUserId;
            msg.attributes = {
              "em_apns_ext": {
                "em_push_title": "${_me.name} sent you a message",
                "em_push_content": input,
                'type': 'chat',
              },
              //   // Adds the push template to the message.
              //   // "em_push_template": {
              //   //   // Sets the template name.
              //   //   "name": "default",
              //   //   // Sets the template title by specifying the variable.
              //   //   "title_args": ["${model.contact.name} sent you a message"],
              //   //   // Sets the template content by specifying the variable.x
              //   //   "content_args": [input],
              //   // }
            };
            // ref.read(chatMessageListProvider.notifier).addChat(msg);
            return await _sendMessage(msg, ref);
          },
          showCamera: true,
          // onCamera: () {
          //   pickFile(AttachType.cameraPhoto, ref, context);
          // },
          showAttach: true,
          // onAttach: (type) => pickFile(type, ref, context),
        );
      },
    );
  }

  Widget _buildMessageList(WidgetRef ref) {
    final chatList =
        ref.watch(bChatMessagesProvider(model)); //.reversed.toList();
    final selectedItems = ref.watch(selectedChatMessageListProvider);

    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount: chatList.length,
      itemBuilder: (context, i) {
        final ChatMessageExt? previousMessage =
            i < chatList.length - 1 ? chatList[i + 1] : null;
        final ChatMessageExt? nextMessage = i > 0 ? chatList[i - 1] : null;
        final ChatMessageExt message = chatList[i];
        final bool isAfterDateSeparator =
            shouldShowDateSeparator(previousMessage?.msg, message.msg);
        bool isBeforeDateSeparator = false;
        if (nextMessage != null) {
          isBeforeDateSeparator =
              shouldShowDateSeparator(message.msg, nextMessage.msg);
        }
        bool isPreviousSameAuthor = false;
        bool isNextSameAuthor = false;
        if (previousMessage?.msg.from == message.msg.from) {
          isPreviousSameAuthor = true;
        }
        if (nextMessage?.msg.from == message.msg.from) {
          isNextSameAuthor = true;
        }
        bool isSelected = selectedItems.contains(message.msg);

        bool isOwnMessage = message.msg.from != model.id;
        isOwnMessage ? _markOwnRead(message.msg) : _markRead(message.msg);

        bool notReply = message.msg.body.type == MessageType.CMD ||
            message.msg.body.type == MessageType.CUSTOM;
        // print('notReply -> $notReply , type=> ${message.chatType} ');

        int progress = 0;
        CallMessegeBody? callBody;
        if (isOwnMessage) {
          progress = ref.watch(sendingFileProgress(message.msg.msgId));
        } else {
          callBody = getMissedCallBody(message.msg);
        }

        return AutoScrollTag(
          controller: _scrollController,
          index: i,
          key: ValueKey(message.msg.msgId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment:
            //     isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (isAfterDateSeparator)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    formatDateSeparator(DateTime.fromMillisecondsSinceEpoch(
                        message.msg.serverTime)),
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: AppColors.black,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              callBody != null
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.all(2.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.w),
                        decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(2.w)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.call_missed, color: Colors.red),
                            Text(
                              callBody.callType == CallType.video
                                  ? S.current.chat_missed_call_video(
                                      model.contact.name,
                                      DateFormat('h:mm a').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              message.msg.serverTime)))
                                  : S.current.chat_missed_call(
                                      model.contact.name,
                                      DateFormat('h:mm a').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              message.msg.serverTime))),
                              // 'Missed call from ${model.contact.name} at ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(message.msg.serverTime))}',
                              style: TextStyle(
                                fontFamily: kFontFamily,
                                color: Colors.black,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SwipeTo(
                      // key: ValueKey(message.msg.msgId),
                      rightSwipeWidget: const SizedBox.shrink(),
                      // offsetDx: 0.8,
                      onRightSwipe: notReply
                          ? null
                          : () {
                              ref
                                  .read(chatModelProvider.notifier)
                                  .setReplyOn(message.msg, model.contact.name);
                              // print('open replyBox');
                            },
                      child: GestureDetector(
                        onLongPress: () =>
                            _onMessageLongPress(message, isSelected, ref),
                        onTap: () => selectedItems.isNotEmpty
                            ? _onMessageLongPress(message, isSelected, ref)
                            : notReply || message.isGroupMedia
                                ? null
                                : _onMessageTap(message.msg, context, ref),
                        child: Container(
                          // margin: EdgeInsets.only(top: 1.w, bottom: 2.w),
                          width: double.infinity,
                          color: isSelected
                              ? Colors.grey.shade200
                              : Colors.transparent,
                          child: ChatMessageBubbleExt(
                            message: message,
                            isOwnMessage: isOwnMessage,
                            senderUser: isOwnMessage ? _me : model.contact,
                            isPreviousSameAuthor: isPreviousSameAuthor,
                            isNextSameAuthor: isNextSameAuthor,
                            isAfterDateSeparator: isAfterDateSeparator,
                            isBeforeDateSeparator: isBeforeDateSeparator,
                            progress: progress,
                            onTapRepliedMsg: (msg) async {
                              // print('onTapRepliedMsg ${msg.msgId}');
                              // final index =
                              //     chatList.indexOf(ChatMessageExt([msg]));
                              // if (index >= 0) {
                              //   _scrollController.scrollToIndex(index);
                              // } else {
                              int intx = await ref
                                  .read(bChatMessagesProvider(model).notifier)
                                  .searchRepliedMessageIndex(msg);
                              if (intx >= 0) {
                                // print('Index ${intx}');
                                _scrollController.scrollToIndex(intx,
                                    preferPosition: AutoScrollPosition.begin);
                              } else {
                                // print('Index ${intx}');
                              }
                              // }
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  _onMessageLongPress(ChatMessageExt message, bool selected, WidgetRef ref) {
    // ChatClient.getInstance.chatManager.a
    if (selected) {
      if (message.isGroupMedia) {
        for (ChatMessage m in message.messages) {
          ref.read(selectedChatMessageListProvider.notifier).remove(m);
        }
      } else {
        ref.read(selectedChatMessageListProvider.notifier).remove(message.msg);
      }
      //
    } else {
      if (message.isGroupMedia) {
        for (ChatMessage m in message.messages) {
          ref.read(selectedChatMessageListProvider.notifier).addChat(m);
        }
      } else {
        ref.read(selectedChatMessageListProvider.notifier).addChat(message.msg);
      }
      // ref.read(selectedChatMessageListProvider.notifier).addChat(message);
    }
  }

  _onMessageTap(
      ChatMessage message, BuildContext context, WidgetRef ref) async {
    final action = await showMessageMenu(context, message);
    if (action == null) return;
    if (action == messageActionCopy) {
      //Copy
      copyToClipboard([message]);
    } else if (action == messageActionForward) {
      //Forward
      await showForwardList(context, [message], model.id);
    } else if (action == messageActionReply) {
      //Reply
      bool isOwnMessage = message.from != model.id;
      ref.read(chatModelProvider.notifier).setReplyOn(
          message, isOwnMessage ? S.current.chat_yourself : model.contact.name);
    } else if (action == messageActionDelete) {
      //Delete
      ref.read(bChatMessagesProvider(model).notifier).deleteMessages([message]);
    }
  }

  Future<String?> _sendMessage(ChatMessage msg, WidgetRef ref,
      {bool isFile = false}) async {
    // if (_me == null) return 'User details not loaded yet';
    try {
      msg.attributes?.addAll({"em_force_notification": true});
      ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
      if (replyOf != null) {
        msg.attributes?.addAll({'reply_of': replyOf.toJson()});
        ref.read(chatModelProvider).clearReplyBox();
      }

      // print('pre:msgId ${msg.msgId}');
      // msg.setMessageStatusCallBack(
      //   MessageStatusCallBack(
      //     onSuccess: () {
      //       if (isFile) {
      //         ref.read(sendingFileProgress(msg.msgId).notifier).state = 0;
      //       }
      //     },
      //     onError: (error) {
      //       if (isFile) {
      //         // hideLoading(ref);
      //         ref.read(sendingFileProgress(msg.msgId).notifier).state = 0;
      //       }
      //       BuildContext? cntx = navigatorKey.currentContext;
      //       if (cntx != null) {
      //         AppSnackbar.instance.error(cntx, error.description);
      //       }
      //       // Occurs when the message sending fails. You can update the message status and add other operations in this callback.
      //     },
      //     onProgress: (progress) {
      //       if (isFile) {
      //         // showLoading(ref);
      //         ref.read(sendingFileProgress(msg.msgId).notifier).state =
      //             progress;
      //       }

      //       // For attachment messages such as image, voice, file, and video, you can get a progress value for uploading or downloading them in this callback.
      //     },
      //   ),
      // );
      // final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
      final chat = await ref
          .read(bChatMessagesProvider(model).notifier)
          .sendMessage(msg);

      if (chat != null) {
        // print('post:msgId ${chat.msgId}');
        ref.read(chatConversationProvider.notifier).addConversationMessage(msg);
        // _scrollController.animateTo(
        //   0.0,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        // );
        _scrollController.scrollToIndex(0,
            preferPosition: AutoScrollPosition.begin);
        return null;
      } else {
        AppSnackbar.instance
            .error(navigatorKey.currentContext!, "Error while sending message");
      }
    } on ChatError catch (e) {
      print("send failed, code: ${e.code}, desc: ${e.description}");
      AppSnackbar.instance.error(navigatorKey.currentContext!,
          "Error while sending message: ${e.code}");
      return e.description;
    } catch (e) {
      print("send failed, code: $e");
      AppSnackbar.instance
          .error(navigatorKey.currentContext!, "Error while sending message");
      return e.toString();
    }
    return 'Error while sending message';
  }

  Widget _buildUserTyping() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getCicleAvatar(
              radius: 4.w,
              model.contact.name,
              model.contact.profileImage,
              cacheWidth: (50.w * devicePixelRatio).round(),
              cacheHeight: (50.w * devicePixelRatio).round()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
                color: AppColors.chatBoxBackgroundOthers,
                borderRadius: BorderRadius.all(Radius.circular(3.w))),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: const TypingIndicator(),
            // child: JumpingDots(
            //   color: AppColors.chatBoxMessageOthers,
            //   radius: 1.w,
            //   numberOfDots: 4,
            //   // innerPadding: 1.w,
            // ),
          ),
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //           text: model.contact.name,
          //           style: TextStyle(
          //               fontSize: 12,
          //               fontFamily: kFontFamily,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black)),
          //       TextSpan(
          //         text: ' is typing',
          //         style: TextStyle(
          //             fontFamily: kFontFamily,
          //             fontSize: 12,
          //             color: Colors.black),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    // ref.read(bChatMessagesProvider(model).notifier).addChats(messages);
    for (var msg in messages) {
      if (msg.conversationId == model.id && msg.from == model.id) {
        ref.read(typingProvider(model.id).notifier).cancelTimer();
        break;
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
        ref.watch(bChatMessagesProvider(model).notifier).loadMore();
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
          Expanded(
            child: Text(
              selectedItems.length > 1
                  ? '${selectedItems.length} Messages selected'
                  : '${selectedItems.length} Message',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const Spacer(),
          Visibility(
            visible: (selectedItems
                .where((e) => e.body.type != MessageType.TXT)
                .isEmpty),
            child: IconButton(
              onPressed: () async {
                await copyToClipboard(selectedItems);
                // ref
                //     .read(bhatMessagesProvider(model).notifier)
                //     .deleteMessages(selectedItems);
                ref.read(selectedChatMessageListProvider.notifier).clear();
                // AppSnackbar.instance.message(context, 'Need to implement');
                // ChatClient.getInstance.chatManager.del
              },
              padding: EdgeInsets.all(1.w),
              tooltip: S.current.chat_menu_copy,
              icon: getSvgIcon(
                'icon_chat_copy.svg',
                width: 5.w,
                color: Colors.white,
              ),
            ),
          ),
          Visibility(
            visible:
                // selectedItems.length == 1 &&
                selectedItems
                    .where((e) => e.body.type == MessageType.CUSTOM)
                    .isEmpty,
            // selectedItems.first.body.type != MessageType.CUSTOM,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await showForwardList(context, selectedItems, model.id);
                    // ref
                    //     .read(bhatMessagesProvider(model).notifier)
                    //     .deleteMessages(selectedItems);
                    ref.read(selectedChatMessageListProvider.notifier).clear();
                    // AppSnackbar.instance.message(context, 'Need to implement');
                    // ChatClient.getInstance.chatManager.del
                  },
                  padding: EdgeInsets.all(1.w),
                  tooltip: S.current.chat_menu_forward,
                  icon: getSvgIcon(
                    'icon_chat_forward.svg',
                    width: 5.w,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    ChatMessage message = selectedItems.first;
                    // bool isOwnMessage = message.from != model.id;
                    ref
                        .read(chatModelProvider.notifier)
                        .setReplyOn(message, model.contact.name);
                    // ref
                    //     .read(bhatMessagesProvider(model).notifier)
                    //     .deleteMessages(selectedItems);
                    ref.read(selectedChatMessageListProvider.notifier).clear();
                    // ChatClient.getInstance.chatManager.del
                  },
                  padding: EdgeInsets.all(1.w),
                  tooltip: S.current.chat_menu_reply,
                  icon: getSvgIcon(
                    'icon_chat_reply.svg',
                    width: 5.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              ref
                  .read(bChatMessagesProvider(model).notifier)
                  .deleteMessages(selectedItems);
              ref.read(selectedChatMessageListProvider.notifier).clear();
              // ChatClient.getInstance.chatManager.del
            },
            padding: EdgeInsets.all(1.w),
            tooltip: S.current.chat_menu_delete,
            icon: getSvgIcon(
              'icon_delete_conv.svg',
              width: 5.w,
              color: Colors.white,
            ),
          ),
          // IconButton(
          //   onPressed: () async {
          //     ref
          //         .read(bhatMessagesProvider(model).notifier)
          //         .deleteMessages(selectedItems);
          //     ref.read(selectedChatMessageListProvider.notifier).clear();
          //     // ChatClient.getInstance.chatManager.del
          //   },
          //   icon: const Icon(
          //     Icons.delete,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context, WidgetRef ref) {
    // final value = ref.watch(onlineStatusProvier);
    bool isAdmin = model.contact.userId == AgoraConfig.bViydaAdmitUserId;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (() {
                if (direct) {
                  Navigator.pushReplacementNamed(context, RouteList.homeDirect);
                } else {
                  Navigator.pop(context);
                }
              }),
              icon: getSvgIcon('arrow_back.svg', width: 6.w),
            ),
            // SizedBox(width: 2.w),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 2.w),
            //   child: ,
            // ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, RouteList.contactProfile,
                      arguments: model.contact);
                  setScreen(RouteList.chatScreen);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w, top: 1.h, bottom: 1.h),
                  child: Row(
                    children: [
                      // SizedBox(width: 2.w),
                      getRectFAvatar(
                          model.contact.name, model.contact.profileImage,
                          cacheHeight: (40.w * devicePixelRatio).round(),
                          cacheWidth: (40.w * devicePixelRatio).round()),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.contact.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: kFontFamily,
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              isAdmin
                                  ? 'Any query or suggestion'
                                  : parseChatPresenceToReadable(
                                      ref.watch(onlineStatusProvider)),
                              // parseChatPresenceToReadable(value),
                              style: TextStyle(
                                fontFamily: kFontFamily,
                                color: AppColors.yellowAccent,
                                fontSize: 9.sp,
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
            ),
            if (!isAdmin)
              IconButton(
                onPressed: () async {
                  final msg = await makeAudioCall(model.contact, ref, context);
                  if (msg != null) {
                    // ref.read(bChatMessagesProvider(model).notifier).addChat(msg);
                  }
                  setScreen(RouteList.chatScreen);
                },
                icon: getSvgIcon(
                  'icon_audio_call.svg',
                  width: 6.w,
                ),
              ),
            SizedBox(width: 2.w),
            if (!isAdmin)
              IconButton(
                onPressed: () async {
                  // receiveAudioCall(
                  //   'YcJ5uHP31M8sMyAZ1msC',
                  //   model.contact.profileImage,
                  //   ref,
                  //   context,
                  // );
                  final msg = await makeVideoCall(model.contact, ref, context);
                  if (msg != null) {
                    // ref.read(bChatMessagesProvider(model).notifier).addChat(msg);
                  }
                  setScreen(RouteList.chatScreen);
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
    try {
      if (!message.hasReadAck) {
        await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
      }
      await model.conversation?.markMessageAsRead(message.msgId);
    } catch (_) {}
  }

  void _markOwnRead(ChatMessage message) async {
    try {
      if (!message.hasRead) {
        await model.conversation?.markMessageAsRead(message.msgId);
      }
    } catch (_) {}
  }
}
