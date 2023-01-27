// ignore_for_file: use_build_context_synchronously

import 'package:bvidya/core/helpers/bmeet_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../ui/screens.dart';
import '../state.dart';
import '../ui_core.dart';

Future joinGroupCall(BuildContext context, WidgetRef ref, String meetingId,
    bool camOff, bool micOff) async {
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  if (!await handleCameraAndMic(Permission.camera)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need camera permission');
      return;
    }
  }
  showLoading(ref);

  
}

