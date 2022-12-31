import '../../../controller/profile_providers.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';
import '../profile/components/instructor_course_row.dart';
import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/instructors_response.dart';
// import '../profile/components/instructor_course_row.dart';
import '../profile/student/my_learning_screen.dart';
import 'components/common.dart';

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
                                  onSelect: (index) async {
                                    ref
                                        .read(selectedTabLearningProvider
                                            .notifier)
                                        .state = index;
                                    // showLoading(ref);
                                    // final profile = await ref
                                    //     .read(profileRepositoryProvider)
                                    //     .getUserProfile();
                                    // hideLoading(ref);
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
                            selectedIndex == 0
                                ? _buildCoursesList(instructor, ref)
                                : _buildAboutList(instructor, ref)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(
            S.current.teacher_all_courses,
            style: TextStyle(
                fontSize: 5.w,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w400),
          ),
        ),
        ref
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
                loading: () => SizedBox(
                      height: 32.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomizableShimmerTile(
                                height: 30.h, width: 70.w),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomizableShimmerTile(
                                height: 30.h, width: 70.w),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomizableShimmerTile(
                                height: 30.h, width: 70.w),
                          ),
                        ],
                      ),
                    )),
        _buildTestimonialCaption(),
        ref.watch(bLearnInstructorsProvider).when(
              data: (data) {
                return _buildTestimonialList(data?.categories);
              },
              error: (error, stackTrace) => buildEmptyPlaceHolder("Error"),
              loading: () => ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 2.w),
                itemBuilder: (context, index) {
                  return CustomizableShimmerTile(height: 22.h, width: 70.w);
                },
              ),
            ),
      ],
    );
  }

  Widget _buildAboutList(Instructor instructor, WidgetRef ref) {
    return ref.watch(profileUserProvider).when(
        data: (data) {
          if (data == null) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Text(
                  S.current.course_instructor_detail,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 4.7.w,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    getSvgIcon("04.svg", width: 15.w),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        "Worked as ${data.occupation}",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 4.w,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    getSvgIcon("03.svg", width: 15.w),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        "Lives in ${data.city},${data.state}",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 4.w,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    getSvgIcon("02.svg", width: 15.w),
                    SizedBox(
                      width: 70.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          "bvidya Educator since 1st January, 2022",
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 4.w,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    getSvgIcon("01.svg", width: 15.w),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        "Knows ${data.language}",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 4.w,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              _buildTestimonialCaption(),
              ref.watch(bLearnInstructorsProvider).when(
                    data: (data) {
                      return _buildTestimonialList(data?.categories);
                    },
                    error: (error, stackTrace) =>
                        buildEmptyPlaceHolder("Error"),
                    loading: () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 2.w),
                      itemBuilder: (context, index) {
                        return CustomizableShimmerTile(
                            height: 22.h, width: 70.w);
                      },
                    ),
                  ),
            ],
          );
        },
        error: (e, t) => buildEmptyPlaceHolder('text'),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
    //   builder: (context, snapshot) {
    //     Widget widget = snapshot.hasData
    //         ? Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 2.h),
    //                 child: Text(
    //                   S.current.course_instructor_detail,
    //                   style: TextStyle(
    //                       color: AppColors.primaryColor,
    //                       fontSize: 4.7.w,
    //                       fontWeight: FontWeight.w400),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 1.h),
    //                 child: Row(
    //                   children: [
    //                     getSvgIcon("04.svg", width: 15.w),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 4.w),
    //                       child: Text(
    //                         "Worked as ${snapshot.data?.occupation}",
    //                         style: TextStyle(
    //                             color: AppColors.black,
    //                             fontSize: 4.w,
    //                             fontWeight: FontWeight.w400),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 1.h),
    //                 child: Row(
    //                   children: [
    //                     getSvgIcon("03.svg", width: 15.w),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 4.w),
    //                       child: Text(
    //                         "Lives in ${snapshot.data?.city},${snapshot.data?.state}",
    //                         style: TextStyle(
    //                             color: AppColors.black,
    //                             fontSize: 4.w,
    //                             fontWeight: FontWeight.w400),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 1.h),
    //                 child: Row(
    //                   children: [
    //                     getSvgIcon("02.svg", width: 15.w),
    //                     SizedBox(
    //                       width: 70.w,
    //                       child: Padding(
    //                         padding: EdgeInsets.only(left: 4.w),
    //                         child: Text(
    //                           "bvidya Educator since 1st January, 2022",
    //                           style: TextStyle(
    //                               color: AppColors.black,
    //                               fontSize: 4.w,
    //                               fontWeight: FontWeight.w400),
    //                         ),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 1.h),
    //                 child: Row(
    //                   children: [
    //                     getSvgIcon("01.svg", width: 15.w),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 4.w),
    //                       child: Text(
    //                         "Knows ${snapshot.data?.language}",
    //                         style: TextStyle(
    //                             color: AppColors.black,
    //                             fontSize: 4.w,
    //                             fontWeight: FontWeight.w400),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               _buildTestimonialCaption(),
    //               ref.watch(bLearnInstructorsProvider).when(
    //                     data: (data) {
    //                       return _buildTestimonialList(data?.categories);
    //                     },
    //                     error: (error, stackTrace) =>
    //                         buildEmptyPlaceHolder("Error"),
    //                     loading: () => ListView.builder(
    //                       shrinkWrap: true,
    //                       itemCount: 10,
    //                       scrollDirection: Axis.horizontal,
    //                       padding: EdgeInsets.only(left: 2.w),
    //                       itemBuilder: (context, index) {
    //                         return CustomizableShimmerTile(
    //                             height: 22.h, width: 70.w);
    //                       },
    //                     ),
    //                   ),
    //             ],
    //           )
    //         : Center(child: CircularProgressIndicator.adaptive());
    //     return widget;
    //   },
    // );
  }

  Widget _buildTestimonialCaption() {
    return Padding(
      padding: EdgeInsets.only(top: 2.3.h, right: 1.3.h, left: 2.3.h),
      child: Text(
        S.current.blearn_testimonial,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.primaryColor,
          fontFamily: kFontFamily,
        ),
      ),
    );
  }

  Widget _buildTestimonialList(List<Instructor>? instructors) {
    if (instructors == null || instructors.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 0.8.h),
      height: 22.h,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.all(0.5.h),
        itemCount: instructors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final instructor = instructors[index];
          return Container(
            width: 70.w,
            margin: EdgeInsets.only(right: 3.w, left: 2.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
              border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    getCicleAvatar(
                        instructor.name ?? 'AA', instructor.image ?? '',
                        radius: 8.w),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            instructor.name ?? '',
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          buildRatingBar(4.0),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.w),
                Text(
                  instructor.specialization ?? '',
                  maxLines: 4,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
