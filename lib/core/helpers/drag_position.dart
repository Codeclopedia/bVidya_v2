import 'package:sizer/sizer.dart';

import '../constants/route_list.dart';
import '../state.dart';

class DrawerPositionModel {
  final double iconTop;
  final double iconRight;
  final double arcTop;
  final double arcRight;

  DrawerPositionModel(this.iconTop, this.iconRight, this.arcTop, this.arcRight);
}

final drawerPositionNotifierProvider =
    StateNotifierProvider<DragNotifier, DrawerPositionModel>(
  (_) => DragNotifier(),
);

class DragNotifier extends StateNotifier<DrawerPositionModel> {
  static final _initialState = DrawerPositionModel(56.h, 0, 82.h, 19.w);

  DragNotifier() : super(_initialState);

  updatDrawerPositions(String currentPage) {
    switch (currentPage) {
      case RouteList.settings:
        _updateState(56.h, 0, 8.h, 19.w);
        break;
      case RouteList.profile:
        _updateState(56.h, 0, 23.h, 19.w);
        break;
      // case RouteList.bDiscuss:
      //   _updateState(56.h, 0, 28.5.h, 19.w);
      //   break;
      // case RouteList.bForum:
      //   _updateState(56.h, 0, 38.h, 19.w);
      //   break;
      case RouteList.bLive:
        _updateState(56.h, 0, 37.5.h, 19.w);
        break;
      case RouteList.bMeet:
        _updateState(56.h, 0, 53.h, 19.w);
        break;
      case RouteList.bLearnHome:
        _updateState(56.h, 0, 68.h, 19.w);
        break;
      case RouteList.home:
        _updateState(56.h, 0, 83.h, 19.w);
        break;
    }
  }

  _updateState(double iconTopPosition, double iconrightPosition,
      double arcTopPosition, double arcrightPosition) {
    state = DrawerPositionModel(
        iconTopPosition, iconrightPosition, arcTopPosition, arcrightPosition);
  }
}

updatDrawerPositions(WidgetRef ref, String currentPage) {}
