import '../../../../core/constants.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../widget/courses_circularIndicator.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 3.h),
          Center(
            child: SlideTab(
                initialIndex: selectedIndex,
                containerWidth: 88.w,
                onSelect: (index) {
                  ref.read(selectedTabLearningProvider.notifier).state = index;
                },
                containerHeight: 6.h,
                direction: Axis.horizontal,
                sliderColor: AppColors.primaryColor,
                containerBorderRadius: 2.w,
                sliderBorderRadius: 2.6.w,
                containerColor: AppColors.cardWhite,
                activeTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: kFontFamily,
                ),
                inactiveTextStyle: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
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
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Container(
                height: 25.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 18.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: Text(
                                "Course name: Course name and details",
                                style: TextStyle(
                                    fontSize: 4.6.w,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const CoursesCircularIndicator(
                              progressValue: 65,
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: AppColors.drawerBackgroundColor,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 0.5.w),
                                child: const Text(
                                  "0 Hours left",
                                  style: TextStyle(
                                      color: AppColors.drawerBackgroundColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: AppColors.drawerBackgroundColor,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 0.5.w),
                                child: const Text(
                                  "Continue learning",
                                  style: TextStyle(
                                      color: AppColors.drawerBackgroundColor),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildFollowed() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            height: 10.h,
            width: 100.w,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 7.w,
                  backgroundImage:
                      AssetImage("assets/images/dummy_profile.png"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                            fontSize: 4.5.w, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.3.h),
                        child: Text(
                          "1000 followers",
                          style: TextStyle(
                              fontSize: 3.w, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
