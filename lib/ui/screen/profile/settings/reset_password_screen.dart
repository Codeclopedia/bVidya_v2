import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '../base_settings_noscroll.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                S.current.resetTitle,
                style: textStyleSettingHeading,
              ),
              SizedBox(height: 3.h),
              Text(
                S.current.fp_desc_message,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 10.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 3.h),
              TextFormField(
                decoration: inputDirectionStyle.copyWith(
                  hintText: S.current.emailHint,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                style: elevatedButtonTextStyle,
                onPressed: () {},
                child: Text(S.current.submitBtn),
              ),
              const Spacer()
            ]),
      ),
    );
  }

// //AppColors.primaryColor
//   Widget _buildSetting() {
//     return Container(
//       margin: EdgeInsets.only(top: 4.h),
//       child: Text(
//         S.current.resetTitle,
//         style: TextStyle(
//           fontFamily: kFontFamily,
//           fontSize: 20.sp,
//           fontWeight: FontWeight.bold,
//           color: AppColors.primaryColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(Function() onClick) {
//     return Container(
//       margin: EdgeInsets.only(top: 3.h),
//       child: Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               S.current.resetDesc,
//               style: TextStyle(
//                 fontFamily: kFontFamily,
//                 fontSize: 10.sp,
//                 color: Colors.black,
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 3.h),
//               child: TextField(
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: S.current.emailHint,
//                   contentPadding: // Text Field height
//                       EdgeInsets.symmetric(horizontal: 10.0),
//                 ),
//                 keyboardType: TextInputType.multiline,
//               ),
//             ),
//             Container(
//               height: 5.5.h,
//               width: 100.w,
//               margin: EdgeInsets.only(top: 2.h),
//               child: ElevatedButton(
//                   style: elevatedButtonStyle,
//                   onPressed: onClick,
//                   child: Text(
//                     S.current.submitBtn,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
