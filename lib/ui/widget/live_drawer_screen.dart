import 'package:flutter_svg/svg.dart';

import '../../core/ui_core.dart';
import '../widgets.dart';

class LiveDrawerScreen extends StatefulWidget {
  final Widget body;
  final Widget? anotherContent;
  final String screenName;
  const LiveDrawerScreen(
      {Key? key,
      required this.body,
      this.anotherContent,
      required this.screenName})
      : super(key: key);

  @override
  State<LiveDrawerScreen> createState() => _LiveDrawerScreenState();
}

class _LiveDrawerScreenState extends State<LiveDrawerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.transparent,
      drawerEdgeDragWidth: 20.w,
      endDrawer: EndDrawer(
        scaffoldKey: _scaffoldKey,
        myRouteName: widget.screenName,
      ),
      onEndDrawerChanged: (isOpened) {
        setState(() {
          _isDrawerOpen = isOpened;
        });
        // ref.read(drawerLiveOpenProvider.notifier).state = isOpened;
      },
      body: Stack(children: [
        if (widget.anotherContent != null) widget.anotherContent!,
        widget.body,
        if (!_isDrawerOpen) _toggler(),
      ]),
    );
  }

  Widget _toggler() {
    return Positioned(
      top: 66.h,
      right: -10.0,
      child: InkWell(
        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
        child: SvgPicture.asset(
          'assets/icons/svgs/drawer.svg',
          width: 15.w,
          height: 42.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
