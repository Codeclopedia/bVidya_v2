// ignore_for_file: use_build_context_synchronously

import 'package:bvidya/core/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants.dart';
import '../../core/ui_core.dart';

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
          Positioned(
            top: 75.h,
            right: 15.w,
            child: InkWell(
              onTap: () => scaffoldKey.currentState?.closeEndDrawer(),
              child: SvgPicture.asset(
                'assets/icons/svgs/arc.svg',
                width: 8.w,
                height: 32.w,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 20.w,
              color: AppColors.drawerBackgroundColor,
              child: SafeArea(
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
                    _buildIcon(S.current.drawer_setting, 'icons8-settings.svg',
                        () {
                      Navigator.pushNamed(context, RouteList.settings);
                    }),
                    _buildIcon(S.current.drawer_profile, 'ic_Profile.svg',
                        () async {
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
                    _buildIcon(
                        S.current.drawer_disucss, 'ic_Community.svg', () {}),
                    _buildIcon(S.current.drawer_forum, 'ic_Forum.svg', () {}),
                    _buildIcon(S.current.drawer_blive, 'ic_blive.svg', () {
                      if (myRouteName == RouteList.bLive) return;
                      Navigator.pushReplacementNamed(context, RouteList.bLive);
                    }),
                    _buildIcon(S.current.drawer_bmeet, 'ic_bmeet.svg', () {
                      if (myRouteName == RouteList.bMeet) return;
                      Navigator.pushReplacementNamed(context, RouteList.bMeet);
                    }),
                    _buildIcon(S.current.drawer_blearn, 'ic_blearn.svg', () {
                      if (myRouteName == RouteList.bLearnHome) return;
                      Navigator.pushReplacementNamed(
                          context, RouteList.bLearnHome);
                    }),
                    Stack(children: [
                      _buildIcon(S.current.drawer_bchat, 'ic_Bchat.svg', () {
                        if (myRouteName == RouteList.home) return;
                        Navigator.pushReplacementNamed(context, RouteList.home);
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
                ),
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
