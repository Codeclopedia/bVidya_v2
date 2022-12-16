import 'package:flutter_svg/svg.dart';

import '../../core/constants/route_list.dart';
import '../../core/ui_core.dart';
import '../widgets.dart';

class HomeDrawerScreen extends StatefulWidget {
  //
  final Widget topBar;
  final Widget body;
  final String routeName;

  const HomeDrawerScreen(
      {super.key, required this.topBar, required this.body,required  this.routeName});

  @override
  State<HomeDrawerScreen> createState() => _HomeDrawerScreenState();
}

class _HomeDrawerScreenState extends State<HomeDrawerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    // final isOpen = ref.watch(drawerOpenProvider);
    return Scaffold(
      key: _scaffoldKey,
      drawerScrimColor: Colors.transparent,
      drawerEdgeDragWidth: 20.w,
      onEndDrawerChanged: (isOpened) {
        setState(() {
          _isDrawerOpen = isOpened;
        });
        // ref.read(drawerOpenProvider.notifier).state = isOpened;
      },
      endDrawer: EndDrawer(
        scaffoldKey: _scaffoldKey,
        myRouteName: widget.routeName ,
      ),
      body: ColouredBoxBar(
        topBar: widget.topBar,
        // home: true,
        body: Stack(
          children: [
            widget.body,
            if (!_isDrawerOpen)
              Positioned(
                top: 53.h,
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
              ),
          ],
        ),
      ),
    );
  }
}
