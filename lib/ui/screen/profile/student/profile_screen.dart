import '/ui/dialog/basic_dialog.dart';

import '/core/constants/colors.dart';
import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

import '../../../widget/base_drawer_setting_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerSettingScreen(
      showEmail: true,
      screenName: RouteList.profile,
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 0.4.h),
            // Center(
            //   child: Consumer(
            //     builder: (context, ref, child) {
            //       return Text(
            //         user?.email ?? '',
            //         style: TextStyle(
            //           fontSize: 8.sp,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.primaryColor,
            //           fontFamily: kFontFamily,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Text(
                S.current.profile_title,
                style: textStyleHeading,
              ),
            ),
            SizedBox(height: 1.h),
            _buildContent(S.current.profile_details, "profile_user.svg", () {
              Navigator.pushNamed(context, RouteList.studentProfileDetail);
            }),
            _buildContent(S.current.profile_learning, "profile_learning.svg",
                () {
              Navigator.pushNamed(context, RouteList.studentLearnings);
            }),
            _buildContent(S.current.settingsNoti, "ic_set_noty.svg", () {
              Navigator.pushNamed(context, RouteList.notificationSetting);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const NotificationSettingScreen()),
              // );
            }),
            _buildContent(S.current.profile_instr, "profile_instru.svg", () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const HelpCenterScreen()),
              // );
            }),
            _buildContent(
                S.current.profile_invite, "profile_invite.svg", () {}),
            Consumer(builder: (context, ref, child) {
              return _buildContent(
                  S.current.profile_logout, "profile_logout.svg", () {
                showLogoutDialog(context, ref, callback: () async {
                  // ref.watch(loginRepositoryProvider).loggedOut();
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, RouteList.login, (route) => route.isFirst);
                });
              });
            }),
            Container(
              width: 0.5.w,
            )
          ]),
    );
  }

  // Widget _buildProfile() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 4.h),
  //     child: Text(
  //       S.current.profile_title,
  //       style: textStyleHeading,
  //     ),
  //   );
  // }

  // Widget _buildGmail() {
  //   return Text(
  //     S.current.profile_gmail,
  //     style: TextStyle(
  //       fontSize: 10.sp,
  //       fontWeight: FontWeight.w600,
  //       color: AppColors.primaryColor,
  //       fontFamily: kFontFamily,
  //     ),
  //   );
  // }

  Widget _buildContent(String title, String icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(top: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Text(
                      title,
                      style: textStyleSettingTitle,
                    ),
                  ),
                ),
                getSvgIcon('arrow_right.svg',
                    width: 2.w, color: Colors.black, height: 2.h),
                SizedBox(width: 6.w),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1.5.h),
              height: 0.5,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }
}
