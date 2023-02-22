// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/ui/widget/chat_reply_body.dart';
import '/core/helpers/extensions.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/group_chats_provider.dart';
import '/core/sdk_helpers/typing_helper.dart';
import '/core/utils/common.dart';
import '../../dialog/forward_dialog.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker_plus/image_picker_plus.dart' as ipp;

import '/data/models/contact_model.dart';
import '/data/models/conversation_model.dart';
import '/app.dart';
import '/controller/providers/chat_messagelist_provider.dart';
import '/controller/providers/bchat/chat_messeges_provider.dart';
import '/core/utils/chat_utils.dart';
import '/core/helpers/call_helper.dart';
import '/core/sdk_helpers/bchat_handler.dart';
import '/core/utils.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import 'models/attach_type.dart';
import 'models/media.dart';
import 'models/reply_model.dart';
import 'widgets/attached_file.dart';
import '/ui/dialog/message_menu_popup.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';
import '../../widget/chat_input_box.dart';
import 'widgets/chat_message_bubble_ex.dart';
import 'widgets/typing_indicator.dart';

// const String commandTypingBegin = "TypingBegin";
// const String commandTypingEnd = "TypingEnd";

final attachedFile = StateProvider.autoDispose<AttachedFile?>((_) => null);
final attachedFiles = StateProvider.autoDispose<List<AttachedFile>>((_) => []);
final sendingFileProgress =
    StateProvider.autoDispose.family<int, String>((_, id) => 0);

// ignore: must_be_immutable
class ChatScreen extends HookConsumerWidget {
  final ConversationModel model;
  final bool direct;
  ChatScreen({Key? key, required this.model, this.direct = false})
      : super(key: key);

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
      final f = ref.read(bChatMessagesProvider(model).notifier);
      f.init(ref);
      _loadMe();
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
        // _buildChatInputBox(),
        _buildAttachedFile()
      ],
    );
  }

  Widget _buildAttachedFile() {
    return Consumer(
      builder: (context, ref, child) {
        List<AttachedFile> attaches = ref.watch(attachedFiles);
        if (attaches.isNotEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
            margin: EdgeInsets.only(bottom: 1.h),
            alignment: Alignment.center,
            height: 10.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEC),
              borderRadius: BorderRadius.circular(3.w),
            ),
            // constraints: BoxConstraints(
            //   minHeight: 2.h,
            //   maxHeight: 10.h,
            // ),
            child: Row(
              children: [
                Expanded(
                    child: ListView.separated(
                  itemCount: attaches.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                  itemBuilder: (context, index) {
                    final attFile = attaches[index];
                    return SizedBox(
                      width: 10.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1.w),
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(
                              attFile.file.thumbPath ?? attFile.file.path)),
                        ),
                      ),
                    );
                  },
                )),
                InkWell(
                  onTap: () async {
                    showLoading(ref);
                    for (var attFile in attaches) {
                      await _sendMediaFile(attFile, ref);
                    }
                    ref.read(attachedFiles.notifier).state = [];
                    hideLoading(ref);
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
                ),
                SizedBox(width: 2.w),
              ],
            ),
          );
        }

        AttachedFile? attFile = ref.watch(attachedFile);

        return attFile == null
            ? _buildChatInputBox()
            : Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 2.w),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minHeight: 2.h,
                        maxHeight: 10.h,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5)),
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.all(Radius.circular(3.w))),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.current.bmeet_user_you,
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 15.sp,
                                      fontFamily: kFontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 4.w,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 1.w),
                                    Flexible(
                                      child: Text(
                                        attFile.file.path.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                        // maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: kFontFamily,
                                            color: Colors.grey,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                            child: AttachedFileView(
                              attFile: attFile,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     ref.read(attachedFile.notifier).state = null;
                          //   },
                          //   icon: const Icon(Icons.close, color: Colors.red),
                          // )
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(width: 1.w),
                  InkWell(
                    onTap: () async {
                      showLoading(ref);
                      await _sendMediaFile(attFile, ref);
                      ref.read(attachedFile.notifier).state = null;
                      hideLoading(ref);
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
                  ),
                  SizedBox(width: 2.w),
                ],
              );
      },
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
      msg = ChatMessage.createVideoSendMessage(
        targetId: model.contact.userId.toString(),
        filePath: attFile.file.path,
        thumbnailLocalPath: attFile.file.thumbPath,
        displayName: displayName,
        fileSize: attFile.file.size.toInt(),
      );
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
                // 'name': _me.name,
                // 'content': input,
                // 'image': _me.profileImage,
                // 'content_type': msg.body.type.name,
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
          onCamera: () {
            _pickFile(AttachType.cameraPhoto, ref, context);
          },
          onAttach: (type) => _pickFile(type, ref, context),
        );
      },
    );
  }

  _pickFile(AttachType type, WidgetRef ref, BuildContext context) async {
    ImagePicker picker = ImagePicker();
    switch (type) {
      case AttachType.cameraPhoto:
        // SelectedImagesDetails? details =
        //     await picker.pickImage(source: ImageSource.camera);
        XFile? xFile = await picker.pickImage(source: ImageSource.camera);
        if (xFile != null) {
          // File file = xFile.path;
          final Media media = Media(
              path: xFile.path,
              size: (await xFile.length()),
              thumbPath: xFile.path);
          ref.read(attachedFile.notifier).state =
              AttachedFile(media, MessageType.IMAGE);
        }
        break;
      case AttachType.cameraVideo:
        XFile? xFile = await picker.pickVideo(source: ImageSource.camera);
        if (xFile != null) {
          final thumb = await VideoThumbnail.thumbnailFile(
            video: xFile.path,
            thumbnailPath: Directory.systemTemp.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 128,
            quality: 25,
          );
          final Media media = Media(
              path: xFile.path, size: (await xFile.length()), thumbPath: thumb);
          ref.read(attachedFile.notifier).state =
              AttachedFile(media, MessageType.VIDEO);
        }
        break;
      case AttachType.media:
        ipp.ImagePickerPlus pickerPlus = ipp.ImagePickerPlus(context);
        ipp.SelectedImagesDetails? details = await pickerPlus.pickImage(
            source: ipp.ImageSource.gallery,
            galleryDisplaySettings: ipp.GalleryDisplaySettings(
// showImagePreview: true
                ),
            multiImages: true); //todo change to both
        if (details != null && details.selectedFiles.isNotEmpty) {
          if (details.selectedFiles.length == 1) {
            ref.read(attachedFile.notifier).state =
                await getMediaFile(details.selectedFiles.first);
            return;
          }
          List<AttachedFile> files = [];
          for (var f in details.selectedFiles) {
            files.add(await getMediaFile(f));
          }
          ref.read(attachedFiles.notifier).state = files;
        }
        break;
      case AttachType.audio:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['aac', 'mp3', 'wav'],
        );
        if (result != null) {
          PlatformFile file = result.files.first;
          final Media media =
              Media(path: file.path!, size: (await File(file.path!).length()));
          ref.read(attachedFile.notifier).state =
              AttachedFile(media, MessageType.VOICE);
        }
        // fileExts = ['aac', 'mp3', 'wav'];
        break;
      case AttachType.docs:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        );
        if (result != null) {
          PlatformFile file = result.files.first;
          final Media media =
              Media(path: file.path!, size: (await File(file.path!).length()));
          ref.read(attachedFile.notifier).state =
              AttachedFile(media, MessageType.FILE);
        }
        // docPaths = await DocumentsPicker.pickDocuments;
        // fileExts = ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'];
        break;
    }
  }

  // _pickFiles(AttachType type, WidgetRef ref) async {
  //   switch (type) {
  //     case AttachType.cameraPhoto:
  //       List<Media>? res = await ImagesPicker.openCamera(
  //         quality: 0.8,
  //         pickType: PickType.image,
  //         maxSize: 5000, //5 MB
  //       );
  //       print(res);
  //       if (res != null) {
  //         final Media media = res.first;
  //         ref.read(attachedFile.notifier).state =
  //             AttachedFile(media, MessageType.IMAGE);
  //       }
  //       return;
  //     case AttachType.cameraVideo:
  //       List<Media>? res = await ImagesPicker.openCamera(
  //         quality: 0.8,
  //         pickType: PickType.video,
  //         maxSize: 10000, //10 MB
  //       );
  //       print(res);
  //       if (res != null) {
  //         final Media media = res.first;
  //         ref.read(attachedFile.notifier).state =
  //             AttachedFile(media, MessageType.VIDEO);
  //       }
  //       return;
  //     case AttachType.media:
  //       List<Media>? res = await ImagesPicker.pick(
  //         count: 1,
  //         pickType: PickType.all,
  //         language: Language.System,
  //         maxSize: 5000,
  //       );
  //       print(res);
  //       if (res != null) {
  //         final Media media = res.first;
  //         bool isImage = media.path.toLowerCase().endsWith('png') ||
  //             media.path.toLowerCase().endsWith('jpg') ||
  //             media.path.toLowerCase().endsWith('jpeg');
  //         ref.read(attachedFile.notifier).state = AttachedFile(
  //             media, isImage ? MessageType.IMAGE : MessageType.VIDEO);
  //       }
  //       break;
  //     // ;
  //     case AttachType.audio:
  //       FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: ['aac', 'mp3', 'wav'],
  //       );
  //       if (result != null) {
  //         PlatformFile file = result.files.first;
  //         final Media media = Media(
  //             path: file.path!,
  //             size: (await File(file.path!).length()).toDouble());
  //         ref.read(attachedFile.notifier).state =
  //             AttachedFile(media, MessageType.VOICE);
  //       }
  //       // fileExts = ['aac', 'mp3', 'wav'];
  //       break;
  //     case AttachType.docs:
  //       FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: ['pdf', 'doc', 'txt'],
  //       );
  //       if (result != null) {
  //         PlatformFile file = result.files.first;
  //         final Media media = Media(
  //             path: file.path!,
  //             size: (await File(file.path!).length()).toDouble());
  //         ref.read(attachedFile.notifier).state =
  //             AttachedFile(media, MessageType.FILE);
  //       }
  //       // docPaths = await DocumentsPicker.pickDocuments;
  //       // fileExts = ['txt', 'pdf', 'doc', 'docx', 'ppt', 'xls'];
  //       break;
  //   }
  // }

  Widget _buildMessageList(WidgetRef ref) {
    final chatList =
        ref.watch(bChatMessagesProvider(model)); //.reversed.toList();
    final selectedItems = ref.watch(selectedChatMessageListProvider);

    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
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
        bool isSelected = selectedItems.contains(message);

        bool isOwnMessage = message.msg.from != model.id;
        isOwnMessage ? _markOwnRead(message.msg) : _markRead(message.msg);

        bool notReply = message.msg.body.type == MessageType.CMD ||
            message.msg.body.type == MessageType.CUSTOM;
        // print('notReply -> $notReply , type=> ${message.chatType} ');

        int progress = 0;
        if (isOwnMessage) {
          progress = ref.watch(sendingFileProgress(message.msg.msgId));
        }

        return Column(
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
            SwipeTo(
              rightSwipeWidget: const SizedBox.shrink(),
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
                    _onMessageLongPress(message.msg, isSelected, ref),
                onTap: () => selectedItems.isNotEmpty
                    ? _onMessageTapSelect(message.msg, isSelected, ref)
                    : notReply
                        ? null
                        : _onMessageTap(message.msg, context, ref),
                child: Container(
                  margin: const EdgeInsets.only(top: 2, bottom: 4),
                  width: double.infinity,
                  color: isSelected ? Colors.grey.shade200 : Colors.transparent,
                  child: ChatMessageBubbleExt(
                      message: message,
                      isOwnMessage: isOwnMessage,
                      senderUser: isOwnMessage ? _me : model.contact,
                      isPreviousSameAuthor: isPreviousSameAuthor,
                      isNextSameAuthor: isNextSameAuthor,
                      isAfterDateSeparator: isAfterDateSeparator,
                      isBeforeDateSeparator: isBeforeDateSeparator,
                      progress: progress),
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

  _onMessageTap(
      ChatMessage message, BuildContext context, WidgetRef ref) async {
    // if (message.body.type == MessageType.IMAGE) {
    //   //open image
    //   showImageViewer(
    //       context,
    //       getImageProviderChatImage(message.body as ChatImageMessageBody,
    //           loadThumbFirst: false), onViewerDismissed: () {
    //     // print("dismissed");
    //   });

    //   // Navigator.pushNamed(context, RouteList.bViewImage,
    //   //     arguments: message.body as ChatImageMessageBody);
    // } else if (message.body.type == MessageType.VIDEO) {
    //   Navigator.pushNamed(context, RouteList.bViewVideo,
    //       arguments: message.body as ChatVideoMessageBody);
    // } else if (message.body.type == MessageType.FILE) {
    // } else
    {
      final action = await showMessageMenu(context, message);
      if (action == 0) {
        //Copy
        // AppSnackbar.instance.message(context, 'Need to implement');
        copyToClipboard([message]);
      } else if (action == 1) {
        //Forward
        // AppSnackbar.instance.message(context, 'Need to implement');
        await showForwardList(context, [message], model.id);
      } else if (action == 2) {
        //Reply
        bool isOwnMessage = message.from != model.id;
        ref.read(chatModelProvider.notifier).setReplyOn(message,
            isOwnMessage ? S.current.chat_yourself : model.contact.name);
      } else if (action == 3) {
        //Delete
        ref
            .read(bChatMessagesProvider(model).notifier)
            .deleteMessages([message]);
      }
    }
  }

  _onMessageTapSelect(ChatMessage message, bool selected, WidgetRef ref) {
    if (selected) {
      ref.read(selectedChatMessageListProvider.notifier).remove(message);
    } else {
      ref.read(selectedChatMessageListProvider.notifier).addChat(message);
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
      msg.setMessageStatusCallBack(
        MessageStatusCallBack(
          onSuccess: () {
            if (isFile) {
              // hideLoading(ref);
              ref.read(sendingFileProgress(msg.msgId).notifier).state = 0;
            }

            // FCMApiService.instance.sendChatPush(
            //     msg, 'toToken', _myUserId, _me!.name, NotificationType.chat);
            // Occurs when the message sending succeeds. You can update the message and add other operations in this callback.
          },
          onError: (error) {
            if (isFile) {
              // hideLoading(ref);
              ref.read(sendingFileProgress(msg.msgId).notifier).state = 0;
            }
            BuildContext? cntx = navigatorKey.currentContext;
            if (cntx != null) {
              AppSnackbar.instance.error(cntx, error.description);
            }
            // Occurs when the message sending fails. You can update the message status and add other operations in this callback.
          },
          onProgress: (progress) {
            if (isFile) {
              // showLoading(ref);
              ref.read(sendingFileProgress(msg.msgId).notifier).state =
                  progress;
            }

            // For attachment messages such as image, voice, file, and video, you can get a progress value for uploading or downloading them in this callback.
          },
        ),
      );
      // final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
      final chat = await ref
          .read(bChatMessagesProvider(model).notifier)
          .sendMessage(msg);

      if (chat != null) {
        // print('post:msgId ${chat.msgId}');
        ref.read(chatConversationProvider.notifier).addConversationMessage(msg);
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
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
              radius: 4.w, model.contact.name, model.contact.profileImage),
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
                    bool isOwnMessage = message.from != model.id;
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
                              parseChatPresenceToReadable(
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
            IconButton(
              onPressed: () async {
                final msg = await makeAudioCall(model.contact, ref, context);
                if (msg != null) {
                  ref.read(bChatMessagesProvider(model).notifier).addChat(msg);
                }
                setScreen(RouteList.chatScreen);
              },
              icon: getSvgIcon(
                'icon_audio_call.svg',
                width: 6.w,
              ),
            ),
            SizedBox(width: 2.w),
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
                  ref.read(bChatMessagesProvider(model).notifier).addChat(msg);
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
      await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
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

Future<AttachedFile> getMediaFile(ipp.SelectedByte f) async {
  File file = f.selectedFile;
  bool isImage = file.path.toLowerCase().endsWith('png') ||
      file.path.toLowerCase().endsWith('jpg') ||
      file.path.toLowerCase().endsWith('jpeg');
  if (isImage) {
    final Media media = Media(
        path: file.absolute.path,
        size: (await file.length()),
        thumbPath: file.absolute.path);
    // files.add(AttachedFile(media, MessageType.IMAGE));
    return AttachedFile(media, MessageType.IMAGE);
    // ref.read(attachedFile.notifier).state =
    //     AttachedFile(media, MessageType.IMAGE);
  } else {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: Directory.systemTemp.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    final Media media = Media(
        path: file.absolute.path,
        size: (await file.length()),
        thumbPath: thumb);
    // files.add(AttachedFile(media, MessageType.VIDEO));
    return AttachedFile(media, MessageType.VIDEO);
  }
}
