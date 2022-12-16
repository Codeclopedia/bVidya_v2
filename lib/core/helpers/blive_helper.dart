// ignore_for_file: use_build_context_synchronously



import '../../controller/blive_providers.dart';
import '../../ui/base_back_screen.dart';
import '../state.dart';
import '../ui_core.dart';

Future joinBroadcast(
  BuildContext context,
  WidgetRef ref,
  String broadcastId,
) async {
  // if (!await _handleCameraAndMic(Permission.microphone)) {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     AppSnackbar.instance.error(context, 'Need microphone permission');
  //     return;
  //   }
  // }
  // if (!await _handleCameraAndMic(Permission.camera)) {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     AppSnackbar.instance.error(context, 'Need camera permission');
  //     return;
  //   }
  // }
  showLoading(ref);

  final liveClass =
      await ref.read(bLiveRepositoryProvider).getLiveClass(broadcastId);
  if (liveClass == null) {
    AppSnackbar.instance.error(context, 'Error fetching broadcast detail');
    hideLoading(ref);
    return;
  }

  final userToken =
      await ref.read(bLiveRepositoryProvider).fetchLiveRTM(liveClass.id);
  hideLoading(ref);
  if (userToken == null) {
    AppSnackbar.instance
        .error(context, 'Error joing broadcast, Please try after some time');
    return;
  }

  // final meeting =
  //     await ref.read(bMeetRepositoryProvider).joinMeeting(meetingId);

  // if (meeting == null || meeting.appid.isEmpty) {
  //   AppSnackbar.instance.error(context, 'Error joining meeting');
  //   hideLoading(ref);
  // } else {
  // await _startMeeting(context, meeting, meetingId, ref, camOff, micOff);
  // }
}

// Future _joinBroadcast(context, meeting, meetingId, ref)

// Future<bool> _handleCameraAndMic(Permission permission) async {
//   final status = await permission.request();
//   debugPrint(status.name);
//   return status == PermissionStatus.granted;
// }
