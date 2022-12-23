import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widget/base_drawer_appbar_screen.dart';
import '../../widget/user_top_bar.dart';
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
          _buildEnroll(),
          _buildLearnCaption(),
          _buildLearnList(body.popularInstructors),
          _buildComplementary(),
          _buildComplementaryList(),
          _buildRecentCaption(),
          _buildRecentList(body.featuredCourses),
          _buildTestimonialCaption(),
          _buildTestimonialList(body.popularInstructors),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildUser() {
    return Padding(
      padding: EdgeInsets.only(right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
      child: const UserTopBar(),
    );
  }

  Widget _buildOngoing() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner_image.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ongoing',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black,
              fontFamily: kFontFamily,
            ),
          ),
          SizedBox(height: 0.7.h),
          Text(
            'Photoshop Beginners:\nZero to Hero',
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 1.h),
          Text(
            '15/25 Lessons',
            style: TextStyle(
                fontFamily: kFontFamily, fontSize: 12.sp, color: Colors.black),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.white,
                  fontSize: 10.sp),
              elevation: 0.0,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
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
              child: Text(
                S.current.blearn_btx_viewall,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: AppColors.primaryColor,
                ),
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
      height: 38.h,
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
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
            ),
            child: Container(
              padding: EdgeInsets.all(3.w),
              width: 25.h,
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
                  Container(
                    width: 12.w,
                    height: 12.w,
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
    return Container(
      color: Colors.white,
      child: ListView.builder(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
          itemCount: courses.length,
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
      height: 18.h,
      color: Colors.white,
      child: ListView.builder(
          padding: EdgeInsets.all(0.5.h),
          itemCount: instructors.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final instructor = instructors[index];
            return Container(
              width: 70.w,
              margin: EdgeInsets.only(top: 0.2.h, left: 4.w),
              child: Center(
                child: InstructorRowItem(instructor: instructor),
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
      margin: EdgeInsets.only(top: 1.5.h),
      height: 29.h,
      color: Colors.white,
      child: ListView.builder(
          padding: EdgeInsets.all(0.5.h),
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
                width: 45.w,
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
                    Column(
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
