import '../../../core/state.dart';
import '../../../core/ui_core.dart';

class BaseSettings extends StatelessWidget {
  final Widget bodyContent;
  static const Color gradientTopColor = Color(0xFF360C35);
  static const Color gradientLiveBottomColor = Color(0xFF9C1132);

  const BaseSettings({Key? key, required this.bodyContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientTopColor,
              gradientLiveBottomColor,
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
                borderRadius: BorderRadius.all(
                  Radius.circular(4.w),
                ),
              ),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.only(top: 7.h),
                child: SingleChildScrollView(
                  child: bodyContent,
                  // child: _buildBody(),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg')),
            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(loginRepositoryProvider).user;
                return Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 4.h),
                  child: Column(
                    children: [
                      getRectFAvatar(
                          size: 22.w, user?.name ?? '', user?.image ?? ''),
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        )),
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
