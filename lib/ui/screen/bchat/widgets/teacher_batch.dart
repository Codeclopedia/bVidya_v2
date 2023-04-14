import '/core/constants/colors.dart';
import '/core/ui_core.dart';

Widget teacherBatch() {
  return CircleAvatar(
    radius: 2.w,
    backgroundColor: AppColors.yellowAccent,
    child: Text(
      'T',
      style: TextStyle(
          fontFamily: kFontFamily,
          fontWeight: FontWeight.w900,
          fontSize: 7.sp,
          color: AppColors.cardWhite),
    ),
  );
}
