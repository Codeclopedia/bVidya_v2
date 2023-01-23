// ignore_for_file: use_build_context_synchronously

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/controller/blearn_providers.dart';
import '/core/state.dart';
import '/ui/screens.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class LessonListTile extends StatelessWidget {
  final int index;
  final int openIndex;
  final Lesson lesson;
  final WidgetRef ref;
  final bool isSubscribed;
  final Function(int) onExpand;
  final Function() onplay;
  final int courseId;
  final int instructorId;

  const LessonListTile(
      {Key? key,
      required this.index,
      required this.lesson,
      required this.openIndex,
      required this.ref,
      required this.isSubscribed,
      required this.onExpand,
      required this.onplay,
      required this.courseId,
      required this.instructorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border.all(
            color: ref.watch(currentLessonIdProvider) == lesson.id
                ? AppColors.primaryColor
                : Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
      ),
      padding: EdgeInsets.only(top: 2.h, left: 4.w, bottom: 2.h, right: 4.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              isSubscribed
                  ? onExpand(openIndex == index ? -1 : index)
                  : index == 0
                      ? onExpand(openIndex == index ? -1 : index)
                      : {
                          showTopSnackBar(
                            Overlay.of(context)!,
                            const CustomSnackBar.error(
                              message: 'Please Subscribe to Course first.',
                            ),
                          )
                        };
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
                          color: isSubscribed
                              ? Colors.black
                              : index == 0
                                  ? Colors.black
                                  : Colors.grey,
                          fontSize: 8.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        lesson.name ?? '',
                        style: TextStyle(
                          color: isSubscribed
                              ? Colors.black
                              : index == 0
                                  ? Colors.black
                                  : Colors.grey,
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: lesson.playlist?.length,
              itemBuilder: (context, playlistIndex) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: GestureDetector(
                    onTap: () async {
                      showLoading(ref);
                      ref.read(currentVideoIDProvider.notifier).state =
                          lesson.playlist?[playlistIndex]?.videoId ?? 0;
                      ref.read(currentVideoUrlProvider.notifier).state =
                          lesson.playlist?[playlistIndex]?.media?.location ??
                              "";
                      ref.read(currentLessonIdProvider.notifier).state =
                          lesson.id ?? 0;
                      ref.read(selectedLessonIndexProvider.notifier).state =
                          index;
                      onplay();
                      // Navigator.pushNamed(context, RouteList.bLearnLessionVideo,
                      //     arguments: {
                      //       "lesson": lesson,
                      //       "course_id": courseId,
                      //       'instructor_id': instructorId
                      //     });
                      hideLoading(ref);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.play_circle_outline_sharp,
                          color: ref.watch(currentVideoIDProvider) ==
                                  lesson.playlist?[playlistIndex]?.videoId
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.h),
                            child: Text(
                              lesson.playlist?[playlistIndex]?.title ?? '',
                              style: TextStyle(
                                  color: ref.watch(currentVideoIDProvider) ==
                                          lesson
                                              .playlist?[playlistIndex]?.videoId
                                      ? AppColors.primaryColor
                                      : Colors.black,
                                  fontWeight:
                                      ref.watch(currentVideoIDProvider) ==
                                              lesson.playlist?[playlistIndex]
                                                  ?.videoId
                                          ? FontWeight.w500
                                          : FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
