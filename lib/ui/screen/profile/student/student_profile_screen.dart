// import '/data/models/response/profile/user_profile_response.dart';

// ignore_for_file: use_build_context_synchronously

import 'package:spring/spring.dart';

import '/core/utils.dart';
import '/core/utils/common.dart';

import '/controller/profile_providers.dart';
import '/ui/screens.dart';
import '/ui/dialog/basic_dialog.dart';

import '/core/constants/colors.dart';
import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

import '/ui/widget/base_drawer_setting_screen.dart';

class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditHistoryData = ref.watch(creditHistoryProvider);
    return WillPopScope(
      onWillPop: () async {
        hideLoading(ref);
        // Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteList.home, (route) => false);
        return true;
      },
      child: BaseDrawerSettingScreen(
        showEmail: true,
        currentIndex: DrawerMenu.profile,
        bodyContent: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              creditHistoryData.when(
                data: (data) {
                  if (data == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      SizedBox(height: 2.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getPngIcon('coin.png', width: 4.w),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            "You have ${data.avilableCourseCredits ?? 0} Credits",
                            style: textStyleBlack.copyWith(fontSize: 10.sp),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          InkWell(
                            onTap: () {
                              ref.refresh(creditHistoryProvider);
                            },
                            child: Spring.rotate(
                              child: Icon(
                                Icons.replay_circle_filled_sharp,
                                size: 4.w,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return const SizedBox.shrink();
                },
                loading: () {
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                child: Text(
                  S.current.profile_title,
                  style: textStyleHeading,
                ),
              ),
              SizedBox(height: 1.h),
              _buildContent(S.current.profile_detail, "profile_user.svg",
                  () async {
                showLoading(ref);
                final profile =
                    await ref.watch(profileRepositoryProvider).getUserProfile();
                hideLoading(ref);

                if (profile != null) {
                  await updateProfile(ref, profile);
                  await Navigator.pushNamed(
                      context, RouteList.studentProfileDetail,
                      arguments: profile);
                } else {
                  AppSnackbar.instance
                      .error(context, 'Error in loading profile');
                }
              }),
              _buildContent(S.current.profile_learning, "profile_learning.svg",
                  () {
                Navigator.pushNamed(context, RouteList.studentLearnings);
              }),
              // _buildContent(S.current.settingsNoti, "ic_set_noty.svg", () {
              //   Navigator.pushNamed(context, RouteList.notificationSetting);
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //       builder: (context) => const NotificationSettingScreen()),
              //   // );
              // }),
              _buildContent(S.current.tp_schedule, 'noti_calender.svg', () {
                Navigator.pushNamed(context, RouteList.studentProfileSchdule);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const NotificationSettingScreen()),
                // );
              }),
              _buildContent(S.current.profile_subscription, 'subscription.svg',
                  () {
                // return Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return SubscriptionDetail(
                //         creditsDetails:
                //             creditHistoryData.value ?? CreditDetailBody());
                //   },
                // ));
                // final data = creditHistoryData.valueOrNull;
                if ((creditHistoryData.valueOrNull?.avilableCourseCredits ??
                        0) >
                    0) {
                  Navigator.pushReplacementNamed(context, RouteList.activePlan);
                } else {
                  Navigator.pushNamed(context, RouteList.buySubscription);
                }
                // if (creditHistoryData.isLoading) {
                //   showLoading(ref);
                // }
                // if (creditHistoryData.value == null) {
                //   hideLoading(ref);
                // }
                // creditHistoryData.whenData((value) {
                //   hideLoading(ref);
                //   if (creditHistoryData.value!.avilableCourseCredits! > 0) {
                //     Navigator.pushReplacementNamed(
                //         context, RouteList.activePlan);
                //   } else {
                //     Navigator.pushNamed(context, RouteList.subscriptionPlans);
                //   }
                // });
              }),
              _buildContent(S.current.profile_instr, "profile_instru.svg", () {
                showLoading(ref);
                Navigator.pushNamed(context, RouteList.webview, arguments: {
                  'url': "https://www.app.bvidya.com/",
                });
                hideLoading(ref);
              }),
              _buildContent(S.current.profile_invite, "profile_invite.svg", () {
                shareApp();
              }),
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
      ),
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
