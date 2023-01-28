// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '/data/services/fcm_api_service.dart';
import '/core/utils/callkit_utils.dart';
import '../p2p_call_provider.dart';
import '/controller/bmeet_providers.dart';
import '/core/constants.dart';
import '/core/helpers/call_helper.dart';
import '/core/helpers/bmeet_helper.dart';

import '/core/state.dart';
import '../../bchat_providers.dart';

import '/core/helpers/duration.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

final raisedHandMeetingProvider = StateProvider<String>((ref) => '');

class GroupCallProvider extends ChangeNotifier {
  final MethodChannel _iosScreenShareChannel =
      const MethodChannel('example_screensharing_ios');
//
  int _localUid = 0;
  int? get localUid => _localUid;

//
  bool _localUserJoined = false;
  bool get localUserJoined => _localUserJoined;

  bool get endCall => _endCall;
  bool _disconnected = false;
  bool get disconnected => _disconnected;
  // bool _kickOut = false;
  // bool get kickOut => _kickOut;

//
  // int _screenShareId = 0;

//
  bool _isPreviewReady = false;
  bool get isPreviewReady => _isPreviewReady;

//
  bool _allMuted = true;
  bool get allMuted => _allMuted;

//
  // bool _hostDisableCamera = false;
  // bool get hostCamera => _hostDisableCamera;

//
  // bool _hostMute = false;
  // bool get hostMute => _hostMute;

//
  bool _muted = false;
  bool get muted => _muted;

//
  bool _speakerOn = false;
  bool get speakerOn => _speakerOn;

//
  bool _disableLocalCamera = true;
  bool get disableLocalCamera => _disableLocalCamera;

//
  int _indexValue = 0;
  int get indexValue => _indexValue;

//
  Set<int> get remoteUsersIds => _userRemoteIds;
  final Set<int> _userRemoteIds = HashSet();

  CallConnectionStatus _status = CallConnectionStatus.Connecting;

  CallConnectionStatus get status => _status;

//
  final Map<int, GroupCallUser> _groupCallingMembers = <int, GroupCallUser>{};
  Map<int, GroupCallUser> get userList => _groupCallingMembers;

  bool _initialized = false;
  bool _initializingScreenShare = false;
  bool get initializingScreenShare => _initializingScreenShare;

//
  bool _shareScreen = false;
  bool get shareScreen => _shareScreen;

//
  late RtcEngineEx _engine;
  RtcEngineEx get engine => _engine;

//
  late final Meeting _meeting;
  late final CallType _callType;
  late final String _groupId;
  // late final ChatGroup groupModel;
  // late final RTMUserTokenResponse rtmTokem;

  late final String _callId;
  late final int _callRequestId;
  late final CallDirectionType callDirectionType;
  late final User _me;
  AssetsAudioPlayer? _player;
  Timer? _timer;
  // final List<Contacts> _memberContacts = [];

  final DurationNotifier _callTimerProvider;

  GroupCallProvider(this._callTimerProvider);

  WidgetRef? _ref;

  bool _isReceiving = false;

  String? _error;
  String? get error => _error;
  void initReceiver(
      BuildContext context,
      WidgetRef ref,
      int requestId,
      String callId,
      String groupId,
      CallType callType,
      User user,
      String membersIds) async {
    if (_isReceiving) return;
    _ref = ref;

    _callType = callType;
    _me = user;
    _callId = callId;
    _callRequestId = requestId;
    _isReceiving = true;
    _groupId = groupId;
    // final grpInfo = ref.read(groupMembersInfo(_groupId)).valueOrNull;

    final List<Contacts> contacts = [];
    if (membersIds.isNotEmpty) {
      final conts = await ref.read(bChatProvider).getContactsByIds(membersIds);
      if (conts?.isNotEmpty == true) {
        contacts.addAll(conts!
            .map((e) => Contacts.fromContact(e, ContactStatus.group))
            .toList());
      }
    }

    print('my_fcm ${_me.fcmToken}');
    // if (grpInfo == null || grpInfo.members.isEmpty) {
    //   final contactList =
    //       await BchatGroupManager.fetchContactsOfGroup(ref, groupId);
    //   contacts.addAll(
    //       contactList.map((e) => Contacts.fromContact(e, ContactStatus.group)));
    // } else {
    //   contacts.addAll(grpInfo.members);
    // }
    if (contacts.isEmpty) {
      setError('Error getting contacts');
      return;
    }

    // _memberContacts.addAll(grpInfo.members);
    final JoinMeeting? joinMeeting =
        await ref.read(bMeetRepositoryProvider).joinMeeting(callId);
    if (joinMeeting != null) {
      Meeting smeeting = Meeting(joinMeeting.appid, joinMeeting.channel,
          joinMeeting.token, 'audience', joinMeeting.audienceLatency);
      _meeting = smeeting;
      // final userRTMToken = await ref
      //     .read(bMeetRepositoryProvider)
      //     .fetchUserToken(1000000 + user.id, user.name);

      // _callDirectiontype = CallDirectionType.incoming;

      if (!await handleCameraAndMic(Permission.microphone)) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          AppSnackbar.instance.error(context, 'Need microphone permission');
          // return;
        }
      }
      if (!await handleCameraAndMic(Permission.camera) &&
          callType == CallType.video) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          AppSnackbar.instance.error(context, 'Need camera permission');
          // return;
        }
      }
      for (Contacts contact in contacts) {
        print('contact fcm ${contact.fcmToken}');
        userList.addAll({
          contact.userId: GroupCallUser(
              contact.userId, contact, _callType == CallType.video)
        });
      }
      _createRTMClient();
    } else {
      await Future.delayed(const Duration(seconds: 2));
      setError('Error joining call');
    }
  }

  void init(
      WidgetRef ref,
      int callRequestId,
      String callId,
      String groupId,
      User me,
      Meeting meeting,
      CallType callType,
      List<Contacts> memberContacts,
      CallDirectionType callDirectiontype) {
    if (_initialized) return;
    _ref = ref;
    _initialized = true;
    _meeting = meeting;
    _callType = callType;
    _me = me;
    _callId = callId;
    _callRequestId = callRequestId;
    _groupId = groupId;
    // _memberContacts.addAll(memberContacts);
    print('my_fcm ${_me.fcmToken}');
    // _callDirectiontype = callDirectiontype;
    for (Contacts contact in memberContacts) {
      print('contact fcm ${contact.fcmToken}');
      userList.addAll({
        contact.userId:
            GroupCallUser(contact.userId, contact, _callType == CallType.video)
      });
    }
    _createRTMClient();
  }

  void _createRTMClient() async {
    if (_meeting.appid.isEmpty) {
      // print('Meeting App ID is emply');
      setError('Meeting App ID is emply');
      return;
    }
    setOnGoing(_callId);
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage Group Call Screen=> ${message.data}');
      if (message.data['type'] == NotiConstants.typeGroupCall) {
        final String? action = message.data['action'];

        if (action == NotiConstants.actionCallDecline ||
            action == NotiConstants.actionCallDeclineBusy ||
            action == NotiConstants.actionCallEnd) {
          String callId = message.data['call_id'];
          String grpId = message.data['grp_id'];
          if (callId != _callId || grpId != _groupId) {
            print('Invalid group');
            return;
          }
          int fromId = int.parse(message.data['from_id']);
          _groupCallingMembers.update(fromId, ((value) {
            value.status = action == NotiConstants.actionCallEnd
                ? JoinStatus.ended
                : JoinStatus.decline;
            value.widget = null;
            return value;
          }));

          if (!_disconnected && !_endCall) {
            bool isAllRejected = true;
            for (var user in _groupCallingMembers.values) {
              if (user.status != JoinStatus.ended &&
                  user.status != JoinStatus.decline) {
                isAllRejected = false;
                break;
              }
            }
            _endCall = isAllRejected;
            if (_endCall) {
              if (_timer?.isActive == true) {
                _timer?.cancel();
                _player?.stop();
                _callTimerProvider.reset();
                clearCall();
              }
            }

            if (action == NotiConstants.actionCallDeclineBusy) {
              // Fluttertoast.showToast(
              //     msg: "${body.calleeName} is  Busy",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0);
            }
            // _endCall = true;
            // _read.reset();
            // clearCall();
            // activeCallId = null;
            // _updateMemberList();
            notifyListeners();
          }
        }
      }
    });

    try {
      // print('User $rtmUser');
      // await _rtmClient.login(rtmToken.rtmToken, rtmToken.rtmUser!);
      await _initAgoraRTC(_me.id);

      /// RTM
    } catch (errorCode) {
      setError('error agroa rtc $errorCode');
    }
  }

  setError(String message) async {
    _error = message;
    print('Error =>$message ');
    try {
      notifyListeners();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      notifyListeners();
    }
  }

  bool _endCall = false;
  _outgoingTimer() async {
    // _player = AudioPlayer();
    _player = AssetsAudioPlayer.newPlayer();
    //  String audioasset = "assets/audio/Basic.mp3";
    // ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    // Uint8List soundbytes =
    // bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    _timer = Timer(const Duration(seconds: 30), () {
      _endCall = true;
      _callTimerProvider.reset();

      print('Timer ended here');
      notifyListeners();
    });
    try {
      await _player?.open(Audio('assets/audio/Basic.mp3'));
      await _player?.play();

      // await _player?.play(AssetSource('audio/Basic.mp3'));
    } catch (e) {
      print('$e');
    }
  }

  Future<void> _initAgoraRTC(int userid) async {
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: _meeting.appid,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
          onRejoinChannelSuccess: (connection, elapsed) {},
          onError: (err, msg) {},
          onMediaDeviceChanged: (deviceType) {},
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            _localUserJoined = true;
            _localUid = connection.localUid ?? 0;
            _status = CallConnectionStatus.Ringing;
            _outgoingTimer();
            // _userRemoteIds.add(_localUid);
            _groupCallingMembers.update(_localUid, ((value) {
              value.status = JoinStatus.connected;
              if (value.enabledVideo) {
                value.widget = _localView();
              } else {
                value.widget = getRectFAvatar(
                    value.contact.name, value.contact.profileImage);
              }
              return value;
            }));
            // _userList.addAll({_localUid: GroupCallUser(_localUid, _localView())});
            _updateMemberList();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (_status == CallConnectionStatus.Ringing) {
              _status == CallConnectionStatus.Connected;
              _callTimerProvider.start();
              _timer?.cancel();
              _player?.stop();
            }

            _groupCallingMembers.update(remoteUid, ((value) {
              value.status = JoinStatus.connected;
              if (value.enabledVideo) {
                value.widget = _remoteView(remoteUid);
              } else {
                value.widget = getRectFAvatar(
                    value.contact.name, value.contact.profileImage);
              }
              return value;
            }));
            // _userList.addAll(
            // {remoteUid: GroupCallUser(remoteUid, _remoteView(remoteUid))});
            // notifyListeners();
            _updateMemberList();
          },
          // onRemoteVideoStateChanged:
          //     (connection, remoteUid, state, reason, elapsed) {
          //   print(
          //       'remote user video $remoteUid  status changed to ${state.name}, since $elapsed seconds  ,reason ${reason.name}');
          // },
          onLeaveChannel: (connection, stats) {
            int remoteUid = connection.localUid ?? 0;
            _groupCallingMembers.update(remoteUid, ((value) {
              value.status = JoinStatus.ended;
              value.widget = null;
              return value;
            }));
            // int userId = connection.localUid ?? 0;
            // if (userId < 1000000) {
            //   _screenShareId = 0;
            //   _shareScreen = false;
            //   _userRemoteIds.remove(userid);
            //   _userList.removeWhere((key, value) => key == userid);
            //   _initializingScreenShare = false;
            //   _userList.update(
            //     _localUid,
            //     (value) {
            //       value.widget = _localView();
            //       return value;
            //     },
            //   );
            // _userList.addAll(
            //     {_localUid: ConnectedUserInfo(_localUid, '', _localView())});
            // _updateMemberList();
            if (_localUserJoined) {
              _localUserJoined = false;
              // print('User Id:$userid');
              notifyListeners();
            }
          },
          onUserOffline: (connection, remoteUid, UserOfflineReasonType reason) {
            _userRemoteIds.remove(remoteUid);
            _groupCallingMembers.update(remoteUid, ((value) {
              value.status = JoinStatus.ended;
              value.widget = null;
              return value;
            }));
            // _userList.removeWhere((key, value) => key == remoteUid);

            // if (remoteUid < 1000000) {
            //   _screenShareId = 0;
            //   _shareScreen = false;
            //   _initializingScreenShare = false;
            // }

            // _userRemoteIds.removeWhere((item) => item == remoteUid);
            // _speakingUsersMap.removeWhere((key, value) => key == remoteUid);
            _updateMemberList();
          },
          onAudioVolumeIndication:
              (connection, speakers, speakerNumber, totalVolume) {
            for (var speaker in speakers) {
              if ((speaker.volume ?? 0) > 5) {
                // print(
                //     '[onAudioVolumeIndication] uid: ${speaker.uid}, volume: ${speaker.volume}');
                _groupCallingMembers.forEach((key, value) {
                  //Highlighting local user
                  //In this callback, the local user is represented by an uid of 0.
                  if ((_localUid.compareTo(key) == 0) && (speaker.uid == 0)) {
                    _groupCallingMembers.update(key, (value) {
                      value.isSpeaking = true;
                      return value;
                    });
                  }

                  //Highlighting remote user
                  else if (key.compareTo(speaker.uid ?? 0) == 0) {
                    _groupCallingMembers.update(key, (value) {
                      value.isSpeaking = true;
                      return value;
                    });
                  } else {
                    _groupCallingMembers.update(key, (value) {
                      value.isSpeaking = false;
                      return value;
                    });
                  }
                });
              }
              // if (_localUserJoined) notifyListeners();
              _updateMemberList();
            }
          },
          onUserMuteAudio: (connection, remoteUid, muted) {
            if (_groupCallingMembers.containsKey(remoteUid)) {
              _groupCallingMembers.update(remoteUid, (value) {
                value.muteAudio = muted;
                return value;
              });
            }
            _updateMemberList();
          },
          onUserEnableVideo: (connection, remoteUid, enabled) {
            if (_groupCallingMembers.containsKey(remoteUid)) {
              _groupCallingMembers.update(remoteUid, (value) {
                value.enabledVideo = enabled;
                if (enabled) {
                  value.widget = _localUid == remoteUid
                      ? _localView()
                      : _remoteView(remoteUid);
                } else {
                  value.widget = getRectFAvatar(
                      value.contact.name, value.contact.profileImage);
                }
                return value;
              });
            }
            _updateMemberList();
          }

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

    if (_callType == CallType.video) {
      _disableLocalCamera = false;
      await _engine.enableVideo();
      await _engine.enableLocalVideo(true);
      await _engine.setDefaultAudioRouteToSpeakerphone(true);
      await _engine.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 360),
          frameRate: 15,
          bitrate: 0,
        ),
      );
    } else {
      _disableLocalCamera = true;
      await _engine.disableVideo();
      await _engine.enableLocalVideo(false);
      await _engine.setDefaultAudioRouteToSpeakerphone(false);
    }
    await _engine.muteLocalVideoStream(_disableLocalCamera);
    await _engine.enableAudioVolumeIndication(
        interval: 250, smooth: 3, reportVad: true);
    await _engine.muteLocalAudioStream(_muted);
    // await _engine.muteLocalVideoStream(_disableLocalCamera);
    // await _engine.enableVideo();
// await _engine.setEnableSpeakerphone(speakerOn)

    await _engine.startPreview();
    await _engine.joinChannel(
        token: _meeting.token,
        channelId: _meeting.channel,
        uid: userid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: _callType == CallType.video,
          publishScreenTrack: false,
        ));
    _isPreviewReady = true;
    _callTimerProvider.start();

    notifyListeners();
  }

  // void onToggleAllMute() {
  //   _allMuted = !_allMuted;
  //   _engine.muteAllRemoteAudioStreams(_allMuted);
  //   debugPrint('mute All $allMuted');
  //   notifyListeners();
  // }

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
    if (_localUserJoined) notifyListeners();
  }

  // void sendPeerMessage(String userId, String content) async {
  //   AgoraRtmMessage message = AgoraRtmMessage.fromText(content);
  //   try {
  //     await _rtmClient.sendMessageToPeer(userId, message, false, false);
  //   } catch (e) {}
  // }

  Future<String?> endCurrentCall(
      CallDirectionType callDirectionType, String grpName) async {
    if (_disconnected || _userRemoteIds.length > 2) {
      return null;
    }
    if (callDirectionType == CallDirectionType.outgoing) {
      if (status == CallConnectionStatus.Connecting ||
          status == CallConnectionStatus.Ringing) {
        List<String> fcmIds = [];
        for (var user in _groupCallingMembers.values) {
          if (user.status != JoinStatus.decline &&
              user.status != JoinStatus.ended &&
              _me.id != user.contact.userId &&
              user.contact.fcmToken?.isNotEmpty == true) {
            fcmIds.add(user.contact.fcmToken!);
          }
        }

        if (fcmIds.isNotEmpty) {
          print('fcm =>${fcmIds}');
          await FCMApiService.instance.sendGroupCallEndPush(
              fcmIds,
              NotiConstants.actionCallEnd,
              _me.id,
              _groupId,
              _callId,
              grpName,
              _me.image,
              _callType == CallType.video);
        }
      }
    }
    return await _ref?.read(bMeetRepositoryProvider).leaveMeet(_callRequestId);
  }

  void toggleVolume() async {
    _speakerOn = !_speakerOn;
    await _engine.setEnableSpeakerphone(_speakerOn);
    notifyListeners();
  }

  void toggleCamera() async {
    _disableLocalCamera = !_disableLocalCamera;
    await _engine.muteLocalVideoStream(_disableLocalCamera);
    notifyListeners();
  }

  void onToggleMute() async {
    _muted = !_muted;
    await _engine.muteLocalAudioStream(_muted);
    notifyListeners();
  }

  void toggleShareScreen() async {
    if (_initializingScreenShare) return;

    _initializingScreenShare = true;
    if (!_shareScreen) {
      await startScreenShare();
    } else {
      await stopScreenShare();
    }
    // _shareScreen = _screenShareId == 1000;
    // _engine.muteLocalAudioStream(_muted);
    notifyListeners();
  }

  Future startScreenShare() async {
    // if (_shareScreen) return;
    try {
      await _engine.startScreenCapture(const ScreenCaptureParameters2(
          captureAudio: true, captureVideo: true));
      await _engine.startPreview(sourceType: VideoSourceType.videoSourceScreen);
      _showRPSystemBroadcastPickerViewIfNeed();
      if (!_shareScreen) {
        await _engine.updateChannelMediaOptions(const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishScreenTrack: true,
          publishSecondaryScreenTrack: true,
          publishCameraTrack: false,
          publishMicrophoneTrack: false,
          publishScreenCaptureAudio: true,
          publishScreenCaptureVideo: true,
        ));
        _shareScreen = true;
        _initializingScreenShare = false;

        _groupCallingMembers.update(
          _localUid,
          (value) {
            value.widget = _localScreenView();
            return value;
          },
        );
        notifyListeners();
      } else {}
    } catch (e) {}
    // onStartScreenShared();
  }

  // Future<void> _updateScreenShareChannelMediaOptions() async {
  //   // final shareShareUid = int.tryParse(_screenShareId);
  //   // if (shareShareUid == null) return;
  //   await _engine.updateChannelMediaOptionsEx(
  //     options: const ChannelMediaOptions(
  //       publishScreenTrack: true,
  //       publishSecondaryScreenTrack: true,
  //       publishCameraTrack: false,
  //       publishMicrophoneTrack: false,
  //       publishScreenCaptureAudio: true,
  //       publishScreenCaptureVideo: true,
  //       clientRoleType: ClientRoleType.clientRoleBroadcaster,
  //     ),
  //     connection:
  //         RtcConnection(channelId: _meeting.channel, localUid: _screenShareId),
  //   );
  // }

  // @override
  Future stopScreenShare() async {
    if (!_shareScreen) return;
    try {
      await _engine.stopScreenCapture();
      // await _engine.leaveChannelEx(
      //     RtcConnection(channelId: _meeting.channel, localUid: 1000));
      await _engine.updateChannelMediaOptions(const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishScreenTrack: false,
        publishSecondaryScreenTrack: false,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        publishScreenCaptureAudio: false,
        publishScreenCaptureVideo: false,
      ));

      _groupCallingMembers.update(
        _localUid,
        (value) {
          value.widget = _localView();
          return value;
        },
      );
      _shareScreen = false;
      _initializingScreenShare = false;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> _showRPSystemBroadcastPickerViewIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _iosScreenShareChannel
          .invokeMethod('showRPSystemBroadcastPickerView');
    }
  }

  void onSwitchCamera() async {
    await _engine.switchCamera();
  }

  // Future sendMuteAll() async {
  //   _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('mute_all'));
  // }

  // Future sendVideoOffAll() async {
  //   _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('disable_video'));
  // }

  // Future sendLeaveApi() async {
  //   await _rtmChannel?.sendMessage(AgoraRtmMessage.fromText('leave'));
  // }

  // Future _leaveApi() async {
  //   // await _rtmChannel?.se
  //   await _rtmChannel?.leave();
  // }

  disconnect() async {
    if (_disconnected) {
      return;
    }
    _disconnected = true;
    try {
      if (_timer?.isActive == true) {
        _timer?.cancel();
      }
      setOnGoing(null);
      await _player?.stop();
      await _player?.dispose();

      await _engine.leaveChannel();
      await _engine.release();
    } catch (_) {}
  }

  @override
  void dispose() {
    _localUserJoined = false;

    // _callTimerProvider.reset();
    // _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    // clear users

    disconnect();
    _groupCallingMembers.clear();
    _userRemoteIds.clear();
    _disconnected = true;
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
          isScreenView: false,
          sourceType: VideoSourceType.videoSourceRemote,
        ),
        connection: RtcConnection(channelId: _meeting.channel),
      ),
    );
  }

  StatefulWidget _localScreenView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        // connection: RtcConnection(
        //     channelId: _meeting.channel, localUid: _screenShareId),
        canvas: const VideoCanvas(
            // uid: _localUid,

            renderMode: RenderModeType.renderModeFit,
            sourceType: VideoSourceType.videoSourceScreen,
            isScreenView: true),
      ),
    );
  }

  void startRecording() {
    // _engine.startAudioRecording(config);
  }

  // StatefulWidget _remoteScreenView() {
  //   return AgoraVideoView(
  //     controller: VideoViewController.remote(
  //       rtcEngine: engine,
  //       connection: RtcConnection(
  //           channelId: _meeting.channel, localUid: _screenShareId),
  //       canvas: VideoCanvas(
  //           uid: _screenShareId,
  //           renderMode: RenderModeType.renderModeFit,
  //           sourceType: VideoSourceType.videoSourceScreen,
  //           isScreenView: true),
  //     ),
  //   );
  // }
}

// class SpeakingUser {
//   final int uid; //reference to user uid
//   bool isSpeaking; // reference to whether the user is speaking
//   SpeakingUser(this.uid, this.isSpeaking);
//   @override
//   String toString() {
//     return 'User{uid: $uid, isSpeaking: $isSpeaking}';
//   }
// }

class GroupCallUser {
  final int uid;
  final Contacts contact;
  Widget? widget;

  bool isSpeaking = false;
  bool muteAudio = false;
  bool enabledVideo = false;
  JoinStatus status = JoinStatus.ringing;
  GroupCallUser(this.uid, this.contact, this.enabledVideo);
}

enum JoinStatus { ringing, decline, connected, ended }
