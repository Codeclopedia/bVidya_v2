import 'package:flutter_svg/flutter_svg.dart';

import '/core/helpers/drag_position.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'end_drawer.dart';

final drawerStateProvider = StateProvider<bool>((ref) => false);

class BaseDrawerPage extends StatelessWidget {
  final Widget body;
  final String screenName;
  BaseDrawerPage({Key? key, required this.body, required this.screenName})
      : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isDrawerOpen = ref.watch(drawerStateProvider);
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        drawerEdgeDragWidth: 20.w,
        endDrawer: EndDrawer(
          scaffoldKey: _scaffoldKey,
          myRouteName: screenName,
        ),
        onEndDrawerChanged: (isOpened) {
          // ref.read(drawerStateProvider.notifier).state = isOpened;
        },
        body: Stack(children: [
          body,
          Visibility(
            visible: !isDrawerOpen,
            child: _toggler(_scaffoldKey),
          )
        ]),
      );
    });
  }

  Widget _toggler(GlobalKey<ScaffoldState> key) {
    return Consumer(builder: (context, ref, child) {
      final drag = ref.watch(drawerPositionNotifierProvider);
      return Positioned(
        top: drag.iconTop,
        right: -10.0, //+ drag.arcRight,
        child: GestureDetector(
          onTap: () => key.currentState?.openEndDrawer(),
          child: SvgPicture.asset(
            'assets/icons/svgs/drawer.svg',
            width: 15.w,
            height: 42.w,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
