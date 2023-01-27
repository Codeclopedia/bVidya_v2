import 'package:bvidya/core/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/core/helpers/drag_position.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'end_drawer.dart';
import 'floating_draggable_widget.dart';

final drawerStateProvider = StateProvider<bool>((ref) => false);
final drawerPositionProvider =
    StateProvider<List<double>>((ref) => [75.w, 85.h]);

class BaseDrawerPage extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  const BaseDrawerPage(
      {Key? key, required this.body, required this.currentIndex})
      : super(key: key);

  @override
  State<BaseDrawerPage> createState() => _BaseDrawerPageState();
}

class _BaseDrawerPageState extends State<BaseDrawerPage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isDrawerOpen = ref.watch(drawerStateProvider);
      return _buildScreen(isDrawerOpen, ref);
    });
  }

  Widget _screenContent(WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.transparent,
      drawerEdgeDragWidth: 20.w,
      endDrawer: EndDrawer(
        currentIndex: widget.currentIndex,
        scaffoldKey: _scaffoldKey,
        // myRouteName: widget.screenName,
      ),
      onEndDrawerChanged: (isOpened) {
        ref.read(drawerStateProvider.notifier).state = isOpened;
      },
      body: widget.body,
      // body: Stack(children: [
      //   widget.body,
      //   Visibility(
      //     visible: !isDrawerOpen,
      //     child: _toggler(_scaffoldKey),
      //   )
      // ]),
    );
  }

  Widget _buildScreen(bool isOpen, WidgetRef ref) {
    final intialPos = ref.read(drawerPositionProvider);
    return FloatingDraggableWidget(
      floatingWidget: isOpen
          ? const SizedBox.shrink()
          : FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: Icon(Icons.menu, size: 5.w),
            ),
      floatingWidgetHeight: 15.w,
      floatingWidgetWidth: 15.w,
      dx: intialPos[0],
      dy: intialPos[1],
      onDragEnd: (x, y) {
        ref.read(drawerPositionProvider.notifier).state = [x, y];
      },

      // deleteWidgetDecoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [Colors.white12, Colors.grey],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     stops: [.0, 1],
      //   ),
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(50),
      //     topRight: Radius.circular(50),
      //   ),
      // ),
      // deleteWidget: Container(
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     border: Border.all(width: 2, color: Colors.black87),
      //   ),
      //   child: const Icon(Icons.close, color: Colors.black87),
      // ),
      // onDeleteWidget: () {
      //   debugPrint('Widget deleted');
      // },
      mainScreenWidget: _screenContent(ref),
    );
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
