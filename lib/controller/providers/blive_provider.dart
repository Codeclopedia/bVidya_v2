import 'dart:async';
import 'dart:collection';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../blive_providers.dart';

class BLiveProvider extends ChangeNotifier {
//
  int _localUid = 0;
  int? get localUid => _localUid;

//
  bool _localUserJoined = false;
  bool get localUserJoined => _localUserJoined;

//
//
  bool _isPreviewReady = false;
  bool get isPreviewReady => _isPreviewReady;

//
  bool _allMuted = true;
  bool get allMuted => _allMuted;

//
  bool _hostCamera = false;
  bool get hostCamera => _hostCamera;

//
  bool _hostMute = false;
  bool get hostMute => _hostMute;

//
  bool _muted = false;
  bool get muted => _muted;

//
  bool _speakerOn = false;
  bool get speakerOn => _speakerOn;

//
  bool _camera = false;
  bool get camera => _camera;

//
  int _indexValue = 0;
  int get indexValue => _indexValue;

//
  Set<int> get remoteUsersIds => _userRemoteIds;
  final Set<int> _userRemoteIds = HashSet();

  String? _error = null;
  String? get error => _error;

//
  // final Map<int, ConnectedUserInfo> _userList = <int, ConnectedUserInfo>{};
  // Map<int, ConnectedUserInfo> get userList => _userList;

  final Map<int, Widget> _userList = <int, Widget>{};
  Map<int, Widget> get userList => _userList;

//
  final List<AgoraRtmMember> _memberList = [];
  List<AgoraRtmMember> get memberList => _memberList;

  bool _initialized = false;

//
  late RtcEngine _engine;
  RtcEngine get engine => _engine;

//
  late AgoraRtmClient _rtmClient;
  AgoraRtmChannel? _rtmChannel;

//
  // late final Meeting _meeting;
  late final LiveClass _liveClass;
  // late final bool _enableVideo;
  late final LiveRtmToken _token;

  // final DurationNotifier _callTimerProvider;
  // final Refreshable<RTMChatMessageNotifier> messageListProvider;
  late final WidgetRef _ref;

  BLiveProvider();

  void init(
      LiveClass liveClass, LiveRtmToken rtmToken, int userid, WidgetRef refs) {
    if (_initialized) return;
    _initialized = true;
    _ref = refs;
    _liveClass = liveClass;
    _token = rtmToken;

    _createRTMClient(userid);
  }

  void _createRTMClient(int userid) async {
    if (_token.appid.isEmpty) {
      print('Meeting App ID is emply');
      return;
    }
    _rtmClient = await AgoraRtmClient.createInstance(_token.appid);
    _rtmClient.onConnectionStateChanged = (state, reason) {
      if (state == 5) {
        _rtmClient.logout();
      }
    };
    // _rtmClient.onMessageReceived =
    //     (AgoraRtmMessage message, String peerId) async {
    //   // debugPrint("Peer ID $peerId");
    //   debugPrint("onMessageReceived=> Peer ID:$peerId - msg:${message.text}");
    //   if (message.text == "mic_off") {
    //     _hostMute = true;
    //     notifyListeners();

    //     EasyLoading.showToast(
    //       "You are muted by host.",
    //       duration: const Duration(seconds: 3),
    //       toastPosition: EasyLoadingToastPosition.bottom,
    //     );
    //     await _engine.muteLocalAudioStream(true);
    //   } else if (message.text == "mic_on") {
    //     _hostMute = false;

    //     notifyListeners();
    //     await _engine.muteLocalAudioStream(false);
    //     EasyLoading.showToast(
    //       "Host un-muted you.\n Now you can enable your mic.",
    //       duration: const Duration(seconds: 3),
    //       toastPosition: EasyLoadingToastPosition.bottom,
    //     );
    //   } else if (message.text == "videocam_off") {
    //     _hostCamera = true;
    //     notifyListeners();

    //     EasyLoading.showToast(
    //       "Host disabled your camera",
    //       duration: const Duration(seconds: 3),
    //       toastPosition: EasyLoadingToastPosition.bottom,
    //     );
    //     await _engine.muteLocalVideoStream(true);
    //   } else if (message.text == "videocam_on") {
    //     _hostCamera = false;
    //     notifyListeners();

    //     await _engine.muteLocalVideoStream(false);
    //     EasyLoading.showToast(
    //       "You can enable your camera now",
    //       duration: const Duration(seconds: 3),
    //       toastPosition: EasyLoadingToastPosition.bottom,
    //     );
    //   }
    // };

    try {
      await _rtmClient.login(_token.rtmToken, _token.rtmUser);
      await _initAgoraRTC(userid);
      await _createJoinRTMChannel();
      // _ref.read(bLiveCallTimerProvider.notifier).start();
      notifyListeners();

      /// RTM
    } catch (errorCode) {
      _error = errorCode.toString();
      notifyListeners();
      print('Login error: $errorCode');
    }
  }

  Future<void> _initAgoraRTC(int userid) async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(RtcEngineContext(
      appId: _token.appid,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onRejoinChannelSuccess: (connection, elapsed) {},
        onError: (err, msg) {
          print("onError :error:$err msg:$msg");
          if (err == ErrorCodeType.errTokenExpired) {
            _error = 'Token Expired Please try again later';
            notifyListeners();
          }
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print(
              "local user ${connection.localUid} joined, since $elapsed seconds");
          _localUserJoined = true;

          _localUid = connection.localUid ?? 0;
          _userRemoteIds.add(_localUid);
          _userList.addAll({_localUid: _localView()});
          // _userList.addAll(
          //     {_localUid: ConnectedUserInfo(_localUid, '', _localView())});
          _updateMemberList();
          // notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("remote user $remoteUid joined, since $elapsed seconds");
          _userRemoteIds.add(remoteUid);
          _userList.addAll({remoteUid: _remoteView(remoteUid)});
          // _userList.addAll({
          //   remoteUid: ConnectedUserInfo(remoteUid, '', _remoteView(remoteUid))
          // });
          // notifyListeners();
          _updateMemberList();
        },
        onRemoteVideoStateChanged:
            (connection, remoteUid, state, reason, elapsed) {
          // print(
          //     "remote user video $remoteUid  status changed to ${state.name}, since $elapsed seconds  ,reason ${reason.name}");
        },
        onLeaveChannel: (connection, stats) {
          int userId = connection.localUid ?? 0;

          print('User Id:$userid');
          // if (_userRemoteIds.contains(userId)) {
          //   _userRemoteIds.remove(userId);
          // }
          // if (_userList.containsKey(userId)) {
          //   _userList.removeWhere((key, value) => key == userId);
          // }
          // if (localUid != userid) {
          //   _updateMemberList();
          // } else {
          //   // _userRemoteIds.clear();
          // }
          // _isPreviewReady = false;
          // _userRemoteIds.clear();

          // _speakingUsersMap.clear();
          // notifyListeners();
        },

        onUserOffline: (connection, remoteUid, UserOfflineReasonType reason) {
          _userRemoteIds.remove(remoteUid);
          _userList.removeWhere((key, value) => key == remoteUid);
          // print("remote user $remoteUid left channel");
          // _userRemoteIds.removeWhere((item) => item == remoteUid);
          // _speakingUsersMap.removeWhere((key, value) => key == remoteUid);
          _updateMemberList();
          // notifyListeners();
        },
        onLocalVideoStateChanged: (source, state, error) {
          // print(
          //     "local video source:${source.name} state:${state.name}  err:${error.name}");
        },
        // onAudioVolumeIndication:
        //     (connection, speakers, speakerNumber, totalVolume) {
        //   for (var speaker in speakers) {
        //     if ((speaker.volume ?? 0) > 5) {
        //       // print(
        //       //     '[onAudioVolumeIndication] uid: ${speaker.uid}, volume: ${speaker.volume}');
        //       _userList.forEach((key, value) {
        //         //Highlighting local user
        //         //In this callback, the local user is represented by an uid of 0.
        //         if ((_localUid.compareTo(key) == 0) && (speaker.uid == 0)) {
        //           _userList.update(key, (value) {
        //             value.isSpeaking = true;
        //             return value;
        //           });
        //         }

        //         //Highlighting remote user
        //         else if (key.compareTo(speaker.uid ?? 0) == 0) {
        //           _userList.update(key, (value) {
        //             value.isSpeaking = true;
        //             return value;
        //           });
        //         } else {
        //           _userList.update(key, (value) {
        //             value.isSpeaking = false;
        //             return value;
        //           });
        //         }
        //       });
        //     }
        //     notifyListeners();
        //   }
        // },
        // onUserMuteAudio: (connection, remoteUid, muted) {
        //   // print('[onUserMuteAudio] uid: $remoteUid, enabled: $muted');
        //   if (_userList.containsKey(remoteUid)) {
        //     _userList.update(remoteUid, (value) {
        //       value.muteAudio = muted;
        //       return value;
        //     });
        //   }
        //   notifyListeners();
        // },
        // onUserEnableVideo: (connection, remoteUid, enabled) {
        //   // print('[onUserEnableVideo] uid: $remoteUid, enabled: $enabled');
        //   if (_userList.containsKey(remoteUid)) {
        //     _userList.update(remoteUid, (value) {
        //       value.enabledVideo = enabled;
        //       return value;
        //     });
        //   }
        // },
        // onUserInfoUpdated: (uid, info) {
        //   // print(
        //   //     '[onUserInfoUpdated] uid: $uid, info: ${info.uid} , account:${info.userAccount}');
        // },
        // onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        //   // print(
        //   //     '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        // },
      ),
    );

    await _engine.enableVideo();
    await _engine.enableLocalVideo(true);
    await _engine.enableAudioVolumeIndication(
        interval: 250, smooth: 3, reportVad: true);
    await _engine.muteLocalAudioStream(_muted);
    await _engine.muteLocalVideoStream(_camera);
    // await _engine.enableVideo();
// await _engine.setEnableSpeakerphone(speakerOn)
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );

    await _engine.startPreview();
    await _engine.joinChannel(
        token: _liveClass.streamToken,
        channelId: _liveClass.streamChannel,
        uid: userid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleAudience,
          publishCameraTrack: true,
          publishScreenTrack: false,

          // autoSubscribeVideo: true,
          // autoSubscribeAudio: true,
          // publishScreenTrack: true,
          // defaultVideoStreamType: VideoStreamType.videoStreamLow,
          // publishScreenCaptureVideo: true,
          // publishSecondaryCameraTrack: true,
          // token: _meeting.token,
          // isInteractiveAudience: true,
        ));
    _isPreviewReady = true;
  }

  Future<void> _createJoinRTMChannel() async {
    try {
      _rtmChannel = await _rtmClient.createChannel(_token.rtmChannel);
      await _rtmChannel?.join();
      _rtmChannel?.onError = (error) {
        print('RTM Error:$error');
      };
      _rtmChannel?.onMemberJoined = (member) {
        _memberList.add(member);
        print('JOINED - ${member.userId}');
      };
      _rtmChannel?.onMemberLeft = (member) {
        _memberList.remove(member);
        print('LEFT - ${member.userId}');
      };
      _rtmChannel?.onMemberCountUpdated = (count) {
        print('onMemberCountUpdated - $count');
      };
      _rtmChannel?.onMessageReceived = (message, fromMember) {
        print('MESSAGE - ${message.text} : ${fromMember.userId}');
        _ref
            .read(bLiveMessageListProvider.notifier)
            .addChat((RTMMessageModel(message, fromMember)));
      };
      print('RTM Join channel success.');
    } catch (errorCode) {
      print('RTM Join channel error: $errorCode');
    }
  }

  void onToggleAllMute() {
    _allMuted = !_allMuted;
    _engine.muteAllRemoteAudioStreams(_allMuted);
    debugPrint('mute All $allMuted');
    notifyListeners();
  }

  void updateIndex(int index) {
    _indexValue = index;
    notifyListeners();
  }

  bool checkNoSignleDigit(int no) {
    int len = no.toString().length;
    if (len == 1) {
      return true;
    }
    return false;
  }

  void _updateMemberList() async {
    if (_rtmChannel == null) {
      notifyListeners();
      return;
    }
    _memberList.clear();
    _memberList.addAll(await _rtmChannel?.getMembers() ?? []);
    for (var u in userList.keys) {
      print('user - $u');
    }
    for (var e in _memberList) {
      String user = e.userId;
      print('member - $user');
      // if (user.contains(':')) {
      // int id = int.tryParse(user.split(':')[0]) ?? 0;
      // String name = user.split(':')[1];

      // if (_userList.containsKey(id)) {
      //   _userList.update(
      //     id,
      //     (value) {
      //       value.name = name;
      //       return value;
      //     },
      //   );
      // } else {
      //   // _userList.addAll({id: ViewModel(id, name, _remoteView(id), false)});
      // }
      // }
    }
    // if (_screenShareId == 1000) {
    //   _memberList.add(AgoraRtmMember('1000:You', _meeting.channel));
    // }
    // _viewModels = getRenderViews();
    notifyListeners();
  }

  // void sendPeerMessage(String userId, String content) async {
  //   AgoraRtmMessage message = AgoraRtmMessage.fromText(content);
  //   // _rtmChannel.sendMessage(message)
  //   await _rtmClient.sendMessageToPeer(userId, message, true, false);
  // }

  void sendChannelMessage(String content) async {
    AgoraRtmMessage message = AgoraRtmMessage.fromText(content);
    try {
      await _rtmChannel?.sendMessage(message);
      _ref.read(bLiveMessageListProvider.notifier).addChat(
          (RTMMessageModel(message, AgoraRtmMember('', _token.rtmChannel))));
    } catch (e) {}
  }

  void toggleVolume() async {
    _speakerOn = !_speakerOn;
    await _engine.setEnableSpeakerphone(_speakerOn);
    notifyListeners();
  }

  void toggleCamera() async {
    _camera = !_camera;
    await _engine.muteLocalVideoStream(_camera);
    notifyListeners();
  }

  void onToggleMute() async {
    _muted = !_muted;
    await _engine.muteLocalAudioStream(_muted);
    notifyListeners();
  }

  void onSwitchCamera() async {
    await _engine.switchCamera();
  }

  _leaveApi() async {
    await _rtmChannel?.leave();
  }

  Future disposeAgora() async {
    await _engine.stopPreview();
    await _engine.leaveChannel();
    await _engine.release();
    await _rtmClient.logout();
    await _rtmClient.destroy();
  }

  @override
  void dispose() {
    // if (_meeting.role == "host") {
    _leaveApi();
    // }
    print('Dispose Called');
    // _callTimerProvider.reset();
    // _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    // clear users
    _userRemoteIds.clear();
    disposeAgora();
    super.dispose();
  }

  StatefulWidget _localView() {
    return AgoraVideoView(
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

  StatefulWidget _remoteView(int uid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(
          uid: uid,
          renderMode: RenderModeType.renderModeHidden,
          sourceType: VideoSourceType.videoSourceRemote,
        ),
        connection: RtcConnection(channelId: _liveClass.streamChannel),
      ),
    );
  }
}

// class ConnectedUserInfo {
//   final int uid;
//   final StatefulWidget widget;
//   String name;
//   bool isSpeaking = false;
//   bool muteAudio = false;
//   bool enabledVideo = false;

//   ConnectedUserInfo(this.uid, this.name, this.widget);
// }

class RTMMessageModel {
  final AgoraRtmMessage message;
  final AgoraRtmMember member;

  RTMMessageModel(this.message, this.member);
}

class RTMChatMessageNotifier extends StateNotifier<List<RTMMessageModel>> {
  RTMChatMessageNotifier() : super([]); //listMessages.reversed.toList()

  RTMMessageModel? getLast() {
    if (state.isEmpty) return null;
    return state[0];
  }

  void addChat(RTMMessageModel todo) {
    state = [...state, todo];
  }

  void addChats(List<RTMMessageModel> chats) {
    for (var c in chats) {
      state = [...state, c];
    }
  }
}
