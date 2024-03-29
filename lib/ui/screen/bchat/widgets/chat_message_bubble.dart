import 'dart:convert';
// import 'dart:io';
import 'dart:math';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/utils/file_utils.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter_file_preview/flutter_file_preview.dart';

import 'package:linkable/linkable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '/core/helpers/call_helper.dart';
import '/data/models/call_message_body.dart';
import '/data/models/contact_model.dart';
import '../models/reply_model.dart';
import '/ui/widgets.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '../dash/models/mention.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;

  final Contacts senderUser;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;
  final bool isNextSameAuthor;
  final bool isPreviousSameAuthor;
  final bool showOtherUserName;
  final int progress;
  // final bool showAvatar;

  final Function(Mention)? onPressMention;
  const ChatMessageBubble(
      {Key? key,
      required this.message,
      required this.senderUser,
      required this.isOwnMessage,
      required this.isPreviousSameAuthor,
      required this.isNextSameAuthor,
      this.isAfterDateSeparator = false,
      this.isBeforeDateSeparator = false,
      this.showOtherUserName = false,
      // this.showAvatar = false,
      this.progress = 0,
      this.onPressMention})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: isOwnMessage ? 0 : 4.w,
          right: isOwnMessage ? 4.w : 0,
          top: isPreviousSameAuthor ? 2 : 1.h,
          bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // if (!isOwnMessage && (!isPreviousSameAuthor || isBeforeDateSeparator))
          // getCicleAvatar(
          //     radius: 6.w,
          //     senderUser.nickName ?? senderUser.userId,
          //     senderUser.avatarUrl ?? ''),
          if (showOtherUserName)
            Opacity(
              opacity: !isOwnMessage &&
                      (!isPreviousSameAuthor || isBeforeDateSeparator)
                  ? 1
                  : 0,
              child: getCicleAvatar(
                  radius: 6.w,
                  senderUser.name,
                  senderUser.profileImage,
                  cacheWidth: (75.w * devicePixelRatio).round(),
                  cacheHeight: (75.w * devicePixelRatio).round()),
            ),
          Column(
            crossAxisAlignment: isOwnMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isPreviousSameAuthor || isBeforeDateSeparator)
                SizedBox(height: 1.2.h),
              if (showOtherUserName &&
                  !isOwnMessage &&
                  (!isPreviousSameAuthor || isAfterDateSeparator))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    senderUser.name,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 7.sp,
                        color: Colors.grey),
                  ),
                ),
              _buildMessageBody(context)
            ],
          ),
          // if (isOwnMessage && !isPreviousSameAuthor)

          // if (showOtherUserName)
          //   Opacity(
          //     opacity: isOwnMessage && !isPreviousSameAuthor ? 1 : 0,
          //     child: getCicleAvatar(
          //         radius: 6.w, senderUser.name, senderUser.profileImage),
          //   ),
        ],
      ),
    );
  }

  Widget _buildMessageBody(BuildContext context) {
    // print("inside build message body ${message.body.type}");

    switch (message.body.type) {
      case MessageType.TXT:
        {
          ChatTextMessageBody body = message.body as ChatTextMessageBody;
          return _buildTextMessage(body);
        }

      case MessageType.IMAGE:
        {
          ChatImageMessageBody body = message.body as ChatImageMessageBody;
          return GestureDetector(
              onTap: () {
                showImageViewer(
                    context,
                    getImageProviderChatImage(
                        message.body as ChatImageMessageBody,
                        loadThumbFirst: false), onViewerDismissed: () {
                  // print("dismissed");
                });
              },
              child: _imageOnly(body));
        }
      case MessageType.VIDEO:
        {
          ChatVideoMessageBody body = message.body as ChatVideoMessageBody;
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteList.bViewVideo,
                    arguments: message.body as ChatVideoMessageBody);
              },
              child: _videoOnly(body));
        }
      case MessageType.CUSTOM:
        ChatCustomMessageBody body = message.body as ChatCustomMessageBody;
        if (message.chatType == ChatType.GroupChat) {
          try {
            // print('JSON=> ${body.event}');
            final callBody =
                GroupCallMessegeBody.fromJson(jsonDecode(body.event));

            return _callBody(callBody.callType);
          } catch (e) {
            // print('Error Grp=> $e');
            break;
          }
        } else if (message.chatType == ChatType.Chat) {
          try {
            final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));

            return _callBody(callBody.callType);
          } catch (e) {
            break;
          }
        } else {
          break;
        }

      case MessageType.FILE:
        ChatFileMessageBody body = message.body as ChatFileMessageBody;
        return GestureDetector(
            onTap: () async {
              handleChatFileOption(context, body, isOwnMessage);
            },
            child: _fileTypeBody(body));
      case MessageType.VOICE:
        ChatVoiceMessageBody body = message.body as ChatVoiceMessageBody;

        return _fileTypeBodyVoice(body);
      default:
      // return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
    // return message.body.type == MessageType.TXT ? _onlyText() : _imageOnly(me);
  }

  Widget _callBody(CallType callType) {
    String content =
        '${isOwnMessage ? 'Outgoing' : 'Incoming'} ${callType == CallType.video ? 'Video Call' : 'Audio call'}';

    return Container(
      constraints: BoxConstraints(
        minWidth: 30.w,
        maxWidth: 60.w,
        minHeight: 5.h,
        maxHeight: 30.h,
      ),
      // height: 10.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),

      decoration: _buildDecoration(),
      margin: isOwnMessage
          ? EdgeInsets.only(right: 2.w)
          : EdgeInsets.only(left: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getSvgIcon(
                callType == CallType.video
                    ? 'icon_vcall.svg'
                    : 'icon_acall.svg',
                width: 4.w,
                // color: Colors.white,
              ),
              SizedBox(width: 2.w),
              _textCallMessage(content)
            ],
          ),
          Container(
              width: 18.w,
              alignment: Alignment.topRight,
              child: Text(
                DateFormat('h:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(message.serverTime)),
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 8.sp,
                  color: isOwnMessage
                      ? AppColors.chatBoxTimeMine
                      : AppColors.chatBoxTimeOthers,
                ),
              )),
        ],
      ),
    );
  }

  Widget _imageOnly(ChatImageMessageBody body) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 30.w,
        maxWidth: 60.w,
        minHeight: 5.h,
        maxHeight: 30.h,
      ),
      margin: isOwnMessage
          ? EdgeInsets.only(right: 2.w)
          : EdgeInsets.only(left: 2.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: Image(
              image: getImageProviderChatImage(body),
            ),
          ),
          Positioned(
            right: 2.w,
            bottom: 1.h,
            child: _buildTime(),
          ),
          if (progress > 0)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Center(
                  child: CircularProgressIndicator(
                value: progress.toDouble(),
                backgroundColor: Colors.transparent,
                color: AppColors.primaryColor,
              )),
            )

          // Center(child: CircularProgressIndicator(value: progress.toDouble()))
        ],
      ),
    );
  }

  Widget _videoOnly(ChatVideoMessageBody body) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Container(
      constraints: BoxConstraints(
        minWidth: 30.w,
        maxWidth: 60.w,
        minHeight: 5.h,
        maxHeight: 30.h,
      ),
      margin: isOwnMessage
          ? EdgeInsets.only(right: 2.w)
          : EdgeInsets.only(left: 2.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: Image(
              image: getImageProviderChatVideo(body),
            ),
          ),
          Positioned(
            right: 2.w,
            bottom: 1.h,
            child: _buildTime(),
          ),
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
            ),
          ),
          if (progress > 0)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.toDouble(),
                  backgroundColor: Colors.transparent,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          // Center(child: CircularProgressIndicator(value: progress.toDouble()))
        ],
      ),
    );
  }

  // _onlyText() {
  //   // return mine ? _textMessageMy() : _textMessageOther();
  // }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
        color: isOwnMessage
            ? AppColors.chatBoxBackgroundMine
            : AppColors.chatBoxBackgroundOthers,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              !isOwnMessage && !isPreviousSameAuthor ? 0.0 : 3.w),
          topRight: Radius.circular(
              isOwnMessage && !isPreviousSameAuthor ? 0.0 : 3.w),
          bottomLeft: Radius.circular(3.w),
          bottomRight: Radius.circular(3.w),
        ));
  }

  BoxDecoration _buildDecorationMine() {
    return BoxDecoration(
        color: isOwnMessage
            ? AppColors.chatBoxBackgroundMine
            : AppColors.chatBoxBackgroundOthers,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              !isPreviousSameAuthor && !isOwnMessage && !isAfterDateSeparator
                  ? 0.0
                  : 5.w),
          topRight: Radius.circular(
              !isPreviousSameAuthor && isOwnMessage && !isAfterDateSeparator
                  ? 0.0
                  : 5.w),
          bottomLeft: Radius.circular(
              !isOwnMessage && !isBeforeDateSeparator && !isNextSameAuthor
                  ? 0.0
                  : 5.w),
          bottomRight: Radius.circular(
              isOwnMessage && !isBeforeDateSeparator && !isNextSameAuthor
                  ? 0.0
                  : 5.w),
        ));
  }

  // textBubbleDecoration() => BoxDecoration(
  //       color: mine
  //           ? AppColors.chatBoxBackgroundMine
  //           : AppColors.chatBoxBackgroundOthers,
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(5.w),
  //         bottomRight: Radius.circular(5.w),
  //         topRight: mine ? Radius.zero : Radius.circular(5.w),
  //         topLeft: mine ? Radius.circular(5.w) : Radius.zero,
  //       ),
  //     );

  replyTextBubbleDecoration() => BoxDecoration(
        color: isOwnMessage
            ? AppColors.chatBoxBackgroundOthers
            : AppColors.chatBoxBackgroundMine,
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
      );

  Widget _buildTextMessage(ChatTextMessageBody body) {
    bool hasReply = message.attributes?.keys.contains('reply_of') ?? false;
    bool isSingleEmojiText = isLessEmojisThan(body.content, 2);
    return Container(
      constraints: BoxConstraints(
        minWidth: 20.w,
        maxWidth: 60.w,
      ),
      margin: EdgeInsets.only(
          left: isOwnMessage ? 0 : 2.w, right: isOwnMessage ? 2.w : 0),
      decoration: _buildDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasReply) _replyText(),
          // if(body.content)
          Row(
            mainAxisSize: hasReply ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(child: _textMessage(body.content, isSingleEmojiText)),
              // Flexible(
              //     child: Wrap(
              //   alignment: WrapAlignment.start,
              //   children: getMessage(body.content),
              // )),
              // const Spacer(),
              SizedBox(width: body.content.length < 6 ? 8.w : 2.w)
            ],
          ),
          _buildTime(),
        ],
      ),
    );
  }

  Widget _replyText() {
    final replyMap = message.attributes?['reply_of'];
    // print('Reply : ${jsonEncode(replyMap)}');
    final replyOf = ReplyModel.fromJson(replyMap);
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: replyTextBubbleDecoration(),
      // padding: const EdgeInsets.all(0.1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              // constraints: BoxConstraints(
              //   minWidth: 30.w,
              //   maxWidth: 50.w,
              // ),
              width: 50.w,
              decoration: BoxDecoration(
                color: isOwnMessage
                    ? const Color(0xFF6F3253)
                    : const Color.fromARGB(255, 248, 213, 131),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(3.w),
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(3.w),
                  topLeft: Radius.zero,
                ),
              ),
              margin: EdgeInsets.only(left: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    replyOf.fromName,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: isOwnMessage
                            ? AppColors.chatBoxBackgroundOthers
                            : AppColors.chatBoxBackgroundMine,
                        fontSize: 7.sp),
                  ),
                  ChatMessageBodyWidget(
                      message: replyOf.message, isOwnMessage: isOwnMessage)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // _replyImageContent(String image) {
  //   return Container(
  //     constraints: BoxConstraints(
  //       minWidth: 30.w,
  //       maxWidth: 50.w,
  //     ),
  //     margin: mine ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.all(Radius.circular(3.w)),
  //       child: Image(
  //         image: NetworkImage(image),
  //       ),
  //     ),
  //   );
  // }

  // _textUserName() {
  //   return Expanded(
  //     child: Text(
  //       'Saurabh',
  //       style: TextStyle(
  //         fontFamily: kFontFamily,
  //         fontSize: 10.sp,
  //         color: mine ? AppColors.yellowAccent : AppColors.primaryColor,
  //         fontWeight: FontWeight.w300,
  //       ),
  //     ),
  //   );
  // }

  getFileSize(int? bytes, int decimals) {
    if (bytes == null) {
      return '';
    }
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Widget _fileTypeBody(ChatFileMessageBody body) {
    bool hasReply = message.attributes?.keys.contains('reply_of') ?? false;
    String fileName = body.displayName ?? '';
    String size = '';
    Widget fileWidget = Icon(
      Icons.file_copy,
      color: Colors.white,
      size: 25.w,
    );
    if (fileName.contains('.')) {
      String fileType = fileName.split('.').last;
      size = getFileSize(body.fileSize, 1);
      // print('File type $fileType  ${getFileSize(body.fileSize, 1)}');
      switch (fileType) {
        case 'pdf':
          fileWidget =
              getSvgIcon('icon_file_pdf.svg', width: 25.w, color: Colors.white);
          break;
        case 'doc':
        case 'docx':
          fileWidget =
              getSvgIcon('icon_file_doc.svg', width: 25.w, color: Colors.white);
          break;
        case 'txt':
          fileWidget = getSvgIcon('icon_file_txt-file.svg',
              width: 25.w, color: Colors.white);
          break;
      }
    }
    return Container(
      constraints: BoxConstraints(
        minWidth: 20.w,
        maxWidth: 50.w,
      ),
      margin: EdgeInsets.only(
          left: isOwnMessage ? 0 : 2.w, right: isOwnMessage ? 2.w : 0),
      decoration: _buildDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasReply) _replyText(),
          Container(
            // width: 33.w,
            // height: 33.w,
            padding: EdgeInsets.all(4.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: !isOwnMessage
                  ? const Color(0xFF6F3253)
                  : const Color.fromARGB(255, 248, 213, 131),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(child: fileWidget),
          ),
          Row(
            mainAxisSize: hasReply ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(child: _textCallMessage(fileName)),
              // Flexible(
              //     child: Wrap(
              //   alignment: WrapAlignment.start,
              //   children: getMessage(body.content),
              // )),
              // const Spacer(),
              SizedBox(width: 3.w)
            ],
          ),
          SizedBox(height: 1.w),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Size $size',
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 8.sp,
                    color: isOwnMessage
                        ? AppColors.chatBoxMessageMine
                        : AppColors.chatBoxMessageOthers,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildTime(),
            ],
          )
          // Container(
          //   width: 20.w,
          //   alignment: Alignment.centerRight,
          //   child: _buildTime(),
          // )
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [const Spacer(), _buildTime()],
          // )

          // Align(alignment: Alignment.bottomRight, child: _buildTime())
        ],
      ),
    );
  }

  Widget _fileTypeBodyVoice(ChatVoiceMessageBody body) {
    // bool hasReply = message.attributes?.keys.contains('reply_of') ?? false;
    // String fileName = body.displayName ?? '';
    // String size = '';
    // Widget fileWidget =
    //     getSvgIcon('icon_chat_audio.svg', width: 25.w, color: Colors.white);

    // if (fileName.contains('.')) {
    //   size = getFileSize(body.fileSize, 1);
    // }
    return Container(
      decoration: _buildDecoration(),
      margin: EdgeInsets.only(
          left: isOwnMessage ? 0 : 2.w, right: isOwnMessage ? 2.w : 0),
      padding: EdgeInsets.only(right: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          VoiceMessage(
            contactBgColor: AppColors.chatBoxBackgroundOthers,
            meBgColor: AppColors.chatBoxBackgroundMine,
            contactFgColor: AppColors.chatBoxMessageOthers,
            contactPlayIconColor: Colors.white,
            meFgColor: AppColors.chatBoxMessageMine,
            audioSrc: isOwnMessage ? body.localPath : body.remotePath ?? "",
            me: isOwnMessage,
          ),
          _buildTime(),
          SizedBox(height: 2.w)
        ],
      ),
    );
    // Container(
    //   constraints: BoxConstraints(minWidth: 20.w, maxWidth: 60.w),
    //   margin: EdgeInsets.only(
    //       left: isOwnMessage ? 0 : 2.w, right: isOwnMessage ? 2.w : 0),
    //   decoration: _buildDecoration(),
    //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       if (hasReply) _replyText(),

    //       // Container(
    //       //   // width: 33.w,
    //       //   // height: 33.w,
    //       //   padding: EdgeInsets.all(4.w),
    //       //   alignment: Alignment.center,
    //       //   decoration: BoxDecoration(
    //       //     color: !isOwnMessage
    //       //         ? const Color(0xFF6F3253)
    //       //         : const Color.fromARGB(255, 248, 213, 131),
    //       //     borderRadius: BorderRadius.circular(2.w),
    //       //   ),
    //       //   child: Center(child: fileWidget),
    //       // ),
    //       Row(
    //         mainAxisSize: hasReply ? MainAxisSize.max : MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           Flexible(child: _textMessage(fileName, false)),
    //           // Flexible(
    //           //     child: Wrap(
    //           //   alignment: WrapAlignment.start,
    //           //   children: getMessage(body.content),
    //           // )),
    //           // const Spacer(),
    //           SizedBox(width: 3.w)
    //         ],
    //       ),
    //       SizedBox(height: 1.w),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Text(
    //               'Size $size',
    //               style: TextStyle(
    //                 fontFamily: kFontFamily,
    //                 fontSize: 8.sp,
    //                 color: isOwnMessage
    //                     ? AppColors.chatBoxMessageMine
    //                     : AppColors.chatBoxMessageOthers,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ),
    //           _buildTime(),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _textCallMessage(String content) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Text(
      content,
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 10.sp,
        color: isOwnMessage
            ? AppColors.chatBoxMessageMine
            : AppColors.chatBoxMessageOthers,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _textMessage(String content, bool isOnlyEmoji) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Linkable(
      text: content,
      textColor: isOwnMessage
          ? AppColors.chatBoxMessageMine
          : AppColors.chatBoxMessageOthers,
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: isOnlyEmoji ? 30.sp : 10.sp,
        color: isOwnMessage
            ? AppColors.chatBoxMessageMine
            : AppColors.chatBoxMessageOthers,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildTime() {
    // final bool isOwnMessage = message.from == currentUser.id;
    bool showTick =
        (isOwnMessage && (message.hasReadAck || message.hasDeliverAck));
    return showTick
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('h:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(message.serverTime)),
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 8.sp,
                  color: isOwnMessage
                      ? AppColors.chatBoxTimeMine
                      : AppColors.chatBoxTimeOthers,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                message.hasReadAck ? Icons.done_all : Icons.done,
                color: Colors.white,
                size: 4.w,
              )
            ],
          )
        : Text(
            DateFormat('h:mm a').format(
                DateTime.fromMillisecondsSinceEpoch(message.serverTime)),
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 8.sp,
              color: isOwnMessage
                  ? AppColors.chatBoxTimeMine
                  : AppColors.chatBoxTimeOthers,
            ),
          );
  }

  bool isOnlyEmojis(String text) {
    // find all emojis
    final emojis = emojisRegExp.allMatches(text);

    // return if none found
    if (emojis.isEmpty) return false;

    // remove all emojis from the this
    for (final emoji in emojis) {
      text = text.replaceAll(emoji.input.substring(emoji.start, emoji.end), "");
    }

    // remove all whitespace (optional)
    text = text.replaceAll(" ", "");

    // return true if nothing else left
    return text.isEmpty;
  }

  /// True if the string is only emojis and the number of emojis is less than [maxEmojis]
  bool isLessEmojisThan(String text, int maxEmojis) {
    final allEmojis = emojisRegExp.allMatches(text);
    final numEmojis = allEmojis.length;

    if (numEmojis < maxEmojis && isOnlyEmojis(text)) {
      return true;
    }

    return false;
  }

  List<Widget> getMessage(String content) {
    List<Mention>? mentions = message.attributes?['mentions'];
    if (mentions != null && mentions.isNotEmpty) {
      String stringRegex = r'([\s\S]*)';
      String stringMentionRegex = '';
      for (final Mention mention in mentions) {
        stringRegex += '(${mention.title})' r'([\s\S]*)';
        stringMentionRegex += stringMentionRegex.isEmpty
            ? '(${mention.title})'
            : '|(${mention.title})';
      }
      final RegExp mentionRegex = RegExp(stringMentionRegex);
      final RegExp regexp = RegExp(stringRegex);

      RegExpMatch? match = regexp.firstMatch(content);
      if (match != null) {
        List<Widget> res = <Widget>[];
        match
            .groups(List<int>.generate(match.groupCount, (int i) => i + 1))
            .forEach((String? part) {
          if (mentionRegex.hasMatch(part!)) {
            Mention mention = mentions.firstWhere(
              (Mention m) => m.title == part,
            );
            res.add(getMention(mention));
          } else {
            res.add(getParsePattern(part));
          }
        });
        if (res.isNotEmpty) {
          return res;
        }
      }
    }
    return <Widget>[getParsePattern(content)];
  }

  Widget getParsePattern(String text) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return ParsedText(
      parse: defaultPersePatterns,
      text: text,
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 10.sp,
        color: isOwnMessage
            ? AppColors.chatBoxMessageMine
            : AppColors.chatBoxMessageOthers,
      ),
    );
  }

  Widget getMention(Mention mention) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return RichText(
      text: TextSpan(
        text: mention.title,
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => onPressMention != null ? onPressMention!(mention) : null,
        style: TextStyle(
          fontSize: 10.sp,
          color: isOwnMessage
              ? AppColors.chatBoxMessageMine
              : AppColors.chatBoxMessageOthers,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

final List<MatchText> defaultPersePatterns = <MatchText>[
  MatchText(
    type: ParsedType.URL,
    style: const TextStyle(
      decoration: TextDecoration.underline,
    ),
    onTap: (String url) {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'http://$url';
      }
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    },
  ),
];
final emojisRegExp = RegExp(
    r"(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])");
