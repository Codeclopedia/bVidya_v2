import 'dart:async';
// import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bvidya/app.dart';

// import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '/core/helpers/bmeet_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import '/core/utils/callkit_utils.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import '/core/constants/notification_const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '/core/utils/common.dart';
import '/core/helpers/call_helper.dart';
import '/core/helpers/duration.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/data/models/models.dart';

// ignore: constant_identifier_names
enum CallConnectionStatus { Connecting, Ringing, Connected, Ended }

class P2PCallProvider extends ChangeNotifier {
  final DurationNotifier _read;
  P2PCallProvider(this._read);

  RtcEngine? _engine;

  RtcEngine? get engine => _engine;

  bool _remoteMute = false;
  bool get remoteMute => _remoteMute;

  // bool _remoteVideoOn = false;
  // bool get remoteVideoOn => _remoteVideoOn;

  // bool _isInitialized = false;

  bool _speakerOn = false;
  bool get speakerOn => _speakerOn;

  bool _mute = false;
  bool get mute => _mute;

  bool _videoOn = false;
  bool get videoOn => _videoOn;

  bool _remoteVideoMute = true;
  bool get remoteVideoMute => _remoteVideoMute;

  bool _disconnected = false;

  bool get disconnected => _disconnected;
  bool _endCall = false;
  bool get isCallEnded => _endCall;

  CallConnectionStatus _status = CallConnectionStatus.Connecting;

  CallConnectionStatus get status => _status;

  // CallType _currentCallType = CallType.audio;

  CallType get updateCallType => _callType;

  Timer? _timer;

  late CallDirectionType _callDirection;
  late CallBody _body;
  late CallType _callType;

  int _localId = -1;
  int _remoteId = -1;

  int get remoteId => _remoteId;
  int get localId => _localId;

  // AudioPlayer? _player;
  AssetsAudioPlayer? _player;

  void init(CallBody body, CallDirectionType type, CallType callType) async {
    // if (_isInitialized) {
    //   return;
    // }
    // showOutGoingCall(body, callType == CallType.video);
    // _isInitialized = true;
    _callType = callType;
    setOnGoing(body.callId);

    _callDirection = type;
    _body = body;
    FirebaseMessaging.onMessage.listen((message) {
      // print('onMessage Call Screen=> ${message.data}');
      if (message.data['type'] == NotiConstants.typeCall) {
        final String? action = message.data['action'];
        if (action == NotiConstants.actionCallDecline ||
            action == NotiConstants.actionCallDeclineBusy) {
          if (!_disconnected && !_endCall) {
            if (action == NotiConstants.actionCallDeclineBusy) {
              Fluttertoast.showToast(
                  msg: "${body.calleeName} is  Busy",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            _endCall = true;
            _read.reset();
            clearCall();
            // activeCallId = null;
            updateUI();
          }
        }
      }
    });

    if (!await handleCameraAndMic(Permission.microphone)) {
      if (navigatorKey.currentContext != null) {
        AppSnackbar.instance
            .error(navigatorKey.currentContext!, 'Need microphone permission');
      }
      return;
    }
    if (callType == CallType.video) {
      if (!await handleCameraAndMic(Permission.camera)) {
        if (navigatorKey.currentContext != null) {
          AppSnackbar.instance
              .error(navigatorKey.currentContext!, 'Need camera permission');
        }
        return;
      }
    }

    await _initEngine();
  }

  void _outgoingTimer() async {
    // _player = AudioPlayer();
    _player = AssetsAudioPlayer.newPlayer();
    //  String audioasset = "assets/audio/Basic.mp3";
    // ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    // Uint8List soundbytes =
    // bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    _timer = Timer(const Duration(seconds: 30), () {
      _endCall = true;
      _read.reset();
      // print('Timer ended here');
      updateUI();
    });
    try {
      await _player?.open(Audio('assets/audio/Basic.mp3'));
      await _player?.play();

      // await _player?.play(AssetSource('audio/Basic.mp3'));
    } catch (e) {
      // print('$e');
    }
  }

  Future _initEngine() async {
    int userId = (await getMeAsUser())?.id ?? 0;
    try {
      final engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(
          appId: _body.appid,
          channelProfile: ChannelProfileType.channelProfileCommunication1v1,
        ),
      );
      engine.registerEventHandler(RtcEngineEventHandler(
        // onUserEnableVideo: (connection, remoteUid, enabled) {
        //   if (remoteId == _remoteId) {
        //     _remoteVideoOn = enabled;
        //     if (_remoteVideoOn && _currentCallType == CallType.audio) {
        //       _switchToVideoCall();
        //     }
        //     notifyListeners();
        //     print('remote video state: $enabled ');
        //   }
        // },
        onUserMuteAudio: (connection, remoteUid, muted) {
          if (_remoteId == remoteUid) {
            _remoteMute = muted;
            updateUI();
          }
        },
        onUserMuteVideo: (connection, remoteUid, muted) {
          if (_remoteId == remoteUid) {
            _remoteVideoMute = muted;
            updateUI();
          }
        },
        onJoinChannelSuccess: (connection, elapsed) {
          _localId = connection.localUid ?? 0;

          if (_callDirection == CallDirectionType.outgoing) {
            // _status = 'Ringing';
            _status = CallConnectionStatus.Ringing;
            _outgoingTimer();
          }
          updateUI();
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          _remoteId = remoteUid;
          _remoteVideoMute = _callType != CallType.video;
          if (_callDirection == CallDirectionType.outgoing) {
            _timer?.cancel();
            _player?.stop();
          }
          _status = CallConnectionStatus.Connected;
          // _status = 'Connected';
          updateUI();
          _read.start();
        },
        onUserOffline: (connection, remoteUid, reason) {
          _endCall = true;
          _status = CallConnectionStatus.Ended;
          updateUI();
        },
        // onRemoteAudioStateChanged:
        //     (connection, remoteUid, state, reason, elapsed) {
        //   if (remoteId == _remoteId) {
        //     _remoteMute = state != RemoteAudioState.remoteAudioStateDecoding;
        //     print('remote audio state: $state ');
        //   }
        // },
        // onRemoteVideoStateChanged:
        //     (connection, remoteUid, state, reason, elapsed) {
        //   if (remoteId == _remoteId) {
        //     _remoteVideoOn = state == RemoteVideoState.remoteVideoStateDecoding;
        //     if (_remoteVideoOn && _currentCallType == CallType.audio) {
        //       _switchToVideoCall();
        //     }
        //     notifyListeners();
        //     print('remote video state: ${state.name} ');
        //   }
        // },
      ));

      if (_callType == CallType.video) {
        await engine.enableLocalVideo(true);
        await engine.enableVideo();
        _videoOn = true;
        _speakerOn = true;
      } else {
        await engine.enableLocalVideo(false);
        await engine.disableVideo();
      }
      await engine.enableAudio();

      await engine.muteLocalAudioStream(_mute);
      await engine.setDefaultAudioRouteToSpeakerphone(_speakerOn);

      // await engine.setEnableSpeakerphone(_speakerOn);
      await engine.joinChannel(
        token: _body.callToken,
        channelId: _body.callChannel,
        uid: userId,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication1v1,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          publishScreenTrack: false,
          token: _body.callToken,
        ),
      );
      _engine = engine;
      updateUI();
    } catch (e) {
      // print('Error on join channel: $e');
    }
  }

  void setCallEnded() {
    _endCall = true;
   updateUI();
  }

  void toggleVideo(BuildContext context) async {
    try {
      // if (_currentCallType == CallType.audio) {
      //   if (!await handleCameraAndMic(Permission.camera)) {
      //     // if (defaultTargetPlatform == TargetPlatform.android) {
      //     AppSnackbar.instance.error(context, 'Need camera permission');
      //     return;
      //     // }
      //   }
      //   // try {
      //   //   await _engine?.updateChannelMediaOptions(
      //   //     ChannelMediaOptions(
      //   //       channelProfile: ChannelProfileType.channelProfileCommunication1v1,
      //   //       clientRoleType: ClientRoleType.clientRoleBroadcaster,
      //   //       autoSubscribeAudio: true,
      //   //       autoSubscribeVideo: true,
      //   //       publishCameraTrack: true,
      //   //       publishMicrophoneTrack: true,
      //   //       publishScreenTrack: false,
      //   //       token: _body.callToken,
      //   //     ),
      //   //   );
      //   // } catch (e) {
      //   //   print('error in switching mode: $e');
      //   //   return;
      //   // }
      //   _currentCallType = CallType.video;
      //   _remoteVideoOn = true;
      // }
      if (_videoOn) {
        await _engine?.disableVideo();
      } else {
        await _engine?.enableVideo();
      }

      await _engine?.enableLocalVideo(!_videoOn);
      _videoOn = !_videoOn;
      updateUI();
    } catch (_) {}
  }

  void toggleSpeaker() async {
    try {
      await _engine?.setEnableSpeakerphone(!_speakerOn);
      _speakerOn = !_speakerOn;
      updateUI();
    } catch (_) {}
  }

  void updateUI() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  void toggleMute() async {
    try {
      await _engine?.muteLocalAudioStream(!_mute);
      _mute = !_mute;
      updateUI();
    } catch (_) {}
  }

  void switchCamera() async {
    try {
      await _engine?.switchCamera();
      updateUI();
    } catch (_) {}
  }

  void disconnect() async {
    if (_disconnected) {
      return;
    }
    _disconnected = true;
    try {
      if (_timer?.isActive == true) {
        _timer?.cancel();
      }

      await _player?.stop();
      await _player?.dispose();
      // await _player?.release();

      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (_) {}
  }

  @override
  void dispose() {
    showOnLock(false);
    disconnect();
    // _isInitialized = false;
    setOnGoing(null);
    FlutterCallkitIncoming.endAllCalls();
    print('Dispose call screen');
    super.dispose();
  }
}
