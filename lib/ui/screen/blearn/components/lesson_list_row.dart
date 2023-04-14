// ignore_for_file: use_build_context_synchronously

import '/controller/blearn_providers.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/core/state.dart';
import '/ui/screens.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class LessonListRow extends StatelessWidget {
  final int index;
  final Lesson lesson;
  final bool isSubscribed;
  final WidgetRef ref;
  final Function(int) onExpand;
  final Course course;
  final int instructorId;

  const LessonListRow(
      {Key? key,
      required this.index,
      required this.lesson,
      required this.isSubscribed,
      required this.ref,
      required this.onExpand,
      required this.course,
      required this.instructorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
      ),
      padding: EdgeInsets.only(top: 2.h, left: 4.w, bottom: 2.h, right: 4.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              isSubscribed
                  ? onExpand(ref.watch(selectedLessonIndexProvider) == index
                      ? -1
                      : index)
                  : index == 0
                      ? onExpand(ref.watch(selectedLessonIndexProvider) == index
                          ? -1
                          : index)
                      : {
                          showTopSnackBar(
                            Overlay.of(context)!,
                            const CustomSnackBar.error(
                              message: 'Subscribe to the Course first.',
                            ),
                          )
                        };
              // openIndex == index
              //     ? ref.read(selectedIndexLessonProvider.notifier).state = -1
              //     : ref.read(selectedIndexLessonProvider.notifier).state =
              //         index;
            },
            child: isSubscribed
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                lesson.name ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontFamily: kFontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        ref.watch(selectedLessonIndexProvider) == index
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  )
                : index == 0
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.sp,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    lesson.name ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.sp,
                                      fontFamily: kFontFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            ref.watch(selectedLessonIndexProvider) == index
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    lesson.name ?? '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11.sp,
                                      fontFamily: kFontFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
          ),
          if (ref.watch(selectedLessonIndexProvider) == index)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lesson.playlist?.length,
              itemBuilder: (context, playlistindex) {
                return Padding(
                  padding: EdgeInsets.only(top: 4.w, bottom: 1.w),
                  child: InkWell(
                    onTap: () async {
                      showLoading(ref);
                      index == 0 && playlistindex < 2 || isSubscribed
                          ? {
                              ref.read(currentVideoUrlProvider.notifier).state =
                                  lesson.playlist?[playlistindex]?.media
                                          ?.location ??
                                      "",
                              ref.read(currentVideoIDProvider.notifier).state =
                                  lesson.playlist?[playlistindex]?.videoId ?? 0,
                              Navigator.pushNamed(
                                  context, RouteList.bLearnLessionVideo,
                                  arguments: {
                                    "lesson": lesson,
                                    "course": course,
                                    'instructor_id': instructorId,
                                    'isSubscribed': isSubscribed,
                                  }),
                              ref
                                  .read(selectedLessonIndexProvider.notifier)
                                  .state = index,
                              ref.read(currentLessonIdProvider.notifier).state =
                                  lesson.id ?? 0,
                            }
                          : {
                              showTopSnackBar(
                                Overlay.of(context)!,
                                const CustomSnackBar.error(
                                  message: 'Subscribe to the Course first.',
                                ),
                              )
                            };

                      hideLoading(ref);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 2.w),
                            getSvgIcon("Icon material-slow-motion-video.svg",
                                color: index == 0 && playlistindex < 2 ||
                                        isSubscribed
                                    ? Colors.black
                                    : Colors.grey,
                                width: 5.w),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 3.w, right: 1.w, top: 1.w),
                            child: Text(
                              lesson.playlist?[playlistindex]?.title ?? '',
                              style: TextStyle(
                                  color: index == 0 && playlistindex < 2 ||
                                          isSubscribed
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          // if (openIndex == index)
          //   Padding(
          //     padding: EdgeInsets.symmetric(vertical: 2.h),
          //     child: GestureDetector(
          //       onTap: () async {
          //         showLoading(ref);
          //         ref.read(currentVideoIdProvider.notifier).state =
          //             lesson.videoId!;
          //         Navigator.pushNamed(context, RouteList.bLearnLessionVideo,
          //             arguments: {
          //               "lesson": lesson,
          //               "course_id": courseId,
          //               'instructor_id': instructorId
          //             });
          //         hideLoading(ref);
          //       },
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Icon(Icons.play_circle_outline_sharp),
          //           Expanded(
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 1.h),
          //               child: Text(lesson.description ?? ''),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
