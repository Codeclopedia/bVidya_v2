import 'package:easy_image_viewer/easy_image_viewer.dart';

import '/core/constants.dart';

import '/data/models/response/auth/login_response.dart';
// import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'base_drawer_page.dart';

class BaseDrawerSettingScreen extends StatelessWidget {
  final Widget bodyContent;
  // final String screenName;
  final int currentIndex;
  final bool showEmail;

  const BaseDrawerSettingScreen(
      {Key? key,
      required this.bodyContent,
      // required this.screenName,
      required this.currentIndex,
      this.showEmail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerPage(
      currentIndex: currentIndex,
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
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteList.home, (route) => false);
                },
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  color: Colors.white,
                )),
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
              //   child: SingleChildScrollView(
              //     child: bodyContent,
              //     // child: _buildBody(),
              //   ),
              // ),
            ),
            UserConsumer(
              builder: (context, user, ref) {
                return _buildUser(user, context, ref);
              },
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildUser(User user, BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 4.h),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
              onTap: () async {
                await showImageViewer(
                    context,
                    getImageProvider(user.image,
                        maxHeight: (200.w * devicePixelRatio).round(),
                        maxWidth: (200.w * devicePixelRatio).round()),
                    doubleTapZoomable: true, onViewerDismissed: () {
                  // print("dismissed");
                });
              },
              child: getRectFAvatar(
                  size: 22.w,
                  user.name,
                  user.image,
                  cacheHeight: (50.w * devicePixelRatio).round(),
                  cacheWidth: (50.w * devicePixelRatio).round())),
          Text(
            user.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: Colors.black),
          ),
          if (showEmail)
            Text(
              user.email,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                fontFamily: kFontFamily,
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: bodyContent,
              // child: _buildBody(),
            ),
          ),
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
