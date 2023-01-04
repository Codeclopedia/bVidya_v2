import '/data/models/response/blearn/live_classes_response.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class WebinarDetailTile extends StatelessWidget {
  final LMSLiveClass broadcastData;
  const WebinarDetailTile({super.key, required this.broadcastData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        width: 60.w,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Center(
              child: Container(
                height: 40.w,
                width: 60.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: getImageProvider(broadcastData.image.toString()),
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: Text(
                broadcastData.name.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  broadcastData.status.toString(),
                  style: TextStyle(fontSize: 5.sp),
                ),
                Text("Starts in: ${broadcastData.startsAt}",
                    style: TextStyle(
                        fontSize: 5.sp, color: AppColors.primaryColor))
              ],
            ),
            SizedBox(
              height: 2.w,
            ),
          ],
        ),
      ),
    );
  }
}
