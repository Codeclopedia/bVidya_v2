import '/controller/profile_providers.dart';
// import 'package:bvidya/data/models/response/profile/instructor_dashboard_response.dart';

import '/ui/widget/base_drawer_setting_screen.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

import '../../../widget/shimmer_tile.dart';
import '../../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import 'teacher_dashboard_screen.dart';

var dataX = [
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

class DashBoardBLiveScreen extends StatelessWidget {
  // final User user;
  const DashBoardBLiveScreen({Key? key
      // , required this.user
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerSettingScreen(
      currentIndex: DrawerMenu.bDashboard,
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: UserConsumer(builder: (context, user, ref) {
          final data = ref.watch(dashboardDetailsProvider);
          return data.when(
              data: (data) {
                return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        S.current.td_dash,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primaryColor,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.w),
                      _buildRevenue(data),
                      SizedBox(height: 4.w),
                      _buildPerformance(
                          data.followers, data.totalWatchtime.toString()),
                      SizedBox(height: 1.w),
                      _buildtwodetailsTile(
                          "Total broadcasts",
                          data.broadcasts.toString(),
                          Icons.broadcast_on_home,
                          "Total meetings",
                          data.meetings.toString(),
                          Icons.video_label_sharp),
                      SizedBox(height: 6.w),
                      _buildUploadedCourse(),
                      SizedBox(height: 2.w),
                      _buildCoursesList(data.courses),
                      SizedBox(height: 4.w),
                      // _buildRunningCourse(),
                      // _buildRunningList(data.webinar)
                    ]);
              },
              error: (_, s) => buildEmptyPlaceHolder(''),
              loading: () => buildDashboardloading());
        }),
      ),
    );
  }

  Widget buildDashboardloading() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Text(
          S.current.td_dash,
          style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.bold),
        ),
        // SizedBox(height: 2.h),
        // CustomizableShimmerTile(height: 40.w, width: 100.w),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomizableShimmerTile(height: 20.w, width: 42.5.w),
            CustomizableShimmerTile(height: 20.w, width: 42.5.w),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          S.current.td_courses,
          style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp),
        ),
        SizedBox(
          height: 2.h,
        ),
        CustomizableShimmerTile(height: 40.w, width: 100.w),
      ],
    );
  }

  Widget _buildRevenue(DashBoardBody dashboardDetails) {
    final List<double> payoutTrend = [];
    int totalpayout = 0;
    dashboardDetails.watchtimeTrends?.forEach(
      (element) {
        final payoutAtTime =
            double.parse(element) * dashboardDetails.payoutRate!;
        payoutTrend.add(payoutAtTime);
        totalpayout = totalpayout + payoutAtTime.round();
      },
    );

    totalpayout = totalpayout + dashboardDetails.personalClassEarning!;
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
                "₹ ${totalpayout.toString()}",
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
                data: payoutTrend,
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

  Widget _buildPerformance(int? followers, String? totalWatchTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        performanceTile(
            data: followers.toString(),
            title: S.current.td_subs,
            icon: Icons.people_outline),
        performanceTile(
            data: totalWatchTime.toString(),
            title: S.current.td_hrs,
            icon: Icons.access_time),
      ],
    );
  }

  Widget _buildtwodetailsTile(
    String title1,
    String data1,
    IconData icon1,
    String title2,
    String data2,
    IconData icon2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        performanceTile(data: data1, title: title1, icon: icon1),
        performanceTile(data: data2, title: title2, icon: icon2),
      ],
    );
  }

  Widget performanceTile(
      {required String data, required String title, required IconData icon}) {
    return SizedBox(
      width: 43.w,
      height: 20.w,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.w),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: kFontFamily,
                          color: AppColors.primaryColor),
                    ),
                    Text(
                      data,
                      // S.current.td_total_subs,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor),
                    ),
                  ],
                )),
          ),
          Positioned(
            right: 0,
            // bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 1.h, right: 3.w),
              child: Icon(
                icon,
                size: 22.w,
                color: const Color(0x08500D34),
                // width: 25.w,
                // fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
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
      ],
    );
  }

  Widget _buildCoursesList(List<Course>? courses) {
    return Container(
        height: 56.w,
        margin: EdgeInsets.only(top: 0.5.h),
        child: courses?.isNotEmpty == true
            ? ListView.builder(
                itemCount: courses!.length,
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteList.bLearnCourseDetail,
                            arguments: courses[index]);
                      },
                      child: InstructorCourseRowItem(course: courses[index]));
                })
            : buildEmptyPlaceHolder('No Courses uploaded yet')

        // Consumer(
        //   builder: (context, ref, child) {
        //     if (user == null) return const SizedBox.shrink();
        //     return ref
        //         .watch(bLearnInstructorCoursesProvider(user.id.toString()))
        //         .when(
        //             data: (data) {
        //               if (data?.isNotEmpty == true) {
        //                 return ListView.builder(
        //                     itemCount: data!.length,
        //                     shrinkWrap: true,
        //                     scrollDirection: Axis.horizontal,
        //                     itemBuilder: (context, index) {
        //                       return CourseListRow(course: data[index]);
        //                     });
        //               } else {
        //                 return buildEmptyPlaceHolder('No Course uploaded');
        //               }
        //             },
        //             error: (_, s) => buildEmptyPlaceHolder('No Course uploaded'),
        //             loading: () => buildLoading);
        //   },
        // ),
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

//   Widget _buildRunningList(List<Webinar>? webinar) {
//     if (webinar?.isNotEmpty == true) {
//       return Container(
//         height: 20.h,
//         color: Colors.grey,
//         child: ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: webinar!.length,
//             itemBuilder: (context, index) {
//               webinar[index];
//               return WebinarListRow(webinar: webinar[index]);
//             }),
//       );
//     } else {}
//     return SizedBox(
//       height: 10.h,
//       // color: Colors.grey,
//       child: buildEmptyPlaceHolder('No Live Courses'),
//     );
//   }
// }
}

// class InstructorCourseRowItem extends StatelessWidget {
//   // final InstructorCourse course;
//   final Course course;
//   const InstructorCourseRowItem({Key? key, required this.course})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 3.w),
//       width: 70.w,
//       height: 30.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(2.3.w)),
//         color: AppColors.cardWhite,
//         border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(2.3.w),
//                 topRight: Radius.circular(2.3.w)),
//             child: Image(
//               image: getImageProvider(course.image ?? ''),
//               height: 14.h,
//               // width: 70.w,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(2.w),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     course.name ?? '',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: kFontFamily,
//                         color: Colors.black),
//                   ),
//                   SizedBox(height: 0.5.h),
//                   Text(
//                     course.description ?? '',
//                     maxLines: 1,
//                     style: TextStyle(
//                         fontFamily: kFontFamily,
//                         fontSize: 9.sp,
//                         color: Colors.black),
//                   ),
//                   SizedBox(height: 0.5.h),
//                   Row(
//                     children: [
//                       Text(
//                         course.rating ?? '',
//                         style: TextStyle(
//                             color: AppColors.yellowAccent,
//                             fontSize: 12.sp,
//                             fontFamily: kFontFamily,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       buildRatingBar(double.parse(course.rating ?? '0.0')),
//                       Text(
//                         '(${course.ratingCount})',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: kFontFamily,
//                           fontSize: 9.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
