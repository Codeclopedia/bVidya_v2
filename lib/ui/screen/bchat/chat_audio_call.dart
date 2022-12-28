import 'package:bvidya/core/ui_core.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class ChatAudioCall extends StatelessWidget {
  const ChatAudioCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage(
                  'assets/images/pexels-pixabay-220453.jpg',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20.w,
                    backgroundImage: const AssetImage(
                      "assets/images/pexels-pixabay-220453.jpg",
                    ),
                  ),
                  Text(
                    "Calling",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 5.w),
                  ),
                  Text(
                    "Username",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 6.w),
                  ),
                ],
              ),
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
            getSvgIcon('vc_mic_off.svg'),
            getSvgIcon('vc_video_on.svg', color: Colors.grey),
            getSvgIcon('vc_sound_on.svg'),
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
