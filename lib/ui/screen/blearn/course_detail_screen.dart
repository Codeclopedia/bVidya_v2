import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/ui/widget/sliding_tab.dart';
import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import 'components/common.dart';
import 'components/course_feedback_form.dart';
import 'components/lesson_list_row.dart';
import '../../widgets.dart';

// int _selectedIndex = -1;
final ratingProvider = StateProvider<int>((ref) => 3);
final selectedTabCourseDetailProvider = StateProvider<int>((ref) => 0);
final selectedIndexLessonProvider = StateProvider<int>((ref) => 0);
final isModelSheetOpened = StateProvider.autoDispose<bool>((ref) => false);

class CourseDetailScreen extends HookConsumerWidget {
  final Course course;
  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(selectedTabCourseDetailProvider);
    bool modelSheetOpened = ref.watch(isModelSheetOpened);
    int rating = ref.read(ratingProvider);
    final feedbackMessageController = useTextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: CustomFeedbackForm(
        callback: (modelSheetState) {
          ref.read(isModelSheetOpened.notifier).state = modelSheetState;
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _topImage(context),
                _subjectDetail(),
                SlidingTab(
                  label1: 'Description',
                  label2: 'Curriculum',
                  selectedIndex: selectedIndex,
                  callback: (index) {
                    ref.read(selectedTabCourseDetailProvider.notifier).state =
                        index;
                  },
                ),
                // _toggleItems(),
                SizedBox(height: 2.h),
                selectedIndex == 0 ? _buildDescView() : _builCurriculumView(),
              ],
            ),
            Visibility(
                visible: modelSheetOpened,
                child: feedbackform(
                    rating, ref, feedbackMessageController, context))
          ],
        ),
      ),
    );
  }

  Widget feedbackform(int rating, WidgetRef ref,
      TextEditingController feedbackMessageController, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: ClipPathClass(),
        child: Container(
          height: 100.w,
          width: 100.w,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 125, 125, 125),
                    blurRadius: 5.0,
                    offset: Offset(1, 3)),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.w),
                  topRight: Radius.circular(5.w))),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Rate Your Experience',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
              ),
              Text(
                'Are you satisfied with the experience?',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
                child: RatingBar.builder(
                  initialRating: rating.roundToDouble(),
                  itemCount: 5,
                  itemSize: 12.5.w,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  // itemBuilder: (context, index) {
                  //   switch (index) {
                  //     case 0:
                  //       return const Icon(
                  //         Icons.sentiment_very_dissatisfied,
                  //         color: Colors.red,
                  //       );

                  //     case 1:
                  //       return const Icon(
                  //         Icons.sentiment_dissatisfied,
                  //         color: Colors.redAccent,
                  //       );
                  //     case 2:
                  //       return const Icon(
                  //         Icons.sentiment_neutral,
                  //         color: Colors.amber,
                  //       );
                  //     case 3:
                  //       return const Icon(
                  //         Icons.sentiment_satisfied,
                  //         color: Colors.lightGreen,
                  //       );
                  //     case 4:
                  //       return const Icon(
                  //         Icons.sentiment_very_satisfied,
                  //         color: Colors.green,
                  //       );
                  //   }
                  //   return Container();
                  // },
                  onRatingUpdate: (rating) {
                    ref.read(ratingProvider.notifier).state = rating.toInt();
                  },
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tell us what can be improved?",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp),
                ),
              ),
              SizedBox(height: 1.w),
              Container(
                height: 35.w,
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: TextField(
                  controller: feedbackMessageController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tell us how can we improve...",
                      hintStyle: TextStyle(fontSize: 10.sp)),
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 12.5.w,
                  width: 70.w,
                  child: ElevatedButton(
                      onPressed: () async {
                        final response;
                        feedbackMessageController.text.isEmpty
                            ? showTopSnackBar(
                                Overlay.of(context)!,
                                const CustomSnackBar.error(
                                  message: 'Please Fill all the details.',
                                ),
                              )
                            : {
                                response = await ref
                                    .read(bLearnRepositoryProvider)
                                    .setfeedback(course.id.toString(), rating,
                                        feedbackMessageController.text),
                                ref.read(isModelSheetOpened.notifier).state =
                                    false,
                                print(response.status),
                                showTopSnackBar(
                                  Overlay.of(context)!,
                                  const CustomSnackBar.success(
                                    message: 'Feedback Submitted',
                                  ),
                                )
                              };
                      },
                      child: const Text("Submit")),
                ),
              )
              // Container(
              // height: 15.w,
              // width: 70.w,
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //       color: AppColors.primaryColor,
              //       borderRadius: BorderRadius.circular(15)),
              //   child: Text(
              //     "Submit",
              //     style: TextStyle(
              //         color: AppColors.cardWhite,
              //         fontSize: 12.5.sp,
              //         fontWeight: FontWeight.w500),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _builCurriculumView() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${course.numberOfLesson} Lessons | ${course.duration!.replaceAll(":", ".")} Hours',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 8.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return ref.watch(bLearnLessonsProvider(course.id!)).when(
                    data: (data) {
                      if (data?.lessons?.isNotEmpty == true) {
                        return _buildLessons(ref, data!.lessons!);
                      } else {
                        return buildEmptyPlaceHolder('No Lessons');
                        // return _buildLessons();
                      }
                    },
                    error: (error, stackTrace) => buildEmptyPlaceHolder('text'),
                    loading: () => buildLoading);
              },
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildLessons(WidgetRef ref, List<Lesson> lessons) {
    final selectedIndex = ref.watch(selectedIndexLessonProvider);
    return ListView.builder(
      itemCount: lessons.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return LessonListRow(
          index: index + 1,
          openIndex: selectedIndex,
          lesson: lessons[index],
          courseId: course.id!,
          instructorId: course.userId!,
          onExpand: (index) {
            ref.read(selectedIndexLessonProvider.notifier).state = index;
          },
          // ref: ref
        );
      },
    );
  }

  Widget _buildDescView() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem(
                          'Duration:', ' ${course.duration}', Icons.history),
                      const Divider(
                        height: 0.5,
                        color: Color(0xFFDBDBDB),
                      ),
                      _buildDetailItem('Lectures:', ' ${course.numberOfLesson}',
                          Icons.description),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    children: [
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
            _getText(),
            SizedBox(height: 10.w),
            const TwoColorText(
              first: 'Related',
              second: 'Courses',
            ),
          ],
        ),
      ),
    ));
  }

  Widget _getText() {
    return Text(course.description ?? '');
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

  Widget _subjectDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.name ?? '',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        // offset: Offset(0, 0),
                        // blurRadius: 1,
                      )
                    ]),
                child: Icon(
                  Icons.favorite_outline,
                  size: 8.w,
                  color: Colors.black,
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
                  'Launguage', course.language ?? '', 'icon_language.svg'),
              const Spacer(),
              _buildMeta(
                  'Category', course.level.toString(), 'icon_category.svg'),
            ],
          )
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
        SizedBox(
          width: 95.w,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
              child: Image(
                image: getImageProvider(course.image ?? ''),
                fit: BoxFit.fitWidth,
              )),
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

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.835, size.height);

    path.quadraticBezierTo(size.width * 0.7, size.height * 0.825,
        size.width * 0.85, size.height * 0.775);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.765, size.width, size.height * 0.9);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
