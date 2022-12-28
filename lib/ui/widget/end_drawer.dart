// ignore_for_file: use_build_context_synchronously

import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants.dart';
import '../../core/state.dart';
import '../../core/ui_core.dart';
import '../../core/utils.dart';
import '../../core/helpers/drag_position.dart';

class EndDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String myRouteName;

  const EndDrawer(
      {Key? key, required this.scaffoldKey, required this.myRouteName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final drag = ref.watch(drawerPositionNotifierProvider);
              return Positioned(
                top: 86.85.h,
                right: 17.5.w,
                child: InkWell(
                  onTap: () => scaffoldKey.currentState?.closeEndDrawer(),
                  child: SvgPicture.asset(
                    'assets/icons/svgs/arc_type1.svg',
                    color: myRouteName == RouteList.home
                        ? AppColors.yellowAccent
                        : AppColors.drawerBackgroundColor,
                    width: 8.w,
                    height: 12.h,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 18.w,
              color: AppColors.drawerBackgroundColor,
              child: SafeArea(
                child: Consumer(builder: (context, ref, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // InkWell(
                      //   child: Container(
                      //     padding: EdgeInsets.all(1.w),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(2.w)),
                      //       color: AppColors.yellowAccent,
                      //     ),
                      //     child: const Icon(
                      //       Icons.search,
                      //       color: AppColors.primaryColor,
                      //     ),
                      //   ),
                      // ),
                      _buildIconPng(
                          S.current.drawer_setting,
                          'menu_settings.png',
                          myRouteName == RouteList.settings, () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.settings);

                        Navigator.pushReplacementNamed(
                            context, RouteList.settings);
                      }),
                      _buildIconPng(
                          S.current.drawer_profile,
                          'menu_profile.png',
                          myRouteName == RouteList.profile, () async {
                        scaffoldKey.currentState?.closeEndDrawer();
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.profile);
                        final user = await getMeAsUser();
                        if (user != null) {
                          //removed to work as  a teacher profile

                          // print('user role ${user.role}');
                          if (user.role == 'teacher' || user.role == 'admin') {
                            Navigator.pushReplacementNamed(
                                context, RouteList.teacherProfile);
                          } else {
                            Navigator.pushReplacementNamed(
                                context, RouteList.studentProfile);
                          }
                        }
                      }),
                      // _buildIcon(S.current.drawer_disucss, 'ic_Community.svg',
                      //     myRouteName == RouteList.bDiscuss, () {
                      //   scaffoldKey.currentState?.closeEndDrawer();
                      //   if (myRouteName == RouteList.bDiscuss) return;
                      //   ref
                      //       .read(drawerPositionNotifierProvider.notifier)
                      //       .updatDrawerPositions(RouteList.bDiscuss);
                      //   Navigator.pushReplacementNamed(
                      //       context, RouteList.bDiscuss);
                      // }),
                      // _buildIcon(S.current.drawer_forum, 'ic_Forum.svg',
                      //     myRouteName == RouteList.bForum, () {
                      //   scaffoldKey.currentState?.closeEndDrawer();
                      //   if (myRouteName == RouteList.bForum) return;
                      //   ref
                      //       .read(drawerPositionNotifierProvider.notifier)
                      //       .updatDrawerPositions(RouteList.bForum);
                      //   Navigator.pushReplacementNamed(
                      //       context, RouteList.bForum);
                      // }),
                      _buildIconPng(S.current.drawer_blive, 'menu_blive.png',
                          myRouteName == RouteList.bLive, () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bLive) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bLive);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bLive);
                      }),
                      _buildIconPng(S.current.drawer_bmeet, 'menu_bmeet.png',
                          myRouteName == RouteList.bMeet, () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bMeet) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bMeet);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bMeet);
                      }),
                      _buildIconPng(S.current.drawer_blearn, 'menu_blearn.png',
                          myRouteName == RouteList.bLearnHome, () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bLearnHome) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bLearnHome);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bLearnHome);
                      }),
                      SizedBox(
                        width: 20.w,
                        height: 7.h,
                        child: Stack(children: [
                          _buildIconPng(
                              S.current.drawer_bchat,
                              'menu_bchat.png',
                              myRouteName == RouteList.home, () {
                            scaffoldKey.currentState?.closeEndDrawer();
                            if (myRouteName == RouteList.home) return;
                            ref
                                .read(drawerPositionNotifierProvider.notifier)
                                .updatDrawerPositions(RouteList.home);
                            Navigator.pushReplacementNamed(
                                context, RouteList.home);
                          }),
                          Positioned(
                            right: 5.w,
                            top: 0.5.h,
                            child: CircleAvatar(
                              backgroundColor: myRouteName == RouteList.home
                                  ? AppColors.cardWhite
                                  : AppColors.yellowAccent,
                              radius: 1.8.w,
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kFontFamily,
                                  fontSize: 6.sp,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
      String title, String icon, bool selected, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 20.w,
        height: 8.h,
        color: selected ? AppColors.yellowAccent : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            getSvgIcon(icon, width: 7.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: selected ? AppColors.primaryColor : Colors.white,
                fontSize: 9.sp,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconPng(
      String title, String icon, bool selected, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 20.w,
        height: 10.h,
        color: selected ? AppColors.yellowAccent : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            getPngIcon(icon, width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 0.2.h),
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    color: selected ? AppColors.primaryColor : Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
