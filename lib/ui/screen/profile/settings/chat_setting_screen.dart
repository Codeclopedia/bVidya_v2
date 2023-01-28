import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '../../../dialog/basic_dialog.dart';
import '../base_settings.dart';

class ChatSettingScreen extends StatelessWidget {
  const ChatSettingScreen({Key? key}) : super(key: key);

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
              child:
                  Text(S.current.settingChat, style: textStyleSettingHeading),
            ),
            // _buildSetting(),
            // S.current.hello;
            _buildSingleLineItem(S.current.blockedUser, "accnt_dlt.svg", () {}),
            _buildSingleLineItem(S.current.clearChat, "accnt_dlt.svg", () {
              showBasicDialog(
                  context,
                  S.current.clearChat,
                  S.current.ClearChatMessage,
                  S.current.ClearChatConfirm,
                  () async {});
            }),
            _buildSingleLineItem(S.current.ChatBackup, "accnt_dlt.svg", () {
              showBasicDialog(
                  context,
                  S.current.ChatBackup,
                  S.current.ChatBackupMessage,
                  S.current.ChatBackupConfirm,
                  () async {});
            }),
            _buildSingleLineItem(S.current.ExportChat, "accnt_dlt.svg", () {
              showBasicDialog(context, S.current.deleteAcc,
                  S.current.dltConfirmation, S.current.sureDlt, () async {});
            }),
          ]),
    );
  }

  Widget _buildSingleLineItem(String title, String icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 6.w),
                CircleAvatar(
                  backgroundColor: AppColors.cardWhite,
                  radius: 6.w,
                  child: getSvgIcon(icon,
                      width: 5.w, color: AppColors.primaryColor),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: textStyleSettingTitle,
                        ),
                      ],
                    ),
                  ),
                ),
                getSvgIcon('arrow_right.svg', width: 2.w, color: Colors.black),
                SizedBox(width: 6.w),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.h),
              height: 0.5,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
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
