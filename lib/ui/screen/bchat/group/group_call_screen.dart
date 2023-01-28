// ignore_for_file: use_build_context_synchronously

// import 'package:bvidya/controller/providers/p2p_call_provider.dart';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/group_call_provider.dart';
import '/core/helpers/duration.dart';
import '/core/helpers/call_helper.dart';
import '/data/models/models.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '/core/state.dart';
import '/ui/base_back_screen.dart';
import '/ui/screen/bchat/group/groups_screen.dart';

class GroupCallScreen extends StatelessWidget {
  // final ChatGroup groupModel;

  final CallType callType;
  final String callId;
  final int callRequiestId;
  final CallDirectionType callDirectionType;

  // final RTMUserTokenResponse? rtmTokem;
  final List<Contacts>? members;
  final Meeting? meeting;
  final String groupId;
  final String groupName;
  final User me;
  final String membersIds;
  final String prevScreen;

  const GroupCallScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.callId,
    required this.callRequiestId,
    required this.callType,
    required this.callDirectionType,
    required this.me,
    required this.membersIds,
    required this.prevScreen,
    this.meeting,
    this.members,

    // this.rtmTokem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return BaseWilPopupScreen(
        onBack: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          PIPView.of(context)?.presentBelow(const GroupsScreen());
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: !isFloating,
          backgroundColor: Colors.black,
          // appBar: _appBar(context),
          bottomNavigationBar: _toolbar(context),
          body: Stack(children: [
            Consumer(builder: (context, ref, child) {
              final provider = ref.watch(bGroupCallChangeProvider);
              if (callDirectionType == CallDirectionType.outgoing) {
                provider.init(ref, callRequiestId, callId, groupId, me,
                    meeting!, callType, members!, callDirectionType);
              } else {
                provider.initReceiver(context, ref, callRequiestId, callId,
                    groupId, callType, me, membersIds);
              }
              ref.listen(bGroupCallChangeProvider, (previous, next) {
                if (next.error != null) {
                  AppSnackbar.instance.error(context, next.error!);
                  _onCallEnd(context, ref);
                }
              });

              ref.listen(bGroupCallChangeProvider, (previous, next) {
                if (next.endCall) {
                  _onCallEnd(context, ref);
                }
              });

              return provider.localUserJoined
                  ? _buildGridVideoView(provider)
                  : const Center(child: CircularProgressIndicator());
            }),
            _buildRow(context),
          ]),
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
              final duration = ref.watch(groupCallTimerProvider).duration;
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
        ),
        IconButton(
          onPressed: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            PIPView.of(context)?.presentBelow(const GroupsScreen());
          },
          icon: const Icon(
            Icons.close_fullscreen_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _onCallEnd(BuildContext context, WidgetRef ref) async {
    showLoading(ref);
    final error = await ref
        .read(bGroupCallChangeProvider)
        .endCurrentCall(callDirectionType, groupName);
    hideLoading(ref);

    if (error != null) {
      print('error:$error');
      AppSnackbar.instance.error(context, error);
    } else {}
    if (prevScreen.isNotEmpty) {
      Navigator.pop(context);
      setScreen(prevScreen);
    } else {
      setScreen(RouteList.homeDirect);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteList.homeDirect,
        (route) => false,
      );
    }
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: _toolbar(context));
  }

  Widget _toolbar(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.read(bGroupCallChangeProvider);
      return SizedBox(
          // padding: EdgeInsets.only(left: 6.w, right: 5.w),
          // alignment: Alignment.center,
          width: 85.w,
          height: 12.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: callType == CallType.video,
                child: GestureDetector(
                  onTap: () {
                    provider.onSwitchCamera();
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
                  provider.onToggleMute();
                },
                child: Icon(
                  provider.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 10.w,
                ),
                // child: getSvgIcon(
                //     width: 8.w,
                //     provider.mute ? 'vc_mic_off.svg' : 'vc_mic_on.svg'),
              ),
              Visibility(
                visible: callType == CallType.video,
                child: GestureDetector(
                  onTap: () {
                    //
                    provider.toggleCamera();
                  },
                  child: Icon(
                    provider.disableLocalCamera
                        ? Icons.videocam_rounded
                        : Icons.videocam_off_rounded,
                    color: Colors.white,
                    size: 10.w,
                  ),
                  // child: getSvgIcon(
                  //     width: 8.w,
                  //     provider.videoOn ? 'vc_video_off.svg' : 'vc_video_on.svg'),
                ),
              ),
              Visibility(
                visible: callType == CallType.audio,
                child: GestureDetector(
                  onTap: () {
                    provider.toggleVolume();
                  },
                  child: Icon(
                    provider.speakerOn
                        ? Icons.volume_mute_rounded
                        : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 10.w,
                  ),
                ),
              ),
              Consumer(builder: (context, ref, child) {
                return InkWell(
                  onTap: () async {
                    _onCallEnd(context, ref);
                    // _finish(context);
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
                );
              })
            ],
          ));
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Consumer(builder: (context, ref, child) {
        bool volume = ref.watch(bGroupCallChangeProvider).speakerOn;
        // bool volume = false;
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
                      // ref.read(bGroupCallChangeProvider).onSwitchCamera();
                    },
                    icon: getSvgIcon('vc_camera_flip.svg'),
                  ),
                  IconButton(
                    onPressed: () {
                      // ref.read(bGroupCallChangeProvider).toggleVolume();
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
                  onTap: () {},
                  child: Row(
                    children: [
                      Expanded(child: buildBText('GroupCall')),
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
                  _onCallEnd(context, ref);
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
            )
          ],
        );
      }),
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
                color: Colors.white,
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

  // Widget _toolbar() {
  //   return Container(
  //     // padding: EdgeInsets.only(left: 6.w, right: 5.w),
  //     padding: EdgeInsets.only(top: 1.h),
  //     alignment: Alignment.center,
  //     child: Consumer(
  //       builder: (context, ref, child) {
  //         final provider = ref.watch(bGroupCallChangeProvider);
  //         return Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             _buildToolItemIcon(
  //                 text: provider.muted
  //                     ? S.current.bmeet_tool_unmute
  //                     : S.current.bmeet_tool_mute,
  //                 onTap: () {
  //                   if (provider.hostMute) {
  //                     EasyLoading.showToast(
  //                         S.current.bmeet_call_msg_diable_audio_host,
  //                         duration: const Duration(seconds: 5),
  //                         toastPosition: EasyLoadingToastPosition.bottom);
  //                   } else {
  //                     ref.read(bGroupCallChangeProvider).onToggleMute();
  //                   }
  //                 },
  //                 icon: provider.muted ? Icons.mic : Icons.mic_off
  //                 // child: getSvgIcon(
  //                 //   provider.muted ? 'vc_mic_on.svg' : 'vc_mic_off.svg',
  //                 //   width: 2.w,
  //                 // )
  //                 ),
  //             _buildToolItemIcon(
  //                 text: provider.disableLocalCamera
  //                     ? S.current.bmeet_tool_stop_video
  //                     : S.current.bmeet_tool_video,
  //                 onTap: () {
  //                   if (provider.hostCamera) {
  //                     EasyLoading.showToast(
  //                         S.current.bmeet_call_msg_diable_camera_host,
  //                         duration: const Duration(seconds: 5),
  //                         toastPosition: EasyLoadingToastPosition.bottom);
  //                   } else {
  //                     ref.read(bGroupCallChangeProvider).toggleCamera();
  //                   }
  //                 },
  //                 icon: provider.disableLocalCamera
  //                     ? Icons.videocam
  //                     : Icons.videocam_off
  //                 // child: getSvgIcon(
  //                 //     provider.camera ? 'vc_camera_on.svg' : 'vc_camera_off.svg'),
  //                 ),

  //             // provider.muted
  //             //     ? Image.asset(
  //             //         'assets/icons/svg/mic_off.png',
  //             //         height: 3.h,
  //             //         width: 3.h,
  //             //       )
  //             //     : SvgPicture.asset(
  //             //         'assets/icons/svg/mic_icon.svg',
  //             //         height: 3.h,
  //             //         width: 3.h,
  //             //       )),
  //             // GestureDetector(
  //             //     onTap: () {
  //             //       _onShareWithEmptyFields(context, meetingId, 'Meeting');
  //             //     },
  //             //     child: SvgPicture.asset(
  //             //       'assets/icons/svgs/ic_set_share.svg',
  //             //       height: 3.h,
  //             //       width: 3.h,
  //             //       color: Colors.white,
  //             //     )),
  //             // SizedBox(
  //             //     width: 5.h, height: 5.h, child: _buildShareScreen(provider)),
  //             _buildToolItem(
  //               text: provider.shareScreen
  //                   ? S.current.bmeet_tool_stop_sshare
  //                   : S.current.bmeet_tool_share_screen,
  //               onTap: () {
  //                 provider.toggleShareScreen();
  //               },
  //               child: Center(
  //                 child: provider.initializingScreenShare
  //                     ? const CircularProgressIndicator()
  //                     : Icon(
  //                         provider.shareScreen
  //                             ? Icons.stop_screen_share
  //                             : Icons.screen_share,
  //                         color: Colors.white,
  //                         size: 6.w,
  //                       ),
  //               ),
  //             ),
  //             Expanded(
  //               child: Stack(
  //                 children: [
  //                   _buildToolItemIcon(
  //                       text: S.current.bmeet_tool_participants,
  //                       onTap: () {
  //                         // _showParticipantsList(context);
  //                       },
  //                       icon: Icons.people
  //                       // child: getSvgIcon('vc_participants.svg'),
  //                       ),
  //                   if (provider.memberList.isNotEmpty)
  //                     Positioned(
  //                       right: 2.w,
  //                       top: 0,
  //                       child: Container(
  //                         padding: EdgeInsets.all(0.5.h),
  //                         decoration: const BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: AppColors.yellowAccent,
  //                         ),
  //                         alignment: Alignment.topRight,
  //                         child: Text(
  //                           "${provider.memberList.length}",
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               fontSize: 8.sp,
  //                               letterSpacing: .5,
  //                               color: Colors.black),
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             _buildToolItem(
  //               text: S.current.bmeet_tool_raisehand,
  //               onTap: () {
  //                 provider.sendRaiseHand();
  //               },
  //               child: getSvgIcon('vc_raise_hand.svg'),
  //             ),
  //             _buildToolItem(
  //               text: S.current.bmeet_tool_more,
  //               onTap: () {
  //                 // _addMoreDetails(context, provider);
  //               },
  //               child: const Icon(
  //                 Icons.more_horiz,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _videoView(GroupCallUser view) {
    return Expanded(
        child: Stack(
      children: [
        // view.view,
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(1),
          color: Colors.black,
          child: view.widget,
        ),
        Positioned(
          bottom: 2.h,
          left: 4.w,
          child: Text(
            view.contact.name,
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

  Widget _expandedVideoRow(List<GroupCallUser> views) {
    final wrappedViews = views.map(_videoView).toList();
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: wrappedViews,
      ),
    );
  }

  Widget _viewRows(GroupCallProvider provider) {
    final views = provider.userList.values
        .where((element) => element.widget != null)
        .toList();
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

  Widget _buildGridVideoView(GroupCallProvider provider) {
    if (provider.remoteUsersIds.length < 8) {
      // if (screenshareid == 1000) {
      //   return RtcRemoteView.SurfaceView(uid: 10000);
      // } else {
      //   return _viewRows(provider);
      // }
      return _viewRows(provider);
    } else {
      final views = provider.userList.values
          .where((element) => element.widget != null)
          .toList();
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
                              viewModel.contact.name,
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
}
