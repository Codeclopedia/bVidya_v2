// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/sdk_helpers/bchat_group_manager.dart';
import '/data/models/models.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';

Future<int?> showGroupConversationOptions(
    BuildContext context, GroupConversationModel model) async {
  ChatPushRemindType remindType =
      await BchatGroupManager.fetchGroupMuteStateFor(model.id);
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
        child: GroupConversationMenuDialog(model: model, muted: mute),
      );
    },
  );
}

class GroupConversationMenuDialog extends StatelessWidget {
  final GroupConversationModel model;
  final bool muted;

  const GroupConversationMenuDialog(
      {Key? key, required this.model, required this.muted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasUnread = model.badgeCount > 0;
    // bool muted = model.mute;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, top: 2.h),
          child: Text(
            model.groupInfo.name ?? '',
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (hasUnread) SizedBox(height: 2.h),
        if (hasUnread)
          _buildOption(S.current.bchat_conv_read, 'icon_markread_conv.svg',
              () async {
            try {
              await model.conversation?.markAllMessagesAsRead();
              await ChatClient.getInstance.chatManager.sendConversationReadAck(
                model.id,
              );
              
            } catch (e) {}

            Navigator.pop(context, 1);
          }),
        // if (hasUnread) SizedBox(height: 1.h),
        if (hasUnread) const Divider(height: 0.8, color: Color(0xFFF5F6F6)),
        // SizedBox(height: 1.h),
        _buildOption(S.current.bchat_conv_delete, 'icon_delete_conv.svg',
            () async {
          await model.conversation?.deleteAllMessages();

          Navigator.pop(context, 2);
        }),
        // SizedBox(height: 1.h),
        const Divider(height: 0.8, color: Color(0xFFF5F6F6)),
        // SizedBox(height: 1.h),
        _buildOption(
            muted ? S.current.bchat_conv_unmute : S.current.bchat_conv_mute,
            muted ? 'icon_unmute_conv.svg' : 'icon_mute_conv.svg', () async {
          await BchatGroupManager.chageGroupMuteStateFor(model.id, !muted);
          Navigator.pop(context, 3);
        }),
        SizedBox(height: 1.h),
      ],
    );
  }

  _buildOption(String title, String icon, Function() onOption) {
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
