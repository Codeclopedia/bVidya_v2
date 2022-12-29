// import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class InstructorRowItem extends StatelessWidget {
  final Instructor instructor;
  const InstructorRowItem({Key? key, required this.instructor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 22.5.h,
          width: 17.5.h,
          margin: EdgeInsets.only(left: 3.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              image: DecorationImage(
                  image: getImageProvider(instructor.image ?? ''),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(
          instructor.name ?? '',
          style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Row(
          children: [
            Text(
              '2K Followers',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 6.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
