import '../../../core/constants/colors.dart';
import '../../../core/ui_core.dart';

class ChatVideoCall extends StatelessWidget {
  const ChatVideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/pexels-pixabay-220453.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                height: 10.h,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15)),
                child: _toolbar(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, right: 4.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 20.h,
                width: 35.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/pexels-juan-gomez-2589653.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Container(
        // padding: EdgeInsets.only(left: 6.w, right: 5.w),

        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getSvgIcon('vc_camera_flip.svg'),
            getSvgIcon('vc_mic_off.svg'),

            getSvgIcon('vc_video_off.svg'),

            // provider.muted
            //     ? Image.asset(
            //         'assets/icons/svg/mic_off.png',
            //         height: 3.h,
            //         width: 3.h,
            //       )
            //     : SvgPicture.asset(
            //         'assets/icons/svg/mic_icon.svg',
            //         height: 3.h,
            //         width: 3.h,
            //       )),
            // GestureDetector(
            //     onTap: () {
            //       _onShareWithEmptyFields(context, meetingId, 'Meeting');
            //     },
            //     child: SvgPicture.asset(
            //       'assets/icons/svgs/ic_set_share.svg',
            //       height: 3.h,
            //       width: 3.h,
            //       color: Colors.white,
            //     )),
            // SizedBox(
            //     width: 5.h, height: 5.h, child: _buildShareScreen(provider)),

            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 6.5.h,
                width: 13.w,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: AppColors.redBColor,
                    borderRadius: BorderRadius.circular(3.w)),
                child: getSvgIcon("hang_up.svg"),
              ),
            )
          ],
        ));
  }
}
