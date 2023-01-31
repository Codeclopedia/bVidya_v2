import 'package:bvidya/ui/screens.dart';

import '/ui/screen/blearn/components/request_class_form.dart';
import '/ui/widget/sliding_tab.dart';
import '/data/models/models.dart';
import '/core/constants/route_list.dart';

import '../../widgets.dart';

import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'components/common.dart';

final teacherOccupation = StateProvider.autoDispose<String>((ref) => '');

final selectedTabTeacherDetailsProvider =
    StateProvider.autoDispose<int>((ref) => 0);

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
                height: double.infinity,
                margin: EdgeInsets.only(top: 9.h),
                padding: EdgeInsets.only(top: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.w),
                      topLeft: Radius.circular(10.w)),
                ),
                child: SingleChildScrollView(
                  child: Consumer(builder: (context, ref, child) {
                    return ref
                        .watch(bLearnProfileProvider(instructor.id.toString()))
                        .when(
                          data: (data) {
                            if (data == null) {
                              return SizedBox(
                                height: 20.h,
                                child: buildEmptyPlaceHolder('No Data'),
                              );
                            }
                            // ref.read(teacherOccupation.notifier).state =
                            //     data.profile?.occupation ?? '';
                            return _buildContent(data, context, ref);
                          },
                          error: (error, stackTrace) =>
                              buildEmptyPlaceHolder('error in loading data'),
                          loading: () => _loading(),
                        );
                  }),
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
                                image: getImageProvider(instructor.image ?? ''),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: 2.w,
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
                        child: instructor.occupation == null
                            ? Consumer(
                                builder: (context, ref, child) {
                                  return Text(
                                    ref.watch(teacherOccupation),
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 2.5.w,
                                        fontWeight: FontWeight.w500),
                                  );
                                },
                              )
                            : Text(
                                instructor.occupation ?? '',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 2.5.w,
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                      Text(
                        S.current
                            .teacher_exp_value(instructor.experience ?? '0'),
                        // "${instructor.experience??''}${S.current.teacher_exp.replaceAll("7", "")}",
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

  Widget _buildContent(
      ProfileDetailBody body, BuildContext context, WidgetRef ref) {
    // if (body.followers?.isNotEmpty == true) {
    //   follwersCount = (body.followers?[0].count ?? 0).toString();
    // }

    // if (body.watchtime?.isNotEmpty == true) {
    //   watchTotal = (body.watchtime?[0].total ?? '0');
    // }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 6.w, left: 6.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    body.followersCount.toString(),
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
                    body.totalWatchtime ?? "",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 4.5.w),
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
                  onPressed: () async {
                    showLoading(ref);
                    await ref
                        .read(bLearnRepositoryProvider)
                        .followInstructor(instructor.id.toString());
                    hideLoading(ref);
                    ref.refresh(
                        bLearnProfileProvider(instructor.id.toString()));
                    // ref.refresh(isFollowedInstructor(
                    //     instructor.id.toString()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: body.isFollowed ?? false
                          ? AppColors.iconGreyColor
                          : AppColors.primaryColor),
                  child: body.isFollowed ?? false
                      ? Text(S.current.teacher_followed)
                      : Text(S.current.teacher_follow))
              // Consumer(builder: (context, ref, child) {
              //   return ref
              //       .watch(isFollowedInstructor(instructor.id.toString()))
              //       .when(
              //         data: (data) {
              //           return ElevatedButton(
              //               onPressed: () async {
              //                 ref.read(bLearnFollowInstructorProvider(
              //                     instructor.id.toString()));
              //                 ref.refresh(bLearnProfileProvider(
              //                     instructor.id.toString()));
              //                 // ref.refresh(isFollowedInstructor(
              //                 //     instructor.id.toString()));
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   padding: EdgeInsets.zero,
              //                   backgroundColor: body.isFollowed ?? false
              //                       ? AppColors.iconGreyColor
              //                       : AppColors.primaryColor),
              //               child: body.isFollowed ?? false
              //                   ? Text(S.current.teacher_followed)
              //                   : Text(S.current.teacher_follow));
              //         },
              //         error: (error, stackTrace) =>
              //             buildEmptyPlaceHolder('error'),
              //         loading: () => Shimmer.fromColors(
              //           highlightColor: Colors.white,
              //           baseColor: Colors.grey,
              //           child: ElevatedButton(
              //               onPressed: () async {
              //                 // ref.read(bLearnFollowInstructorProvider(
              //                 //     instructor.id.toString()));
              //                 // ref.refresh(bLearnProfileProvider(
              //                 //     instructor.id.toString()));
              //                 // ref.refresh(isFollowedInstructor(
              //                 //     instructor.id.toString()));
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   padding: EdgeInsets.zero,
              //                   backgroundColor: AppColors.iconGreyColor),
              //               child: Text("      ")),
              //         ),
              //       );

              //   // return ElevatedButton(
              //   //     onPressed: () async {
              //   //        ref.read(bLearnFollowInstructorProvider(instructor.id.toString()));
              //   //     },
              //   //     child: Text(S.current.teacher_follow));
              // })
            ],
          ),
        ),
        SizedBox(height: 2.h),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestClassForm(
                    instructor: instructor,
                  ),
                ));
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 2.3.h, right: 6.w, left: 6.w),
            height: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.iconGreyColor.withOpacity(0.2),
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
                        S.current.request_class,
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
            final selectedIndex = ref.watch(selectedTabTeacherDetailsProvider);

            return Column(
              children: [
                Center(
                    child: SlidingTab(
                  label1: S.current.sp_tab_course,
                  label2: S.current.teacher_about,
                  selectedIndex: selectedIndex,
                  callback: (index) {
                    ref.read(selectedTabTeacherDetailsProvider.notifier).state =
                        index;
                  },
                )

                    // child: SlideTab(
                    //     initialIndex: selectedIndex,
                    //     containerWidth: 88.w,
                    //     onSelect: (index) async {
                    //       ref
                    //           .read(selectedTabTeacherDetailsProvider.notifier)
                    //           .state = index;
                    //     },
                    //     containerHeight: 6.h,
                    //     direction: Axis.horizontal,
                    //     sliderColor: AppColors.primaryColor,
                    //     containerBorderRadius: 2.w,
                    //     sliderBorderRadius: 2.6.w,
                    //     containerColor: AppColors.cardWhite,
                    //     activeTextStyle: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 9.sp,
                    //       fontWeight: FontWeight.w600,
                    //       fontFamily: kFontFamily,
                    //     ),
                    //     inactiveTextStyle: TextStyle(
                    //       fontSize: 9.sp,
                    //       fontWeight: FontWeight.w600,
                    //       fontFamily: kFontFamily,
                    //       color: Colors.black,
                    //     ),
                    //     texts: [
                    //       S.current.sp_tab_course,
                    //       S.current.teacher_about,
                    //     ]),
                    ),
                selectedIndex == 0
                    ? _buildCoursesList(body.courses)
                    : _buildAboutList(body)
              ],
            );
          },
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildCriteriaList(List<Course>? courses) {
    if (courses == null || courses.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
        // padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
        padding: EdgeInsets.only(left: 6.w, right: 6.w),
        itemCount: courses.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          Course course = Course.fromJson(courses[index].toJson()
            ..addAll({
              'instructor_name': instructor.name,
              'instructor_image': instructor.image,
            }));
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteList.bLearnCourseDetail,
                arguments: course),
            child: InstructorCourseListRow(course: courses[index]),
          );
        });
  }

  Widget _buildCoursesList(List<Course>? courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h, bottom: 2.h),
          child: Text(
            S.current.teacher_all_courses,
            style: textStyleCaption,
          ),
        ),
        _buildAllCourseList(courses),
        if (courses?.isNotEmpty == true) buildmostViewedTitle(),
        if (courses?.isNotEmpty == true) _buildCriteriaList(courses)
      ],
    );
  }

  Widget _loading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomizableShimmerTile(height: 10.w, width: 90.w),
          SizedBox(
            height: 5.w,
          ),
          CustomizableShimmerTile(height: 15.w, width: 90.w),
          SizedBox(
            height: 5.w,
          ),
          CustomizableShimmerTile(height: 15.w, width: 60.w),
          SizedBox(
            height: 3.w,
          ),
          SizedBox(
            height: 32.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomizableShimmerTile(height: 25.w, width: 35.w),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomizableShimmerTile(height: 25.w, width: 35.w),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomizableShimmerTile(height: 25.w, width: 35.w),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.w),
          CustomizableShimmerTile(height: 15.w, width: 90.w),
          SizedBox(height: 3.w),
          CustomizableShimmerTile(height: 15.w, width: 90.w),
          SizedBox(height: 3.w),
          CustomizableShimmerTile(height: 15.w, width: 90.w),
          SizedBox(height: 3.w),
          CustomizableShimmerTile(height: 15.w, width: 90.w),
        ],
      ),
    );
  }

  Widget _buildAllCourseList(List<Course>? courses) {
    if (courses == null || courses.isEmpty) {
      return buildEmptyPlaceHolder('No Courses');
    }
    return SizedBox(
      height: 28.h,
      child: ListView.builder(
          itemCount: courses.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 6.w, right: 6.w),
          // physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            Course course = courses[index];

            // Course course = courses[index] as Course;
            return InkWell(
              onTap: () => Navigator.pushNamed(
                  context, RouteList.bLearnCourseDetail,
                  arguments: course),
              child: InstructorProfileCourseRowItem(course: course),
            );
          }),
    );
  }

  Widget _buildInstructorDetail(Profile? profile) {
    if (profile == null) {
      return SizedBox(
        height: 12.h,
        child: const Text('No Data'),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getSvgIcon("04.svg", width: 15.w),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "Worked as ${profile.occupation ?? '(Unknown)'}",
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getSvgIcon("03.svg", width: 15.w),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "Lives in ${profile.city ?? '(Unknown)'},${profile.state ?? ''}",
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getSvgIcon("02.svg", width: 15.w),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "bvidya Educator since 1st January, 2022",
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getSvgIcon("01.svg", width: 15.w),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "Knows ${profile.language ?? '(Unknown)'}",
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAboutList(ProfileDetailBody? profileBody) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.only(top: 2.3.h, right: 6.w, left: 6.w),
          child: Text(
            S.current.course_instructor_detail,
            style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 4.7.w,
                fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 2.h),
        _buildInstructorDetail(profileBody?.profile),
        SizedBox(height: 1.h),
        _buildTestimonialCaption(),
        _buildTestimonialList(profileBody?.courseFeedbacks),
      ],
    );
  }
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

Widget _buildTestimonialList(List<CourseFeedback>? feedbackList) {
  if (feedbackList == null || feedbackList.isEmpty) {
    return SizedBox(
        height: 22.h,
        child: Center(child: buildEmptyPlaceHolder("No Testimonials.")));
  }
  return Container(
    margin: EdgeInsets.only(top: 0.8.h),
    height: 22.h,
    color: Colors.white,
    child: ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.5.h),
      itemCount: feedbackList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final feedbackData = feedbackList[index];
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
                      feedbackData.name ?? 'AA', feedbackData.image ?? '',
                      radius: 8.w),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          feedbackData.name ?? '',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: kFontFamily,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        buildRatingBar(feedbackData.rating?.toDouble() ?? 3.0),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.w),
              Text(
                feedbackData.comment ?? '',
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

Widget buildmostViewedTitle() {
  return Padding(
    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h, bottom: 2.h),
    // padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Text(S.current.teacher_most_viewed, style: textStyleCaption),
  );
}

Widget buildAllCoursesShimmer() {
  return SizedBox(
    height: 32.h,
    child: ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 30.h, width: 70.w),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 30.h, width: 70.w),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 30.h, width: 70.w),
        ),
      ],
    ),
  );
}

class InstructorProfileCourseRowItem extends StatelessWidget {
  final Course course;
  // final Course course;
  const InstructorProfileCourseRowItem({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: 40.w,
      // height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.3.w)),
        color: AppColors.cardWhite,
        border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.3.w),
                topRight: Radius.circular(2.3.w)),
            child: Image(
              image: getImageProvider(course.image ?? ''),
              height: 14.h,
              // width: 70.w,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    course.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: kFontFamily,
                        color: Colors.black),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    course.description ?? '',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 7.sp,
                        color: Colors.black),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        course.rating ?? '',
                        style: TextStyle(
                            color: AppColors.yellowAccent,
                            fontSize: 9.sp,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                      buildRatingBar(double.parse(course.rating ?? '0.0')),
                      Text(
                        '(${course.ratingCount})',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: kFontFamily,
                          fontSize: 7.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstructorCourseListRow extends StatelessWidget {
  final Course course;
  const InstructorCourseListRow({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
        border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
      ),
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3.w),
              child: Image(
                image: getImageProvider(course.image ?? ''),
                height: 7.5.h,
                width: 7.5.h,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    course.duration ?? '',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    course.name ?? '',
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 3.5.w,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.play_arrow,
                size: 4.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3.w),
          ],
        ),
      ),
    );
  }
}
