import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class BlearnUserTopBar extends StatelessWidget {
  const BlearnUserTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserConsumer(
      builder: (context, user, ref) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // SizedBox(width: 7.w),
            getRectFAvatar(user.name, user.image),
            SizedBox(width: 3.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.home_welcome,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.yellowAccent,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                //need to add to route
                Navigator.pushNamed(context, RouteList.bLearnWishList);
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return WishlistCourses();
                //   },
                // ));
              },
              child: CircleAvatar(
                backgroundColor: AppColors.cardWhite,
                radius: 4.5.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            InkWell(
              onTap: () {
                //need to add to route
                Navigator.pushNamed(context, RouteList.bLearnAllCourses);
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return AllCoursesPage();
                //   },
                // ));
              },
              child: CircleAvatar(
                backgroundColor: AppColors.yellowAccent,
                radius: 4.5.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                  child: const Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}