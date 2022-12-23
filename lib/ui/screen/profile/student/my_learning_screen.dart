import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../widget/tab_switcher.dart';
import '../base_settings_noscroll.dart';

final selectedTabLearningProvider = StateProvider<int>((ref) => 0);

class MyLearningScreen extends ConsumerWidget {
  const MyLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabLearningProvider);
    return Scaffold(
      body: BaseNoScrollSettings(
          bodyContent: Column(
        children: [
          SizedBox(height: 3.h),
          Center(
            child: SlideTab(
                initialIndex: selectedIndex,
                containerWidth: 80.w,
                onSelect: (index) {
                  ref.read(selectedTabLearningProvider.notifier).state = index;
                },
                containerHeight: 6.h,
                sliderColor: AppColors.primaryColor,
                containerBorderRadius: 2.5.w,
                sliderBorderRadius: 2.6.w,
                containerColor: AppColors.cardWhite,
                activeTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: kFontFamily,
                ),
                inactiveTextStyle: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: kFontFamily,
                  color: Colors.black,
                ),
                texts: [
                  S.current.sp_tab_course,
                  S.current.sp_tab_followed,
                ]),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            child: selectedIndex == 0 ? _buildCourses() : _buildFollowed(),
          ))
        ],
      )),
    );
  }

  Widget _buildCourses() {
    return Container(
      color: Colors.black,
    );
  }

  Widget _buildFollowed() {
    return Container(
      color: Colors.red,
    );
  }
}
