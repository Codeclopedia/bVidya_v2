import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widgets.dart';
import 'components/common.dart';
import 'components/course_row.dart';

class CourseListScreen extends StatelessWidget {
  final SubCategory subCategory;
  const CourseListScreen({Key? key, required this.subCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColouredBoxBar(
      topBar: BAppBar(title: subCategory.name ?? 'Courses'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.w),
        child: Consumer(
          builder: (context, ref, child) {
            return ref
                .watch(bLearnCoursesProvider(subCategory.id?.toString() ?? '4'))
                .when(
                  data: (data) {
                    if (data?.courses?.isNotEmpty == true) {
                      return _buildCourseGridList(context, data!.courses!);
                    } else {
                      return buildEmptyPlaceHolder('No Courses found');
                    }
                  },
                  error: (error, stackTrace) {
                    return buildEmptyPlaceHolder('$error');
                  },
                  loading: () => buildLoading,
                );
          },
        ),
      ),
    );
  }

  _buildCourseGridList(BuildContext context, List<Course> courses) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: courses.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.h,
          mainAxisSpacing: 1.h,
          childAspectRatio: 0.75),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteList.bLearnCourseDetail,
                arguments: courses[index]),
            child: CourseRowItem(course: courses[index]));
      },
    );
  }

  _buildCourseList(BuildContext context, List<Course> courses) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: courses.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        Course course = courses[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteList.bLearnCourseDetail);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.all(Radius.circular(3.w)),
              border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // SizedBox(width: 18.w),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    image: DecorationImage(
                      image: getImageProvider(course.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 20.w,
                  height: 20.w,
                  // child: Image(
                  //   image: getImageProvider(
                  //     course.image ?? 'assets/images/dummy_profile.png',
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    course.name,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.black,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
