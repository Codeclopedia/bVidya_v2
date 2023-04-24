import '/data/models/response/blearn/blearn_home_response.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class WebinarDetailTile extends StatelessWidget {
  final UpcomingWebinar broadcastData;
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                  borderRadius: BorderRadius.circular(2.w),
                  // image: DecorationImage(
                  //     image: getImageProvider(broadcastData.image.toString()),
                  //     fit: BoxFit.cover)
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: Image(
                        image: getImageProvider(broadcastData.image.toString(),
                            maxHeight: (100.w * devicePixelRatio).round(),
                            maxWidth: (100.w * devicePixelRatio).round()),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    if (broadcastData.status != 'scheduled') liveBanner()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.w,
            ),
            Text(
              broadcastData.name == "Coming soon"
                  ? 'Coming soon'
                  : broadcastData.name.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 1.w,
            ),
            if (broadcastData.name != "Coming soon")
              Text(
                  "Scheduled on: ${broadcastData.startsAt.toString().replaceRange(10, broadcastData.startsAt.toString().length, "")}",
                  style:
                      TextStyle(fontSize: 6.sp, color: AppColors.primaryColor)),
            if (broadcastData.name != "Coming soon")
              SizedBox(
                height: 2.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget liveBanner() {
    return Padding(
      padding: EdgeInsets.only(top: 1.w, right: 1.w),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.w),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(0.2.w),
          child: getLottieIcon('99714-go-live.json', width: 10.w),
        ),
      ),
    );
  }
}
