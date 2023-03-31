import '/core/constants/route_list.dart';

import '/core/constants/api_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../dialog/basic_dialog.dart';
import '../base_settings.dart';
// import 'reset_password_screen.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Text(S.current.Account, style: textStyleSettingHeading),
            ),
            // _buildSetting(),
            // S.current.hello;
            getTwoRowSettingItem(S.current.resetTitle, S.current.resetPassDesc,
                "accnt_reset.svg", () {
              Navigator.pushNamed(context, RouteList.resetPassword
                  // MaterialPageRoute(
                  //     builder: (context) => const ResetPasswordScreen()),
                  );
            }),
            // getTwoRowSettingItem(S.current.accnt_security,
            //     S.current.secrityDesc, "accnt_security.svg", () {}),
            Consumer(builder: (context, ref, child) {
              return getTwoRowSettingItem(
                  S.current.deleteAcc, S.current.deleteDesc, "accnt_dlt.svg",
                  () {
                showAccountDeleteDialog(
                  context,
                  ref,
                  callback: () async {
                    EasyLoading.showToast("Account deleted");
                    Navigator.popUntil(
                        context, ModalRoute.withName(ApiList.login));
                  },
                );
              });
            }),
          ]),
    );
  }

  // Widget _buildSetting() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 4.h),
  //     child: Text(
  //       S.current.Account,
  //       style: TextStyle(
  //         fontFamily: kFontFamily,
  //         fontSize: 20.sp,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.primaryColor,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAlert() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 1.h),
  //     padding: EdgeInsets.all(3.w),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           S.current.deleteAcc,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w700,
  //             fontFamily: kFontFamily,
  //             fontSize: 15.sp,
  //             color: AppColors.primaryColor,
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(top: 1.5.h),
  //           child: Text(
  //             S.current.dltConfirmation,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 10.sp,
  //               color: Colors.black,
  //               fontFamily: kFontFamily,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 2.h),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Expanded(
  //               child: ElevatedButton(
  //                 style: dialogElevatedButtonStyle,
  //                 onPressed: () {},
  //                 child: Text(
  //                   S.current.sureDlt,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 2.w),
  //             Expanded(
  //               child: ElevatedButton(
  //                 style: dialogElevatedButtonSecondaryStyle,
  //                 onPressed: () {},
  //                 child: Text(S.current.dltCancel),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
