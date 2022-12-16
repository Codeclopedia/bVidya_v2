import '../../core/constants.dart';
import '../../core/ui_core.dart';
import '../../data/models/conversation_model.dart';

class ConversationMenuDialog extends StatelessWidget {
  final ConversationModel model;
  const ConversationMenuDialog({Key? key, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasUnread = model.badgeCount > 0;
    bool muted = model.mute;
    return Container(
      // height: 35.h,
      // width: 40.w,
      // constraints: BoxConstraints(minWidth: 30.h, minHeight: 30.h),
      // padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.w, top: 2.h),
            child: Text(
              model.user.name,
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
            _buildOption('Mark as Read', 'icon_markread_conv.svg', () {}),
          // if (hasUnread) SizedBox(height: 1.h),
          if (hasUnread) Container(height: 0.8, color: const Color(0xFFF5F6F6)),
          // SizedBox(height: 1.h),
          _buildOption('Delete Conversation', 'icon_delete_conv.svg', () {}),
          // SizedBox(height: 1.h),
          Container(height: 0.8, color: const Color(0xFFF5F6F6)),
          // SizedBox(height: 1.h),
          _buildOption(muted ? 'Unmute Conversation' : 'Mute Conversation',
              'icon_mute_conv.svg', () {}),
          SizedBox(height: 1.h),
        ],
      ),
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
