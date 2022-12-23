// ignore_for_file: use_build_context_synchronously

import '/controller/blive_providers.dart';
import '/ui/base_back_screen.dart';
import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../utils.dart';

Future joinBroadcast(
  BuildContext context,
  WidgetRef ref,
  String broadcastStreamId,
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
      await ref.read(bLiveRepositoryProvider).getLiveClass(broadcastStreamId);
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
  if (userToken.roomStatus == 'Locked' || userToken.appid.isEmpty) {
    AppSnackbar.instance.error(context, 'Broadcast not live or full');
    return;
  }

  final user = await getMeAsUser();
  if (user == null) {
    AppSnackbar.instance
        .error(context, 'Error joing broadcast, Please try after some time');
    return;
  }
  final args = <String, dynamic>{
    'user_id': user.id,
    'rtm_token': userToken,
    'live_class': liveClass
  };

  Navigator.pushNamed(context, RouteList.bLiveClass, arguments: args);
}
