// import 'package:intl/intl.dart';

// import '../../core/constants.dart';
// import '../../core/constants/data.dart';
// import '../../core/state.dart';
// import '../../core/ui_core.dart';

// class ChatBubble extends StatelessWidget {
//   final Messege message;
//   final bool mine;
//   final int secondUserId;

//   const ChatBubble(
//       {Key? key,
//       required this.message,
//       required this.mine,
//       required this.secondUserId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // print('object')
//     // final ConversationModel otherUser = conversationList.firstWhere(
//     //   (contact) => contact.id == secondUserId,
//     //   orElse: () {
//     //     return conversationList.first;
//     //   },
//     // );
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//       child: Consumer(
//         builder: (context, ref, child) {
//           final user = ref.watch(loginRepositoryProvider).user;
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment:
//                 mine ? MainAxisAlignment.end : MainAxisAlignment.start,
//             children: [
//               if (!mine) getCicleAvatar(otherUser.name, ''),
//               Container(
//                 margin: EdgeInsets.only(top: 2.h),
//                 child: _messageBody(),
//               ),
//               if (mine)
//                 getCicleAvatar(user?.name ?? 'You',
//                     user?.image ?? 'assets/images/dummy_profile.png'),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   _messageBody() {
//     return message.type == 'text' ? _onlyText() : _imageOnly();
//   }

//   _imageOnly() {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: 30.w,
//         maxWidth: 60.w,
//       ),
//       margin: mine ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(3.w)),
//             child: Image(
//               image: NetworkImage(message.image ??
//                   'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg'),
//             ),
//           ),
//           // SizedBox(
//           //   width: 8.w,
//           // ),
//           Positioned(
//             child: _buildTime(),
//             right: 2.w,
//             bottom: 1.h,
//           ),
//         ],
//       ),
//     );
//   }

//   _onlyText() {
//     return mine ? _textMessageMy() : _textMessageOther();
//   }

//   textBubbleDecoration() => BoxDecoration(
//         color: mine
//             ? AppColors.chatBoxBackgroundMine
//             : AppColors.chatBoxBackgroundOthers,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(5.w),
//           bottomRight: Radius.circular(5.w),
//           topRight: mine ? Radius.zero : Radius.circular(5.w),
//           topLeft: mine ? Radius.circular(5.w) : Radius.zero,
//         ),
//       );

//   replyTextBubbleDecoration() => BoxDecoration(
//         color: mine
//             ? AppColors.chatBoxBackgroundOthers
//             : AppColors.chatBoxBackgroundMine,
//         borderRadius: BorderRadius.all(Radius.circular(5.w)),
//       );

//   _textMessageMy() {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: message.replyOf != null ? 60.w : 30.w,
//         maxWidth: message.replyOf != null ? 60.w : 50.w,
//       ),
//       margin: EdgeInsets.only(right: 2.w),
//       decoration: textBubbleDecoration(),
//       padding: EdgeInsets.symmetric(
//         horizontal: 4.w,
//         vertical: 1.h,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (message.replyOf != null) _replyText(),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               _textMessage(message.message),
//               SizedBox(
//                 width: 8.w,
//               )
//             ],
//           ),
//           _buildTime(),
//         ],
//       ),
//     );
//   }

//   _textMessageOther() {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: message.replyOf != null ? 60.w : 30.w,
//         maxWidth: message.replyOf != null ? 60.w : 50.w,
//       ),
//       margin: EdgeInsets.only(left: 2.w),
//       decoration: textBubbleDecoration(),
//       padding: EdgeInsets.symmetric(
//         horizontal: 4.w,
//         vertical: 1.h,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (message.replyOf != null) _replyText(),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               _textMessage(message.message),
//               SizedBox(
//                 width: 8.w,
//               )
//             ],
//           ),
//           _buildTime(),
//         ],
//       ),
//     );
//   }

//   _replyText() {
//     return Container(
//       height: message.replyOf!.type == 'text' ? 25.w : 36.w,
//       margin: EdgeInsets.only(bottom: 1.h),
//       decoration: replyTextBubbleDecoration(),
//       padding: const EdgeInsets.all(0.3),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           SizedBox(width: 2.w),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: mine
//                     ? const Color(0xFF6F3253)
//                     : const Color.fromARGB(255, 248, 213, 131),
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(5.w),
//                   bottomLeft: Radius.zero,
//                   topRight: Radius.circular(5.w),
//                   topLeft: Radius.zero,
//                 ),
//               ),
//               margin: EdgeInsets.only(left: 2.w),
//               padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _textUserName(),
//                   if (message.replyOf!.type == 'text')
//                     _textMessage(message.replyOf!.message),
//                   if (message.replyOf!.type == 'image')
//                     _replyImageContent(message.replyOf!.image!),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   _replyImageContent(String image) {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: 30.w,
//         maxWidth: 50.w,
//       ),
//       margin: mine ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
//       child: ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(3.w)),
//         child: Image(
//           image: NetworkImage(image),
//         ),
//       ),
//     );
//   }

//   _textUserName() {
//     return Expanded(
//       child: Text(
//         'Saurabh',
//         style: TextStyle(
//           fontFamily: kFontFamily,
//           fontSize: 10.sp,
//           color: mine ? AppColors.yellowAccent : AppColors.primaryColor,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//     );
//   }

//   _textMessage(String content) {
//     return Expanded(
//       child: Text(
//         content,
//         style: TextStyle(
//           fontFamily: kFontFamily,
//           fontSize: 10.sp,
//           color: mine
//               ? AppColors.chatBoxMessageMine
//               : AppColors.chatBoxMessageOthers,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//     );
//   }

//   _buildTime() {
//     return Text(
//       DateFormat('h:mm a').format(message.time),
//       style: TextStyle(
//         fontFamily: kFontFamily,
//         fontSize: 8.sp,
//         color: mine ? AppColors.chatBoxTimeMine : AppColors.chatBoxTimeOthers,
//       ),
//     );
//   }
// }
