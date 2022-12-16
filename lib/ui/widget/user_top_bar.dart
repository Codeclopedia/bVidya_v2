import '../../core/state.dart';
import '../../core/ui_core.dart';

class UserTopBar extends StatelessWidget {
  const UserTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(loginRepositoryProvider).user;
        if (user == null) return const SizedBox.shrink();
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
          ],
        );
      },
    );
  }
}
