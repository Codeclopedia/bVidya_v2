import '../../core/constants.dart';
import '../../core/ui_core.dart';

class ColouredBoxBar extends StatelessWidget {
  final Widget topBar;
  final Widget body;
  final double? topSize;

  const ColouredBoxBar({
    Key? key,
    required this.topBar,
    required this.body,
    this.topSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gradientBottomColor,
      child: _option1(),
    );
  }

  // Widget _option2() {
  //   bool custom = topSize != null;
  //   return Stack(
  //     children: [
  //       Container(
  //         height: topSize ?? 22.h,
  //         decoration: const BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               AppColors.gradientTopColor,
  //               AppColors.gradientBottomColor,
  //             ],
  //           ),
  //         ),
  //       ),
  //       CustomScrollView(
  //         shrinkWrap: true,
  //         controller: ScrollController(),
  //         slivers: [
  //           SliverAppBar(
  //             backgroundColor: Colors.transparent,
  //             expandedHeight: custom ? (topSize! * 1) : 12.h,
  //             collapsedHeight: custom ? (topSize!) : 7.h,
  //             toolbarHeight: custom ? (topSize!) : 7.h,
  //             stretch: true,
  //             // pinned: custom,
  //             automaticallyImplyLeading: false,
  //             flexibleSpace: SafeArea(child: topBar),
  //           ),
  //           SliverFillRemaining(
  //             hasScrollBody: true,
  //             // fillOverscroll: false,
  //             child: Container(
  //               width: 100.w,
  //               height: double.infinity,
  //               // padding: EdgeInsets.only(top: 1.h),
  //               decoration: boxDecorationTopRound,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(10.w),
  //                   topRight: Radius.circular(10.w),
  //                 ),
  //                 child: body,
  //               ),
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }

  Widget _option1() {
    return Stack(
      children: [
        Container(
          height: topSize ?? 16.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.gradientTopColor,
                AppColors.gradientBottomColor,
              ],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              topBar,
              Expanded(
                child: Container(
                  width: 100.w,
                  height: double.infinity,
                  // padding: EdgeInsets.only(top: 1.h),
                  decoration: boxDecorationTopRound,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      topRight: Radius.circular(10.w),
                    ),
                    child: body,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
