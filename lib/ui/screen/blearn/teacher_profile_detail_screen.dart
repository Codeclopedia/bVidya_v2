import 'package:bvidya/ui/screen/profile/components/instructor_course_row.dart';

import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/instructors_response.dart';
import '../../widget/tab_switcher.dart';
// import '../profile/components/instructor_course_row.dart';
import '../profile/student/my_learning_screen.dart';
import 'components/common.dart';
import 'components/instructor_course_tile.dart';

class TeacherProfileDetailScreen extends StatelessWidget {
  final Instructor instructor;
  const TeacherProfileDetailScreen({super.key, required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTopColor,
              AppColors.gradientLiveBottomColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 9.h),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.w),
                      topLeft: Radius.circular(10.w)),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "2k",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.w),
                              ),
                              Text(
                                S.current.teacher_followers,
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 3.w),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "100",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.w),
                              ),
                              Text(
                                S.current.teacher_watch,
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 3.w),
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(S.current.teacher_follow))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: SizedBox(
                        height: 10.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 6.w,
                              backgroundColor:
                                  AppColors.iconGreyColor.withOpacity(0.2),
                              child: Center(
                                child: Icon(
                                  Icons.message,
                                  color: AppColors.primaryColor,
                                  size: 6.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.current.requestclass,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: kFontFamily,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    S.current.t_schedule_class_msg,
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        fontFamily: kFontFamily,
                                        fontWeight: FontWeight.w200,
                                        color: AppColors.iconGreyColor),
                                  ),
                                ],
                              ),
                            ),
                            // const Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 7.w,
                              color: AppColors.iconGreyColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final selectedIndex =
                            ref.watch(selectedTabLearningProvider);

                        return Column(
                          children: [
                            Center(
                              child: SlideTab(
                                  initialIndex: selectedIndex,
                                  containerWidth: 88.w,
                                  onSelect: (index) {
                                    ref
                                        .read(selectedTabLearningProvider
                                            .notifier)
                                        .state = index;
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
                                    S.current.teacher_about,
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 1.h),
                              child: selectedIndex == 0
                                  ? _buildCoursesList(instructor, ref)
                                  : Text("About"),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg', color: Colors.white),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Column(
                    children: [
                      Container(
                        height: 12.5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: getImageProvider(
                                    instructor.image.toString()),
                                fit: BoxFit.cover)),
                      ),
                      Text(
                        instructor.name.toString(),
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 4.w,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          instructor.occupation.toString(),
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 2.5.w,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        "${instructor.experience.toString()}${S.current.teacher_exp.replaceAll("7", "")}",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 2.5.w,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
              // _buildHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesList(Instructor instructor, WidgetRef ref) {
    // return Consumer(
    //   builder: (context, ref, child) {
    // final data =
    //     ref.watch(bLearnInstructorCoursesProvider(instructor.id.toString()));
    return ref
        .watch(bLearnInstructorCoursesProvider(instructor.id.toString()))
        .when(
          data: (courses) {
            if (courses == null) {
              return const SizedBox.shrink();
            }

            return Container(
                height: 30.h,
                margin: EdgeInsets.only(top: 0.5.h),
                child: courses.isNotEmpty == true
                    ? ListView.builder(
                        itemCount: courses.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InstructorCourseRowItem(
                              course: courses[index]);
                        })
                    : buildEmptyPlaceHolder('No Cources uploaded yet'));
          },
          error: (error, stackTrace) => buildEmptyPlaceHolder("Error"),
          loading: () => buildLoading,
        );
  }
}
