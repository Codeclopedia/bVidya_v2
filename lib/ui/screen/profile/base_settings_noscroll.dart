import '/core/constants.dart';
import '/data/models/response/auth/login_response.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class BaseNoScrollSettings extends StatelessWidget {
  final Widget bodyContent;
  // final bool showEmail;
  final bool showName;

  const BaseNoScrollSettings({
    Key? key,
    required this.bodyContent,
    this.showName = true,
    // this.showEmail = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTopColor,
              AppColors.gradientLiveBottomColor,
            ],
          ),
        ),
        child: SafeArea(
            child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 9.h),
              // padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                ),
              ),
              // child: Container(
              //   height: double.infinity,
              //   padding: EdgeInsets.only(top: 7.h),
              //   child: bodyContent,
              // ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg')),

            UserConsumer(
              builder: (context, user, ref) {
                return _buildUser(user);
              },
            )
            // Container(
            //   alignment: Alignment.topCenter,
            //   margin: EdgeInsets.only(top: 4.h),
            //   child: Column(
            //     children: [
            //       getRectFAvatar(size: 22.w, 'User Name', ''),
            //       Text('User Name',
            //           style: TextStyle(
            //               fontFamily: kFontFamily,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 17.sp,
            //               color: Colors.black)),
            //     ],
            //   ),
            // )
          ],
        )),
      ),
    );
  }

  Widget _buildUser(User? user) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getRectFAvatar(
              size: 22.w,
              user?.name ?? '',
              user?.image ?? '',
              cacheHeight: (40.w * devicePixelRatio).round(),
              cacheWidth: (40.w * devicePixelRatio).round()),
          if (showName)
            Text(
              user?.name ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black),
            ),
          Expanded(child: bodyContent)
          // Text(
          //   user?.email ?? '',
          //   style: TextStyle(
          //     fontSize: 8.sp,
          //     fontWeight: FontWeight.w600,
          //     color: AppColors.primaryColor,
          //     fontFamily: kFontFamily,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: []);
  }
}

// const avatarPlaceHolderColors = [
//   Color(0xFF1abc9c),
//   Color(0xFFf1c40f),
//   Color(0xFF8e44ad),
//   Color(0xFFe74c3c),
//   Color(0xFFd35400),
//   Colors.green,
//   Colors.blue,
//   Color(0xFF7f8c8d),
// ];

// Widget getRectFAvatar(String name, String image, {double? size}) => Avatar(
//       shape: AvatarShape.rectangle(
//         size ?? 14.w,
//         size ?? 14.w,
//         BorderRadius.all(Radius.circular(3.w)),
//       ),
//       name: name,
//       placeholderColors: avatarPlaceHolderColors,
//       textStyle: TextStyle(
//         // fontFamily: kFontFamily,
//         // color: AppColors.contactNameTextColor,
//         fontSize: 14.sp,
//       ),
//       sources: [
//         // if (image.startsWith('http'))?
//         if (image.isNotEmpty && !image.startsWith("asset"))
//           // GenericSource(
//           //   getImageProvider(
//           //       image.startsWith('http') ? image : '$baseImageApi$image'),
//           // ),
//           // NetworkSource(Hi
//           //   image.startsWith('http') ? image : '$baseImageApi$image',
//           // ),
//           if (image.isNotEmpty && image.startsWith("asset"))
//             GenericSource(
//               AssetImage(image),
//             ),
//       ],
//     );

// SvgPicture getSvgIcon(String name, {double? width = 24.0, Color? color, double? height = 24.0}) =>
//     SvgPicture.asset(
//       'assets/$name',
//       width: width,
//       color: color,
//       fit: BoxFit.fitWidth,
//     );
