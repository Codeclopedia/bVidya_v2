import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/ui_core.dart';
import '/core/constants/colors.dart';
import '../screen/bchat/models/reply_model.dart';

class ChatReplyBodyContent extends StatelessWidget {
  final ReplyModel replyOf;
  final bool isOwnMessage;
  final Function() onClose;

  const ChatReplyBodyContent(
      {Key? key,
      required this.replyOf,
      required this.isOwnMessage,
      required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                S.current.chat_replying(
                    isOwnMessage ? S.current.chat_yourself : replyOf.fromName),
                // 'Replying to ${replyOf.fromName}',
                style: textStyleWhite,
              ),
              InkWell(
                onTap: () {
                  onClose();
                },
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
              constraints: BoxConstraints(minHeight: 5.h, maxHeight: 10.h),
              decoration: BoxDecoration(
                color: AppColors.chatBoxBackgroundOthers,
                borderRadius: BorderRadius.all(Radius.circular(3.w)),
              ),
              padding: EdgeInsets.all(1.w),
              child: _buildBodyContent()
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

  Widget _buildFileBody(String fileName) {
    // String fileName = body.displayName ?? '';
    Widget fileWidget = getSvgIcon('icon_chat_audio.svg',
        width: 8.w,
        color: isOwnMessage
            ? AppColors.chatBoxMessageMine
            : AppColors.primaryColor);
    if (fileName.contains('.')) {
      String fileType = fileName.split('.').last;

      switch (fileType) {
        case 'pdf':
          fileWidget = getSvgIcon('icon_file_pdf.svg',
              width: 8.w,
              color: isOwnMessage
                  ? AppColors.chatBoxMessageMine
                  : AppColors.primaryColor);
          break;
        case 'doc':
        case 'docx':
          fileWidget = getSvgIcon('icon_file_doc.svg',
              width: 8.w,
              color: isOwnMessage
                  ? AppColors.chatBoxMessageMine
                  : AppColors.primaryColor);
          break;
        case 'txt':
          fileWidget = getSvgIcon('icon_file_txt-file.svg',
              width: 8.w,
              color: isOwnMessage
                  ? AppColors.chatBoxMessageMine
                  : AppColors.primaryColor);
          break;
      }
    }
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          fileWidget,
          SizedBox(width: 2.w),
          // Expanded(
          //   child: Text(
          //     body.displayName ?? 'File',
          //     style: TextStyle(
          //       fontFamily: kFontFamily,
          //       fontSize: 10.sp,
          //       color: isOwnMessage
          //           ? AppColors.chatBoxMessageMine
          //           : AppColors.chatBoxMessageOthers,
          //       fontWeight: FontWeight.w300,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (replyOf.message.body.type) {
      case MessageType.TXT:
        return _buildTextMessage(replyOf.message.body as ChatTextMessageBody);
      case MessageType.IMAGE:
        final body = replyOf.message.body as ChatImageMessageBody;
        return _buildMediaMessage(
          body.displayName ?? 'Photo',
          'Photo',
          Image(
            image: getImageProviderChatImage(body),
            fit: BoxFit.cover,
          ),
        );
      case MessageType.VIDEO:
        final body = replyOf.message.body as ChatVideoMessageBody;
        return _buildMediaMessage(
          body.displayName ?? 'Video',
          'Video',
          Image(
            image: getImageProviderChatVideo(body),
            fit: BoxFit.cover,
          ),
        );
      case MessageType.FILE:
        final body = replyOf.message.body as ChatFileMessageBody;
        return _buildMediaMessage(body.displayName ?? 'File', 'File',
            _buildFileBody(body.displayName ?? 'File'));
      case MessageType.VOICE:
        final body = replyOf.message.body as ChatVoiceMessageBody;
        return _buildMediaMessage(body.displayName ?? 'Voice', 'Voice',
            _buildFileBody(body.displayName ?? 'Voice'));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMediaMessage(String fileName, String typeName, Widget item) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                typeName,
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 11.sp,
                    fontFamily: kFontFamily,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Icon(
                    Icons.image,
                    size: 4.w,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: kFontFamily,
                          color: AppColors.primaryColor,
                          fontSize: 10.sp),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          width: 20.w,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: item,
          ),
        ),
        // IconButton(
        //   onPressed: () {
        //     ref.read(attachedFile.notifier).state = null;
        //   },
        //   icon: const Icon(Icons.close, color: Colors.red),
        // )
      ],
    );
  }

  Widget _buildTextMessage(ChatTextMessageBody body) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            body.content,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 10.sp,
              color: AppColors.chatBoxMessageOthers,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(width: 8.w)
      ],
    );
  }
}
