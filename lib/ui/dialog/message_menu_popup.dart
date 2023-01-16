import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/ui_core.dart';

import '/core/constants.dart';

Future<int?> showMessageMenu(BuildContext context, ChatMessage message) async {
  return await showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: MessageMenuDialog(
          message: message,
        ),
      );
    },
  );
}

class MessageMenuDialog extends StatelessWidget {
  final ChatMessage message;
  const MessageMenuDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, top: 2.h),
          child: Text(
            S.current.chat_menu_title,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        if (message.body.type == MessageType.TXT)
          ..._buildOption(S.current.chat_menu_copy,
              getSvgIcon('icon_chat_copy.svg', width: 4.w), () async {
            Navigator.pop(context, 0);
          }),
        ..._buildOption(
            S.current.chat_menu_forward,
            getSvgIcon(
              'icon_chat_forward.svg',
              width: 4.w,
            ), () async {
          Navigator.pop(context, 1);
        }),
        ..._buildOption(
          S.current.chat_menu_reply,
          getSvgIcon('icon_chat_reply.svg', width: 4.w),
          () async {
            Navigator.pop(context, 2);
          },
        ),
        ..._buildOption(
            S.current.chat_menu_delete,
            getSvgIcon(
              'icon_delete_conv.svg',
              width: 4.w,
            ), () async {
          Navigator.pop(context, 3);
        }, isLast: true),
        SizedBox(height: 1.h),
      ],
    );
  }

  List<Widget> _buildOption(String title, Widget icon, Function() onOption,
      {bool isLast = false}) {
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
                child: icon,
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
      // SizedBox(height: 1.h),
      if (!isLast) const Divider(height: 0.8, color: Color(0xFFF5F6F6)),
    ];
  }
}
