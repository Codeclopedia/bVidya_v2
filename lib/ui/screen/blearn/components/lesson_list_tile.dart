import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class LessonListTile extends StatelessWidget {
  final int index;
  final int openIndex;
  final Lesson lesson;

  const LessonListTile({
    Key? key,
    required this.index,
    required this.lesson,
    required this.openIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color:
            openIndex == index ? AppColors.primaryColor : AppColors.cardWhite,
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
      ),
      padding: EdgeInsets.only(top: 2.h, left: 4.w, bottom: 2.h, right: 4.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson ${index + 1}',
                      style: TextStyle(
                        color: openIndex == index ? Colors.white : Colors.black,
                        fontSize: 8.sp,
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      lesson.name,
                      style: TextStyle(
                        color: openIndex == index ? Colors.white : Colors.black,
                        fontSize: 11.sp,
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    openIndex == index
                        ? Text(
                            "Currently playing... ",
                            style: TextStyle(
                                color: AppColors.cardWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 3.w),
                          )
                        : Container()
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: openIndex == index
                    ? const Icon(
                        Icons.play_circle_sharp,
                        color: AppColors.cardWhite,
                      )
                    : const Icon(
                        Icons.play_arrow,
                        color: AppColors.primaryColor,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
