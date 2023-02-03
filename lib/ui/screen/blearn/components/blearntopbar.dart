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
            InkWell(
                onTap: () {
                  if (user.role == 'teacher' ||
                      user.role == 'instructor' ||
                      user.role == 'admin') {
                    Navigator.pushNamed(context, RouteList.teacherProfile);
                  } else {
                    Navigator.pushNamed(context, RouteList.studentProfile);
                  }
                },
                child: getRectFAvatar(user.name, user.image)),
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
                  child: Icon(
                    Icons.favorite_outline,
                    color: AppColors.primaryColor,
                    size: 5.w,
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
                  child: Icon(
                    Icons.search,
                    size: 5.w,
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
