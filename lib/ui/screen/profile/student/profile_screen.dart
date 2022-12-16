import '../../../../core/constants/colors.dart';
import '../../../../core/ui_core.dart';

import '../base_settings.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

//   @override
//   _MyappState createState() => _MyappState();
// }

// class _MyappState extends State<ProfileSettings> {

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                S.current.profile_gmail,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontFamily: kFontFamily,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Text(
                S.current.profile_title,
                style: textStyleHeading,
              ),
            ),
            SizedBox(height: 1.h),
            _buildContent(S.current.profile_details, "profile_user.svg", () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const AccountSettingScreen()),
              // );
            }),
            _buildContent(
                S.current.profile_learning, "profile_learning.svg", () {}),
            _buildContent(S.current.settingsNoti, "ic_set_noty.svg", () {
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
            _buildContent(
                S.current.profile_logout, "profile_logout.svg", () {}),
            Container(
              width: 0.5.w,
            )
          ]),
    );
  }

  Widget _buildProfile() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: Text(
        S.current.profile_title,
        style: textStyleHeading,
      ),
    );
  }

  Widget _buildGmail() {
    return Text(
      S.current.profile_gmail,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
        fontFamily: kFontFamily,
      ),
    );
  }

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
