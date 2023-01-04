import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class ChatMessageBodyWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;

  const ChatMessageBodyWidget(
      {super.key, required this.message, this.isOwnMessage = true});

  @override
  Widget build(BuildContext context) {
    return _buildMessageBody();
  }

  Widget _buildMessageBody() {
    switch (message.body.type) {
      case MessageType.TXT:
        {
          ChatTextMessageBody body = message.body as ChatTextMessageBody;
          return _buildTextMessage(body);
        }
      case MessageType.IMAGE:
        {
          ChatImageMessageBody body = message.body as ChatImageMessageBody;
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: Image(
              image: NetworkImage(body.remotePath ??
                  'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg'),
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
                child: Image(
                  image: NetworkImage(body.thumbnailRemotePath ??
                      'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg'),
                ),
              )
            ],
          );
        }
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
