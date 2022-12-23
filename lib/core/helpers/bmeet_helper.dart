// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '/controller/bmeet_providers.dart';
import '/data/models/models.dart';
import '/ui/base_back_screen.dart';
import '/ui/dialog/ok_dialog.dart';
import '../constants.dart';
import '../state.dart';
import '../ui_core.dart';
import '../utils.dart';

Future joinMeeting(BuildContext context, WidgetRef ref, String meetingId,
    bool camOff, bool micOff) async {
  if (!await _handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  if (!await _handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return;
    }
  }
  showLoading(ref);
  final joinMeeting =
      await ref.read(bMeetRepositoryProvider).joinMeeting(meetingId);

  if (joinMeeting == null || joinMeeting.appid.isEmpty) {
    AppSnackbar.instance.error(context, 'Error joining meeting');
    hideLoading(ref);
  } else if (joinMeeting.status == 'streaming') {
    // joinMeeting.role = 'audience';

    Meeting smeeting = Meeting(joinMeeting.appid, joinMeeting.channel,
        joinMeeting.token, 'audience', joinMeeting.audienceLatency);

    await _openMeetingScreen(
        context, smeeting, meetingId, -1, ref, camOff, micOff);
  } else {
    showOkDialog(context, 'Oops!',
        'Oops! Broadcast is not started yet! \nPlease wait for moment.');
  }
}

Future startMeeting(BuildContext context, WidgetRef ref,
    ScheduledMeeting scheduledMeeting, bool camOff, bool micOff) async {
  if (!await _handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  if (!await _handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return;
    }
  }
  showLoading(ref);
  final meeting = await ref
      .read(bMeetRepositoryProvider)
      .startHostMeeting(scheduledMeeting.id);

  if (meeting == null || meeting.appid.isEmpty) {
    AppSnackbar.instance.error(context, 'Error joining meeting');
    hideLoading(ref);
  } else {
    await _openMeetingScreen(context, meeting, scheduledMeeting.meetingId,
        scheduledMeeting.id, ref, camOff, micOff);
  }
}

Future _openMeetingScreen(BuildContext context, Meeting meeting,
    String meetingId, int id, WidgetRef ref, bool camOff, bool micOff) async {
  final User? user = await getMeAsUser();

  if (user == null) {
    hideLoading(ref);
    return;
  }

  final userToken = await ref
      .read(bMeetRepositoryProvider)
      .fetchUserToken(1000000 + user.id, user.name);
  hideLoading(ref);
  if (userToken == null) {
    return;
  }

  final args = <String, dynamic>{
    'id': id,
    'video': !camOff,
    'meeting': meeting,
    'user_id': user.id,
    'rtm_token': userToken.rtmToken ?? '',
    'rtm_user': userToken.rtmUser ?? '',
    'app_id': userToken.appid ?? '',
    'meeting_id': meetingId,
    'user_name': user.name,
    'mute': micOff,
  };
  Navigator.pushNamed(context, RouteList.bMeetCall, arguments: args);
}

// Future _joinMeeting(BuildContext context, JoinMeeting joinMeeting,
//     String meetingId, WidgetRef ref, bool camOff, bool micOff) async {
//   final User? user = await getMeAsUser();

//   if (user == null) {
//     hideLoading(ref);
//     return;
//   }

//   final userToken = await ref
//       .read(bMeetRepositoryProvider)
//       .fetchUserToken(user.id, user.name);
//   hideLoading(ref);
//   if (userToken == null) {
//     return;
//   }
//   final args = <String, dynamic>{
//     'video': !camOff,
//     'meeting': meeting,
//     'user_id': user.id,
//     'rtm_token': userToken.rtmToken ?? '',
//     'rtm_user': userToken.rtmUser ?? '',
//     'app_id': userToken.appid ?? '',
//     'meeting_id': meetingId,
//     'user_name': user.name,
//     'mute': micOff
//   };
//   Navigator.pushNamed(context, RouteList.bMeetCall, arguments: args);
// }

Future<bool> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  debugPrint(status.name);
  return status == PermissionStatus.granted;
}
