import 'dart:async';

import 'package:bvidya/core/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pip_view/pip_view.dart';
import 'package:wakelock/wakelock.dart';

import '../../../core/utils.dart';
import '/controller/blive_providers.dart';
import '/controller/providers/blive_provider.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '../../widget/chat_input_box.dart';
import '../../widget/rtm_chat_bubble.dart';
import '../blearn/components/common.dart';
// import 'blive_home_screen.dart';

final isDrawerAccessed = StateProvider.autoDispose((ref) {
  return true;
});

class BLiveClassScreen extends HookConsumerWidget {
  final LiveClass liveClass;
  final LiveRtmToken rtmToken;
  final int userId;

  late final ScrollController _scrollController;
  User? _me;
  BLiveClassScreen(
      {Key? key,
      required this.liveClass,
      required this.rtmToken,
      required this.userId})
      : super(key: key);

  void disposeAll() {
    Wakelock.disable();
  }

  _loadMe() async {
    _me = await getMeAsUser();
  }

  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _scrollController = ScrollController();

      _loadMe();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      Wakelock.enable();
      print("wakelock enabled: ${Wakelock.enabled}");
      return disposeAll;
    }, []);

    final isLandscapeView = ref.watch(bLiveLandScapeView);
    final isChatVisible = ref.watch(bLiveChatVisible);
    final provider = ref.watch(bLiveCallChangeProvider);

    provider.init(liveClass, rtmToken, userId, ref);
    if (ref.watch(isDrawerAccessed)) {
      Timer(const Duration(seconds: 5), () {
        ref.read(isDrawerAccessed.notifier).state = false;
      });
    }
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: provider.isPreviewReady &&
                provider.error == null &&
                provider.remoteUsersIds.isNotEmpty
            ? SafeArea(
                child: Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (ref.read(isDrawerAccessed)) {
                              } else {
                                ref.read(isDrawerAccessed.notifier).state =
                                    true;
                              }
                            },
                            child: Stack(
                              children: [
                                ..._viewRows1(provider),
                                // !isLandscapeView
                                //     ? _viewRows(provider)
                                //     :
                                // _viewRows(provider),
                                // RotatedBox(
                                //     quarterTurns: 4,
                                //     child: _viewRows(provider)),
                                // if (provider.userList.values.length == 2)
                                //   Align(
                                //       alignment: Alignment.bottomRight,
                                //       child: SizedBox(
                                //         height: 25.w,
                                //         width: 30.w,
                                //         child: provider.userList.values.first,
                                //       )
                                //       // _singleViewWindow(
                                //       //     [provider.userList.values.first]
                                //       // ),
                                //       ),
                                // Positioned(
                                //   left: 0,
                                //   bottom: 0,
                                //   child: ,
                                // )
                                _controller(context, isLandscapeView,
                                    isChatVisible, ref)
                              ],
                            ),
                          ),
                        ),
                        // Visibility(
                        //   visible: isChatVisible,
                        // child:
                        if (isChatVisible)
                          Expanded(
                            flex: 1,
                            child: _buildChatScreen(ref),
                          ),
                        // )
                      ],
                    ),
                    if (ref.watch(isDrawerAccessed)) _buildAppBar(context)
                  ],
                ),
              )
            : (!provider.isPreviewReady
                ? buildLoading
                : buildEmptyPlaceHolder(
                    provider.error ?? 'Error while live screen')),
      ),
    );
    // });
  }

  _buildChatScreen(WidgetRef ref) {
    return Column(
      children: [
        Expanded(child: _buildMessageList(ref)),
        SizedBox(height: 0.5.h),
        _buildChatInputBox(ref),
      ],
    );
  }

  Widget _buildMessageList(WidgetRef ref) {
    final chatList = ref.watch(bLiveMessageListProvider).reversed.toList();
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      controller: _scrollController,
      itemCount: chatList.length,
      itemBuilder: (context, i) {
        final RTMMessageModel? previousModel =
            i < chatList.length - 1 ? chatList[i + 1] : null;
        final RTMMessageModel? nextModel = i > 0 ? chatList[i - 1] : null;
        final RTMMessageModel model = chatList[i];
        final bool isAfterDateSeparator =
            shouldShowDateRTMSeparator(previousModel, model);
        bool isBeforeDateSeparator = false;
        if (nextModel != null) {
          isBeforeDateSeparator = shouldShowDateRTMSeparator(model, nextModel);
        }
        bool isPreviousSameAuthor = false;
        bool isNextSameAuthor = false;
        if (previousModel?.member.userId == model.member.userId) {
          isPreviousSameAuthor = true;
        }
        if (nextModel?.member.userId == model.member.userId) {
          isNextSameAuthor = true;
        }

        bool isOwnMessage =
            model.member.userId.split(':')[0] == userId.toString();

        return Column(
          crossAxisAlignment:
              isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isAfterDateSeparator)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  formatDateSeparator(
                      DateTime.fromMillisecondsSinceEpoch(model.message.ts)),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            GestureDetector(
              onLongPress: () {
                // _showMessageOption(message);
              },
              child: RTMChatMessageBubble(
                message: model.message,
                isOwnMessage: isOwnMessage,
                senderUser: model.member,
                isPreviousSameAuthor: isPreviousSameAuthor,
                isNextSameAuthor: isNextSameAuthor,
                isAfterDateSeparator: isAfterDateSeparator,
                isBeforeDateSeparator: isBeforeDateSeparator,
                // ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _videoView(Widget view) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(1),
      color: Colors.black,
      child: view,
    ));
    // return Expanded(
    //     child: Stack(
    //   children: [
    //     // view.view,
    //     Container(
    //       padding: const EdgeInsets.all(1),
    //       color: Colors.black,
    //       child: view,
    //     ),
    // Positioned(
    //   bottom: 2.h,
    //   left: 4.w,
    //   child: Text(
    //     view.name,
    //     style: TextStyle(
    //         color: Colors.white, fontFamily: kFontFamily, fontSize: 10.sp),
    //   ),
    // ),
    //   ],
    // ));
  }

  Widget _controller(BuildContext context, bool isLandscapeView,
      bool isChatVisible, WidgetRef ref) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconButton(
            //     icon: Padding(
            //       padding: EdgeInsets.all(1.w),
            //       child: Icon(
            //         Icons.close_fullscreen_outlined,
            //         color: Colors.white,
            //         shadows: [Shadow(color: Colors.black, blurRadius: 1.w)],
            //       ),
            //     ),
            //     onPressed: () {
            //       // setState(() {
            //       //   chatvisibility = false;
            //       // });
            //       SystemChrome.setPreferredOrientations(
            //           [DeviceOrientation.portraitUp]);

            //       // PIPView.of(context)?.presentBelow(const BLiveHomeScreen());
            //     }),
            Row(
              children: [
                if (isLandscapeView)
                  IconButton(
                    onPressed: () {
                      ref.read(bLiveChatVisible.notifier).state =
                          !isChatVisible;
                    },
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 1.w)],
                    ),
                  ),
                // IconButton(
                //     icon: Icon(
                //       isLandscapeView
                //           ? Icons.fullscreen_exit
                //           : Icons.fullscreen_outlined,
                //       shadows: <Shadow>[
                //         Shadow(color: Colors.black, blurRadius: 1.w)
                //       ],
                //       color: Colors.white,
                //     ),
                //     onPressed: () {
                //       ref.read(bLiveLandScapeView.notifier).state =
                //           !isLandscapeView;
                //       // setState(() {
                //       //   chatvisibility = !chatvisibility;
                //       // });

                //       if (isLandscapeView) {
                //         SystemChrome.setPreferredOrientations(
                //             [DeviceOrientation.landscapeRight]);
                //       } else {
                //         SystemChrome.setPreferredOrientations(
                //             [DeviceOrientation.portraitUp]);
                //       }
                //     }),
              ],
            )
          ],
        ));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map(_videoView).toList();
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: wrappedViews,
      ),
    );
  }

  Widget _singleViewWindow(List<Widget> views) {
    final wrappedViews = views.map(_videoView).toList();
    return Container(
      height: 25.w,
      width: 30.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.4.w),
          border: Border.all(width: 1.w, color: AppColors.darkChatColor),
          color: AppColors.black.withOpacity(0.5)),
      child: wrappedViews.first,
    );
  }

  // Widget _singleView(List<Widget> views) {
  //   final wrappedViews = views.map(_videoView).toList();
  //   return wrappedViews.first;
  // }

  List<Widget> _viewRows1(BLiveProvider provider) {
    final hostScreens = provider.userList;
    hostScreens.removeWhere((key, value) => key == _me?.id);
    final views = hostScreens.values.toList();
    switch (views.length) {
      case 1:
        return [
          Column(
            children: <Widget>[
              _expandedVideoRow([views[0]]),
            ],
          )
        ];
      case 2:
        return [
          Column(
            children: <Widget>[
              _expandedVideoRow([views[1]]),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 25.w,
                width: 30.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.4.w),
                    border:
                        Border.all(width: 1.w, color: AppColors.darkChatColor),
                    color: AppColors.black.withOpacity(0.5)),
                child: views[0],
              )
              // _singleViewWindow(
              //     [provider.userList.values.first]
              // ),
              )
        ];
    }
    return [];
  }

  Widget _viewRows(BLiveProvider provider) {
    final hostScreens = provider.userList;
    hostScreens.removeWhere((key, value) => key == _me?.id);
    final views = hostScreens.values.toList();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[1]]),
          ],
        );
      // return SizedBox(
      //   width: 100.h,
      //   height: 100.w,
      //   child: Stack(
      //     children: [
      //       // _singleView([views[1]]),
      //       views[1],
      //       // Column(
      //       //   mainAxisSize: MainAxisSize.max,
      //       //   children: <Widget>[
      //       //     _expandedVideoRow([views[1]]),
      //       //   ],
      //       // ),
      //       // _expandedVideoRow([views[1]]),
      //       Align(
      //           alignment: Alignment.bottomRight,
      //           child: _singleViewWindow([views[0]])),
      //     ],
      //   ),
      // );

      // case 3:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 3))
      //     ],
      //   );

      // case 4:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 4)),
      //     ],
      //   );

      // case 5:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 4)),
      //       _expandedVideoRow(views.sublist(4, 5)),
      //     ],
      //   );

      // case 6:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 4)),
      //       _expandedVideoRow(views.sublist(4, 6))
      //     ],
      //   );
      // case 7:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 4)),
      //       _expandedVideoRow(views.sublist(4, 6)),
      //       _expandedVideoRow(views.sublist(6, 7))
      //     ],
      //   );
      // case 8:
      //   return Column(
      //     children: [
      //       _expandedVideoRow(views.sublist(0, 2)),
      //       _expandedVideoRow(views.sublist(2, 4)),
      //       _expandedVideoRow(views.sublist(4, 6)),
      //       _expandedVideoRow(views.sublist(6, 8))
      //     ],
      //   );
      // case 9:
      //   return _buildGridVideoView(provider);
      default:
    }
    return Container();
  }

  Widget _buildChatInputBox(WidgetRef ref) {
    return ChatInputBox(
      smallTextFeild: true,
      onSend: (input) async {
        ref.read(bLiveCallChangeProvider).sendChannelMessage(input);
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return null;
      },
      // showAttach: false
      // onAttach: null,
    );
  }

  _buildAppBar(BuildContext context) {
    return Container(
      height: 15.w,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 6.w,
                  color: AppColors.cardWhite,
                ),
              ),
              SizedBox(width: 4.h),
              Consumer(
                builder: (context, ref, child) {
                  final provider = ref.watch(bLiveCallChangeProvider);
                  return GestureDetector(
                    onTap: () {
                      provider.toggleVolume();
                    },
                    child: provider.speakerOn
                        ? Image.asset(
                            'assets/icons/svg/volume_off.png',
                            height: 3.h,
                            width: 3.h,
                          )
                        : SvgPicture.asset(
                            'assets/icons/svg/volume.svg',
                            height: 3.h,
                            width: 3.h,
                          ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBText('Live'),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: AppColors.cardBackground,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.w),
            child: GestureDetector(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xffca2424),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                  child: Text(
                    "Leave",
                    style: TextStyle(
                        fontSize: 10.sp,
                        letterSpacing: .5,
                        color: AppColors.cardWhite,
                        fontWeight: FontWeight.w500),
                  )
                  //Image.asset('assets/icons/svg/phone_call.png',height: 3.h,width: 3.h,color: Colors.white,)
                  ),
              onTap: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
