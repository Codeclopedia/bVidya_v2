import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class ChatMessageBodyWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;

  const ChatMessageBodyWidget(
      {super.key, required this.message, this.isOwnMessage = false});

  @override
  Widget build(BuildContext context) {
    return _buildMessageBody();
  }

  Widget _buildMessageBody() {
    switch (message.body.type) {
      case MessageType.TXT:
        {
          ChatTextMessageBody body = message.body as ChatTextMessageBody;
          return Padding(
              padding: EdgeInsets.all(1.w), child: _buildTextMessage(body));
        }
      case MessageType.IMAGE:
        {
          ChatImageMessageBody body = message.body as ChatImageMessageBody;
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: Image(
              image: getImageProviderChatImage(body),
              fit: BoxFit.cover,
            ),
          );
        }
      case MessageType.VIDEO:
        {
          ChatVideoMessageBody body = message.body as ChatVideoMessageBody;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3.w)),
                child: Image(image: getImageProviderChatVideo(body)
                    // NetworkImage(body.thumbnailRemotePath ??
                    //     'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg'),
                    ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
      case MessageType.FILE:
        ChatFileMessageBody body = message.body as ChatFileMessageBody;
        String fileName = body.displayName ?? '';
        Widget fileWidget = Icon(
          Icons.file_copy,
          color: Colors.white,
          size: 8.w,
        );
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
              Expanded(child: _textMessage(body.displayName ?? 'File')),
            ],
          ),
        );
      case MessageType.VOICE:
        ChatVoiceMessageBody body = message.body as ChatVoiceMessageBody;
        return Padding(
          padding: EdgeInsets.all(2.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getSvgIcon('icon_chat_audio.svg',
                  width: 8.w,
                  color: isOwnMessage
                      ? AppColors.chatBoxMessageMine
                      : AppColors.primaryColor),
              SizedBox(width: 2.w),
              Expanded(child: _textMessage(body.displayName ?? 'Audio file')),
            ],
          ),
        );

      default:
      // return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
    // return message.body.type == MessageType.TXT ? _onlyText() : _imageOnly(me);
  }

  Widget _buildTextMessage(ChatTextMessageBody body) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: _textMessage(body.content),
        ),
        SizedBox(width: 8.w)
      ],
    );
  }

  Widget _textMessage(String content) {
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
}
