import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';

import '/controller/providers/p2p_call_provider.dart';
import '/controller/bchat_providers.dart';
import '/core/constants/colors.dart';
import '/core/helpers/call_helper.dart';
import '/core/helpers/duration.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../base_back_screen.dart';
import '../home/home_screen.dart';

class ChatCallScreen extends ConsumerWidget {
  // const ChatVideoCall({super.key});
  final String name;
  final String image;
  final CallBody callInfo;
  final CallDirectionType callDirection;
  final CallType callType;

  const ChatCallScreen(
      {super.key,
      required this.name,
      required this.image,
      required this.callInfo,
      required this.callType,
      required this.callDirection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(audioCallChangeProvider);

    provider.init(callInfo, callDirection, callType);

    ref.listen(audioCallChangeProvider, (previous, next) {
      if (next.isCallEnded) {
        Navigator.pop(context);
      }
    });
    final call = ref.watch(audioCallTimerProvider);
    final String status;
    if (call.running) {
      status = durationString(call.duration);
    } else {
      status = ref.watch(audioCallChangeProvider).status;
    }

    return PIPView(builder: (context, isFloating) {
      return BaseWilPopupScreen(
        onBack: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          PIPView.of(context)?.presentBelow(const HomeScreen());
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: !isFloating,
          body: Stack(
            children: [
              provider.updateCallType == CallType.audio
                  ? _buildAudioBackground()
                  : _buildVideoBackground(provider),
              Visibility(
                visible: provider.updateCallType == CallType.audio ||
                    !provider.remoteVideoOn,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        getCicleAvatar(name, image, radius: 20.w),
                        // CircleAvatar(
                        //     radius: 20.w, backgroundImage: getImageProvider(image)
                        //     //  const AssetImage(
                        //     //   "assets/images/pexels-pixabay-220453.jpg",
                        //     // ),
                        //     ),
                        Text(
                          status,
                          style: TextStyle(
                              fontFamily: kFontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 5.w),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontFamily: kFontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 6.w),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 14.h,
                right: 4.w,
                // padding: EdgeInsets.only(bottom: 15.h, right: 4.w),
                child: Visibility(
                  visible: provider.updateCallType == CallType.video,
                  child: SizedBox(
                    height: 45.w,
                    width: 30.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: _buildLocalView(provider.localId, provider.engine),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 8.w,
                  top: 12.h,
                  child: Visibility(
                    visible: provider.remoteId > 0,
                    child: Icon(
                      provider.remoteMute
                          ? Icons.mic_off_rounded
                          : Icons.mic_rounded,
                      size: 8.w,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                right: 12.w,
                bottom: 16.h,
                child: Visibility(
                  visible: provider.updateCallType == CallType.video,
                  child: Text(
                    status,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 5.w),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  height: 10.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: _toolbar(context, provider),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVideoRemote(int id, RtcEngine engine) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(
          uid: id,
          renderMode: RenderModeType.renderModeHidden,
          isScreenView: false,
          sourceType: VideoSourceType.videoSourceRemote,
        ),
        connection: RtcConnection(channelId: callInfo.callChannel),
      ),
    );
  }

  Widget _buildLocalView(int id, RtcEngine? engine) {
    return engine == null
        ? Image.asset(
            "assets/images/pexels-juan-gomez-2589653.jpg",
            fit: BoxFit.cover,
          )
        : AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: engine,
              canvas: const VideoCanvas(
                uid: 0,
                renderMode: RenderModeType.renderModeHidden,
                isScreenView: false,
                sourceType: VideoSourceType.videoSourceCamera,
              ),
            ),
          );
  }

  Widget _buildVideoBackground(P2PCallProvider provider) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: provider.remoteId < 0 ||
              provider.engine == null ||
              !provider.remoteVideoOn
          ? _buildAudioBackground()
          : _buildVideoRemote(provider.remoteId, provider.engine!),
    );
  }

  Widget _buildAudioBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
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
    );
  }

  Widget _toolbar(BuildContext context, P2PCallProvider provider) {
    return SizedBox(
        // padding: EdgeInsets.only(left: 6.w, right: 5.w),
        width: 85.w,
        height: 12.h,
        // alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              // visible: provider.updateCallType == CallType.video,
              child: GestureDetector(
                onTap: () {
                  provider.switchCamera();
                },
                // child: Icon(
                //   Icons.switch_camera,
                //   color: Colors.white,
                //   size: 8.w,
                // ),
                child: getSvgIcon(width: 8.w, 'vc_camera_flip.svg'),
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.toggleMute();
              },
              child: Icon(
                provider.mute ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 10.w,
              ),
              // child: getSvgIcon(
              //     width: 8.w,
              //     provider.mute ? 'vc_mic_off.svg' : 'vc_mic_on.svg'),
            ),
            GestureDetector(
              onTap: () {
                //
                provider.toggleVideo(context);
              },
              child: Icon(
                provider.videoOn
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                color: Colors.white,
                size: 10.w,
              ),
              // child: getSvgIcon(
              //     width: 8.w,
              //     provider.videoOn ? 'vc_video_off.svg' : 'vc_video_on.svg'),
            ),
            Visibility(
              // visible: provider.updateCallType == CallType.audio,
              child: GestureDetector(
                onTap: () {
                  provider.toggleSpeaker();
                },
                child: Icon(
                  provider.speakerOn
                      ? Icons.volume_mute_rounded
                      : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 10.w,
                ),
                // child: getSvgIcon(
                //     width: 8.w,
                //     provider.speakerOn
                //         ? 'vc_sound_off.svg'
                //         : 'vc_sound_on.svg'),
              ),
            ),
            // getSvgIcon('vc_camera_flip.svg'),
            // getSvgIcon('vc_mic_off.svg'),
            // getSvgIcon('vc_video_off.svg'),

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
                height: 12.w,
                width: 20.w,

                // padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: AppColors.redBColor,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 8.w,
                ),
                // child: getSvgIcon("hang_up.svg"),
              ),
            )
          ],
        ));
  }
}
