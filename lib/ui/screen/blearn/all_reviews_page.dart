import 'package:bvidya/core/constants/colors.dart';

import '../../../core/ui_core.dart';
import '../../../data/models/models.dart';

class AllReviewsPage extends StatelessWidget {
  final List<CourseFeedback?> feedbacks;
  final String title;
  const AllReviewsPage(
      {super.key, required this.feedbacks, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyleBlack.copyWith(
                    fontSize: 12.sp, color: Colors.white)),
            Text("${S.current.blearn_review_title} (${feedbacks.length})",
                style: textStyleBlack.copyWith(
                    fontSize: 10.sp, color: Colors.white)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            final feedback = feedbacks[index];
            return reviewTile(feedback ?? CourseFeedback());
          },
        ),
      ),
    );
  }

  Widget customAppbar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: textStyleBlack.copyWith(
                  fontSize: 12.sp, color: Colors.white)),
          Text("${S.current.blearn_review_title} (${feedbacks.length})",
              style: textStyleBlack.copyWith(
                  fontSize: 10.sp, color: Colors.white)),
        ],
      ),
    );
  }

  Widget reviewTile(CourseFeedback feedback) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          vertical: 3.w,
          horizontal: 4.w,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(76, 158, 158, 158),
                blurRadius: 2.w,
                spreadRadius: 1.w,
                offset: Offset(1.w, 1.w),
              )
            ],
            color: AppColors.cardWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getCicleAvatar(title, feedback.image ?? "",
                cacheHeight: (30.w * devicePixelRatio).round(),
                cacheWidth: (30.w * devicePixelRatio).round()),
            SizedBox(width: 1.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback.name ?? "",
                    style: textStyleBlack.copyWith(fontSize: 10.sp),
                  ),
                  // SizedBox(height: 1.w),
                  buildRatingBar(feedback.rating?.toDouble() ?? 0.0),
                  SizedBox(height: 1.w),
                  Text(
                    feedback.comment ?? "",
                    style: textStyleBlack.copyWith(
                        fontSize: 8.sp,
                        color: AppColors.inputHintText,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
