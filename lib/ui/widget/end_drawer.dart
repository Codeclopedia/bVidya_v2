// ignore_for_file: use_build_context_synchronously

import 'package:flutter_svg/flutter_svg.dart';

import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/core/helpers/drag_position.dart';

class EndDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String myRouteName;

  const EndDrawer(
      {Key? key, required this.scaffoldKey, required this.myRouteName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final drag = ref.watch(drawerPositionNotifierProvider);
              return Positioned(
                top: drag.arcTop,
                right: drag.arcRight,
                child: SafeArea(
                  top: false,
                  child: InkWell(
                    onTap: () => scaffoldKey.currentState?.closeEndDrawer(),
                    child: SvgPicture.asset(
                      'assets/icons/svgs/arc_drawer.svg',
                      color: AppColors.yellowAccent,
                      width: 7.w,
                      height: 12.h,
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 20.w,
              height: double.infinity,
              color: AppColors.drawerBackgroundColor,
              child: Consumer(builder: (context, ref, child) {
                return SafeArea(
                  child: Column(
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

                        Navigator.pushNamed(context, RouteList.settings);
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
                          // print('user role ${user.role}');
                          if (user.role == 'teacher' || user.role == 'admin') {
                            Navigator.pushNamed(
                                context, RouteList.teacherProfile);
                          } else {
                            Navigator.pushNamed(
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
                        height: 8.h,
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
                            right: 3.w,
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
                  ),
                );
              }),
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
        height: 8.h,
        color: selected ? AppColors.yellowAccent : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            getPngIcon(icon, width: 7.w),
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
}
