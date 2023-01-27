// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';

import '../../dialog/meet_participants_dialog.dart';
import '/controller/bmeet_providers.dart';
import '/controller/providers/bmeet_provider.dart';
import '/core/constants.dart';
import '/core/helpers/duration.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '../../screens.dart';

class BMeetCallScreen extends StatelessWidget {
  final Meeting meeting;
  final bool enableVideo;
  final bool disableMic;
  final String rtmToken;
  final String rtmUser;
  final String meetingId;
  final String appId;
  final String userName;
  final int userId;
  final int id;

  const BMeetCallScreen({
    Key? key,
    required this.meeting,
    required this.enableVideo,
    required this.disableMic,
    required this.rtmToken,
    required this.rtmUser,
    required this.meetingId,
    required this.appId,
    required this.userId,
    required this.userName,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return BaseWilPopupScreen(
        onBack: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          PIPView.of(context)?.presentBelow(const BMeetHomeScreen());
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: !isFloating,
          backgroundColor: Colors.black,
          appBar: _appBar(context),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 0),
            height: 10.h,
            color: Colors.black,
            child: _toolbar(),
          ),
          body: Stack(
            children: [
              Consumer(builder: (context, ref, child) {
                final provider = ref.watch(bMeetCallChangeProvider);

                provider.init(
                    ref, meeting, enableVideo, rtmToken, rtmUser, userId);

                ref.listen(bMeetCallChangeProvider, (previous, next) {
                  if (next.kickOut) {
                    _onCallEnd(context);
                  }
                });
                // ref.listen(
                //   endedMeetingProvider,
                //   (previous, next) {
                //     print('listen  $previous - to  - $next');
                //     if (next) {
                //       print('To Remove User');
                //       _onCallEnd(context);
                //     }
                //   },
                //   onError: (error, stackTrace) {
                //     print('To error: $error');
                //   },
                // );
                return provider.localUserJoined
                    ? _buildGridVideoView(provider)
                    : const Center(child: CircularProgressIndicator());
              }),
              _buildRow(context),
              Positioned(
                top: 12.h,
                left: 30.w,
                right: 30.w,
                child: Consumer(
                  builder: (context, ref, child) {
                    String id = ref.watch(raisedHandMeetingProvider);
                    return id.isNotEmpty
                        ? Column(
                            children: [
                              getSvgIcon('vc_raise_hand.svg', width: 12.w),
                              Text(
                                id,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Consumer(
            builder: (context, ref, child) {
              final duration = ref.watch(callTimerProvider).duration;
              return Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 2),
                  Text(
                    durationString(duration),
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              );
            },
          ),
          // child: StreamBuilder<int>(
          //   // stream: _stopWatchTimer.rawTime,
          //   // initialData: _stopWatchTimer.rawTime.value,
          //   builder: (context, snap) {
          //     final value = snap.data;
          //     final displayTime = StopWatchTimer.getDisplayTime(value,
          //         hours: true, second: true, milliSecond: false);
          //     return Row(
          //       children: <Widget>[
          //         const Icon(
          //           Icons.timer,
          //           size: 20,
          //           color: Colors.white,
          //         ),
          //         const SizedBox(width: 5),
          //         Text(
          //           displayTime,
          //           style: TextStyle(
          //               fontSize: 12.sp,
          //               color: Colors.white,
          //               fontFamily: 'Helvetica',
          //               fontWeight: FontWeight.normal),
          //         ),
          //       ],
          //     );
          //   },
          // ),
        ),
        IconButton(
          onPressed: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            PIPView.of(context)?.presentBelow(const BMeetHomeScreen());
          },
          icon: const Icon(
            Icons.close_fullscreen_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(2.w)),
      //     color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Consumer(builder: (context, ref, child) {
        bool volume = ref.watch(bMeetCallChangeProvider).speakerOn;

        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(bMeetCallChangeProvider).onSwitchCamera();
                    },
                    icon: getSvgIcon('vc_camera_flip.svg'),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(bMeetCallChangeProvider).toggleVolume();
                    },
                    icon:
                        // ignore: prefer_const_constructors
                        getSvgIcon(
                            color: Colors.white,
                            volume ? 'vc_volume_off.svg' : 'vc_volume.svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: InkWell(
                  onTap: () {
                    _showDetailDialog(context);
                  },
                  child: Row(
                    children: [
                      buildBText('Meet'),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  if (meeting.role != 'host' || id < 0) {
                    _onCallEnd(context);
                    return;
                  }
                  showLoading(ref);
                  await ref.read(bMeetCallChangeProvider).sendLeaveApi();
                  // _onCallEnd(context);
                  final error =
                      await ref.read(bMeetRepositoryProvider).leaveMeet(id);
                  hideLoading(ref);
                  if (error != null) {
                    print('error:$error');
                    AppSnackbar.instance.error(context, error);
                    _onCallEnd(context);
                  } else {
                    _onCallEnd(context);
                  }
                },
                child: Container(
                  width: 6.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: AppColors.redBColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.w))),
                  child: Text(
                    S.current.btn_end,
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                ),
              ),
              //     child: ElevatedButton(
              //   onPressed: () async {
              //     if (meeting.role != 'host' || id < 0) {
              //       _onCallEnd(context);
              //       return;
              //     }
              //     showLoading(ref);
              //     await ref.read(bMeetCallChangeProvider).sendLeaveApi();
              //     // _onCallEnd(context);
              //     final error =
              //         await ref.read(bMeetRepositoryProvider).leaveMeet(id);
              //     hideLoading(ref);
              //     if (error != null) {
              //       print('error:$error');
              //       AppSnackbar.instance.error(context, error);
              //       _onCallEnd(context);
              //     } else {
              //       _onCallEnd(context);
              //     }
              //   },
              //   style: elevatedButtonEndStyle,
              //   child: Text(
              //     S.current.btn_end,
              //     style: TextStyle(
              //       fontSize: 8.sp,
              //       fontFamily: kFontFamily,
              //     ),
              //   ),
              // )
            )
          ],
        );
      }),
    );
  }

  _showDetailDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, _) {
          return Container(
              height: 50.h,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  topRight: Radius.circular(3.w),
                ),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    "$rtmUser's Meeting Room",
                    style: TextStyle(
                        fontSize: 15.sp,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          S.current.bmeet_call_txt_meeting_id,
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            meetingId,
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          S.current.bmeet_call_txt_host_id,
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            meeting.channel,
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          S.current.bmeet_call_txt_invite_link,
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            S.current.bmeet_call_txt_na,
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          S.current.bmeet_call_txt_encryption,
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            S.current.bmeet_call_txt_enable,
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ));
        });
      },
    );
  }

  _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: _buildAppBar(context)

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Row(
        //       children: [
        //         Consumer(
        //           builder: (context, ref, child) {
        //             return GestureDetector(
        //               onTap: () {
        //                 ref.read(bMeetCallChangeProvider).onSwitchCamera();
        //               },
        //               child: Image.asset(
        //                 'assets/icons/svg/camera_flip.png',
        //                 height: 3.h,
        //                 width: 3.h,
        //               ),
        //             );
        //           },
        //         ),
        //         const SizedBox(
        //           width: 15,
        //         ),
        //         Consumer(
        //           builder: (context, ref, child) {
        //             bool volume = ref.watch(bMeetCallChangeProvider).speakerOn;
        //             return GestureDetector(
        //               onTap: () {
        //                 ref.read(bMeetCallChangeProvider).toggleVolume();
        //               },
        //               child: volume
        //                   ? Image.asset(
        //                       'assets/icons/svg/volume_off.png',
        //                       height: 3.h,
        //                       width: 3.h,
        //                     )
        //                   : SvgPicture.asset(
        //                       'assets/icons/svg/volume.svg',
        //                       height: 3.h,
        //                       width: 3.h,
        //                     ),
        //             );
        //           },
        //         ),
        //       ],
        //     ),
        //     GestureDetector(
        //       onTap: () => _showDetailDialog(context),
        //       child: Row(
        //         children: [
        //           buildBText('Meet'),
        //           // RichText(
        //           //   text: TextSpan(
        //           //     text: 'b',
        //           //     style: TextStyle(
        //           //         fontWeight: FontWeight.bold,
        //           //         color: Colors.red,
        //           //         fontSize: 12.sp),
        //           //     children: <TextSpan>[
        //           //       TextSpan(
        //           //         text: 'Meet',
        //           //         style: TextStyle(
        //           //             fontWeight: FontWeight.bold,
        //           //             color: Colors.white,
        //           //             fontSize: 12.sp),
        //           //       ),
        //           //     ],
        //           //   ),
        //           // ),
        //           const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
        //         ],
        //       ),
        //     ),
        //     Consumer(
        //       builder: (context, ref, child) {
        //         return GestureDetector(
        //           child: Container(
        //               decoration: BoxDecoration(
        //                   color: const Color(0xffca2424),
        //                   borderRadius: BorderRadius.circular(5)),
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 2.h, vertical: .5.h),
        //               child: Text(
        //                 S.current.bmeet_call_bxt_end.toUpperCase(),
        //                 style: TextStyle(
        //                     fontSize: 12.sp,
        //                     letterSpacing: .5,
        //                     fontWeight: FontWeight.w700),
        //               )),
        //           onTap: () async {
        //             if (meeting.role != 'host' || id < 0) {
        //               _onCallEnd(context);
        //               return;
        //             }
        //             await ref.read(bMeetCallChangeProvider).sendLeaveApi();
        //             // _onCallEnd(context);
        //             final error =
        //                 await ref.read(bMeetRepositoryProvider).leaveMeet(id);
        //             if (error != null) {
        //               print('error:$error');
        //               AppSnackbar.instance.error(context, error);
        //               _onCallEnd(context);
        //             } else {
        //               _onCallEnd(context);
        //             }
        //             // _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        //           },
        //         );
        //       },
        //     )
        //   ],
        // ),
        );
  }

  Widget _buildToolItem(
      {required Widget child,
      required String text,
      required Function() onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(1.w),
              width: 8.w,
              height: 8.w,
              child: child,
            ),
            // child,
            Text(
              text,
              maxLines: 1,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildToolItemIcon(
      {required IconData icon,
      required Color? color,
      required String text,
      required Function() onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(1.w),
              width: 8.w,
              height: 8.w,
              child: Icon(
                icon,
                color: color,
              ),
            ),
            // child,
            Text(
              text,
              maxLines: 1,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      // padding: EdgeInsets.only(left: 6.w, right: 5.w),
      padding: EdgeInsets.only(top: 1.h),
      alignment: Alignment.center,
      child: Consumer(
        builder: (context, ref, child) {
          final provider = ref.watch(bMeetCallChangeProvider);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildToolItemIcon(
                text: provider.muted
                    ? S.current.bmeet_tool_unmute
                    : S.current.bmeet_tool_mute,
                onTap: () {
                  if (provider.hostMute) {
                    EasyLoading.showToast(
                        S.current.bmeet_call_msg_diable_audio_host,
                        duration: const Duration(seconds: 5),
                        toastPosition: EasyLoadingToastPosition.bottom);
                  } else {
                    ref.read(bMeetCallChangeProvider).onToggleMute();
                  }
                },
                icon: provider.muted ? Icons.mic : Icons.mic_off,
                color: provider.muted ? Colors.white : Colors.red,
                // child: getSvgIcon(
                //   provider.muted ? 'vc_mic_on.svg' : 'vc_mic_off.svg',
                //   width: 2.w,
                // )
              ),
              _buildToolItemIcon(
                  text: provider.disableLocalCamera
                      ? S.current.bmeet_tool_stop_video
                      : S.current.bmeet_tool_video,
                  onTap: () {
                    if (provider.hostCamera) {
                      EasyLoading.showToast(
                          S.current.bmeet_call_msg_diable_camera_host,
                          duration: const Duration(seconds: 5),
                          toastPosition: EasyLoadingToastPosition.bottom);
                    } else {
                      ref.read(bMeetCallChangeProvider).toggleCamera();
                    }
                  },
                  icon: provider.disableLocalCamera
                      ? Icons.videocam
                      : Icons.videocam_off,
                  color: Colors.white
                  // child: getSvgIcon(
                  //     provider.camera ? 'vc_camera_on.svg' : 'vc_camera_off.svg'),
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
              _buildToolItem(
                text: provider.shareScreen
                    ? S.current.bmeet_tool_stop_sshare
                    : S.current.bmeet_tool_share_screen,
                onTap: () {
                  provider.toggleShareScreen();
                },
                child: Center(
                  child: provider.initializingScreenShare
                      ? const CircularProgressIndicator()
                      : Icon(
                          provider.shareScreen
                              ? Icons.stop_screen_share
                              : Icons.screen_share,
                          color: Colors.white,
                          size: 6.w,
                        ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _buildToolItemIcon(
                        text: S.current.bmeet_tool_participants,
                        onTap: () {
                          _showParticipantsList(context);
                        },
                        icon: Icons.people,
                        color: Colors.white
                        // child: getSvgIcon('vc_participants.svg'),
                        ),
                    if (provider.memberList.isNotEmpty)
                      Positioned(
                        right: 2.w,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(0.5.h),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.yellowAccent,
                          ),
                          alignment: Alignment.topRight,
                          child: Text(
                            "${provider.memberList.length}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 8.sp,
                                letterSpacing: .5,
                                color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildToolItem(
                text: S.current.bmeet_tool_raisehand,
                onTap: () {
                  provider.sendRaiseHand();
                },
                child: getSvgIcon('vc_raise_hand.svg'),
              ),
              _buildToolItem(
                text: S.current.bmeet_tool_more,
                onTap: () {
                  _addMoreDetails(context, provider);
                },
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _videoView(ConnectedUserInfo view) {
    return Expanded(
        child: Stack(
      children: [
        // view.view,
        Container(
          padding: const EdgeInsets.all(1),
          color: Colors.black,
          child: view.widget,
        ),
        Positioned(
          bottom: 2.h,
          left: 4.w,
          child: Text(
            view.name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: kFontFamily,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _expandedVideoRow(List<ConnectedUserInfo> views) {
    final wrappedViews = views.map(_videoView).toList();
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: wrappedViews,
      ),
    );
  }

  Widget _viewRows(BMeetProvider provider) {
    final views = provider.userList.values.toList();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[
            // _videoView(views[0], members[0])
            _expandedVideoRow(
              [views[0]],
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );

      case 3:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        );

      case 4:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
          ],
        );

      case 5:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 5)),
          ],
        );

      case 6:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6))
          ],
        );
      case 7:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 7))
          ],
        );
      case 8:
        return Column(
          children: [
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 8))
          ],
        );
      // case 9:
      //   return _buildGridVideoView(provider);
      default:
    }
    return Container();
  }

  Widget _buildGridVideoView(BMeetProvider provider) {
    if (provider.remoteUsersIds.length < 8) {
      // if (screenshareid == 1000) {
      //   return RtcRemoteView.SurfaceView(uid: 10000);
      // } else {
      //   return _viewRows(provider);
      // }
      return _viewRows(provider);
    } else {
      final views = provider.userList.values.toList();
      return GridView.builder(
          shrinkWrap: true,
          itemCount: views.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 9 / 12, crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            final viewModel = views[index];
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: viewModel.isSpeaking
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(1.0),
                                ),
                              ),
                              child: Container(
                                  color: Colors.white,
                                  child: viewModel.widget)),
                        ),
                        onTap: () {
                          provider.updateIndex(index);
                        },
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }
  }

  void _onShareWithEmptyFields(
      BuildContext context, String id, String type) async {
    shareUserMeetContent('Meeting Id', id, type);
  }

  _addMoreDetails(BuildContext context, BMeetProvider provider) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                padding: EdgeInsets.only(
                    top: 1.h, bottom: 3.h, left: 6.w, right: 6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                  ),
                  color: const Color(0xff4d4d4d),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Card(
                        color: const Color(0xff696969),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: const Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(2.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              provider.allMuted
                                                  ? Text(
                                                      S.current
                                                          .bmeet_call_bxt_muteall,
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          letterSpacing: .5,
                                                          color: provider
                                                                  .allMuted
                                                              ? Colors.red
                                                              : Colors.white),
                                                    )
                                                  : Text(
                                                      S.current
                                                          .bmeet_call_bxt_unmuteall,
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          letterSpacing: .5,
                                                          color: provider
                                                                  .allMuted
                                                              ? Colors.red
                                                              : Colors.white),
                                                    ),

                                              Icon(
                                                provider.allMuted
                                                    ? Icons.mic
                                                    : Icons.mic_off,
                                                color: Colors.white,
                                                size: 6.w,
                                              ),

                                              // Image.asset(
                                              //     'assets/icons/svg/mic_off.png',
                                              //     height: 2.h,
                                              //     width: 2.h,
                                              //   )
                                              // : SvgPicture.asset(
                                              //     'assets/icons/svg/mic_icon.svg',
                                              //     height: 2.h,
                                              //     width: 2.h,
                                              //   )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    provider.onToggleAllMute();
                                  });
                                }),
                            // Divider(
                            //   height: 1,
                            //   thickness: 2,
                            // ),

                            const Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: const Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(3.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                S.current
                                                    .bmeet_call_bxt_sharelink,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              getSvgIcon(
                                                'ic_set_share.svg',
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                              // SvgPicture.asset.asset(
                                              //   'assets/images/share.png',
                                              //   height: 2.h,
                                              //   width: 2.h,
                                              //   color: Colors.white,
                                              // )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    _onShareWithEmptyFields(
                                        context, meetingId, 'Meeting');
                                  });
                                }),
                            const Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: const Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.w)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(3.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                S.current
                                                    .bmeet_call_bxt_disconnect_all,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                'assets/icons/svg/disconnect.png',
                                                height: 2.h,
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    provider.sendLeaveApi();
                                    // EasyLoading.showInfo(
                                    //     S.current.bmeet_call_msg_na_yet);
                                    //  _onShareWithEmptyFields(context, widget.meetingid);
                                  });
                                }),
                            const Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: const Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.w)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(2.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                S.current.bmeet_call_bxt_record,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                'assets/icons/svg/recorder.png',
                                                height: 2.h,
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    provider.startRecording();
                                    EasyLoading.showInfo(
                                        S.current.bmeet_call_msg_na_yet);
                                    //  _onShareWithEmptyFields(context, widget.meetingid);
                                  });
                                }),
                          ],
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 0,
                        color: const Color(0xff696969),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.w)),
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Text(
                            S.current.bmeet_call_bxt_cancel,
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ),
                        )),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  // _showDetails(BuildContext context, BMeetProvider provider) {}
  _showParticipantsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MeetParticipantsDialog(isHost: meeting.role == 'host');
      },
    );
  }

  // Widget _buildMember(
  //     BuildContext context, BMeetProvider provider, AgoraRtmMember member) {
  //   final split = member.userId.split(':');
  //   String name = split[1];
  //   String id = split[0];
  //   final ConnectedUserInfo? info = provider.userList[id];

  //   return Container(
  //     padding: EdgeInsets.all(2.w),
  //     child: Row(
  //       children: [
  //         getCicleAvatar(info?.name ?? name, ''),
  //         SizedBox(width: 3.w),
  //         Text(
  //           name,
  //           style: TextStyle(
  //             fontFamily: kFontFamily,
  //             color: Colors.white,
  //             fontSize: 9.sp,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const Spacer(),
  //         Visibility(
  //           visible: meeting.role == 'host',
  //           child: Row(
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   provider.sendPeerMessage(id, 'content');
  //                 },
  //                 child: getSvgIcon(
  //                   info?.muteAudio == true
  //                       ? 'vc_mic_off.svg'
  //                       : 'vc_mic_off.svg',
  //                 ),
  //               ),
  //               SizedBox(width: 2.w),
  //               InkWell(
  //                 onTap: () {
  //                   provider.sendPeerMessage(id, 'content');
  //                 },
  //                 child: getSvgIcon(
  //                   info?.enabledVideo == true
  //                       ? 'vc_video_off.svg'
  //                       : 'vc_video_on.svg',
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 style: elevatedButtonEndStyle,
  //                 onPressed: () {
  //                   provider.sendPeerMessage(id, 'remove');
  //                 },
  //                 child: Text(
  //                   S.current.btn_remove,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // /// ==========  Meeting Joiner Users ==============
  // _participantsList(BuildContext context, BMeetProvider provider) {
  //   var userAudio = [], userVideo = [];
  //   final List<AgoraRtmMember> members = provider.memberList;
  //   for (int i = 0; i < members.length; i++) {
  //     userAudio.add(false);
  //     userVideo.add(false);
  //   }
  //   // debugPrint("Joiner $joiner");
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return Container(
  //           height: 100.h,
  //           margin: EdgeInsets.symmetric(horizontal: 3.w),
  //           padding:
  //               EdgeInsets.only(top: 1.h, bottom: 3.h, left: 4.w, right: 4.w),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(3.w),
  //               topRight: Radius.circular(3.w),
  //             ),
  //             color: Color(0xff4d4d4d),
  //           ),
  //           child: Column(
  //             children: [
  //               SizedBox(height: 1.h),
  //               SizedBox(
  //                 height: .7.h,
  //                 child: Container(
  //                   height: 3,
  //                   width: 80,
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(20)),
  //                 ),
  //               ),
  //               SizedBox(height: 1.5.h),
  //               SizedBox(
  //                 height: 48.h,
  //                 child: SingleChildScrollView(
  //                   child: ListView.separated(
  //                       scrollDirection: Axis.vertical,
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemBuilder: (context, index) {
  //                         AgoraRtmMember member = members[index];
  //                         return Card(
  //                           color: const Color(0xff696969),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(10),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text(
  //                                   member.userId.toString().split(":")[1],
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 13.sp,
  //                                   ),
  //                                 ),
  //                                 meeting.role == 'host'
  //                                     ? Row(
  //                                         children: [
  //                                           GestureDetector(
  //                                               onTap: () {
  //                                                 setState(() {
  //                                                   if (userVideo[index] ==
  //                                                       false) {
  //                                                     userVideo[index] = true;
  //                                                     provider.sendPeerMessage(
  //                                                         member.userId
  //                                                             .toString(),
  //                                                         'videocam_off');
  //                                                   } else {
  //                                                     userVideo[index] = false;
  //                                                     provider.sendPeerMessage(
  //                                                         member.userId
  //                                                             .toString(),
  //                                                         'videocam_on');
  //                                                   }
  //                                                 });
  //                                               },
  //                                               child: userVideo[index] == false
  //                                                   ? SvgPicture.asset(
  //                                                       'assets/icons/svg/video_camera.svg',
  //                                                       height: 3.h,
  //                                                       width: 3.h,
  //                                                     )
  //                                                   : Image.asset(
  //                                                       'assets/icons/svg/video_camera.png',
  //                                                       height: 3.h,
  //                                                       width: 3.h,
  //                                                     )),
  //                                           const SizedBox(width: 10),
  //                                           GestureDetector(
  //                                               onTap: () {
  //                                                 setState(() {
  //                                                   provider.sendPeerMessage(
  //                                                       member.userId,
  //                                                       userAudio[index]
  //                                                           ? 'mic_on'
  //                                                           : 'mic_off');
  //                                                   userAudio[index] =
  //                                                       !userAudio[index];
  //                                                 });
  //                                               },
  //                                               child: userAudio[index] == false
  //                                                   ? SvgPicture.asset(
  //                                                       'assets/icons/svg/mic_icon.svg',
  //                                                       height: 3.h,
  //                                                       width: 3.h,
  //                                                     )
  //                                                   : Image.asset(
  //                                                       'assets/icons/svg/mic_off.png',
  //                                                       height: 3.h,
  //                                                       width: 3.h,
  //                                                     )),
  //                                         ],
  //                                       )
  //                                     : Container(),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       separatorBuilder: (_, __) => SizedBox(height: 1.h),
  //                       itemCount: members.length),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
}
