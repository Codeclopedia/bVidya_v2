// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/controller/providers/bchat/chat_conversation_list_provider.dart';

import '/core/state.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/conversation_model.dart';

Future showConversationOptions(
    BuildContext context, ConversationModel model) async {
  // if (model.id == AgoraConfig.bViydaAdmitUserId.toString()) {
  //   return;
  // }
  ChatPushRemindType remindType =
      await BChatContactManager.fetchChatMuteStateFor(model.id);

  bool mute = remindType != ChatPushRemindType.NONE;
  return await showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Dialog(
        // insetPadding: EdgeInsets.only(left: 6.w, top: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: ConversationMenuDialog(model: model, muted: mute),
      );
    },
  );
}

class ConversationMenuDialog extends StatelessWidget {
  final ConversationModel model;
  final bool muted;
  const ConversationMenuDialog(
      {Key? key, required this.model, required this.muted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasUnread = model.badgeCount > 0;
    // bool isAdmin = model.id == AgoraConfig.bViydaAdmitUserId.toString();
    // bool muted = model.mute;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, top: 2.h),
          child: Text(
            model.contact.name,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Container(height: 0.8, color: const Color(0xFFF5F6F6)),
        // SizedBox(height: 1.h),
        Consumer(
          builder: (context, ref, child) {
            final isUserPinned = model.contact.ispinned ?? false;
            return _buildOption(
                isUserPinned
                    ? S.current.bchat_conv_unpin
                    : S.current.bchat_conv_pin,
                isUserPinned ? 'UnPin.svg' : 'Pin.svg', () async {
              await BChatContactManager.updatePin(ref, model.id, !isUserPinned);

              Navigator.pop(context, 4);
              // hideLoading(ref);
            });
          },
        ),

        if (hasUnread) SizedBox(height: 2.h),
        if (hasUnread)
          _buildOption(S.current.bchat_conv_read, 'icon_markread_conv.svg',
              () async {
            try {
              await model.conversation?.markAllMessagesAsRead();
              await ChatClient.getInstance.chatManager
                  .sendConversationReadAck(model.id);
            } catch (e) {}

            Navigator.pop(context, 1);
          }),
        // if (hasUnread) SizedBox(height: 1.h),
        if (hasUnread) Container(height: 0.8, color: const Color(0xFFF5F6F6)),
        // SizedBox(height: 1.h),
        _buildOption(S.current.bchat_conv_delete, 'icon_delete_conv.svg',
            () async {
          await model.conversation?.deleteAllMessages();
          // final result = await ChatClient.getInstance.chatManager
          //     .deleteConversation(model.id, deleteMessages: true);
          // print('deleted $result');
          Navigator.pop(context, 2);
        }),
        // SizedBox(height: 1.h),
        Container(height: 0.8, color: const Color(0xFFF5F6F6)),
        // SizedBox(height: 1.h),
        Consumer(builder: (context, ref, child) {
          return _buildOption(
              muted ? S.current.bchat_conv_unmute : S.current.bchat_conv_mute,
              muted ? 'icon_unmute_conv.svg' : 'icon_mute_conv.svg', () async {
            await BChatContactManager.chageChatMuteStateFor(model.id, !muted);
            ref
                .read(chatConversationProvider.notifier)
                .updateConversationMute(model.id, !muted);
            Navigator.pop(context, 3);
          });
        }),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildOption(String title, String icon, Function() onOption) {
    return InkWell(
      onTap: onOption,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 4.w),
            CircleAvatar(
              radius: 5.w,
              backgroundColor: const Color(0xFFF5F5F5),
              child: getSvgIcon(
                icon,
                width: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: kFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp),
            )
          ],
        ),
      ),
    );
  }
}
