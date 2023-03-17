import '/ui/screens.dart';

import '/core/utils.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';
import '../../../widget/base_drawer_setting_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWilPopupScreen(
      onBack: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteList.home, (route) => false);
        return true;
      },
      child: BaseDrawerSettingScreen(
        currentIndex: DrawerMenu.settings,
        bodyContent: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                child: Text(S.current.setting_title, style: textStyleHeading),
              ),
              getTwoRowSettingItem(
                  S.current.Account, S.current.passReset, "ic_set_account.svg",
                  () {
                Navigator.pushNamed(context, RouteList.accountSetting);
              }),
              //todo uncomment phase3
              // getTwoRowSettingItem(
              //     S.current.settingChat, S.current.chatHistory, "ic_set_chat.svg",
              //     () {
              //   Navigator.pushNamed(context, RouteList.chatSetting);
              // }),
              // getTwoRowSettingItem(S.current.settingsNoti, S.current.notiHistory,
              //     "ic_set_noty.svg", () {
              //   Navigator.pushNamed(context, RouteList.notificationSetting);
              // }),
              getTwoRowSettingItem(S.current.settingHelp, S.current.helpCenter,
                  "ic_set_help.svg", () {
                Navigator.pushNamed(context, RouteList.help);
              }),
              _buildSingleLineItem(S.current.settingShare, "ic_set_share.svg",
                  () {
                shareApp();
              }),
              _buildSingleLineItem(S.current.settingRate, "ic_set_rate.svg",
                  () {
                rateApp(context);
              }),
            ]),
      ),
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
}
