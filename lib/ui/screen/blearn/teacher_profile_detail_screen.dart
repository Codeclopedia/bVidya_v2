import '../../../controller/profile_providers.dart';
import '/data/models/models.dart';
import '/core/constants/route_list.dart';
// import '/data/models/response/profile/instructor_profile_response.dart';

import '../../screens.dart';
import '../../widgets.dart';

import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'components/common.dart';

// final recommenedDetailSelectedProvider = StateProvider.autoDispose<CourseType>(
//   (_) => CourseType.trending,
// );

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
                        .watch(bLearnInstructorProfileProvider(
                            instructor.id.toString()))
                        .when(
                          data: (data) {
                            if (data == null) {
                              return SizedBox(
                                height: 20.h,
                                child: buildEmptyPlaceHolder('No Data'),
                              );
                            }
                            return _buildContent(data);
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

  Widget _buildContent(ProfileBody body) {
    String follwersCount = '0';
    if (body.followers?.isNotEmpty == true) {
      follwersCount = (body.followers?[0].count ?? 0).toString();
    }

    String watchTotal = '0';
    if (body.watchtime?.isNotEmpty == true) {
      follwersCount = (body.watchtime?[0].total ?? '');
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 6.w, left: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    follwersCount,
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
                    watchTotal,
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
              Consumer(builder: (context, ref, child) {
                return ref
                    .watch(isFollowedInstructor(instructor.id.toString()))
                    .when(
                      data: (data) {
                        return ElevatedButton(
                            onPressed: data
                                ? null
                                : () async {
                                    ref.read(bLearnFollowInstructorProvider(
                                        instructor.id.toString()));
                                  },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(data
                                        ? AppColors.iconGreyColor
                                        : AppColors.primaryColor)),
                            child: data ? Text(S.current.teacher_followed) : Text(S.current.teacher_follow));
                      },
                      error: (error, stackTrace) =>
                          buildEmptyPlaceHolder('error in loading data'),
                      loading: () => buildLoading,
                    );

                // return ElevatedButton(
                //     onPressed: () async {
                //        ref.read(bLearnFollowInstructorProvider(instructor.id.toString()));
                //     },
                //     child: Text(S.current.teacher_follow));
              })
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
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
        Consumer(
          builder: (context, ref, child) {
            final selectedIndex = ref.watch(selectedTabLearningProvider);

            return Column(
              children: [
                Center(
                  child: SlideTab(
                      initialIndex: selectedIndex,
                      containerWidth: 88.w,
                      onSelect: (index) async {
                        ref.read(selectedTabLearningProvider.notifier).state =
                            index;
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
                    ? _buildCoursesList(body.courses)
                    : _buildAboutList(body.profile)
              ],
            );
          },
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildCoursesList(List<InstructorCourse>? courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        buildmostViewedTitle(),
        _buildCriteriaList(courses)
      ],
    );
  }

  Widget _loading() {
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
                  "Worked as ${profile.occupation}",
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
                  "Lives in ${profile.city},${profile.state}",
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
                  "Knows ${profile.language}",
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

  Widget _buildAboutList(Profile? profile) {
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
        _buildInstructorDetail(profile),
        SizedBox(height: 1.h),
        _buildTestimonialCaption(),
        Consumer(builder: (context, ref, child) {
          return ref.watch(bLearnInstructorsProvider).when(
                data: (data) {
                  return _buildTestimonialList(data?.categories);
                },
                error: (error, stackTrace) => buildEmptyPlaceHolder("Error"),
                loading: () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 2.w),
                  itemBuilder: (context, index) {
                    return CustomizableShimmerTile(height: 22.h, width: 40.w);
                  },
                ),
              );
        }),
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

Widget _buildTestimonialList(List<Instructor>? instructors) {
  if (instructors == null || instructors.isEmpty) {
    return const SizedBox.shrink();
  }
  return Container(
    margin: EdgeInsets.only(top: 0.8.h),
    height: 22.h,
    color: Colors.white,
    child: ListView.builder(
      shrinkWrap: true,
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

Widget _buildAllCourseList(List<InstructorCourse>? courses) {
  if (courses == null || courses.isEmpty) {
    return const SizedBox.shrink();
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
          InstructorCourse course = courses[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteList.bLearnCourseDetail,
                arguments: course),
            child: InstructorProfileCourseRowItem(course: course),
          );
        }),
  );
}

Widget _buildCriteriaList(List<InstructorCourse>? courses) {
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
        InstructorCourse course = courses[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteList.bLearnCourseDetail,
              arguments: course),
          child: InstructorCourseListRow(course: course),
        );
      });
}

class InstructorProfileCourseRowItem extends StatelessWidget {
  final InstructorCourse course;
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
  final InstructorCourse course;
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
