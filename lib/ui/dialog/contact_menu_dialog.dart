// ignore_for_file: use_build_context_synchronously

import '/controller/providers/bchat/chat_conversation_provider.dart';
import '../../core/sdk_helpers/bchat_contact_manager.dart';
import '/core/state.dart';

import '../../data/models/models.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';

Future<int> showContactMenu(BuildContext context, Contacts contact) async {
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
        child: ContactMenuDialog(
          name: contact.name,
          isInContact: true,
          userId: contact.userId,
          blocked: blocked,
        ),
      );
    },
  );
}

Future<int> showSearchMenu(
    BuildContext context, SearchContactResult result, bool added) async {
  bool blocked = false;
  if (added) {
    blocked = await BChatContactManager.isUserBlocked(result.userId.toString());
  }

  return await showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Dialog(
        // insetPadding: EdgeInsets.only(left: 6.w, top: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: ContactMenuDialog(
            name: result.name ?? '',
            isInContact: added,
            userId: result.userId!,
            blocked: blocked),
      );
    },
  );
}

class ContactMenuDialog extends StatelessWidget {
  // final Contacts contact;
  final int userId;
  final String name;
  final bool blocked;
  final bool isInContact;
  const ContactMenuDialog(
      {Key? key,
      required this.userId,
      required this.name,
      required this.isInContact,
      required this.blocked})
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
            name,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if(!isInContact)
        ..._buildOption(S.current.contact_menu_request, 'icon_mute_conv.svg',
            () async {
          Navigator.pop(context, 0);
        }),
        ..._buildOption(S.current.contact_menu_view, 'icon_mute_conv.svg',
            () async {
          Navigator.pop(context, 1);
        }),
        // Consumer(builder: (context, ref, child) {
          if(isInContact)
        ..._buildOption(S.current.contact_menu_delete, 'icon_delete_conv.svg',
            () async {
          await BChatContactManager.deleteContact(userId.toString());
          
          // await ref.read(chatConversationProvider).removedContact(userId);

          Navigator.pop(context, 2);
        }),
        // }),
        // SizedBox(height: 1.h),
        // Container(height: 0.8, color: const Color(0xFFF5F6F6)),
        if(isInContact)
        ..._buildOption(
            blocked
                ? S.current.contact_menu_unblock
                : S.current.contact_menu_block,
            'icon_mute_conv.svg', () async {
          if (blocked) {
            await BChatContactManager.unBlockUser(userId.toString());
          } else {
            await BChatContactManager.blockUser(userId.toString());
          }
          Navigator.pop(context, 3);
        }),
        SizedBox(height: 1.h),
      ],
    );
  }

  List<Widget> _buildOption(String title, String icon, Function() onOption) {
    return [
      InkWell(
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
      ),
      SizedBox(height: 1.h),
      Container(height: 0.8, color: const Color(0xFFF5F6F6)),
    ];
  }
}
