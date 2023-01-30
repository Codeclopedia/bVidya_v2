// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '/controller/blive_providers.dart';
import '/ui/base_back_screen.dart';
import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../utils.dart';
import 'bmeet_helper.dart';

Future joinBroadcast(
  BuildContext context,
  WidgetRef ref,
  String broadcastStreamId,
) async {
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  // if (!await _handleCameraAndMic(Permission.camera)) {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     AppSnackbar.instance.error(context, 'Need camera permission');
  //     return;
  //   }
  // }
  showLoading(ref);

  final liveClassResponse =
      await ref.read(bLiveRepositoryProvider).getLiveClass(broadcastStreamId);
  // if (liveClassResponse == null) {
  //   AppSnackbar.instance.error(context, 'Error fetching broadcast detail');
  //   hideLoading(ref);
  //   return;
  // }

  if (liveClassResponse.status != 'successfull' ||
      liveClassResponse.body == null) {
    hideLoading(ref);
    liveClassResponse.message == "Incorrect Broadcast ID"
        ? AppSnackbar.instance.error(context,
            'Webinar has not started yet. You can join once the webinar is started.')
        : AppSnackbar.instance.error(
            context,
            liveClassResponse.message ??
                'Error joing webinar, Please try after some time');

    return;
  }
  if (liveClassResponse.body?.liveClass?.id != null) {
    final liveClass = liveClassResponse.body!.liveClass!;
    final userToken =
        await ref.read(bLiveRepositoryProvider).fetchLiveRTM(liveClass.id);
    hideLoading(ref);
    if (userToken == null) {
      AppSnackbar.instance
          .error(context, 'Error joing webinar, Please try after some time');
      return;
    }
    if (userToken.roomStatus == 'Locked' || userToken.appid.isEmpty) {
      AppSnackbar.instance.error(context, 'Webinar not live or full');
      return;
    }

    final user = await getMeAsUser();
    if (user == null) {
      AppSnackbar.instance
          .error(context, 'Error joing Webinar, Please try after some time');
      return;
    }
    final args = <String, dynamic>{
      'user_id': user.id,
      'rtm_token': userToken,
      'live_class': liveClass
    };

    Navigator.pushNamed(context, RouteList.bLiveClass, arguments: args);
  } else {
    AppSnackbar.instance.error(
        context,
        liveClassResponse.message ??
            'Error joing webinar, Please try after some time');
  }
}
