// ignore_for_file: use_build_context_synchronously

import '../../core/constants.dart';
import '../../core/ui_core.dart';

Future showBottomDialog(BuildContext context, String title, String message,
        String positiveButton, Future Function() positiveAction,
        {String? negativeButton, Future Function()? negativeAction}) =>
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.w))),
      builder: (context) {
        return BasicDialogContent(
          title: title,
          message: message,
          positiveButton: positiveButton,
          negativeButton: negativeButton ?? S.current.dltCancel,
          positiveAction: positiveAction,
          negativeAction: negativeAction,
        );
      },
    );

Future showBasicDialog(BuildContext context, String title, String message,
        String positiveButton, Future Function() positiveAction,
        {String? negativeButton, Future Function()? negativeAction}) =>
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.w))),
        child: BasicDialogContent(
          title: title,
          message: message,
          positiveButton: positiveButton,
          negativeButton: negativeButton ?? S.current.dltCancel,
          positiveAction: positiveAction,
          negativeAction: negativeAction,
        ),
      ),
    );

class BasicDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButton;
  final String negativeButton;
  final Function() positiveAction;
  final Function()? negativeAction;

  const BasicDialogContent({
    Key? key,
    required this.title,
    required this.message,
    required this.positiveButton,
    required this.negativeButton,
    required this.positiveAction,
    this.negativeAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: kFontFamily,
              fontSize: 15.sp,
              color: AppColors.primaryColor,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5.h),
            child: Text(
              // S.current.dltConfirmation,
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                fontFamily: kFontFamily,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: dialogElevatedButtonStyle,
                  onPressed: () async {
                    await positiveAction();
                    Navigator.pop(context);
                  },
                  child: Text(positiveButton
                      // S.current.sureDlt,
                      ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton(
                  style: dialogElevatedButtonSecondaryStyle,
                  onPressed: () async {
                    if (negativeAction != null) {
                      await negativeAction!();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(negativeButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
