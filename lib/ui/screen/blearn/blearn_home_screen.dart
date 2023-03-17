// import '/data/models/response/blearn/blearn_home_response.dart';
// import '/co/blearntopbar.dart';
import 'dart:convert';

import 'package:bvidya/controller/profile_providers.dart';
import 'package:bvidya/core/utils/local_data.dart';
import 'package:bvidya/ui/widget/no_internet_connection_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

import '../../widget/courses_circularIndicator.dart';
import '/core/helpers/blive_helper.dart';
import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widget/base_drawer_appbar_screen.dart';
import '../../widgets.dart';
import 'all_courses_page.dart';
import 'components/blearntopbar.dart';
import 'components/common.dart';
import 'components/course_list_row.dart';
import 'components/course_row.dart';
import 'components/instructor_row.dart';
import 'components/webinar_detail_tile.dart';

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
        currentIndex: DrawerMenu.bLearn,
        routeName: RouteList.bLearnHome,
        topBar: _buildUser(),
        body: Consumer(
          builder: (context, ref, child) {
            ref.read(profileRepositoryProvider).getSubscribeCourses();
            return ref.watch(bLearnHomeProvider).when(
                data: (data) {
                  if (data != null) {
                    return _buildContent(context, data, ref);
                  } else {
                    return FutureBuilder(
                      future: getLocalData('subscribed_courses'),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          Navigator.pushNamed(
                              context, RouteList.noInternetConnection);
                        }
                        final locallySavedCourses =
                            SubscribedCourseBody.fromJson(
                                jsonDecode(snapshot.data ?? ""));
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3.w),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5.w)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("No Internet connection",
                                          style: textStyleBlack.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp)),
                                      SizedBox(width: 1.w),
                                      getLottieIcon("59204-sad-look.json",
                                          width: 5.w)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.w),
                              Text(
                                S.current.blearn_subscribed_courses,
                                style: textStyleHeading,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: locallySavedCourses
                                          .subscribedCourses?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    return rowCourse(
                                        locallySavedCourses
                                            .subscribedCourses?[index],
                                        context,
                                        ref);
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                error: (error, stackTrace) => buildEmptyPlaceHolder('$error'),
                loading: () => buildloadingbar(context));
          },
        ),
      ),
    );
  }

  Widget rowCourse(
      SubscribedCourse? subscribedCourse, BuildContext context, WidgetRef ref) {
    return Container(
      // height: 20.h,
      width: 100.w,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
          color: AppColors.cardWhite,
          border: Border.all(color: AppColors.cardBorder, width: 0.3),
          borderRadius: BorderRadius.circular(3.w)),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      subscribedCourse?.name ?? "",
                      style: TextStyle(
                          fontFamily: kFontFamily,
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp),
                    ),
                  ),
                  CoursesCircularIndicator(
                    progressValue:
                        subscribedCourse?.progress?.toDouble() ?? 0.0,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.divider,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 3.w, right: 3.w, top: 0.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.video_collection_rounded,
                      color: AppColors.primaryColor,
                      size: 5.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w, right: 1.w),
                      child: Text(
                        "${subscribedCourse?.lessonsLeft} left",
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 9.sp),
                      ),
                    )
                  ],
                ),
                ref
                    .watch(
                        bLearnCourseDetailProvider(subscribedCourse?.id ?? 0))
                    .when(
                      data: (data) {
                        return InkWell(
                          onTap: () =>
                              Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const NoInternetConnectionScreen();
                            },
                          )),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: AppColors.primaryColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 1.w, right: 1.w),
                                child: Text(
                                  subscribedCourse?.progress == 0
                                      ? "Start Learning"
                                      : "Continue Learning",
                                  style: TextStyle(
                                      fontFamily: kFontFamily,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8.sp),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return buildEmptyPlaceHolder("error");
                      },
                      loading: () => buildEmptyPlaceHolder("..."),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildloadingbar(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        SizedBox(
          height: 5.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03),
          child: CustomizableShimmerTile(height: 40.w, width: 90.w),
        ),
        SizedBox(
          height: 5.w,
        ),
        _buildExploreCaption(context),
        SizedBox(
          height: 62.w,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 3.w,
              ),
              CustomizableShimmerTile(height: 70.w, width: 50.w),
              SizedBox(
                width: 3.w,
              ),
              CustomizableShimmerTile(height: 70.w, width: 50.w),
              SizedBox(
                width: 3.w,
              ),
              CustomizableShimmerTile(height: 70.w, width: 50.w),
            ],
          ),
        ),
        SizedBox(
          height: 3.w,
        ),
        _buildRecommended(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 20.w, width: 40.w),
        ),
        SizedBox(
          height: 1.w,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 20.w, width: 40.w),
        ),
        SizedBox(
          height: 1.w,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 20.w, width: 40.w),
        ),
        SizedBox(
          height: 1.w,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableShimmerTile(height: 20.w, width: 40.w),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, BlearnHomeBody body, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          _buildOngoing(body.banners),
          _buildExploreCaption(context),
          _buildCourses(body.homeCategories),
          _buildRecommended(),
          _buildCriteriaCaption(),
          _buildCriteriaList(
              trendingcourses: body.trendingCourses,
              mostViewedcourses: body.mostViewedCourses,
              topcourses: body.topCourses),
          _buildWebinarTitle(),
          _buildWebinarContent(body.upcomingWebinars, ref),
          _buildLearnCaption(context, ref),
          _buildLearnList(body.bestInstructors),
          // _buildComplementary(),
          // _buildComplementaryList(),
          _buildEnroll(context),
          _buildRecentCaption(context, ref),
          _buildRecentList(body.recentlyAddedCourses),
          _buildTestimonialCaption(),
          _buildTestimonialList(body.testimonials),
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

  Widget _buildWebinarContent(
      List<UpcomingWebinar?>? broadcastData, WidgetRef ref) {
    if (broadcastData == null) {
      return const SizedBox.shrink();
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: SizedBox(
          height: 58.w,
          child: ListView.builder(
            itemCount: broadcastData.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 4.w, right: 10.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    joinBroadcast(context, ref,
                        broadcastData[index]?.id.toString() ?? "");
                  },
                  child:
                      WebinarDetailTile(broadcastData: broadcastData[index]!));
            },
          ),
        ));
  }

  Widget _buildUser() {
    return Padding(
      padding: EdgeInsets.only(right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
      child: const BlearnUserTopBar(),
    );
  }

  Widget _buildOngoing(List<BlearnBanner?>? bannerlist) {
    return CarouselSlider.builder(
        itemCount: bannerlist?.length,
        options: CarouselOptions(
          aspectRatio: 18 / 8,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0,
          onPageChanged: (index, reason) {},
          scrollDirection: Axis.horizontal,
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          final bannerData = bannerlist?[itemIndex];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteList.webview, arguments: {
                'url': bannerData?.actionWeb ?? "",
              });
            },
            child: Container(
              width: double.infinity,
              margin:
                  EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w, bottom: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
                image: DecorationImage(
                    image: getImageProvider(bannerData?.image ?? ""),
                    fit: BoxFit.cover),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 158, 158, 158),
                    offset: Offset(
                      3.0,
                      3.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          );
        });
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

  Widget _buildCourses(List<HomeCategory?>? featuredCategories) {
    if (featuredCategories == null || featuredCategories.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 40.sp + 60.w,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
        itemCount: featuredCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final category = featuredCategories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
            child: Container(
              width: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                  color: Colors.grey[50]),
              child: Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    image: DecorationImage(
                      image: getImageProvider(category?.image ?? ''),
                      fit: BoxFit.cover,
                    ),
                  )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primaryColor.withOpacity(0.3)
                            ])),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            category?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteList.bLearnSubCategories,
                              arguments: Category(
                                  id: category?.id,
                                  name: category?.name,
                                  image: category?.image)),
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

  Widget _buildCriteriaList({
    required List<Course?>? trendingcourses,
    required List<Course?>? mostViewedcourses,
    required List<Course?>? topcourses,
  }) {
    List<Course?>? courses = [];
    return Consumer(builder: (context, ref, child) {
      final selected = ref.watch(recommenedSelectedProvider);
      switch (selected) {
        case CourseType.trending:
          {
            courses = trendingcourses;
          }
          break;

        case CourseType.mostViewed:
          {
            //statements;
            courses = mostViewedcourses;
          }
          break;

        default:
          {
            courses = topcourses;
          }
          break;
      }
      if (courses == null || courses!.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        color: Colors.white,
        child: ListView.builder(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
            itemCount: courses?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              Course course = courses?[index] ?? Course();
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

  Widget _buildEnroll(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, RouteList.webview, arguments: {
          'url': "https://www.app.bvidya.com/",
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: const Image(
          image: AssetImage('assets/images/Become-instructor.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildLearnCaption(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 2.w, top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TwoColorText(
            first: S.current.blearn_learnfrom,
            second: S.current.blearn_thebest,
          ),
          InkWell(
            onTap: () {
              ref.read(selectedSearchTabCourseDetailProvider.notifier).state =
                  1;
              Navigator.pushNamed(context, RouteList.bLearnAllCourses);
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
      ),
    );
  }

  Widget _buildLearnList(List<Instructor?>? instructors) {
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
            Instructor instructor = instructors[index]!;
            return Container(
              width: 34.w,
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

  // Widget _buildComplementaryList() {
  //   return Container(
  //     height: 14.h,
  //     color: Colors.white,
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(0.5.h),
  //       itemCount: complementryItems.length,
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (BuildContext context, int index) {
  //         return const ComplementryCourseItem();
  //         // final row = complementryItems.entries.elementAt(index);
  //         // return ComplementryCourseItem(
  //         //   color: complementryItemsColors[row.key]!,
  //         //   image: row.value,
  //         //   title: row.key,
  //         // );
  //       },
  //     ),
  //   );
  // }

  Widget _buildRecentCaption(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 2.3.h, right: 1.3.h, left: 2.3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TwoColorText(
            first: S.current.blearn_recently,
            second: S.current.blearn_added,
          ),
          InkWell(
            onTap: () {
              ref.read(selectedSearchTabCourseDetailProvider.notifier).state =
                  0;
              Navigator.pushNamed(context, RouteList.bLearnAllCourses);
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
      ),
    );
  }

  Widget _buildRecentList(List<Course?>? courses) {
    if (courses == null || courses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 1.5.w),
      height: 60.w,
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

  Widget _buildTestimonialList(List<CourseFeedback?>? testimonials) {
    if (testimonials == null || testimonials.isEmpty) {
      return buildEmptyPlaceHolder('No Testimonials');
    }
    return Container(
      margin: EdgeInsets.only(top: 0.8.h),
      height: 45.w,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.all(0.5.h),
        itemCount: testimonials.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final testimonial = testimonials[index];
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
                        testimonial?.name ?? 'AA', testimonial?.image ?? '',
                        radius: 8.w),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            testimonial?.name ?? '',
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          buildRatingBar(
                              testimonial?.rating?.toDouble() ?? 0.0),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.w),
                Text(
                  testimonial?.comment ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
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
