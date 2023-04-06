// ignore_for_file: use_build_context_synchronously

import '../../dialog/ok_dialog.dart';
import '/controller/profile_providers.dart';
import '/ui/dialog/basic_dialog.dart';

import '/ui/screens.dart';
import 'package:spring/spring.dart';

import '/ui/widget/sliding_tab.dart';
import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import 'components/common.dart';
import 'components/course_feedback_button.dart';
import 'components/feeback_dialog.dart';
import 'components/lesson_list_row.dart';
import '../../widgets.dart';

// int _selectedIndex = -1;

final selectedTabCourseDetailProvider = StateProvider<int>((ref) => 0);

final isModelSheetOpened = StateProvider.autoDispose<bool>((ref) => false);

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      int selectedIndex = ref.watch(selectedTabCourseDetailProvider);
      bool modelSheetOpened = ref.watch(isModelSheetOpened);

      return ref.watch(bLearnCourseDetailProvider(course.id ?? 0)).when(
          data: (data) {
            return Container(
              margin: MediaQuery.of(context).viewInsets,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.cardBackground,
                floatingActionButton: data?.isSubscribed ?? false
                    ? selectedIndex == 0
                        ? CustomFeedbackButton(
                            isOpen: modelSheetOpened,
                            callback: (modelSheetState) {
                              ref.read(isModelSheetOpened.notifier).state =
                                  modelSheetState;
                            },
                          )
                        : Container()
                    : Container(),
                body: SafeArea(
                  child: Stack(
                    // clipBehavior: Clip.none,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _topImage(context),

                            _subjectDetail(data, ref),
                            SlidingTab(
                              label1: 'Description',
                              label2: 'Curriculum',
                              selectedIndex: selectedIndex,
                              callback: (index) {
                                ref
                                    .read(selectedTabCourseDetailProvider
                                        .notifier)
                                    .state = index;
                              },
                            ),
                            // _toggleItems(),
                            SizedBox(height: 2.h),
                            selectedIndex == 0
                                ? _buildDescView(data)
                                : _builCurriculumView(data),
                          ],
                        ),
                      ),
                      selectedIndex == 0
                          ? Container()
                          : data?.isSubscribed == true
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.w),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: 90.w,
                                        height: 12.w,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await useCredits(
                                                ref, context, course);
                                          },
                                          style: elevatedButtonStyle,
                                          child: Text(
                                            "Start Learning",
                                            style: textStyleTitle.copyWith(
                                                color: Colors.white,
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                      )),
                                ),
                      Visibility(
                        visible: modelSheetOpened,
                        child: Spring.slide(
                          slideType: SlideType.slide_in_bottom,
                          curve: Curves.easeIn,
                          // startOpacity: 0.5,
                          // endOpacity: 1,
                          withFade: true,
                          animDuration: const Duration(milliseconds: 300),
                          child: FeedbackPopup(
                              course: course,
                              onClose: () {
                                ref.read(isModelSheetOpened.notifier).state =
                                    false;
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: ((error, stackTrace) => buildEmptyPlaceHolder('Error')),
          loading: () => customLoadingView());
    });
  }

  Future useCredits(WidgetRef ref, BuildContext context, Course course) async {
    showLoading(ref);
    final creditsData =
        await ref.read(profileRepositoryProvider).getCreditsHistory();
    hideLoading(ref);
    showBasicImageDialog(
        context,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getPngIcon('coin.png', width: 8.w),
            SizedBox(width: 1.w),
            Text(
              '1 bCoin',
              style: textStyleBlack.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        'This course ${course.name} cost 1 bCoin. And Will be automatically detected from your account.',
        'Sure', () async {
      if (creditsData.avilableCourseCredits! > 0) {
        showLoading(ref);
        final res = await ref
            .read(bLearnRepositoryProvider)
            .subscribeCourse(course.id ?? 1);
        hideLoading(ref);
        showOkDialog(
          context,
          S.current.blearn_course_subscribed_title,
          S.current.blearn_course_subscribed_msg(course.name ?? ""),
          type: true,
          positiveButton: S.current.btn_continue,
          positiveAction: () {},
        );
        ref.refresh(bLearnCourseDetailProvider(course.id ?? 0));
        ref.refresh(creditHistoryProvider);
      } else {
        showBasicImageDialog(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getPngIcon('coin.png', width: 8.w),
              SizedBox(width: 1.w),
              Text(
                'No Credits left',
                style: textStyleBlack.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          'It seems like you have no credits left in your account. Buy credits to continue learning.',
          'Buy credits',
          () async {
            Navigator.pushReplacementNamed(context, RouteList.buySubscription);
          },
        );
      }
    }, negativeAction: () async {
      hideLoading(ref);
    }, negativeButton: S.current.dltCancel);

    // if (creditsData.avilableCourseCredits! > 0) {
    //   showLoading(ref);
    //   await ref.read(bLearnRepositoryProvider).subscribeCourse(course.id ?? 1);
    //   hideLoading(ref);
    //   showOkDialog(
    //     context,
    //     S.current.blearn_course_subscribed_title,
    //     S.current.blearn_course_subscribed_msg(course.name ?? ""),
    //     type: true,
    //     positiveButton: S.current.btn_continue,
    //     positiveAction: () {
    //       Navigator.pop(context, true);
    //     },
    //   );
    //   ref.refresh(bLearnCourseDetailProvider(course.id ?? 0));
    //   ref.refresh(creditHistoryProvider);
    // } else {
    // showBasicImageDialog(
    //   context,
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       getPngIcon('coin.png', width: 8.w),
    //       SizedBox(width: 1.w),
    //       Text(
    //         'No Credits left',
    //         style: textStyleBlack.copyWith(
    //             color: AppColors.primaryColor,
    //             fontSize: 15.sp,
    //             fontWeight: FontWeight.bold),
    //       ),
    //     ],
    //   ),
    //   'It seems like you have no credits left in your account. Buy credits to continue learning.',
    //   'Buy credits',
    //   () async {
    //     Navigator.pushReplacementNamed(context, RouteList.buySubscription);
    //   },
    // );
    // }
  }

  Widget customLoadingView() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
          child: CustomizableShimmerTile(height: 60.w, width: 100.w),
        ),
        SizedBox(
          height: 3.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
          child: CustomizableShimmerTile(height: 20.w, width: 100.w),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
          child: CustomizableShimmerTile(height: 10.w, width: 70.w),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.w),
          child: CustomizableShimmerTile(height: 40.w, width: 70.w),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.w),
          child: CustomizableShimmerTile(height: 80.w, width: 70.w),
        ),
      ],
    );
  }

  Widget _builCurriculumView(CourseDetailBody? coursedata) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${course.numberOfLesson} Lectures | ${course.duration!} Hours',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 8.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Stack(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(bLearnLessonsProvider(course.id!)).when(
                        data: (data) {
                          if (data?.lessons != null) {
                            return _buildLessons(ref, data?.lessons ?? [],
                                coursedata?.isSubscribed ?? false);
                          } else {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10.w,
                                ),
                                getSvgIcon("no-data-icon.svg"),
                                buildEmptyPlaceHolder("No Lectures"),
                              ],
                            ));
                            // return _buildLessons();
                          }
                        },
                        error: (error, stackTrace) =>
                            buildEmptyPlaceHolder('text'),
                        loading: () => buildLoading);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLessons(WidgetRef ref, List<Lesson> lessons, bool isSubscribed) {
    return ListView.builder(
      itemCount: lessons.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 15.w),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return LessonListRow(
          index: index,

          lesson: lessons[index],
          course: course,
          isSubscribed: isSubscribed,
          ref: ref,
          instructorId: course.userId!,
          onExpand: (selectedindex) {
            ref.read(selectedLessonIndexProvider.notifier).state =
                selectedindex;
          },
          // ref: ref
        );
      },
    );
  }

  Widget _buildDescView(CourseDetailBody? coursedetail) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem("Ratings: ", course.rating ?? "0",
                          Icons.star_border_rounded),
                      _buildDetailItem('Duration : ',
                          ' ${course.duration} hours', Icons.history),
                      const Divider(
                        height: 0.5,
                        color: Color(0xFFDBDBDB),
                      ),
                      _buildDetailItem('Lectures : ',
                          ' ${course.numberOfLesson}', Icons.description),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem(
                          "Subscribers: ",
                          coursedetail?.subscribers.toString() ?? "",
                          Icons.group_outlined),
                      _buildDetailItem(
                          'Level:', ' ${course.level}', Icons.sort),
                      const Divider(
                        height: 0.5,
                        color: Color(0xFFDBDBDB),
                      ),
                      _buildDetailItem(
                          '', 'Full lifetime Access ', Icons.hourglass_bottom),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Description',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 1.h),
            // _getText(),
            Text(
              course.description ?? '',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black87,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.w),
            const TwoColorText(
              first: 'Reviews',
              second: '',
            ),
            coursedetail?.courseFeedback?.isNotEmpty == true
                ? _buildTestimonialList(coursedetail?.courseFeedback)
                : Container(
                    margin: EdgeInsets.only(top: 0.8.h),
                    height: 20.w,
                    alignment: Alignment.center,
                    child: const Text(
                      "No feedback yet. \n Add the first one.",
                      style: TextStyle(color: AppColors.iconGreyColor),
                    ),
                  ),
            SizedBox(height: 10.w),
            // const TwoColorText(
            //   first: 'Related',
            //   second: 'Courses',
            // ),
          ],
        ),
      ),
    );
  }

  Widget _getText() {
    return Text(
      course.description ?? '',
      style: TextStyle(
        fontFamily: kFontFamily,
        color: Colors.black87,
        fontSize: 9.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTestimonialList(List<CourseFeedback>? feedbackList) {
    if (feedbackList == null || feedbackList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 0.8.h),
      height: 22.h,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0.5.h),
        itemCount: feedbackList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final feedback = feedbackList[index];
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
                    getCicleAvatar(feedback.name ?? 'AA', feedback.image ?? '',
                        radius: 8.w),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            feedback.name ?? '',
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          buildRatingBar(feedback.rating?.toDouble() ?? 0.0),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.w),
                Text(
                  feedback.comment ?? '',
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

  Widget _buildGridView() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 20,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 1.w,
            childAspectRatio: 0.85),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteList.bLearnCoursesList);
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(width: 18.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    width: 45.w,
                    height: 45.w,
                    child: Image(
                        image: getImageProvider(
                            'assets/images/dummy_profile.png')),
                  ),
                  Text(
                    'Subject Name',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.black,
                      fontSize: 9.sp,
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

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
      // color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: title,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 8.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
            ),
          ),
          Icon(icon, color: AppColors.primaryColor)
          // getSvgIcon(icon, width: 23.0, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _subjectDetail(CourseDetailBody? coursedata, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  coursedata?.courses?[0].name ?? '',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: () async {
                  showLoading(ref);
                  await ref
                      .read(bLearnRepositoryProvider)
                      .changeinWishlist(coursedata?.courses?[0].id ?? 0);
                  // await ref.read(blearnAddorRemoveinWishlistProvider(
                  //     coursedata?.courses?[0].id ?? 0));
                  ref.refresh(bLearnCourseDetailProvider(course.id ?? 0));
                  hideLoading(ref);
                },
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                      color: coursedata?.isWishlisted == true
                          ? Colors.pink[100]
                          : AppColors.cardWhite,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          // offset: Offset(0, 0),
                          // blurRadius: 1,
                        )
                      ]),
                  child: coursedata?.isWishlisted == true
                      ? Icon(
                          Icons.favorite,
                          size: 8.w,
                          color: Colors.pink[400],
                        )
                      : Icon(
                          Icons.favorite_outline,
                          size: 8.w,
                          color: AppColors.iconGreyColor,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIntructor(),
              const Spacer(),
              _buildMeta(
                  'Language', course.language ?? '', 'icon_language.svg'),
              const Spacer(),
              _buildMeta('Category', coursedata?.courses?[0].categoryName ?? "",
                  'icon_category.svg'),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildIntructor() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCicleAvatar(
            course.instructorName ?? '', course.instructorImage ?? '',
            radius: 4.w),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 6.sp,
                color: Colors.black,
              ),
            ),
            Text(
              course.instructorName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMeta(String title, String value, String icon) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getSvgIcon(icon),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 6.sp,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _topImage(BuildContext context) {
    // final providerFallback = getImageProvider('assets/images/banner_image.png');
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
          child: SizedBox(
            width: 100.w,
            height: 60.w,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(2.w)),
                child: Image(
                  image: getImageProvider(course.image ?? ''),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Positioned(
          top: 1.h,
          left: 3.w,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: getSvgIcon('arrow_back.svg'),
          ),
        )
      ],
    );
  }
}
