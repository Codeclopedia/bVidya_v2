// ignore_for_file: use_build_context_synchronously

import '/core/utils/common.dart';

import '/controller/profile_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '../../../base_back_screen.dart';
import '../../../dialog/basic_dialog.dart';
import '../../../widget/base_drawer_setting_screen.dart';

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerSettingScreen(
      showEmail: true,
      currentIndex: DrawerMenu.profile,
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const [],
            // ),
            _buildProfile(),
            Consumer(builder: (context, ref, child) {
              return _buildContent(
                  S.current.profile_details, 'profile_user.svg', () async {
                // final user = await getMeAsUser();
                showLoading(ref);
                final profile =
                    await ref.read(profileRepositoryProvider).getUserProfile();
                hideLoading(ref);

                if (profile != null) {
                  await updateProfile(ref, profile);
                  Navigator.pushNamed(context, RouteList.teacherEditProfile,
                      arguments: profile);
                } else {
                  AppSnackbar.instance
                      .error(context, 'Error in loading teacher profile');
                }

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TeacherProfileEdit()),
                // );
              });
            }),
            _buildContent(S.current.tp_dashboard, 'profile_learning.svg',
                () async {
              final user = await getMeAsUser();
              if (user != null) {
                Navigator.pushNamed(context, RouteList.teacherDashboard);
              }
            }),
            _buildContent(S.current.tp_schedule, 'noti_calender.svg', () async {
              final user = await getMeAsUser();
              if (user != null) {
                Navigator.pushNamed(context, RouteList.teacherSchedule);
              }
            }),
            _buildClassRequest(S.current.tp_classes, 'profile_instru.svg',
                () async {
              final user = await getMeAsUser();
              if (user != null) {
                Navigator.pushNamed(context, RouteList.teacherClassRequest);
              }
            }),
            _buildContent(S.current.profile_invite, 'profile_invite.svg', () {
              shareApp();
            }),
            Consumer(builder: (context, ref, child) {
              return _buildContent(
                  S.current.profile_logout, 'profile_logout.svg', () {
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

  Widget _buildProfile() {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 6.w),
      child: Text(
        S.current.profile_title,
        style: textStyleHeading,
      ),
    );
  }

  Widget _buildClassRequest(String title, String icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(top: 3.h),
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
            SizedBox(height: 1.9.h),
            Divider(
              // margin: EdgeInsets.only(top: 1.9.h),
              height: 0.1.h,
              color: Colors.grey[300],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String title, String icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(top: 3.h),
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
            SizedBox(height: 1.9.h),
            Divider(
              // margin: EdgeInsets.only(top: 1.9.h),
              height: 0.1.h,
              color: Colors.grey[300],
            )
          ],
        ),
      ),
    );
  }
}
