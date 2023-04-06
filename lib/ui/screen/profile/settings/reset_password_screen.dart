// ignore_for_file: use_build_context_synchronously

import '/core/utils.dart';
import '/core/state.dart';
import '/ui/base_back_screen.dart';
import '/core/ui_core.dart';
import '../base_settings_noscroll.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return BaseWilPopupScreen(
      onBack: () async => true,
      child: BaseNoScrollSettings(
        bodyContent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Form(
            key: formKey,
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
                  Consumer(builder: (context, ref, child) {
                    return TextFormField(
                      controller: textController,
                      decoration: inputDirectionStyle.copyWith(
                        hintText: S.current.emailHint,
                      ),
                      onFieldSubmitted: (value) {
                        if (formKey.currentState?.validate() == true) {
                          _requidEmail(value, ref, context);
                        }
                      },
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return S.current.login_email_empty;
                        }
                        if (!isValidEmail(value ?? '')) {
                          return S.current.login_email_invalid;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    );
                  }),
                  SizedBox(height: 3.h),
                  Consumer(builder: (context, ref, child) {
                    return ElevatedButton(
                      style: elevatedButtonTextStyle,
                      onPressed: () async {
                        if (formKey.currentState?.validate() == true) {
                          String email = textController.text;
                          _requidEmail(email, ref, context);
                        }
                      },
                      child: Text(S.current.submitBtn),
                    );
                  }),
                  const Spacer()
                ]),
          ),
        ),
      ),
    );
  }

  _requidEmail(String email, WidgetRef ref, BuildContext context) async {
    showLoading(ref);
    final result =
        await ref.read(loginRepositoryProvider).forgetPassword(email);
    hideLoading(ref);
    if (result != null) {
      AppSnackbar.instance.error(context, result);
    } else {
      AppSnackbar.instance.message(context, S.current.resetPasswordEmail);
      Navigator.pop(context);
    }
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
