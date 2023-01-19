// ignore_for_file: use_build_context_synchronously

import '/core/state.dart';
import '/ui/screens.dart';

// import '/core/helpers/video_helper.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class LessonListRow extends StatelessWidget {
  final int index;
  final int openIndex;
  final Lesson lesson;
  final WidgetRef ref;
  final Function(int) onExpand;
  final Course course;
  final int instructorId;

  const LessonListRow(
      {Key? key,
      required this.index,
      required this.lesson,
      required this.openIndex,
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
          lesson.playlist?.isEmpty == true
              ? GestureDetector(
                  onTap: () {
                    showLoading(ref);
                    ref.read(currentVideoIdProvider.notifier).state =
                        lesson.videoId!;
                    Navigator.pushNamed(context, RouteList.bLearnLessionVideo,
                        arguments: {
                          "lesson": lesson,
                          "course": course,
                          'instructor_id': instructorId
                        });
                    ref.read(selectedLessonIndexProvider.notifier).state =
                        index;
                    hideLoading(ref);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lesson ${index + 1}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              lesson.name ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: const Icon(Icons.play_circle_outline_sharp),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    onExpand(openIndex == index ? -1 : index);
                    // openIndex == index
                    //     ? ref.read(selectedIndexLessonProvider.notifier).state = -1
                    //     : ref.read(selectedIndexLessonProvider.notifier).state =
                    //         index;
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lesson ${index + 1}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              lesson.name ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(
                          openIndex == index
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ],
                  ),
                ),
          if (openIndex == index)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lesson.playlist?.length,
              itemBuilder: (context, playlistindex) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: InkWell(
                    onTap: () async {
                      showLoading(ref);
                      ref.read(currentVideoIdProvider.notifier).state =
                          lesson.playlist?[playlistindex]?.id ?? 0;
                      Navigator.pushNamed(context, RouteList.bLearnLessionVideo,
                          arguments: {
                            "lesson": lesson,
                            "course": course,
                            'instructor_id': instructorId
                          });
                      ref.read(selectedLessonIndexProvider.notifier).state =
                          index;
                      hideLoading(ref);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.play_circle_outline_sharp),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.h),
                            child: Text(
                                lesson.playlist?[playlistindex]?.title ?? ''),
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
