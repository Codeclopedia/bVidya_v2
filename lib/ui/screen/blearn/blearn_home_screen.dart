import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widget/base_drawer_appbar_screen.dart';
// import '../../widget/user_top_bar.dart';
import '../../widgets.dart';
import 'components/common.dart';
import 'components/complemetry_course.dart';
import 'components/course_list_row.dart';
import 'components/course_row.dart';
import 'components/instructor_row.dart';

final recommenedSelectedProvider = StateProvider.autoDispose<CourseType>(
  (_) => CourseType.trending,
);

class BLearnHomeScreen extends StatelessWidget {
  const BLearnHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BaseDrawerAppBarScreen(
        routeName: RouteList.bLearnHome,
        topBar: _buildUser(),
        body: Consumer(
          builder: (context, ref, child) {
            return ref.watch(bLearnHomeProvider).when(
                  data: (data) {
                    if (data != null) {
                      return _buildContent(context, data);
                    } else {
                      return buildEmptyPlaceHolder('No Data');
                    }
                  },
                  error: (error, stackTrace) => buildEmptyPlaceHolder('$error'),
                  loading: () => buildLoading,
                );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeBody body) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          _buildOngoing(),
          _buildExploreCaption(context),
          _buildCourses(body.featuredCategories),
          _buildRecommended(),
          _buildCriteriaCaption(),
          _buildCriteriaList(body.popularCourses),
          _buildWebinarTitle(),
          _buildWebinarContent(),
          _buildLearnCaption(),
          _buildLearnList(body.popularInstructors),
          _buildComplementary(),
          _buildComplementaryList(),
          _buildEnroll(),
          _buildRecentCaption(),
          _buildRecentList(body.featuredCourses),
          _buildTestimonialCaption(),
          _buildTestimonialList(body.popularInstructors),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildWebinarTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          SizedBox(
            width: 4.w,
          ),
          const TwoColorText(first: "Upcoming", second: "Webinars"),
        ],
      ),
    );
  }

  Widget _buildWebinarContent() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: SizedBox(
          height: 20.h,
          child: ListView.builder(
            itemCount: 30,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 4.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Container(
                  width: 45.w,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 13.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: getImageProviderFile(
                                      "https://www.cvent.com/sites/default/files/image/2022-02/webinars_news_0.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "One Shot Revision Batch:",
                        style: TextStyle(fontSize: 10.sp),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "One Shot Revision Batch:",
                            style: TextStyle(fontSize: 5.sp),
                          ),
                          Text("Starts in: 00:03:00",
                              style: TextStyle(
                                  fontSize: 5.sp,
                                  color: AppColors.primaryColor))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildUser() {
    return Padding(
      padding: EdgeInsets.only(right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
      child: const UserTopBar(),
    );
  }

  Widget _buildOngoing() {
    return Container(
      height: 42.w,
      width: double.infinity,
      margin: EdgeInsets.only(left: 6.w, right: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 42.w,
              width: double.infinity,
              child: Image.asset(
                "assets/images/banner_image.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 42.w,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white.withOpacity(0.5),
              Colors.transparent
            ])),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ongoing',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.black,
                    fontFamily: kFontFamily,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  'Photoshop Beginners:\nZero to Hero',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 11.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '15/25 Lessons',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      color: Colors.black),
                ),
                SizedBox(height: 2.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontSize: 8.sp),
                    // elevation: 0.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.w)),
                    backgroundColor: const Color(0xFF65427A),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Continue',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCaption(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.blearn_explore,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primaryColor,
                fontFamily: kFontFamily,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.bLearnCategories);
              },
              child: Row(
                children: [
                  Text(
                    S.current.blearn_btx_viewall,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 10.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildCourses(List<FeaturedCategories>? featuredCategories) {
    if (featuredCategories == null || featuredCategories.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 30.h,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
        itemCount: featuredCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final category = featuredCategories[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
            ),
            child: Container(
              padding: EdgeInsets.all(3.w),
              width: 20.h,
              height: 35.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: getImageProvider(category.image ?? ''),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      category.name ?? '',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteList.bLearnSubCategories,
                        arguments: Category(
                            id: category.id,
                            name: category.name,
                            image: category.image)),
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      padding: EdgeInsets.all(3.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFDDDDDD),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                          )
                        ],
                      ),
                      child: getSvgIcon('icon_next.svg'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommended() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
      child: TwoColorText(
        first: S.current.blearn_recommended,
        second: S.current.blearn_byus,
      ),
    );
  }

  Widget _buildCriteriaCaption() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer(
        builder: (context, ref, child) {
          final selected = ref.watch(recommenedSelectedProvider);
          return Container(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: selected == CourseType.trending
                      ? textButtonFilledStyle
                      : textButtonOutlineStyle,
                  onPressed: () {
                    ref.read(recommenedSelectedProvider.notifier).state =
                        CourseType.trending;
                  },
                  child: Text(S.current.blearn_btx_trending),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  style: selected == CourseType.mostViewed
                      ? textButtonFilledStyle
                      : textButtonOutlineStyle,
                  onPressed: () {
                    ref.read(recommenedSelectedProvider.notifier).state =
                        CourseType.mostViewed;
                  },
                  child: Text(S.current.blearn_btx_mostviewed),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  style: selected == CourseType.topCourses
                      ? textButtonFilledStyle
                      : textButtonOutlineStyle,
                  onPressed: () {
                    ref.read(recommenedSelectedProvider.notifier).state =
                        CourseType.topCourses;
                  },
                  child: Text(S.current.blearn_btx_topcourses),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCriteriaList(List<Course>? courses) {
    if (courses == null || courses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Consumer(builder: (context, ref, child) {
      final selected = ref.watch(recommenedSelectedProvider);
      courses.sort(
        (a, b) {
          if (selected == CourseType.trending) {
            return (a.numberOfLesson ?? '').compareTo(b.numberOfLesson ?? '');
          } else if (selected == CourseType.mostViewed) {
            return (b.duration ?? '').compareTo(
                a.duration ?? ''); //TODO convert into minutes and compare
          } else {
            return (b.ratingCount ?? 0).compareTo(a.ratingCount ?? 0);
          }
        },
      );
      return Container(
        color: Colors.white,
        child: ListView.builder(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              Course course = courses[index];
              return InkWell(
                onTap: () => Navigator.pushNamed(
                    context, RouteList.bLearnCourseDetail,
                    arguments: course),
                child: CourseListRow(course: course),
              );
            }),
      );
    });
  }

  Widget _buildEnroll() {
    return Container(
      height: 26.h,
      margin: EdgeInsets.only(top: 2.h),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(3.w)),
        image: DecorationImage(
          image: AssetImage('assets/images/Become-instructor.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildLearnCaption() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
      child: TwoColorText(
        first: S.current.blearn_learnfrom,
        second: S.current.blearn_thebest,
      ),
    );
  }

  Widget _buildLearnList(List<Instructor>? instructors) {
    if (instructors == null || instructors.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      height: 55.w,
      color: Colors.white,
      child: ListView.builder(
          padding: EdgeInsets.all(0.5.h),
          itemCount: instructors.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Instructor instructor = instructors[index];
            return Container(
              margin: EdgeInsets.only(left: 4.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteList.bLearnteacherProfileDetail,
                      arguments: instructor);
                },
                child: Center(
                  child: InstructorRowItem(instructor: instructor),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildComplementary() {
    return Padding(
      padding: EdgeInsets.only(top: 2.3.h, right: 1.3.h, left: 2.3.h),
      child: TwoColorText(
          first: S.current.blearn_complementry,
          second: S.current.blearn_courses),
    );
  }

  Widget _buildComplementaryList() {
    return Container(
      height: 14.h,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.all(0.5.h),
        itemCount: complementryItems.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return const ComplementryCourseItem();
          // final row = complementryItems.entries.elementAt(index);
          // return ComplementryCourseItem(
          //   color: complementryItemsColors[row.key]!,
          //   image: row.value,
          //   title: row.key,
          // );
        },
      ),
    );
  }

  Widget _buildRecentCaption() {
    return Padding(
      padding: EdgeInsets.only(top: 2.3.h, right: 1.3.h, left: 2.3.h),
      child: TwoColorText(
        first: S.current.blearn_recently,
        second: S.current.blearn_added,
      ),
    );
  }

  Widget _buildRecentList(List<Course?>? courses) {
    if (courses == null || courses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 1.5.w),
      height: 50.w,
      color: Colors.white,
      child: ListView.builder(
          padding: EdgeInsets.all(2.w),
          itemCount: courses.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            Course course = courses[index]!;
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.bLearnCourseDetail,
                    arguments: course);
              },
              child: Container(
                // width: 45.w,
                margin: EdgeInsets.only(right: 3.w, left: 2.w),
                child: CourseRowItem(course: course),
              ),
            );
          }),
    );
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
      height: 45.w,
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
