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
      width: 28.w,
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final drag = ref.watch(drawerPositionNotifierProvider);
              return Positioned(
                top: drag.arcTop,
                right: drag.arcRight,
                child: InkWell(
                  onTap: () => scaffoldKey.currentState?.closeEndDrawer(),
                  child: SvgPicture.asset(
                    'assets/icons/svgs/arc.svg',
                    width: 8.w,
                    height: 32.w,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 20.w,
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
                      _buildIcon(
                          S.current.drawer_setting, 'icons8-settings.svg', () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.settings);

                        Navigator.pushNamed(context, RouteList.settings);
                      }),
                      _buildIcon(S.current.drawer_profile, 'ic_Profile.svg',
                          () async {
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
                      _buildIcon(S.current.drawer_disucss, 'ic_Community.svg',
                          () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bDiscuss);
                      }),
                      _buildIcon(S.current.drawer_forum, 'ic_Forum.svg', () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bForum);
                      }),
                      _buildIcon(S.current.drawer_blive, 'ic_blive.svg', () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bLive) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bLive);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bLive);
                      }),
                      _buildIcon(S.current.drawer_bmeet, 'ic_bmeet.svg', () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bMeet) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bMeet);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bMeet);
                      }),
                      _buildIcon(S.current.drawer_blearn, 'ic_blearn.svg', () {
                        scaffoldKey.currentState?.closeEndDrawer();
                        if (myRouteName == RouteList.bLearnHome) return;
                        ref
                            .read(drawerPositionNotifierProvider.notifier)
                            .updatDrawerPositions(RouteList.bLearnHome);
                        Navigator.pushReplacementNamed(
                            context, RouteList.bLearnHome);
                      }),
                      Stack(children: [
                        _buildIcon(S.current.drawer_bchat, 'ic_Bchat.svg', () {
                          scaffoldKey.currentState?.closeEndDrawer();
                          if (myRouteName == RouteList.home) return;
                          ref
                              .read(drawerPositionNotifierProvider.notifier)
                              .updatDrawerPositions(RouteList.home);
                          Navigator.pushReplacementNamed(
                              context, RouteList.home);
                        }),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            backgroundColor: AppColors.yellowAccent,
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

  Widget _buildIcon(String title, String icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          getSvgIcon(icon, width: 7.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.white,
              fontSize: 9.sp,
            ),
          )
        ],
      ),
    );
  }
}
