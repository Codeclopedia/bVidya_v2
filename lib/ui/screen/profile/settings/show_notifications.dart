import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '../base_settings.dart';

class ShowNotifications extends StatelessWidget {
  const ShowNotifications({Key? key}) : super(key: key);

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
              child: Text(
                S.current.showNoty,
                style: textStyleSettingHeading,
              ),
            ),
            // _buildSetting(),
            _buildSubName(S.current.bchat),
            getTwoRowSwitchSettingItem(S.current.noti_message,
                S.current.messDesc, "noti_message.svg", false, (value) {}),
            getTwoRowSwitchSettingItem(S.current.noti_call, S.current.callDesc,
                "noti_call.svg", false, (value) {}),
            getTwoRowSwitchSettingItem(S.current.noti_group,
                S.current.groupDesc, "noti_grp_filled.svg", false, (value) {}),
            _buildSubName(S.current.bmeet),
            getTwoRowSwitchSettingItem(S.current.meetingRem,
                S.current.meetingDesc, "noti_calender.svg", false, (value) {}),
            _buildSubName(S.current.blive),
            getTwoRowSwitchSettingItem(S.current.confRem, S.current.confDesc,
                "noti_message.svg", false, (value) {}),
            _buildSubName(S.current.blearn),
            getTwoRowSwitchSettingItem(S.current.confRem, S.current.confDesc,
                "noti_message.svg", false, (value) {}),
            Container(height: 2.h)
          ]),
    );
  }

  // Widget _buildSetting() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 4.h),
  //     child: Text(
  //       S.current.showNoty,
  //       style: TextStyle(
  //         fontFamily: kFontFamily,
  //         fontSize: 20.sp,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.primaryColor,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSubName(String title) {
    return Container(
      margin: EdgeInsets.only(top: 3.h, left: 6.w, right: 6.w),
      //padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          fontFamily: kFontFamily,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  // Widget _buildSwitch(
  //     String title, String desc, String icon, Function() onClick) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 3.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             CircleAvatar(
  //               backgroundColor: Colors.grey[
  //                   200], //back ground colors//opectional give opacity of background
  //               radius: 2.5.h,
  //               child: getSvgIcon(icon,
  //                   width: 4.w, color: AppColors.primaryColor, height: 4.h),
  //             ),
  //             Expanded(
  //               child: Container(
  //                 margin: EdgeInsets.only(left: 4.w),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       title,
  //                       style: TextStyle(
  //                         fontSize: 14.sp,
  //                         color: Colors.black,
  //                         fontFamily: kFontFamily,
  //                       ),
  //                     ),
  //                     Text(
  //                       desc,
  //                       style: TextStyle(
  //                         fontSize: 10.sp,
  //                         color: Colors.grey[900],
  //                         fontFamily: kFontFamily,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             mySwitch(false, (p0) => null)
  //           ],
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(top: 1.9.h),
  //           height: 0.1.h,
  //           color: Colors.grey[400],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget mySwitch(bool value, Function(bool) onChanged) => FlutterSwitch(
  //       onToggle: (v) {
  //         onChanged(v);
  //       },
  //       value: value,
  //       activeColor: const Color(0xFF500D34),
  //       inactiveColor: const Color(0xFFCCCCCC),
  //       toggleSize: 5.w,
  //       width: 12.w,
  //       height: 2.7.h,
  //     );
}
