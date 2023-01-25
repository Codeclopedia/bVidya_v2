// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter_svg/svg.dart';

import '/ui/widget/drawer/curved_drawer.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/core/helpers/drag_position.dart';

final currentDrawerIndex = StateProvider<int>((ref) => 5);

class EndDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  // final String myRouteName;
  final int currentIndex;

  const EndDrawer(
      {Key? key,
      required this.scaffoldKey,
      // required this.myRouteName,
      required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildNormalDrawer();
    // return _buildAnimatedDrawer();
  }

  Widget _buildNormalDrawer() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 86.85.h,
          right: 17.5.w,
          child: InkWell(
            onTap: () => scaffoldKey.currentState?.closeEndDrawer(),
            child: SvgPicture.asset(
              'assets/icons/svgs/arc_type1.svg',
              color: currentIndex == DrawerMenu.bChat
                  ? AppColors.yellowAccent
                  : AppColors.drawerBackgroundColor,
              width: 8.w,
              height: 12.h,
            ),
          ),
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
                  children: _drawerItems(ref, context),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDrawer() {
    return Consumer(builder: (context, ref, child) {
      // int selectedIndex = ref.watch(currentDrawerIndex);
      final children = _drawerIcons();
      final List<DrawerItem> items = [];
      int index = 0;
      for (var c in children) {
        items.add(DrawerItem(
          icon: SizedBox(width: 4.w, child: c),
          label: listLables[index],
        ));
        index++;
      }
      return CurvedDrawer(
        index: currentIndex,
        isEndDrawer: true,
        buttonBackgroundColor: AppColors.yellowAccent,
        items: items,
        width: 18.w,
        onTap: (value) async {
          if (currentIndex == value) {
            return;
          }
          scaffoldKey.currentState?.closeEndDrawer();
          final String routeName;
          switch (value) {
            case DrawerMenu.settings:
              routeName = RouteList.settings;
              break;
            case DrawerMenu.profile:
              final user = await getMeAsUser();
              if (user != null) {
                if (user.role == 'instructor' || user.role == 'admin') {
                  routeName = RouteList.teacherProfile;
                } else {
                  routeName = RouteList.studentProfile;
                }
                break;
              } else {
                return;
              }

            case DrawerMenu.bLive:
              routeName = RouteList.bLive;
              break;
            case DrawerMenu.bMeet:
              routeName = RouteList.bMeet;
              break;
            case DrawerMenu.bLearn:
              routeName = RouteList.bLearnHome;
              break;
            case DrawerMenu.bChat:
              routeName = RouteList.home;
              break;
            default:
              return;
          }
          Navigator.pushReplacementNamed(context, routeName);
          // ref.read(currentDrawerIndex.notifier).state = value;
        },
      );
    });
  }

  static final listLables = [
    S.current.drawer_setting,
    S.current.drawer_profile,
    S.current.drawer_blive,
    S.current.drawer_bmeet,
    S.current.drawer_blearn,
    S.current.drawer_bchat,
  ];
  List<Widget> _drawerIcons() {
    return [
      getPngIcon(
        'menu_settings.png',
      ),
      getPngIcon(
        'menu_profile.png',
      ),
      getPngIcon(
        'menu_blive.png',
      ),
      getPngIcon(
        'menu_bmeet.png',
      ),
      getPngIcon(
        'menu_blearn.png',
      ),
      getPngIcon(
        'menu_bchat.png',
      ),
    ];
  }

  List<Widget> _drawerItems(WidgetRef ref, BuildContext context) {
    return [
      _buildIconPng(S.current.drawer_setting, 'menu_settings.png',
          currentIndex == DrawerMenu.settings, () {
        scaffoldKey.currentState?.closeEndDrawer();
        ref
            .read(drawerPositionNotifierProvider.notifier)
            .updatDrawerPositions(RouteList.settings);

        Navigator.pushReplacementNamed(context, RouteList.settings);
      }),
      _buildIconPng(S.current.drawer_profile, 'menu_profile.png',
          currentIndex == DrawerMenu.profile, () async {
        scaffoldKey.currentState?.closeEndDrawer();
        ref
            .read(drawerPositionNotifierProvider.notifier)
            .updatDrawerPositions(RouteList.profile);
        final user = await getMeAsUser();
        if (user != null) {
          //removed to work as  a teacher profile

          // print('user role ${user.role}');
          if (user.role == 'instructor' || user.role == 'admin') {
            Navigator.pushReplacementNamed(context, RouteList.teacherProfile);
          } else {
            Navigator.pushReplacementNamed(context, RouteList.studentProfile);
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
          currentIndex == DrawerMenu.bLive, () {
        scaffoldKey.currentState?.closeEndDrawer();
        if (currentIndex == DrawerMenu.bLive) return;
        ref
            .read(drawerPositionNotifierProvider.notifier)
            .updatDrawerPositions(RouteList.bLive);
        Navigator.pushReplacementNamed(context, RouteList.bLive);
      }),
      _buildIconPng(S.current.drawer_bmeet, 'menu_bmeet.png',
          currentIndex == DrawerMenu.bMeet, () {
        scaffoldKey.currentState?.closeEndDrawer();
        if (currentIndex == DrawerMenu.bMeet) return;
        ref
            .read(drawerPositionNotifierProvider.notifier)
            .updatDrawerPositions(RouteList.bMeet);
        Navigator.pushReplacementNamed(context, RouteList.bMeet);
      }),
      _buildIconPng(S.current.drawer_blearn, 'menu_blearn.png',
          currentIndex == DrawerMenu.bLearn, () {
        scaffoldKey.currentState?.closeEndDrawer();
        if (currentIndex == DrawerMenu.bLearn) return;
        ref
            .read(drawerPositionNotifierProvider.notifier)
            .updatDrawerPositions(RouteList.bLearnHome);
        Navigator.pushReplacementNamed(context, RouteList.bLearnHome);
      }),
      SizedBox(
        width: 20.w,
        height: 9.h,
        child: Stack(children: [
          _buildIconPng(S.current.drawer_bchat, 'menu_bchat.png',
              currentIndex == DrawerMenu.bChat, () {
            scaffoldKey.currentState?.closeEndDrawer();
            if (currentIndex == DrawerMenu.bChat) return;
            ref
                .read(drawerPositionNotifierProvider.notifier)
                .updatDrawerPositions(RouteList.home);
            Navigator.pushReplacementNamed(context, RouteList.home);
          }),
          Positioned(
            right: 5.w,
            top: 0.5.h,
            child: FutureBuilder(
                future: getUnreadCount(),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data! > 0) {
                    return CircleAvatar(
                      backgroundColor: currentIndex == DrawerMenu.bChat
                          ? AppColors.cardWhite
                          : AppColors.yellowAccent,
                      radius: 1.8.w,
                      child: Text(
                        '${snapshot.data!}',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: kFontFamily,
                          fontSize: 6.sp,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          )
        ]),
      )
    ];
  }

  Future<int> getUnreadCount() async {
    try {
      return await ChatClient.getInstance.chatManager.getUnreadMessageCount();
    } catch (e) {}
    return 0;
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
