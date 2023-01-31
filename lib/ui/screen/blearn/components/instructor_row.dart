import '/core/ui_core.dart';
import '/data/models/models.dart';

class InstructorRowItem extends StatelessWidget {
  final Instructor instructor;
  const InstructorRowItem({Key? key, required this.instructor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40.w,
          width: 30.w,
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
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(
          instructor.occupation ?? '',
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 6.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey),
        ),
        // Text(
        //   '2k Followers',
        //   style: TextStyle(
        //     fontFamily: kFontFamily,
        //     fontSize: 6.sp,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.grey,
        //   ),
        // ),
      ],
    );
  }
}
