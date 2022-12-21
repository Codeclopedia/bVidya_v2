import '../../../../core/constants.dart';
import '../../../../core/ui_core.dart';
import '../../../../data/models/models.dart';

class LessonListRow extends StatelessWidget {
  final int index;
  final int openIndex;
  final Lesson? lesson;
  final Function(int) onExpand;

  const LessonListRow(
      {Key? key,
      required this.index,
      this.lesson,
      required this.openIndex,
      required this.onExpand})
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
      child: Row(
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
                  lesson?.name ?? 'Lesson Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp,
                    fontFamily: kFontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (openIndex == index)
                  Row(
                    children: [
                      const Icon(Icons.ondemand_video),
                      Expanded(
                        child: Text(lesson?.description ?? 'Lesson Name'),
                      )
                    ],
                  )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              onExpand(index);
            },
            child: Icon(
              openIndex == index
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ),
        ],
      ),
    );
  }
}
