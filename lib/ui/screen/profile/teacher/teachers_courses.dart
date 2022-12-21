import '../base_settings_noscroll.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../widgets.dart';

final selectedTabTeacherCourseProvider = StateProvider<int>((ref) => 0);

class CoursesTeachersUi extends ConsumerWidget {
  const CoursesTeachersUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.read(selectedTabTeacherCourseProvider);
    return BaseNoScrollSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildInfo(),
            _buildViews(),
            _buildTab(ref, selectedIndex),
            // _buildTabs((result) {
            //   setState(() {
            //     _isSelected = result;
            //   });
            // }),
            Expanded(
                child:
                    selectedIndex == 0 ? _buildAllCourses() : _buildCourses())
            // _buildAllCourses(),
            //_buildTeachers(),
            // _buildCourses()
          ]),
    );
  }

  Widget _buildInfo() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "${S.current.teacher_sub} | ${S.current.teacher_prep} | ",
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 12.sp,
                    color: Colors.black),
              ),
              Text(
                S.current.teacher_exp,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 12.sp,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViews() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                S.current.teacher_folowers_no,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 13.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                S.current.teacher_followers,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 13.sp,
                    color: Colors.black),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                S.current.teacher_watch_time,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 13.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                S.current.teacher_watch,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 13.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 4.6.h,
              width: 30.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3.w)),
                  color: AppColors.primaryColor),
              child: Text(
                S.current.teacher_follow,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 12.sp,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(WidgetRef ref, int selectedIndex) {
    return Center(
      child: SlideTab(
          initialIndex: selectedIndex,
          containerWidth: 80.w,
          onSelect: (index) {
            ref.read(selectedTabTeacherCourseProvider.notifier).state = index;
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
            S.current.course_header,
            S.current.teacher_about,
          ]),
    );
  }
  // Widget _buildTabs(Function(bool) onclick) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 3.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: InkWell(
  //             onTap: () {
  //               setState(() {
  //                 _isSelected = true;
  //               });
  //             },
  //             child: Container(
  //               alignment: Alignment.center,
  //               height: 5.5.h,
  //               width: 15.w,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(3.w),
  //                       bottomLeft: Radius.circular(3.w)),
  //                   color: _isSelected ? colorSelect : colorUnSelect),
  //               child: Text(
  //                 S.current.course_header,
  //                 style: _isSelected ? textStyleSelect : textStyleUnselect,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: InkWell(
  //             onTap: () {
  //               setState(() {
  //                 _isSelected = false;
  //               });
  //             },
  //             child: Container(
  //               alignment: Alignment.center,
  //               height: 5.5.h,
  //               width: 15.w,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(3.w),
  //                     bottomRight: Radius.circular(3.w)),
  //                 color: _isSelected ? colorUnSelect : colorSelect,
  //               ),
  //               child: Text(
  //                 S.current.teacher_about,
  //                 style: _isSelected ? textStyleUnselect : textStyleSelect,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAllCourses() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.teacher_all_courses,
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 12.sp,
                color: AppColors.cardWhite,
                fontWeight: FontWeight.bold),
          ),
          Text(
            S.current.teacher_view_all,
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 9.sp,
                color: AppColors.primaryColor,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMostViewed() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.teacher_most_viewed,
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 12.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachers() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(0.5.h),
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 7.h,
                    width: 15.1.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7.h)),
                        color: Colors.grey),
                    child: Image.asset(
                      "assets/courses/course_instr_2.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.teachers_username,
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        S.current.teachers_followers,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: kFontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildCourses() {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 10,
          padding: EdgeInsets.all(0.5.h),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Container(
                padding: EdgeInsets.all(1.h),
                height: 20.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    color: Colors.grey[300]),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          S.current.course_title,
                          style: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      height: 0.2.h,
                      width: 100.w,
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getSvgIcon('courses/course_timer.svg',
                                height: 2.h, width: 4.w),
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              child: Text(
                                S.current.course_timer,
                                style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 10.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getSvgIcon('courses/course_play.svg',
                                height: 1.h, width: 3.w),
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              child: Text(
                                S.current.course_conti,
                                style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 10.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
