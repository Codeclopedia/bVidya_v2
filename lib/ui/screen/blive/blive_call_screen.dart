import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pip_view/pip_view.dart';
import 'package:wakelock/wakelock.dart';

import '/controller/blive_providers.dart';
import '/controller/providers/blive_provider.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '../../widget/chat_input_box.dart';
import '../../widget/rtm_chat_bubble.dart';
import '../blearn/components/common.dart';
import 'blive_home_screen.dart';

class BLiveClassScreen extends HookConsumerWidget {
  final LiveClass liveClass;
  final LiveRtmToken rtmToken;
  final int userId;

  late final ScrollController _scrollController;
  // User? _me;
  BLiveClassScreen(
      {Key? key,
      required this.liveClass,
      required this.rtmToken,
      required this.userId})
      : super(key: key);

  void disposeAll() {
    Wakelock.disable();
  }

  // _loadMe() async {
  //   _me = await getMeAsUser();
  // }

  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // _scrollController = useScrollController();
    useEffect(() {
      _scrollController = ScrollController();
      //   _controller = AnimationController(
      //   duration: const Duration(seconds: 3),
      //   vsync: this,
      // )..repeat(reverse: true);
      // _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      //   // _myUserId = ChatClient.getInstance.currentUserId ?? '24';
      //   // _otherUserId = _myUserId == '24' ? '1' : '24';
      //   // _scrollController.addListener(() => _onScroll(_scrollController, ref));
      //   // _loadMe();
      //   // _preLoadChat(ref);
      Wakelock.enable();
      return disposeAll;
    }, []);

    final chatVisible = ref.watch(bLiveChatVisible);
    final provider = ref.watch(bLiveCallChangeProvider);
    print("testing broadcast: inside broadcast call page 1 ${provider}");
    provider.init(liveClass, rtmToken, userId, ref);

    return PIPView(builder: (context, isFloating) {
      print(
          "testing broadcast: inside broadcast call page 2 ${provider.isPreviewReady}");
      return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset:
            !isFloating, //!ref.watch(bLiveFloatingVisible),
        appBar: !chatVisible ? _buildAppBar(context) : null,
        body: provider.isPreviewReady &&
                provider.error == null &&
                provider.remoteUsersIds.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Stack(
                    children: [
                      !chatVisible
                          ? _viewRows(provider)
                          : RotatedBox(
                              quarterTurns: 4, child: _viewRows(provider)),
                      _controller(context, chatVisible, ref)
                    ],
                  )),
                  Visibility(
                    visible: chatVisible,
                    child: Expanded(
                      flex: 3,
                      child: _buildChatScreen(ref),
                    ),
                  )
                ],
              )
            : (!provider.isPreviewReady
                ? buildLoading
                : buildEmptyPlaceHolder(
                    provider.error ?? 'Error while live screen')),
      );
    });
  }

  _buildChatScreen(WidgetRef ref) {
    return Column(
      children: [
        Expanded(child: _buildMessageList(ref)),
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
            // SwipeTo(
            //   onRightSwipe: () {
            //     ref.read(chatModelProvider).setReplyOn(message, otherUser);
            //     print('open replyBox');
            //   },
            //   child:
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

  Widget _controller(BuildContext context, bool chatVisible, WidgetRef ref) {
    return Container(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.close_fullscreen_outlined,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // setState(() {
                  //   chatvisibility = false;
                  // });
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  PIPView.of(context)?.presentBelow(const BLiveHomeScreen());
                }),
            IconButton(
                icon: Icon(
                  chatVisible
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(bLiveChatVisible.notifier).state = !chatVisible;
                  // setState(() {
                  //   chatvisibility = !chatvisibility;
                  // });

                  if (!chatVisible) {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeRight]);
                  } else {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  }
                })
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

  Widget _viewRows(BLiveProvider provider) {
    final views = provider.userList.values.toList();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[
            // _videoView(views[0], members[0])
            _expandedVideoRow([views[0]]),
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

  Widget _buildChatInputBox(WidgetRef ref) {
    return ChatInputBox(
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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
              SizedBox(width: 4.h)
            ],
          ),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildBText('Live'),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                ),
              ],
            ),
            onTap: () {},
          ),
          GestureDetector(
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xffca2424),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                child: Text(
                  "Leave",
                  style: TextStyle(
                      fontSize: 10.sp,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w500),
                )
                //Image.asset('assets/icons/svg/phone_call.png',height: 3.h,width: 3.h,color: Colors.white,)
                ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
