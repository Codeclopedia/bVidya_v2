// import 'dart:async';
// import 'dart:collection';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_rtm/agora_rtm.dart';
// import 'package:bvidya/core/state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// import '/core/helpers/duration.dart';
// import '/core/ui_core.dart';
// import '/data/models/models.dart';

// final raisedHandMeetingProvider = StateProvider<String>((ref) => '');

// final endedMeetingProvider = StateProvider<bool>((ref) => false);

// class BMeetProvider extends ChangeNotifier {
//   final MethodChannel _iosScreenShareChannel =
//       const MethodChannel('example_screensharing_ios');
// //
//   int _localUid = 0;
//   int? get localUid => _localUid;

// //
//   bool _localUserJoined = false;
//   bool get localUserJoined => _localUserJoined;

// //
//   int _screenShareId = 0;

// //
//   bool _isPreviewReady = false;
//   bool get isPreviewReady => _isPreviewReady;

// //
//   bool _allMuted = true;
//   bool get allMuted => _allMuted;

// //
//   bool _hostDisableCamera = false;
//   bool get hostCamera => _hostDisableCamera;

// //
//   bool _hostMute = false;
//   bool get hostMute => _hostMute;

// //
//   bool _muted = false;
//   bool get muted => _muted;

// //
//   bool _speakerOn = false;
//   bool get speakerOn => _speakerOn;

// //
//   bool _camera = false;
//   bool get camera => _camera;

// //
//   int _indexValue = 0;
//   int get indexValue => _indexValue;

// //
//   Set<int> get remoteUsersIds => _userRemoteIds;
//   final Set<int> _userRemoteIds = HashSet();

// //
//   final Map<int, ConnectedUserInfo> _userList = <int, ConnectedUserInfo>{};
//   Map<int, ConnectedUserInfo> get userList => _userList;

// //
//   final List<AgoraRtmMember> _memberList = [];
//   List<AgoraRtmMember> get memberList => _memberList;

//   bool _initialized = false;
//   bool _initializingScreenShare = false;
//   bool get initializingScreenShare => _initializingScreenShare;

//   // bool _ended = false;
//   // bool get ended => _ended;

// //
//   bool _shareScreen = false;
//   bool get shareScreen => _shareScreen;

// //
//   late RtcEngineEx _engine;
//   RtcEngineEx get engine => _engine;

// //
//   late AgoraRtmClient _rtmClient;
//   AgoraRtmChannel? _rtmChannel;

// //
//   late final Meeting _meeting;
//   late final bool _enableVideo;

//   final DurationNotifier _callTimerProvider;

//   BMeetProvider(this._callTimerProvider);

//   // void startMeetingTimer() async {
//   // _meetingTimer = Timer.periodic(
//   //   const Duration(seconds: 1),
//   //   (meetingTimer) {
//   //     int min = (_meetingDuration ~/ 60);
//   //     int sec = (_meetingDuration % 60).toInt();

//   //     _meetingDurationTxt = "$min:$sec";

//   //     if (checkNoSignleDigit(min)) {
//   //       _meetingDurationTxt = "0$min:$sec";
//   //     }
//   //     if (checkNoSignleDigit(sec)) {
//   //       if (checkNoSignleDigit(min)) {
//   //         _meetingDurationTxt = "0$min:0$sec";
//   //       } else {
//   //         _meetingDurationTxt = "$min:0$sec";
//   //       }
//   //     }
//   //     _meetingDuration = _meetingDuration + 1;
//   //   },
//   // );
//   // }

//   late WidgetRef _ref;
//   void init(WidgetRef ref, Meeting meeting, bool enableVideo, String rtmToken,
//       String rtmUser, int userid) {
//     if (_initialized) return;
//     _ref = ref;
//     _initialized = true;
//     _meeting = meeting;
//     _enableVideo = enableVideo;
//     _createRTMClient(rtmToken, rtmUser, userid);
//   }

//   void _createRTMClient(String rtmToken, String rtmUser, int userid) async {
//     if (_meeting.appid.isEmpty) {
//       print('Meeting App ID is emply');
//       return;
//     }
//     _rtmClient = await AgoraRtmClient.createInstance(_meeting.appid);
//     _rtmClient.onMessageReceived =
//         (AgoraRtmMessage message, String peerId) async {
//       // debugPrint("Peer ID $peerId");
//       debugPrint("onMessageReceived=> Peer ID:$peerId - msg:${message.text}");
//       if (message.text == 'remove') {
//         _ref.read(endedMeetingProvider.notifier).state = true;
//         // _ended = true;
//         notifyListeners();
//         return;
//       }

//       if (message.text == "mic_off") {
//         _hostMute = true;
//         notifyListeners();

//         EasyLoading.showToast(
//           "You are muted by host.",
//           duration: const Duration(seconds: 3),
//           toastPosition: EasyLoadingToastPosition.bottom,
//         );
//         await _engine.muteLocalAudioStream(true);
//       } else if (message.text == "mic_on") {
//         _hostMute = false;

//         notifyListeners();
//         await _engine.muteLocalAudioStream(false);
//         EasyLoading.showToast(
//           "Host un-muted you.\n Now you can enable your mic.",
//           duration: const Duration(seconds: 3),
//           toastPosition: EasyLoadingToastPosition.bottom,
//         );
//       } else if (message.text == "videocam_off") {
//         _hostDisableCamera = true;
//         notifyListeners();

//         EasyLoading.showToast(
//           "Host disabled your camera",
//           duration: const Duration(seconds: 3),
//           toastPosition: EasyLoadingToastPosition.bottom,
//         );
//         await _engine.muteLocalVideoStream(true);
//       } else if (message.text == "videocam_on") {
//         _hostDisableCamera = false;
//         notifyListeners();

//         await _engine.muteLocalVideoStream(false);
//         EasyLoading.showToast(
//           "You can enable your camera now",
//           duration: const Duration(seconds: 3),
//           toastPosition: EasyLoadingToastPosition.bottom,
//         );
//       }
//     };

//     try {
//       await _rtmClient.login(rtmToken, rtmUser);
//       await _initAgoraRTC(userid);
//       await _createJoinRTMChannel();

//       /// RTM
//     } catch (errorCode) {
//       print('Login error: $errorCode');
//     }
//   }

//   Future<void> _initAgoraRTC(int userid) async {
//     _engine = createAgoraRtcEngineEx();

//     await _engine.initialize(RtcEngineContext(
//       appId: _meeting.appid,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onRejoinChannelSuccess: (connection, elapsed) {},
//         onError: (err, msg) {
//           print("onError :$err $msg");
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           // print(
//           //     "local user ${connection.localUid} joined, since $elapsed seconds");
//           _localUserJoined = true;
//           if (connection.localUid == 1000) {
//             _screenShareId = 1000;
//             _shareScreen = true;
//             _userRemoteIds.add(_screenShareId);
//             _userList.addAll({
//               _screenShareId:
//                   ConnectedUserInfo(_screenShareId, '', _localScreenView())
//             });
//             _initializingScreenShare = false;
//           } else {
//             _localUid = connection.localUid ?? 0;
//             _userRemoteIds.add(_localUid);
//             _userList.addAll(
//                 {_localUid: ConnectedUserInfo(_localUid, '', _localView())});
//           }
//           _updateMemberList();
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           print("remote user $remoteUid joined, since $elapsed seconds");
//           _userRemoteIds.add(remoteUid);
//           if (remoteUid == 1000) {
//             _screenShareId = 1000;
//             _shareScreen = true;
//             _userList.addAll({
//               _screenShareId:
//                   ConnectedUserInfo(_screenShareId, '', _remoteScreenView())
//             });
//             _initializingScreenShare = false;
//           } else {
//             _userList.addAll({
//               remoteUid:
//                   ConnectedUserInfo(remoteUid, '', _remoteView(remoteUid))
//             });
//           }
//           // notifyListeners();
//           _updateMemberList();
//         },
//         onRemoteVideoStateChanged:
//             (connection, remoteUid, state, reason, elapsed) {
//           // print(
//           //     "remote user video $remoteUid  status changed to ${state.name}, since $elapsed seconds  ,reason ${reason.name}");
//         },
//         onLeaveChannel: (connection, stats) {
//           int userId = connection.localUid ?? 0;
//           if (userId == 1000) {
//             _screenShareId = 0;
//             _shareScreen = false;
//             _userRemoteIds.remove(1000);
//             _userList.removeWhere((key, value) => key == 1000);
//             _initializingScreenShare = false;
//             _userList.update(
//               _localUid,
//               (value) {
//                 value.widget = _localView();
//                 return value;
//               },
//             );
//             // _userList.addAll(
//             //     {_localUid: ConnectedUserInfo(_localUid, '', _localView())});
//             _updateMemberList();
//           } else if (_localUserJoined) {
//             _localUserJoined = false;
//             print('User Id:$userid');
//             notifyListeners();
//           }

//           // if (_userRemoteIds.contains(userId)) {
//           //   _userRemoteIds.remove(userId);
//           // }
//           // if (_userList.containsKey(userId)) {
//           //   _userList.removeWhere((key, value) => key == userId);
//           // }
//           // if (localUid != userid) {
//           //   _updateMemberList();
//           // } else {
//           //   // _userRemoteIds.clear();
//           // }
//           // _isPreviewReady = false;
//           // _userRemoteIds.clear();

//           // _speakingUsersMap.clear();
//           // notifyListeners();
//         },
//         onUserOffline: (connection, remoteUid, UserOfflineReasonType reason) {
//           _userRemoteIds.remove(remoteUid);
//           _userList.removeWhere((key, value) => key == remoteUid);

//           if (remoteUid == 1000) {
//             _screenShareId = 0;
//             _shareScreen = false;
//             _initializingScreenShare = false;
//           }

//           print("remote user $remoteUid left channel,  reason:${reason.name}");
//           // _userRemoteIds.removeWhere((item) => item == remoteUid);
//           // _speakingUsersMap.removeWhere((key, value) => key == remoteUid);
//           _updateMemberList();
//         },
//         onLocalVideoStateChanged: (source, state, error) {
//           // print(
//           //     "local video source:${source.name} state:${state.name}  err:${error.name}");
//         },
//         onAudioVolumeIndication:
//             (connection, speakers, speakerNumber, totalVolume) {
//           for (var speaker in speakers) {
//             if ((speaker.volume ?? 0) > 5) {
//               // print(
//               //     '[onAudioVolumeIndication] uid: ${speaker.uid}, volume: ${speaker.volume}');
//               _userList.forEach((key, value) {
//                 //Highlighting local user
//                 //In this callback, the local user is represented by an uid of 0.
//                 if ((_localUid.compareTo(key) == 0) && (speaker.uid == 0)) {
//                   _userList.update(key, (value) {
//                     value.isSpeaking = true;
//                     return value;
//                   });
//                 }

//                 //Highlighting remote user
//                 else if (key.compareTo(speaker.uid ?? 0) == 0) {
//                   _userList.update(key, (value) {
//                     value.isSpeaking = true;
//                     return value;
//                   });
//                 } else {
//                   _userList.update(key, (value) {
//                     value.isSpeaking = false;
//                     return value;
//                   });
//                 }
//               });
//             }
//             if (_localUserJoined) notifyListeners();
//           }
//         },
//         onUserMuteAudio: (connection, remoteUid, muted) {
//           // print('[onUserMuteAudio] uid: $remoteUid, enabled: $muted');
//           if (_userList.containsKey(remoteUid)) {
//             _userList.update(remoteUid, (value) {
//               value.muteAudio = muted;
//               return value;
//             });
//           }
//           notifyListeners();
//         },
//         onUserEnableVideo: (connection, remoteUid, enabled) {
//           // print('[onUserEnableVideo] uid: $remoteUid, enabled: $enabled');
//           if (_userList.containsKey(remoteUid)) {
//             _userList.update(remoteUid, (value) {
//               value.enabledVideo = enabled;
//               return value;
//             });
//           }
//         },
//         // onUserInfoUpdated: (uid, info) {
//         //   // print(
//         //   //     '[onUserInfoUpdated] uid: $uid, info: ${info.uid} , account:${info.userAccount}');
//         // },
//         // onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//         //   // print(
//         //   //     '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         // },
//       ),
//     );

//     // if (_enableVideo) {
//     //   await _engine.enableVideo();
//     // } else {
//     //   await _engine.disableVideo();
//     // }

//     await _engine.enableVideo();
//     await _engine.enableLocalVideo(true);
//     await _engine.enableAudioVolumeIndication(
//         interval: 250, smooth: 3, reportVad: true);
//     await _engine.muteLocalAudioStream(_muted);
//     await _engine.muteLocalVideoStream(_camera);
//     // await _engine.enableVideo();
// // await _engine.setEnableSpeakerphone(speakerOn)
//     await _engine.setVideoEncoderConfiguration(
//       const VideoEncoderConfiguration(
//         dimensions: VideoDimensions(width: 640, height: 360),
//         frameRate: 15,
//         bitrate: 0,
//       ),
//     );

//     await _engine.startPreview();
//     await _engine.joinChannel(
//         token: _meeting.token,
//         channelId: _meeting.channel,
//         uid: 1000000 + userid,
//         options: const ChannelMediaOptions(
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,

//           // _meeting.role == 'host'
//           //     ? ClientRoleType.clientRoleBroadcaster
//           //     : ClientRoleType.clientRoleAudience,
//           publishCameraTrack: true,
//           publishScreenTrack: false,

//           // autoSubscribeVideo: true,
//           // autoSubscribeAudio: true,
//           // publishScreenTrack: true,
//           // defaultVideoStreamType: VideoStreamType.videoStreamLow,
//           // publishScreenCaptureVideo: true,
//           // publishSecondaryCameraTrack: true,
//           // token: _meeting.token,
//           // isInteractiveAudience: true,
//         ));
//     _isPreviewReady = true;
//     _callTimerProvider.start();

//     notifyListeners();
//   }

//   Timer? _timer;
//   Future<void> _createJoinRTMChannel() async {
//     try {
//       _rtmChannel = await _rtmClient.createChannel(_meeting.channel);
//       await _rtmChannel?.join();
//       _rtmChannel?.onMessageReceived = (message, fromMember) {
//         if (message.text == 'raise_hand') {
//           //from id
//           _timer?.cancel();
//           _ref.read(raisedHandMeetingProvider.notifier).state =
//               fromMember.userId.split(':')[1];
//           _timer = Timer(const Duration(seconds: 2), () {
//             _ref.read(raisedHandMeetingProvider.notifier).state = '';
//           });

//           // Future.delayed(
//           //   const Duration(seconds: 2),
//           //   () {
//           //     _ref.read(raisedHandMeetingProvider.notifier).state = '';
//           //   },
//           // );
//         } else if (message.text == 'mute_all') {
//           _hostMute = true;
//           notifyListeners();
//         } else if (message.text == 'unmute_all') {
//           _hostMute = false;
//           notifyListeners();
//         } else if (message.text == 'leave') {
//           _ref.read(endedMeetingProvider.notifier).state = true;
//           notifyListeners();
//           return;
//         }
//       };
//       print('Join channel success.');
//     } catch (errorCode) {
//       print('Join channel error: $errorCode');
//     }
//   }

//   void onToggleAllMute() {
//     _allMuted = !_allMuted;
//     _engine.muteAllRemoteAudioStreams(_allMuted);
//     debugPrint('mute All $allMuted');
//     notifyListeners();
//   }

//   void updateIndex(int index) {
//     _indexValue = index;
//     notifyListeners();
//   }

//   bool checkNoSignleDigit(int no) {
//     int len = no.toString().length;
//     if (len == 1) {
//       return true;
//     }
//     return false;
//   }

//   void _updateMemberList() async {
//     if (_rtmChannel == null) {
//       notifyListeners();
//       return;
//     }
//     print('_updateMemberList : ${_userList.length}');

//     // for (var e in _userList.keys) {
//     //   print('_updateMemberList : $e');
//     // }
//     _memberList.clear();
//     _memberList.addAll(await _rtmChannel?.getMembers() ?? []);
//     for (var e in _memberList) {
//       String user = e.userId;

//       if (user.contains(':')) {
//         int id = int.tryParse(user.split(':')[0]) ?? 0;
//         String name = user.split(':')[1];
//         if (_userList.containsKey(id)) {
//           _userList.update(
//             id,
//             (value) {
//               value.name = name;
//               return value;
//             },
//           );
//         } else {
//           // if (id == _localUid) {
//           //   _userList.addAll({id: ConnectedUserInfo(id, name, _localView())});
//           // } else if (id != _screenShareId) {
//           //   _userList
//           //       .addAll({id: ConnectedUserInfo(id, name, _remoteView(id))});
//           // }
//           // _userList.addAll({id: ConnectedUserInfo(id, name, _remoteView(id))});
//         }
//       }
//     }
//     // if (_screenShareId == 1000) {
//     //   _memberList.add(AgoraRtmMember('1000:You', _meeting.channel));
//     // }
//     // _viewModels = getRenderViews();
//     if (_localUserJoined) notifyListeners();
//   }

//   void sendPeerMessage(String userId, String content) async {
//     AgoraRtmMessage message = AgoraRtmMessage.fromText(content);
//     await _rtmClient.sendMessageToPeer(userId, message, true, false);
//   }

//   void toggleVolume() async {
//     _speakerOn = !_speakerOn;
//     await _engine.setEnableSpeakerphone(_speakerOn);
//     notifyListeners();
//   }

//   void toggleCamera() async {
//     _camera = !_camera;
//     await _engine.muteLocalVideoStream(_camera);
//     notifyListeners();
//   }

//   void onToggleMute() async {
//     _muted = !_muted;
//     await _engine.muteLocalAudioStream(_muted);
//     notifyListeners();
//   }

//   void toggleShareScreen() async {
//     if (_initializingScreenShare) return;

//     _initializingScreenShare = true;
//     if (!_shareScreen) {
//       await startScreenShare();
//     } else {
//       await stopScreenShare();
//     }
//     // _shareScreen = _screenShareId == 1000;
//     // _engine.muteLocalAudioStream(_muted);
//     notifyListeners();
//   }

//   Future startScreenShare() async {
//     // if (_shareScreen) return;
//     await _engine.startScreenCapture(
//         const ScreenCaptureParameters2(captureAudio: true, captureVideo: true));
//     await _engine.startPreview(sourceType: VideoSourceType.videoSourceScreen);
//     _showRPSystemBroadcastPickerViewIfNeed();
//     if (_screenShareId == 0) {
//       await _engine.joinChannelEx(
//         token: _meeting.token,
//         connection: RtcConnection(channelId: _meeting.channel, localUid: 1000),
//         options: const ChannelMediaOptions(
//           autoSubscribeVideo: true,
//           autoSubscribeAudio: true,
//           publishScreenTrack: true,
//           publishSecondaryScreenTrack: true,
//           publishCameraTrack: false,
//           publishMicrophoneTrack: false,
//           publishScreenCaptureAudio: true,
//           publishScreenCaptureVideo: true,
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         ),
//       );
//       // _memberList.add(AgoraRtmMember('1000:You', _meeting.channel));
//     } else {}

//     // onStartScreenShared();
//   }

//   // Future<void> _updateScreenShareChannelMediaOptions() async {
//   //   // final shareShareUid = int.tryParse(_screenShareId);
//   //   // if (shareShareUid == null) return;
//   //   await _engine.updateChannelMediaOptionsEx(
//   //     options: const ChannelMediaOptions(
//   //       publishScreenTrack: true,
//   //       publishSecondaryScreenTrack: true,
//   //       publishCameraTrack: false,
//   //       publishMicrophoneTrack: false,
//   //       publishScreenCaptureAudio: true,
//   //       publishScreenCaptureVideo: true,
//   //       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//   //     ),
//   //     connection:
//   //         RtcConnection(channelId: _meeting.channel, localUid: _screenShareId),
//   //   );
//   // }

//   // @override
//   Future stopScreenShare() async {
//     if (!_shareScreen) return;
//     try {
//       await _engine.stopScreenCapture();
//       await _engine.leaveChannelEx(
//           RtcConnection(channelId: _meeting.channel, localUid: 1000));
//       await _engine.updateChannelMediaOptions(const ChannelMediaOptions(
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         publishCameraTrack: true,
//         publishScreenTrack: false,
//       ));
//       // _screenShareId = 0;
//       notifyListeners();
//     } catch (e) {}
//   }

//   Future<void> _showRPSystemBroadcastPickerViewIfNeed() async {
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       await _iosScreenShareChannel
//           .invokeMethod('showRPSystemBroadcastPickerView');
//     }
//   }

//   void onSwitchCamera() async {
//     await _engine.switchCamera();
//   }

//   Future sendMuteAll() async {
//     _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('mute_all'));
//   }

//   Future sendRaiseHand() async {
//     _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('raise_hand'));

//     _timer?.cancel();
// //Show to sender too
//     _ref.read(raisedHandMeetingProvider.notifier).state =
//         S.current.bmeet_user_you;
//     _timer = Timer(const Duration(seconds: 2), () {
//       _ref.read(raisedHandMeetingProvider.notifier).state = '';
//     });
//   }

//   // Future sendVideoOffAll() async {
//   //   _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('disable_video'));
//   // }

//   Future sendLeaveApi() async {
//     _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('leave'));
//     // for (var m in _memberList) {
//     //   try {
//     //     int id = int.tryParse(m.userId.split(':')[0]) ?? 0;
//     //     if (id != _localUid) {
//     //       AgoraRtmMessage message = AgoraRtmMessage.fromText('leave');
//     //       await _rtmClient.sendMessageToPeer(
//     //           id.toString(), message, false, false);
//     //       print('send message to ${m.userId}');
//     //     }
//     //   } catch (e) {
//     //     print('Error: $e');
//     //   }
//     // }
//   }

//   Future _leaveApi() async {
//     // await _rtmChannel?.se
//     await _rtmChannel?.leave();
//   }

//   Future disposeAgora() async {
//     await _engine.stopPreview();
//     if (_meeting.role == "host") {
//       await _leaveApi();
//     }
//     await _engine.leaveChannel();
//     await _engine.release();
//     await _rtmClient.logout();
//     await _rtmClient.destroy();
//   }

//   @override
//   void dispose() {
//     _localUserJoined = false;

//     print('Dispose Called');
//     // _callTimerProvider.reset();
//     // _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
//     // clear users

//     disposeAgora();
//     _userRemoteIds.clear();
//     super.dispose();
//   }

//   // List<ViewModel> getRenderViews() {
//   //   List<ViewModel> list = [];
//   //   Set<int> users = _userRemoteIds;
//   //   bool isIMSpeaking = speakingUsers[_localUid]?.isSpeaking ?? false;
//   //   list.add(ViewModel(_localUid, 'userName', _localView(), isIMSpeaking));
//   //   for (var uid in users) {
//   //     if (uid == 1000) {
//   //       list.add(ViewModel(uid, 'userName', _remoteScreenView(), false));
//   //     } else if (uid != localUid) {
//   //       bool isSpeaking = speakingUsers[uid]?.isSpeaking ?? false;
//   //       list.add(ViewModel(uid, 'userName', _remoteView(uid), isSpeaking));
//   //     }
//   //   }
//   //   return list;
//   // }

//   StatefulWidget _localView() {
//     return AgoraVideoView(
//       controller: VideoViewController(
//         rtcEngine: engine,
//         canvas: const VideoCanvas(
//           uid: 0,
//           renderMode: RenderModeType.renderModeHidden,
//           isScreenView: false,
//           sourceType: VideoSourceType.videoSourceCamera,
//         ),
//       ),
//     );
//   }

//   StatefulWidget _remoteView(int uid) {
//     return AgoraVideoView(
//       controller: VideoViewController.remote(
//         rtcEngine: engine,
//         canvas: VideoCanvas(
//           uid: uid,
//           renderMode: RenderModeType.renderModeHidden,
//           isScreenView: false,
//           sourceType: VideoSourceType.videoSourceRemote,
//         ),
//         connection: RtcConnection(channelId: _meeting.channel),
//       ),
//     );
//   }

//   StatefulWidget _localScreenView() {
//     return AgoraVideoView(
//       controller: VideoViewController(
//         rtcEngine: engine,
//         // connection: RtcConnection(
//         //     channelId: _meeting.channel, localUid: _screenShareId),
//         canvas: VideoCanvas(
//             uid: _screenShareId,
//             renderMode: RenderModeType.renderModeFit,
//             sourceType: VideoSourceType.videoSourceScreen,
//             isScreenView: true),
//       ),
//     );
//   }

//   StatefulWidget _remoteScreenView() {
//     return AgoraVideoView(
//       controller: VideoViewController.remote(
//         rtcEngine: engine,
//         connection: RtcConnection(
//             channelId: _meeting.channel, localUid: _screenShareId),
//         canvas: VideoCanvas(
//             uid: _screenShareId,
//             renderMode: RenderModeType.renderModeFit,
//             sourceType: VideoSourceType.videoSourceScreen,
//             isScreenView: true),
//       ),
//     );
//   }
// }

// // class SpeakingUser {
// //   final int uid; //reference to user uid
// //   bool isSpeaking; // reference to whether the user is speaking
// //   SpeakingUser(this.uid, this.isSpeaking);
// //   @override
// //   String toString() {
// //     return 'User{uid: $uid, isSpeaking: $isSpeaking}';
// //   }
// // }

// class ConnectedUserInfo {
//   final int uid;
//   StatefulWidget widget;
//   String name;
//   bool isSpeaking = false;
//   bool muteAudio = false;
//   bool enabledVideo = false;

//   ConnectedUserInfo(this.uid, this.name, this.widget);
// }
