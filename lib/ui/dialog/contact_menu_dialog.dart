// ignore_for_file: use_build_context_synchronously

import '/controller/providers/bchat/chat_conversation_provider.dart';
import '../../core/sdk_helpers/bchat_contact_manager.dart';
import '/core/state.dart';

import '../../data/models/models.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';

Future<bool> showContactMenu(BuildContext context, Contacts contact) async {
  final blocked =
      await BChatContactManager.isUserBlocked(contact.userId.toString());
  return await showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Dialog(
        // insetPadding: EdgeInsets.only(left: 6.w, top: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: ContactMenuDialog(contact: contact, blocked: blocked),
      );
    },
  );
}

class ContactMenuDialog extends StatelessWidget {
  final Contacts contact;
  final bool blocked;
  const ContactMenuDialog(
      {Key? key, required this.contact, required this.blocked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool muted = model.mute;
    // bool blocked = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, top: 2.h),
          child: Text(
            contact.name,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          return _buildOption(
              S.current.contact_menu_delete, 'icon_delete_conv.svg', () async {
            await BChatContactManager.deleteContact(contact.userId.toString());
            await ref
                .read(chatConversationProvider)
                .removedContact(contact.userId.toString());

            Navigator.pop(context, true);
          });
        }),
        // SizedBox(height: 1.h),
        Container(height: 0.8, color: const Color(0xFFF5F6F6)),
        _buildOption(
            blocked
                ? S.current.contact_menu_unblock
                : S.current.contact_menu_block,
            'icon_mute_conv.svg', () async {
          if (blocked) {
            await BChatContactManager.unBlockUser(contact.userId.toString());
          } else {
            await BChatContactManager.blockUser(contact.userId.toString());
          }
          Navigator.pop(context, false);
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
