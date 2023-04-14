// ignore_for_file: use_build_context_synchronously

// import '/controller/providers/p2p_call_provider.dart';
import 'package:wakelock/wakelock.dart';

import '/core/utils/callkit_utils.dart';

import '/ui/screen/blearn/components/common.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final String groupImage;
  final User me;
  final String membersIds;
  final String prevScreen;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GroupCallScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.groupImage,
    required this.callId,
    required this.callRequiestId,
    required this.callType,
    required this.callDirectionType,
    required this.me,
    required this.membersIds,
    required this.prevScreen,
    this.meeting,
    this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return PIPView(builder: (context, isFloating) {
      return BaseWilPopupScreen(
        onBack: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          PIPView.of(context)?.presentBelow(const GroupsScreen());
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: !isFloating,
          backgroundColor: const Color(0xFF222222),
          // appBar: _appBar(context),
          // bottomNavigationBar: _toolbar(context),
          body: SafeArea(
            child: Stack(children: [
              if (callType == CallType.audio) ..._buildAudioCallScreen(),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildRow(context),
                  Expanded(
                    child: Consumer(builder: (context, ref, child) {
                      final provider = ref.watch(bGroupCallChangeProvider);
                      if (callDirectionType == CallDirectionType.outgoing) {
                        provider.init(ref, callRequiestId, callId, groupId, me,
                            meeting!, callType, members!, callDirectionType);
                      } else {
                        provider.initReceiver(context, ref, callRequiestId,
                            callId, groupId, callType, me, membersIds);
                      }
                      ref.listen(bGroupCallChangeProvider, (previous, next) {
                        if (next.error != null) {
                          AppSnackbar.instance.error(context, next.error!);
                          _onCallEnd(context, ref);
                        }
                      });

                      ref.listen(
                          bGroupCallChangeProvider.select(
                              (value) => value.endCall), (previous, next) {
                        // print('$previous to =>  $next ');
                        if (previous != true && next) {
                          _onCallEnd(context, ref);
                        }
                      });

                      return provider.localUserJoined
                          ? _buildGridVideoView(provider)
                          : const Center(child: CircularProgressIndicator());
                    }),
                  ),
                ],
              ),
              Positioned(
                bottom: 1.h,
                left: 4.w,
                child: _toolbar(context),
              ),
            ]),
          ),
        ),
      );
    });
  }

  Widget _buildRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              PIPView.of(context)?.presentBelow(const GroupsScreen());
            },
            icon: getSvgIcon('arrow_back.svg', color: Colors.white)),
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
        const Spacer(),
        Consumer(builder: (context, ref, child) {
          final provider = ref.watch(bGroupCallChangeProvider);

          return IconButton(
            onPressed: () {
              _showMemebers(context, provider.userList.values.toList());
            },
            icon: const Icon(
              Icons.people_alt,
              color: Colors.white,
            ),
          );
        }),
      ],
    );
  }

  PersistentBottomSheetController? _controller;

  _showMemebers(BuildContext context, List<GroupCallUser> users) {
    _controller = _scaffoldKey.currentState
        ?.showBottomSheet(backgroundColor: Colors.transparent, (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: MemberListDialog(
          users: users,
          user: me,
          showVideo: callType == CallType.video,
        ),
      );
    });

    // showBottomSheet(
    //   context: context,
    // isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) {
    //     return GestureDetector(
    //       onTap: () => Navigator.of(context).pop(),
    //       child: MemberListDialog(
    //         users: users,
    //         user: me,
    //         showVideo: callType == CallType.video,
    //       ),
    //     );
    //   },
    // ));
  }

  _onCallEnd(BuildContext context, WidgetRef ref) async {
    showLoading(ref);
    final error =
        await ref.read(bGroupCallChangeProvider).endCurrentCall(groupName);
    hideLoading(ref);
    if (error != null) {
      print('error:$error');
      Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 8.sp);
      // AppSnackbar.instance.error(context, error);
    } else {}
    setOnGoing(null);
    Wakelock.disable();
    if (prevScreen.isNotEmpty) {
      try {
        if (_controller != null) {
          _controller?.close();
        }
      } catch (e) {}
      clearCall();
      Navigator.pop(context);
      setScreen(prevScreen);
    } else {
      setScreen(RouteList.homeDirect);
      clearCall();
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteList.homeDirect,
        (route) => false,
      );
    }
  }

  // Widget _buildAudioBackground() {
  //   return Container(
  //     height: double.infinity,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.black,
  //       image: DecorationImage(
  //         fit: BoxFit.cover,
  //         colorFilter: ColorFilter.mode(
  //             Colors.black.withOpacity(0.3), BlendMode.dstATop),
  //         image: getImageProvider(groupImage),
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _buildAudioCallScreen() {
    return [
      if (groupImage.isNotEmpty)
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: getImageProvider(groupImage),
            ),
          ),
        ),
      Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              getCicleAvatar(groupName, groupImage,
                  radius: 20.w,
                  cacheWidth: (150.w * devicePixelRatio).round(),
                  cacheHeight: (150.w * devicePixelRatio).round()),
              Text(
                'Group Call',
                style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 5.w),
              ),
              Text(
                groupName,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 6.w),
              ),
            ],
          ),
        ),
      )
    ];
  }

  Widget _toolbar(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(bGroupCallChangeProvider);
      return Container(
          // margin: EdgeInsets.symmetric(horizontal: 6.w),
          // alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(3.w),
          ),
          // padding: EdgeInsets.only(left: 6.w, right: 5.w),
          // alignment: Alignment.center,
          width: 92.w,
          // height: 10.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (callType == CallType.video)
                GestureDetector(
                  onTap: () {
                    provider.onSwitchCamera();
                  },
                  child: getSvgIcon(width: 8.w, 'vc_camera_flip.svg'),
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
              if (callType == CallType.video)
                GestureDetector(
                  onTap: () {
                    //
                    provider.toggleCamera();
                  },
                  child: Icon(
                    provider.disableLocalCamera
                        ? Icons.videocam_off_rounded
                        : Icons.videocam_rounded,
                    color: Colors.white,
                    size: 10.w,
                  ),
                  // child: getSvgIcon(
                  //     width: 8.w,
                  //     provider.videoOn ? 'vc_video_off.svg' : 'vc_video_on.svg'),
                ),
              if (callType == CallType.audio)
                GestureDetector(
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
              GestureDetector(
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
              )
            ],
          ));
    });
  }

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
          top: 2.h,
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
    if (callType == CallType.audio) return const SizedBox.shrink();
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
                        alignment: Alignment.topLeft,
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

class MemberListDialog extends StatelessWidget {
  final List<GroupCallUser> users;
  final bool showVideo;

  final User user;
  const MemberListDialog({
    Key? key,
    required this.users,
    required this.user,
    required this.showVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.001),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.remove,
                      color: Colors.grey[600],
                    ),
                    Expanded(
                      child: users.isEmpty
                          ? buildEmptyPlaceHolder('No Members')
                          : ListView.separated(
                              itemBuilder: (_, index) {
                                var u = users[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  child: Row(
                                    children: [
                                      getCicleAvatar(u.contact.name,
                                          u.contact.profileImage,
                                          cacheWidth:
                                              (75.w * devicePixelRatio).round(),
                                          cacheHeight: (75.w * devicePixelRatio)
                                              .round()),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.id == u.contact.userId
                                                  ? S.current.bmeet_user_you
                                                  : u.contact.name,
                                              style: TextStyle(
                                                fontFamily: kFontFamily,
                                                fontSize: 11.sp,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              u.status.name.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: kFontFamily,
                                                fontSize: 8.sp,
                                                color: (u.status ==
                                                            JoinStatus
                                                                .connected ||
                                                        u.status ==
                                                            JoinStatus.ringing)
                                                    ? Colors.black45
                                                    : Colors.red.shade400,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Row(
                                        children: [
                                          Icon(
                                              u.muteAudio
                                                  ? Icons.mic_off_rounded
                                                  : Icons.mic_outlined,
                                              color: AppColors.iconGreyColor),
                                          if (showVideo)
                                            Icon(
                                                u.enabledVideo
                                                    ? Icons.videocam_rounded
                                                    : Icons
                                                        .videocam_off_rounded,
                                                color: AppColors.iconGreyColor),
                                        ],
                                      )
                                    ],
                                    // leading: ,
                                    // title: Text(user.id == u.contact.userId
                                    //     ? S.current.bmeet_user_you
                                    //     : u.contact.name),
                                    // subtitle: Text(
                                    //   u.status.name.toUpperCase(),
                                    // ),
                                    // trailing: ,
                                  ),
                                );
                              },
                              separatorBuilder: (_, index) => const Divider(
                                    color: Colors.black,
                                    height: 1,
                                  ),
                              itemCount: users.length),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
