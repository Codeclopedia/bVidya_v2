import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

class CourseListRow extends StatelessWidget {
  final Course course;
  const CourseListRow({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.all(Radius.circular(3.w)),
          border: Border.all(color: const Color(0xFFCECECE), width: 0.5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 2.w, offset: Offset(1.w, 1.w)),
          ]),
      margin: EdgeInsets.symmetric(vertical: 0.8.h),
      padding:
          EdgeInsets.only(left: 1.5.w, right: 4.w, top: 0.7.h, bottom: 0.7.h),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3.w),
              child: Image(
                image: getImageProvider(course.image ?? '',
                    maxHeight: (30.w * devicePixelRatio).round(),
                    maxWidth: (30.w * devicePixelRatio).round()),
                height: 22.w,
                width: 22.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    course.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: Colors.black),
                  ),
                  SizedBox(height: 0.5.w),
                  Text(
                    course.instructorName ?? "",
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inputHintText,
                    ),
                  ),
                  SizedBox(height: 1.w),
                  Row(
                    children: [
                      Text(
                        course.rating ?? "0.0",
                        style: textStyleBlack.copyWith(
                            fontSize: 8.sp,
                            color: AppColors.yellowAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      RatingBarIndicator(
                        itemBuilder: (context, index) {
                          return const Icon(
                            Icons.star,
                            color: AppColors.yellowAccent,
                          );
                        },
                        rating: double.parse(course.rating ?? '0.0'),
                        itemSize: 4.w,
                      ),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      Text(
                        "(${course.ratingCount})",
                        style: textStyleBlack.copyWith(
                            fontSize: 8.sp,
                            color: AppColors.yellowAccent,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 1.w),
            CircleAvatar(
              radius: 3.5.w,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.play_arrow,
                size: 4.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
