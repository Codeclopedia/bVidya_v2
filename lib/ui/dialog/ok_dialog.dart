import '/core/constants.dart';
import '/core/ui_core.dart';

// Future showBottomOkDialog(BuildContext context, String title, String message,
//         String positiveButton, Future Function() positiveAction,
//         {String? negativeButton, Future Function()? negativeAction}) =>
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(4.w))),
//       builder: (context) {
//         return BasicDialogContent(
//           title: title,
//           message: message,
//           positiveButton: positiveButton,
//           negativeButton: negativeButton ?? S.current.dltCancel,
//           positiveAction: positiveAction,
//           negativeAction: negativeAction,
//         );
//       },
//     );

Future showOkDialog(BuildContext context, String title, String message,
        {bool? type, String? positiveButton, Function()? positiveAction}) =>
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.w))),
        child: OkDialogContent(
          title: title,
          message: message,
          positiveButton: positiveButton,
          positiveAction: positiveAction,
          type: type,
        ),
      ),
    );

class OkDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final bool? type;
  final String? positiveButton;

  final Function()? positiveAction;

  const OkDialogContent(
      {Key? key,
      required this.title,
      required this.message,
      this.positiveButton,
      this.type,
      this.positiveAction})
      : super(key: key);

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
          if (type != null)
            Image(
                image: getImageProvider(type!
                    ? 'assets/images/check.png'
                    : 'assets/images/check.png')),
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
          Center(
            child: ElevatedButton(
              style: dialogElevatedButtonStyle,
              onPressed: () {
                Navigator.pop(context);
                if (positiveAction != null) {
                  positiveAction!();
                }
              },
              child: Text(positiveButton ?? S.current.btn_ok
                  // S.current.sureDlt,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
