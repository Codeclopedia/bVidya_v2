import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import '../../../controller/bchat_providers.dart';
import '../../../core/constants/colors.dart';
import '../../../core/helpers/call_helper.dart';
import '../../../core/helpers/duration.dart';
import '../../../core/state.dart';
import '../../../core/ui_core.dart';
import '../../../data/models/models.dart';
import '../../base_back_screen.dart';
import '../home/home_screen.dart';

class ChatAudioCall extends StatelessWidget {
  final String name;
  final String image;
  final CallBody callInfo;
  final CallDirectionType type;

  const ChatAudioCall(
      {super.key,
      required this.name,
      required this.image,
      required this.callInfo,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return BaseWilPopupScreen(
        onBack: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          PIPView.of(context)?.presentBelow(const HomeScreen());
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: !isFloating,
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      image: getImageProvider(image)

                      // const AssetImage(
                      //   'assets/images/pexels-pixabay-220453.jpg',
                      // ),
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
        ),
      );
    });
  }

  Widget _toolbar(BuildContext context) {
    return Container(
        // padding: EdgeInsets.only(left: 6.w, right: 5.w),

        alignment: Alignment.center,
        child: Consumer(builder: (context, ref, child) {
          final provider = ref.watch(audioCallChangeProvider);
          provider.init(callInfo, type, CallType.audio);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  provider.toggleMute();
                },
                child: getSvgIcon(
                    provider.mute ? 'vc_mic_on.svg' : 'vc_mic_off.svg'),
              ),
              GestureDetector(
                onTap: () {
                  //
                },
                child: getSvgIcon('vc_video_on.svg', color: Colors.grey),
              ),
              GestureDetector(
                onTap: () {
                  provider.toggleSpeaker();
                },
                child: getSvgIcon(provider.speakerOn
                    ? 'vc_sound_off.svg'
                    : 'vc_sound_on.svg'),
              ),
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
          );
        }));
  }
}
