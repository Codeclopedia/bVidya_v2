// ignore_for_file: use_build_context_synchronously

import '/core/helpers/video_helper.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class LessonListRow extends StatelessWidget {
  final int index;
  final int openIndex;
  final Lesson lesson;
  final Function(int) onExpand;
  final int courseId;
  final int instructorId;

  const LessonListRow(
      {Key? key,
      required this.index,
      required this.lesson,
      required this.openIndex,
      required this.onExpand,
      required this.courseId,
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
                        'Lesson $index',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        lesson.name,
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: GestureDetector(
                onTap: () async {
                  await sendVideoPlayback(lesson.id, instructorId);
                  Navigator.pushNamed(context, RouteList.bLearnLessionVideo,
                      arguments: {
                        "lesson": lesson,
                        "course_id": courseId,
                        'instructor_id': instructorId
                      });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.ondemand_video),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h),
                        child: Text(lesson.description),
                      ),
                    ),
                    const Icon(Icons.play_circle)
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
