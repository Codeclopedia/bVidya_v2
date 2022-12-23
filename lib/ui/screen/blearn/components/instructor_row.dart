import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class InstructorRowItem extends StatelessWidget {
  final Instructor instructor;
  const InstructorRowItem({Key? key, required this.instructor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        border: Border.all(color: Colors.black38, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 15.h,
            width: 11.h,
            margin: EdgeInsets.only(left: 3.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                image: DecorationImage(
                    image: getImageProvider(instructor.image ?? ''))),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    instructor.name ?? '',
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  // SizedBox(height: 1.h),
                  Text(
                    instructor.specialization ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 7.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  // SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            '50+',
                            style: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Videos',
                            style: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 7.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        children: [
                          Text(
                            '2K',
                            style: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontFamily: kFontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
