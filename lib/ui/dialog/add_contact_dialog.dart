import 'package:bvidya/core/constants/colors.dart';
import 'package:bvidya/core/state.dart';

import '/core/ui_core.dart';

Future<String?> showAddContactDialog(
    BuildContext context, int userId, String name) async {
  return await showModalBottomSheet(
    context: context,
    elevation: 1,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isDismissible: false,
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(4.w))),
    // clipBehavior: Clip.none,
    // constraints: BoxConstraints(minHeight: 25.h, maxHeight: 30.h),
    builder: (context) {
      return AddContactDialog(
        userId: userId,
        name: name,
      );
    },
  );
}

class AddContactDialog extends HookWidget {
  final int userId;
  final String name;
  const AddContactDialog({Key? key, required this.userId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    return Container(
      // alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      // padding: EdgeInsets.only(
      //     left: 6.w,
      //     right: 6.w,
      //     top: 2.h,
      //     bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.w),
            topRight: Radius.circular(4.w),
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, offset: const Offset(0, -2))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Send Request to $name', style: textStyleHeading),
          SizedBox(height: 1.w),
          Text('Send a hi message to add contact', style: textStyleTitle),
          SizedBox(height: 2.w),
          TextFormField(
            controller: textController,
            decoration:
                inputMultiLineStyle.copyWith(hintText: 'Enter first message'),
            maxLines: 3,
            onFieldSubmitted: (value) {
              Navigator.pop(context, value.trim());
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size(22.w, 4.w),
                    foregroundColor: Colors.black87,
                    textStyle: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // style: dialogElevatedButtonSecondaryStyle,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.toUpperCase())),
              SizedBox(width: 3.w),
              TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size(22.w, 4.w),
                    foregroundColor: AppColors.primaryColor,
                    textStyle: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // style: dialogElevatedButtonStyle,
                  onPressed: () {
                    String input = textController.text.trim();
                    Navigator.pop(context, input);
                  },
                  child: Text('Send'.toUpperCase()))
            ],
          )
        ],
      ),
    );
  }
}
