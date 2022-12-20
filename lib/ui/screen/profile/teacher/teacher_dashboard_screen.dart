import 'package:bvidya/core/state.dart';
import 'package:bvidya/ui/screen/blearn/widget/common.dart';
import 'package:bvidya/ui/screen/blearn/widget/course_list_row.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

import '../../../../controller/blearn_providers.dart';
import '../../../../core/constants.dart';
import '../../../../core/ui_core.dart';
import '../../../../data/models/models.dart';
import '../../blearn/widget/webinar_list_row.dart';
import '../base_settings.dart';

var data = [
  1.0,
  0.9,
  1.5,
  2.0,
  0.8,
  1.2,
  0.5,
  1.4,
  0.5,
  0.7,
  0.2,
  0.8,
  2.0,
  -7.0,
];

class TeacherDashboard extends StatelessWidget {
  // final User user;
  const TeacherDashboard({Key? key
      // , required this.user
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Consumer(builder: (context, ref, child) {
          final user = ref.watch(loginRepositoryProvider).user;
          if (user == null) return const SizedBox.shrink();
          final data =
              ref.watch(bLearnInstructorProfileProvider(user.id.toString()));
          return data.when(
              data: (data) {
                if (data == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        S.current.td_dash,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primaryColor,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      _buildRevenue(),
                      SizedBox(height: 2.h),
                      _buildPerformance(data.followers, data.watchtime),
                      SizedBox(height: 3.h),
                      _buildUploadedCourse(),
                      SizedBox(height: 1.h),
                      _buildCoursesList(data.courses),
                      SizedBox(height: 2.h),
                      _buildRunningCourse(),
                      _buildRunningList(data.webinar)
                    ]);
              },
              error: (_, s) => buildEmptyPlaceHolder(''),
              loading: () => buildLoading);
        }),
      ),
    );
  }

  // Widget _buildTitle() {
  //   return Text(
  //     S.current.td_dash,
  //     style: TextStyle(
  //         fontSize: 16.sp,
  //         color: AppColors.primaryColor,
  //         fontFamily: kFontFamily,
  //         fontWeight: FontWeight.bold),
  //   );
  // }

  Widget _buildRevenue() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4.w)),
      child: Container(
        padding: EdgeInsets.only(top: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            color: Colors.grey[300]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 1.5.h),
              child: Text(
                S.current.td_revenue,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: kFontFamily,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 0.5.h),
              child: Text(
                S.current.td_amt,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: kFontFamily,
                    color: AppColors.primaryColor),
              ),
            ),
            SizedBox(height: 4.h),
            Sparkline(
                fallbackHeight: 10.h,
                data: data,
                lineColor: const Color(0xFF6E2FFF),
                useCubicSmoothing: true,
                cubicSmoothingFactor: 0.12,
                fillMode: FillMode.below,
                fillColor: const Color(0xFFDCD0F6))
          ],
        ),
      ),
    );
  }

  Widget _buildPerformance(
      List<Followers>? followers, List<Watchtime>? watchtime) {
    return Row(
      children: [
        SizedBox(
          width: 43.w,
          height: 10.h,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.w),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 2.h),
                            child: Text(
                              S.current.td_subs,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: kFontFamily,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 0.4.h),
                            child: Text(
                              (followers?.isNotEmpty == true)
                                  ? followers![0].count.toString()
                                  : '',
                              // S.current.td_total_subs,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: kFontFamily,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                // bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.h, right: 3.w),
                  child: Icon(
                    Icons.people_outline,
                    size: 22.w,
                    color: const Color(0x08500D34),
                    // width: 25.w,
                    // fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 43.w,
          height: 10.h,
          margin: EdgeInsets.only(left: 2.w),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.w),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 2.h),
                            child: Text(
                              S.current.td_hrs,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  fontFamily: kFontFamily,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 0.4.h),
                            child: Text(
                              (watchtime?.isNotEmpty == true)
                                  ? watchtime![0].total.toString()
                                  : '',
                              // S.current.td_watch_time,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  fontFamily: kFontFamily,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5.w),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.h, right: 3.w),
                  child: Icon(
                    Icons.access_time,
                    size: 18.w,
                    color: const Color(0x08500D34),
                    // width: 25.w,
                    // fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedCourse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.td_courses,
          style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp),
        ),
        TextButton(
          style: textButtonStyle,
          onPressed: () {},
          child: Text(S.current.teacher_view_all),
        ),
      ],
    );
  }

  Widget _buildCoursesList(List<Course>? courses) {
    return Container(
      height: 30.h,
      margin: EdgeInsets.only(top: 0.5.h),
      child: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(loginRepositoryProvider).user;
          if (user == null) return const SizedBox.shrink();
          return ref
              .watch(bLearnInstructorCoursesProvider(user.id.toString()))
              .when(
                  data: (data) {
                    if (data?.isNotEmpty == true) {
                      return ListView.builder(
                          itemCount: data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CourseListRow(course: data[index]);
                          });
                    } else {
                      return buildEmptyPlaceHolder('No Course uploaded');
                    }
                  },
                  error: (_, s) => buildEmptyPlaceHolder('No Course uploaded'),
                  loading: () => buildLoading);
        },
      ),
    );
  }

  Widget _buildRunningCourse() {
    return Text(
      S.current.td_running,
      style: textStyleHeading,
    );

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Text(
    //       S.current.td_running,
    //       style: TextStyle(color: AppColors.primaryColor, fontSize: 16.sp),
    //     ),
    //   ],
    // );
  }

  Widget _buildRunningList(List<Webinar>? webinar) {
    if (webinar?.isNotEmpty == true) {
      return Container(
        height: 20.h,
        color: Colors.grey,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: webinar!.length,
            itemBuilder: (context, index) {
              webinar[index];
              return WebinarListRow(webinar: webinar[index]);
            }),
      );
    } else {}
    return Container(
      height: 20.h,
      color: Colors.grey,
    );
  }
}
