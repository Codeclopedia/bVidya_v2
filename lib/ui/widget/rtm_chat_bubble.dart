import 'package:agora_rtm/agora_rtm.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/ui_core.dart';

class RTMChatMessageBubble extends StatelessWidget {
  final AgoraRtmMessage message;
  final bool isOwnMessage;

  final AgoraRtmMember senderUser;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;
  final bool isNextSameAuthor;
  final bool isPreviousSameAuthor;
  // final bool showOtherUserName;

  const RTMChatMessageBubble({
    Key? key,
    required this.message,
    required this.senderUser,
    required this.isOwnMessage,
    required this.isPreviousSameAuthor,
    required this.isNextSameAuthor,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    // this.showOtherUserName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: isOwnMessage ? 0 : 4.w,
          right: isOwnMessage ? 4.w : 0,
          top: isPreviousSameAuthor ? 4 : 1.h),
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
          // Opacity(
          //   opacity: !isOwnMessage &&
          //           (!isPreviousSameAuthor || isBeforeDateSeparator)
          //       ? 1
          //       : 0,
          //   child: getCicleAvatar(
          //       radius: 6.w,
          //       senderUser.userId,
          //       senderUser.avatarUrl ?? ''),
          // ),
          Column(
            crossAxisAlignment: isOwnMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isPreviousSameAuthor || isBeforeDateSeparator)
                SizedBox(height: 1.5.h),
              if (!isOwnMessage &&
                  (!isPreviousSameAuthor || isAfterDateSeparator))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    senderUser.userId,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              _buildTextMessage()
            ],
          ),
          // if (isOwnMessage && !isPreviousSameAuthor)
          // getCicleAvatar(
          //     radius: 6.w,
          //     senderUser.nickName ?? senderUser.userId,
          //     senderUser.avatarUrl ?? '')
          // Opacity(
          //   opacity: isOwnMessage && !isPreviousSameAuthor ? 1 : 0,
          //   child: getCicleAvatar(
          //       radius: 6.w,
          //       senderUser.nickName ?? senderUser.userId,
          //       senderUser.avatarUrl ?? ''),
          // ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
        color: isOwnMessage
            ? AppColors.chatBoxBackgroundMine
            : AppColors.chatBoxBackgroundOthers,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              !isOwnMessage && !isPreviousSameAuthor ? 0.0 : 5.w),
          topRight: Radius.circular(
              isOwnMessage && !isPreviousSameAuthor ? 0.0 : 5.w),
          bottomLeft: Radius.circular(5.w),
          bottomRight: Radius.circular(5.w),
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

  // replyTextBubbleDecoration() => BoxDecoration(
  //       color: mine
  //           ? AppColors.chatBoxBackgroundOthers
  //           : AppColors.chatBoxBackgroundMine,
  //       borderRadius: BorderRadius.all(Radius.circular(5.w)),
  //     );

  Widget _buildTextMessage() {
    
    return Container(
      constraints: BoxConstraints(
        minWidth: 20.w,
        maxWidth: 50.w,
      ),
      margin: EdgeInsets.only(
          left: isOwnMessage ? 0 : 2.w, right: isOwnMessage ? 2.w : 0),
      decoration: _buildDecoration(), //textBubbleDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Wrap(
              //   // alignment: WrapAlignment.start,
              //   children: getMessage(body.content),
              // ),
              _textMessage(message.text),
              SizedBox(width: 8.w)
              // Expanded(
              //   //   // child: _textMessage(body.content),
              //   child: Wrap(
              //     children: getMessage(body.content),
              //   ),
              // ),
            ],
          ),
          _buildTime()
        ],
      ),

      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   // mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     // if (replyOf != null) _replyText(),
      //     Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         // Expanded(
      //         //   child: Wrap(
      //         //     children: getMessage(body.content),
      //         //   ),
      //         // ),
      //         _textMessage(body.content),
      //         SizedBox(
      //           width: 6.w,
      //         )
      //       ],
      //     ),
      //     _buildTime(),
      //   ],
      // ),
    );
  }


  Widget _textMessage(String content) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Expanded(
      child: Text(
        content,
        style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: 10.sp,
          color: isOwnMessage
              ? AppColors.chatBoxMessageMine
              : AppColors.chatBoxMessageOthers,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildTime() {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Text(
      DateFormat('h:mm a')
          .format(DateTime.fromMillisecondsSinceEpoch(message.ts)),
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 8.sp,
        color: isOwnMessage
            ? AppColors.chatBoxTimeMine
            : AppColors.chatBoxTimeOthers,
      ),
    );
  }

  // List<Widget> getMessage(String content) {
  //   List<Mention>? mentions = message.attributes?['mentions'];
  //   if (mentions != null && mentions.isNotEmpty) {
  //     String stringRegex = r'([\s\S]*)';
  //     String stringMentionRegex = '';
  //     for (final Mention mention in mentions) {
  //       stringRegex += '(${mention.title})' r'([\s\S]*)';
  //       stringMentionRegex += stringMentionRegex.isEmpty
  //           ? '(${mention.title})'
  //           : '|(${mention.title})';
  //     }
  //     final RegExp mentionRegex = RegExp(stringMentionRegex);
  //     final RegExp regexp = RegExp(stringRegex);

  //     RegExpMatch? match = regexp.firstMatch(content);
  //     if (match != null) {
  //       List<Widget> res = <Widget>[];
  //       match
  //           .groups(List<int>.generate(match.groupCount, (int i) => i + 1))
  //           .forEach((String? part) {
  //         if (mentionRegex.hasMatch(part!)) {
  //           Mention mention = mentions.firstWhere(
  //             (Mention m) => m.title == part,
  //           );
  //           res.add(getMention(mention));
  //         } else {
  //           res.add(getParsePattern(part));
  //         }
  //       });
  //       if (res.isNotEmpty) {
  //         return res;
  //       }
  //     }
  //   }
  //   return <Widget>[getParsePattern(content)];
  // }

//   Widget getParsePattern(String text) {
//     // final bool isOwnMessage = message.from == currentUser.id;
//     return ParsedText(
//       parse: defaultPersePatterns,
//       text: text,
//       style: TextStyle(
//         fontFamily: kFontFamily,
//         fontSize: 10.sp,
//         color: isOwnMessage
//             ? AppColors.chatBoxTimeMine
//             : AppColors.chatBoxTimeOthers,
//       ),
//     );
//   }

//   Widget getMention(Mention mention) {
//     // final bool isOwnMessage = message.from == currentUser.id;
//     return RichText(
//       text: TextSpan(
//         text: mention.title,
//         recognizer: TapGestureRecognizer()
//           ..onTap =
//               () => onPressMention != null ? onPressMention!(mention) : null,
//         style: TextStyle(
//           color: isOwnMessage
//               ? AppColors.chatBoxTimeMine
//               : AppColors.chatBoxTimeOthers,
//           decoration: TextDecoration.none,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// final List<MatchText> defaultPersePatterns = <MatchText>[
//   MatchText(
//     type: ParsedType.URL,
//     style: const TextStyle(
//       decoration: TextDecoration.underline,
//     ),
//     onTap: (String url) {
//       if (!url.startsWith('http://') && !url.startsWith('https://')) {
//         url = 'http://$url';
//       }
//       launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     },
//   ),
// ];
}
