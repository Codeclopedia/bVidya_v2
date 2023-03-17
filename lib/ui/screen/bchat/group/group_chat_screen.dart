// import 'dart:io';

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

import '/core/helpers/group_member_helper.dart';
import '../utils/attach_uihelper.dart';
import '../widgets/chat_message_bubble_ex.dart';
import '/app.dart';
import '/ui/widget/chat_reply_body.dart';
import '/core/helpers/call_helper.dart';
import '/core/helpers/group_call_helper.dart';
import '/core/sdk_helpers/group_typing_helper.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/core/utils/date_utils.dart';
import '/core/helpers/extensions.dart';
import '/core/sdk_helpers/bchat_handler.dart';
import '/data/models/contact_model.dart';
import '/data/models/conversation_model.dart';
import '/controller/providers/bchat/group_chats_provider.dart';
import '/core/utils/common.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/controller/providers/chat_messagelist_provider.dart';
import '/ui/base_back_screen.dart';
import '/ui/dialog/message_menu_popup.dart';
import '../widgets/typing_indicator.dart';
import '../models/attach_type.dart';
import '../models/reply_model.dart';
import '../../../dialog/forward_dialog.dart';
import '../../../widgets.dart';
import '../../../widget/chat_input_box.dart';

// final attachedGroupFile = StateProvider.autoDispose<AttachedFile?>((_) => null);
// final attachedGroupFiles =
//     StateProvider.autoDispose<List<AttachedFile>>((_) => []);
final sendingGroupFileProgress =
    StateProvider.family.autoDispose<int, String>((_, id) => 0);

class GroupChatScreen extends HookConsumerWidget {
  final GroupConversationModel model;
  final bool direct;

  GroupChatScreen({Key? key, required this.model, this.direct = false})
      : super(key: key);

  String _myUserId = '';
  late final AutoScrollController _scrollController;

  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  late Contacts _me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final provider = ref.watch(groupChatProvider(model));
    useEffect(() {
      _addHandler(ref);
      ref.read(groupChatProvider(model).notifier).init(ref);
      // _scrollController = ScrollController();
      _scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical,
      );

      _myUserId = ChatClient.getInstance.currentUserId ?? '';
      _scrollController.addListener(() => _onScroll(_scrollController, ref));
      _loadMe();
      // _loadMembers(ref);

      return disposeAll;
    }, []);

    ref.listen(hasMoreStateProvider, (previous, next) {
      _hasMoreData = next;
    });
    ref.listen(loadingMoreStateProvider, (previous, next) {
      _isLoadingMore = next;
    });
    // ref.listen(groupChatProvider(model), (previous, next) {
    //   _hasMoreData = next.hasMoreData;
    //   _isLoadingMore = next.isLoadingMore;
    // });
    // ref.listen(chatHasMoreOldMessageProvider, (previous, next) {
    //   _hasMoreData = next;
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
          status: ContactStatus.self);
      _myUserId = _me.userId.toString();
      // _memberList =
    }
  }

  // _loadMembers(WidgetRef ref) async {
  // _memberList.clear();
  // final list =
  //     await BchatGroupManager.loadGroupMemebers(model.groupInfo, ref);
  // _memberList.addAll(list);
  // }

  _addHandler(WidgetRef ref) async {
    registerGroupForNewMessage('group_chat_screen', (msg) {
      // print('msg  message=> ${msg.length}');
      onMessagesReceived(msg, ref);
    }, () {
      ref.read(groupChatProvider(model).notifier).updateUi();
    }, (bodies) {
      ref
          .read(groupTypingUsersProvider(model.id).notifier)
          .onReceiveCommandMessage(bodies);
    });
  }

  void disposeAll() {
    unregisterForNewMessage('group_chat_screen');
    // ChatClient.getInstance.chatManager.removeEventHandler('group_chat_screen');
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    // print('message=> ${messages.length}');
    ref.read(groupChatProvider(model).notifier).addChats(messages);
    for (var msg in messages) {
      // print('msg: ${msg.from}');
      if (msg.chatType == ChatType.GroupChat && msg.conversationId != null) {
        if (msg.conversationId == model.id) {
          ref
              .read(groupTypingUsersProvider(model.id).notifier)
              .removeTyping(msg.from);
        }
        ref
            .read(groupConversationProvider.notifier)
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
                    _buildTypingUsers()
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
        buildAttachedFile(_buildChatInputBox(),
            (AttachedFile attFile, WidgetRef ref) async {
          return await _sendMediaFile(attFile, ref);
        })
        // _buildAttachedFile()
        // _buildChatInputBox(),
      ],
    );
  }

  Widget _buildTypingUsers() {
    return Consumer(
      builder: (context, ref, child) {
        final typingUsers = ref.watch(groupTypingUsersProvider(model.id));
        if (typingUsers.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...typingUsers
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: getCicleAvatar(radius: 3.w, e.name, e.profile),
                      ),
                    )
                    .toList(),
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
      },
    );
  }

  Widget _buildChatInputBox() {
    return Consumer(builder: (context, ref, child) {
      return ChatInputBox(
        onSend: (input) async {
          final msg = ChatMessage.createTxtSendMessage(
              targetId: model.id, content: input, chatType: ChatType.GroupChat);
          // ..from = _myUserId;

          msg.attributes = {
            "em_apns_ext": {
              "em_push_title":
                  "${_me.name} sent you a message in ${model.groupInfo.name}",
              "em_push_content": input,
              // 'content': input,
              'type': 'group_chat',
              // 'name': _me.name,
              // 'image': model.image,
              // 'group_name': model.groupInfo.name,
              // 'content_type': msg.body.type.name,
            },
            // Adds the push template to the message.
            // "em_push_template": {
            //   // Sets the template name.
            //   "name": "default",
            //   // Sets the template title by specifying the variable.
            //   "title_args": ["${model.contact.name} sent you a message"],
            //   // Sets the template content by specifying the variable.
            //   "content_args": [input],
            // }
          };

          return await _sendMessage(msg, ref);
        },
        // onCamera: () {
        //   pickFile(AttachType.cameraPhoto, ref, context);
        // },
        showCamera: true,
        showAttach: true,
        // onAttach: (type) => pickFile(type, ref, context),
        onTextChange: () {
          ref
              .read(groupTypingUsersProvider(model.id).notifier)
              .textChange(_me.userId.toString(), _me.name, _me.profileImage);
        },
      );
    });
  }

  // Widget _buildAttachedFile() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       List<AttachedFile> attaches = ref.watch(attachedGroupFiles);
  //       if (attaches.isNotEmpty) {
  //         return attachFilesView(attaches, () async {
  //           showLoading(ref);
  //           for (var attFile in attaches) {
  //             await _sendMediaFile(attFile, ref);
  //           }
  //           ref.read(attachedGroupFiles.notifier).state = [];
  //           hideLoading(ref);
  //         });
  //       }

  //       AttachedFile? attFile = ref.watch(attachedGroupFile);
  //       return attFile == null
  //           ? _buildChatInputBox(ref, context)
  //           : attachFileView(attFile, () async {
  //               showLoading(ref);
  //               await _sendMediaFile(attFile, ref);
  //               ref.read(attachedGroupFile.notifier).state = null;
  //               hideLoading(ref);
  //             });
  //     },
  //   );
  // }

  Future _sendMediaFile(AttachedFile attFile, WidgetRef ref) async {
    // showLoading(ref);
    final ChatMessage msg;
    String displayName = attFile.file.path.split('/').last;
    String content = '';
    if (attFile.messageType == MessageType.IMAGE) {
      msg = ChatMessage.createImageSendMessage(
          targetId: model.id.toString(),
          filePath: attFile.file.path,
          displayName: displayName,
          fileSize: attFile.file.size.toInt(),
          chatType: ChatType.GroupChat);
      content = 'Photo';
    } else if (attFile.messageType == MessageType.VIDEO) {
      msg = ChatMessage.createVideoSendMessage(
          targetId: model.id.toString(),
          filePath: attFile.file.path,
          fileSize: attFile.file.size.toInt(),
          displayName: displayName,
          thumbnailLocalPath: attFile.file.thumbPath,
          chatType: ChatType.GroupChat);
      content = 'Video';
    } else if (attFile.messageType == MessageType.VOICE) {
      msg = ChatMessage.createVoiceSendMessage(
          targetId: model.id.toString(),
          filePath: attFile.file.path,
          displayName: displayName,
          fileSize: attFile.file.size.toInt(),
          chatType: ChatType.GroupChat);
      content = 'Audio';
    } else {
      msg = ChatMessage.createFileSendMessage(
          targetId: model.id.toString(),
          filePath: attFile.file.path,
          displayName: displayName,
          fileSize: attFile.file.size.toInt(),
          chatType: ChatType.GroupChat);
      content = 'File';
    }
    msg.attributes = {
      "em_apns_ext": {
        "em_push_title":
            "${_me.name} sent you a message in ${model.groupInfo.name}",
        "em_push_content": "A new $content ",
        'type': 'group_chat',
        // 'name': _me.name,
        // 'image': model.image,
        // 'group_name': model.groupInfo.name,
        // 'content_type': msg.body.type.name,
      },
    };

    await _sendMessage(msg, ref, isFile: true);
    // ref.read(attachedGroupFile.notifier).state = null;
  }

  Widget _buildMessageList(WidgetRef ref) {
    final chatList = ref.watch(groupChatProvider(model)).toList();
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      controller: _scrollController,
      itemCount: chatList.length,
      itemBuilder: (context, i) {
        final ChatMessage? previousMessage =
            i < chatList.length - 1 ? chatList[i + 1].msg : null;
        final ChatMessage? nextMessage = i > 0 ? chatList[i - 1].msg : null;
        final ChatMessageExt message = chatList[i];
        final bool isAfterDateSeparator =
            shouldShowDateSeparator(previousMessage, message.msg);
        bool isBeforeDateSeparator = false;
        if (nextMessage != null) {
          isBeforeDateSeparator =
              shouldShowDateSeparator(message.msg, nextMessage);
        }
        bool isPreviousSameAuthor = false;
        bool isNextSameAuthor = false;
        if (previousMessage?.from == message.msg.from) {
          isPreviousSameAuthor = true;
        }
        if (nextMessage?.from == message.msg.from) {
          isNextSameAuthor = true;
        }

        final selectedItems = ref.watch(selectedChatMessageListProvider);
        bool isSelected = selectedItems.contains(message.msg);

        bool isOwnMessage = message.msg.from == _myUserId;

        int progress = 0;
        if (isOwnMessage) {
          progress = ref.watch(sendingGroupFileProgress(message.msg.msgId));
        }

        String name = message.msg.attributes?['from_name'] ?? '';
        String image = message.msg.attributes?['from_image'] ?? '';
        Contacts contact = Contacts(
            userId: int.parse(message.msg.from!),
            name: name,
            profileImage: image,
            status: ContactStatus.group);

        bool notReply = message.msg.body.type == MessageType.CMD ||
            message.msg.body.type == MessageType.CUSTOM;

        Widget? grpMemberUpdateView;

        if (message.msg.body.type == MessageType.CUSTOM) {
          ChatCustomMessageBody body =
              message.msg.body as ChatCustomMessageBody;
          try {
            final map = jsonDecode(body.event);
            // print('map: $map');
            if (map['type'] == 'member_update') {
              final memebers = map['members'];
              if (memebers != null) {
                String actionStr = '';
                GroupMemberAction? action = groupActionFrom(map['action']);

                String by = name.isEmpty
                    ? ''
                    : ' by ${isOwnMessage ? S.current.bmeet_user_you : (contact.name)}';
                if (action == GroupMemberAction.added) {
                  actionStr = ' added$by';
                } else if (action == GroupMemberAction.removed) {
                  actionStr = ' removed$by';
                } else if (action == GroupMemberAction.joined) {
                  actionStr = ' joined';
                } else if (action == GroupMemberAction.left ||
                    action == GroupMemberAction.left) {
                  actionStr = ' left';
                } else {
                  actionStr = '';
                }

                final grpMemebers = GroupMembers.fromJson(jsonDecode(memebers));
                final List<Widget> list = grpMemebers.infos
                    .map(
                      (e) => Container(
                        margin: EdgeInsets.all(2.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.8.w),
                        decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(2.w)),
                        child: Text(
                          '${e.id == _me.userId ? S.current.bmeet_user_you : (e.name ?? 'User #${e.id}')}$actionStr',
                          style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.black,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList();
                grpMemberUpdateView = Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: list,
                );
              }
            }
          } catch (_) {
            // print('Error parsing custom message: $e');
          }
        }
        isOwnMessage ? _markOwnRead(message.msg) : _markRead(message.msg);

        return AutoScrollTag(
          controller: _scrollController,
          index: i,
          key: ValueKey(message.msg.msgId),
          child: Column(
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
              grpMemberUpdateView ??
                  SwipeTo(
                    onRightSwipe: notReply
                        ? null
                        : () {
                            ref
                                .read(chatModelProvider.notifier)
                                .setReplyOn(message.msg, contact.name);
                            // print('open replyBox');
                          },
                    child: GestureDetector(
                      onLongPress: () =>
                          _onMessageLongPress(message, isSelected, ref),
                      onTap: () => selectedItems.isNotEmpty
                          ? _onMessageLongPress(message, isSelected, ref)
                          : notReply
                              ? null
                              : _onMessageTap(message.msg, context, ref),
                      child: Container(
                        margin: const EdgeInsets.only(top: 2, bottom: 4),
                        width: double.infinity,
                        color: isSelected
                            ? Colors.grey.shade200
                            : Colors.transparent,
                        child: ChatMessageBubbleExt(
                          message: message,
                          isOwnMessage: isOwnMessage,
                          senderUser: isOwnMessage ? _me : contact,
                          isPreviousSameAuthor: isPreviousSameAuthor,
                          isNextSameAuthor: isNextSameAuthor,
                          isAfterDateSeparator: isAfterDateSeparator,
                          isBeforeDateSeparator: isBeforeDateSeparator,
                          showOtherUserName: true,
                          progress: progress,
                          onTapRepliedMsg: (msg) async {
                            int intx = await ref
                                .read(groupChatProvider(model).notifier)
                                .searchRepliedMessageIndex(ref, msg);
                            if (intx >= 0) {
                              // print('Index ${intx}');
                              _scrollController.scrollToIndex(intx,
                                  preferPosition: AutoScrollPosition.begin);
                            } else {
                              // print('Index ${intx}');
                            }
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
      // AppSnackbar.instance.message(context, 'Need to implement');
      copyToClipboardGroup([message]);
    } else if (action == messageActionForward) {
      //Forward
      // AppSnackbar.instance.message(context, 'Need to implement');
      await showForwardList(context, [message], model.id);
    } else if (action == messageActionForward) {
      //Reply
      String name = message.attributes?['from_name'] ?? '';
      bool isOwnMessage = message.from != model.id;
      ref
          .read(chatModelProvider.notifier)
          .setReplyOn(message, isOwnMessage ? S.current.bmeet_user_you : name);
    } else if (action == messageActionDelete) {
      //Delete
      ref.read(groupChatProvider(model).notifier).deleteMessages([message]);
    }
    // if (message.body.type == MessageType.IMAGE) {
    //   //open image
    //   // Navigator.pushNamed(context, RouteList.bViewImage,
    //   //     arguments: message.body as ChatImageMessageBody);
    //   showImageViewer(
    //       context,
    //       getImageProviderChatImage(message.body as ChatImageMessageBody,
    //           loadThumbFirst: false), onViewerDismissed: () {
    //     // print("dismissed");
    //   });
    // } else if (message.body.type == MessageType.VIDEO) {
    //   Navigator.pushNamed(context, RouteList.bViewVideo,
    //       arguments: message.body as ChatVideoMessageBody);
    // } else if (message.body.type == MessageType.FILE) {}
  }

  Future<String?> _sendMessage(ChatMessage msg, WidgetRef ref,
      {bool isFile = false}) async {
    try {
      msg.attributes?.addAll({'from_name': _me.name});
      msg.attributes?.addAll({'from_image': _me.profileImage});
      msg.attributes?.addAll({"em_force_notification": true});
      ReplyModel? replyOf = ref.read(chatModelProvider).replyOn;
      if (replyOf != null) {
        msg.attributes?.addAll({'reply_of': replyOf.toJson()});
        ref.read(chatModelProvider).clearReplyBox();
      }
      msg.setMessageStatusCallBack(
        MessageStatusCallBack(
          onSuccess: () {
            if (isFile) {
              ref.read(sendingGroupFileProgress(msg.msgId).notifier).state = 0;
            }
            // hideLoading(ref);

            // FCMApiService.instance.sendChatPush(
            //     msg, 'toToken', _myUserId, _me!.name, NotificationType.chat);
            // Occurs when the message sending succeeds. You can update the message and add other operations in this callback.
          },
          onError: (error) {
            // hideLoading(ref);
            print('Error :${error.code} -> ${error.description}');
            if (isFile) {
              ref.read(sendingGroupFileProgress(msg.msgId).notifier).state = 0;
            }
            BuildContext? cntx = navigatorKey.currentContext;
            if (cntx != null && 505 != error.code) {
              AppSnackbar.instance.error(cntx, error.description);
            }

            // Occurs when the message sending fails. You can update the message status and add other operations in this callback.
          },
          onProgress: (progress) {
            // hideLoading(ref);
            if (isFile) {
              ref.read(sendingGroupFileProgress(msg.msgId).notifier).state =
                  progress;
            }
            // ref.read(sendingGroupFileProgress.notifier).state = progress;
            // print('progress=> $progress');
            // For attachment messages such as image, voice, file, and video, you can get a progress value for uploading or downloading them in this callback.
          },
        ),
      );

      // msg.needGroupAck = true; //todo uncomment when pricing

      final sentMessage =
          await ChatClient.getInstance.chatManager.sendMessage(msg);

      ref.read(groupChatProvider(model).notifier).addChat(sentMessage);
      ref
          .read(groupConversationProvider.notifier)
          .updateConversationMessage(sentMessage, model.id);
    } on ChatError catch (e) {
      // print("send failed, code: ${e.code}, desc: ${e.description}");
      AppSnackbar.instance.error(navigatorKey.currentContext!,
          "send failed, code: ${e.code}, desc: ${e.description}");
      return e.description;
    } catch (e) {
      // print("send failed, code: $e");
      AppSnackbar.instance.error(navigatorKey.currentContext!, "$e");
      return e.toString();
    }
    _scrollController.scrollToIndex(0);
    // _scrollController.animateTo(
    //   0.0,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    return null;
  }

  // Widget _buildUserTyping(String name) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15, top: 25),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         const Padding(
  //           padding: EdgeInsets.only(right: 2),
  //           child: TypingIndicator(),
  //         ),
  //         RichText(
  //           text: TextSpan(
  //             children: [
  //               TextSpan(
  //                   text: name,
  //                   style: const TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                   )),
  //               const TextSpan(
  //                 text: ' is typing',
  //                 style: TextStyle(fontSize: 12),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _onScroll(
      ScrollController scrollController, WidgetRef ref) async {
    // print('has _isLoadingMore :$_isLoadingMore');
    // print('has More Data :$_hasMoreData');
    if (!_isLoadingMore && _hasMoreData) {
      bool topReached = scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange;
      if (topReached) {
        ref.read(groupChatProvider(model).notifier).loadMore(ref);
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
                await copyToClipboardGroup(selectedItems);
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
                    String name = message.attributes?['from_name'] ?? '';
                    // bool isOwnMessage = message.from != model.id;
                    ref
                        .read(chatModelProvider.notifier)
                        .setReplyOn(message, name);

                    ref.read(selectedChatMessageListProvider.notifier).clear();
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
                  .read(groupChatProvider(model).notifier)
                  .deleteMessages(selectedItems);
              ref.read(selectedChatMessageListProvider.notifier).clear();
            },
            padding: EdgeInsets.all(1.w),
            tooltip: S.current.chat_menu_delete,
            icon: getSvgIcon(
              'icon_delete_conv.svg',
              width: 5.w,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context, WidgetRef ref) {
    return Padding(
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
              onTap: () async {
                await Navigator.pushNamed(context, RouteList.groupInfoChat,
                    arguments: model);
                setScreen(RouteList.groupChatScreen);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.groupInfo.name ?? '',
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
            onPressed: () async {
              final chat = await makeGroupCall(
                  ref, context, model.groupInfo, CallType.audio);
              if (chat != null) {
                ref.read(groupChatProvider(model).notifier).addChat(chat);
                setScreen(RouteList.groupChatScreen);
              } else {
                AppSnackbar.instance.error(context, 'Error in making call');
              }
            },
            icon: getSvgIcon('icon_audio_call.svg'),
          ),
          SizedBox(
            width: 1.w,
          ),
          IconButton(
            onPressed: () async {
              final chat = await makeGroupCall(
                  ref, context, model.groupInfo, CallType.video);
              if (chat != null) {
                ref.read(groupChatProvider(model).notifier).addChat(chat);
                setScreen(RouteList.groupChatScreen);
              } else {
                AppSnackbar.instance.error(context, 'Error in making call');
              }
            },
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
          return ChatReplyBodyContent(
            replyOf: replyOf,
            isOwnMessage: replyOf.message.from == _me.userId.toString(),
            onClose: () {
              ref.read(chatModelProvider).clearReplyBox();
            },
          );
          // return Container(
          //   width: 90.w,
          //   margin: EdgeInsets.only(bottom: 1.h),
          //   padding: EdgeInsets.all(2.w),
          //   decoration: BoxDecoration(
          //     color: AppColors.chatBoxBackgroundMine,
          //     borderRadius: BorderRadius.all(Radius.circular(3.w)),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Replying to ${replyOf.fromName}',
          //             style: textStyleWhite,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               ref.read(chatModelProvider).clearReplyBox();
          //             },
          //             child: const Icon(Icons.close, color: Colors.white),
          //           ),
          //         ],
          //       ),
          //       SizedBox(height: 1.h),
          //       Container(
          //           // padding: EdgeInsets.all(1.w),
          //           constraints:
          //               BoxConstraints(minHeight: 5.h, maxHeight: 25.h),
          //           decoration: BoxDecoration(
          //             color: AppColors.chatBoxBackgroundOthers,
          //             borderRadius: BorderRadius.all(Radius.circular(3.w)),
          //           ),
          //           child: ChatMessageBodyWidget(
          //             message: replyOf.message,
          //           )),
          //     ],
          //   ),
          // );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _markRead(ChatMessage message) async {
    try {
      if (message.needGroupAck) {
        // var i = await message.groupAckCount();
        // print('mark Read=>${message.msgId} -> ${message.toJson()} ');
        await ChatClient.getInstance.chatManager
            .sendGroupMessageReadAck(message.msgId, model.id);
      }

      // await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
      // await model.conversation?.markMessageAsRead(message.msgId);
    } catch (e) {
      print('Error mark read');
    }
  }

  void _markOwnRead(ChatMessage message) async {
    try {
      if (!message.hasRead) {
        message.hasRead = true;

        print(
            'mark OWN Read=>${message.msgId} -> ${message.hasDeliverAck}->  ${message.hasReadAck} ${await message.groupAckCount()}');
        await model.conversation?.markMessageAsRead(message.msgId);
      }
    } catch (_) {}
  }
}
