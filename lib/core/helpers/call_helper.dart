// ignore_for_file: use_build_context_synchronously

import 'package:bvidya/data/services/fcm_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/bchat_providers.dart';
import '../../data/models/models.dart';
import '../../data/services/bchat_api_service.dart';
import '../../ui/base_back_screen.dart';
import '../constants/route_list.dart';
import '../state.dart';
import '../ui_core.dart';
import '../utils.dart';
import 'bmeet_helper.dart';

enum CallDirectionType {
  incoming,
  outgoing;
}

enum CallType { audio, video }

Future makeAudioCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final user = await getMeAsUser();
  if (user == null) {
    return;
  }
  if (!await handleCameraAndMic(Permission.microphone)) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppSnackbar.instance.error(context, 'Need microphone permission');
      return;
    }
  }
  showLoading(ref);
  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'name': contact.name,
      'image': contact.profileImage,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing
    };
    hideLoading(ref);
    if (contact.fcmToken?.isNotEmpty == true) {
      FCMApiService.instance.sendCallPush(
          contact.fcmToken ?? '',
          user.fcmToken,
          'START_CALL',
          callBody,
          callBody.callId,
          user.id.toString(),
          user.name,
          user.image,
          false);
    }

    Navigator.pushNamed(context, RouteList.bChatAudioCall, arguments: map);
  } else {
    hideLoading(ref);
  }
  // ref.read(fcm)
  // FCMApiService.instance
  //     .sendChatPush(chat, toToken, fromUserId, senderName, type);
}

Future makeVideoCall(
    Contacts contact, WidgetRef ref, BuildContext context) async {
  final user = await getMeAsUser();
  if (user == null) {
    return;
  }
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
  final response = await ref
      .read(apiBChatProvider)
      .makeCall(user.authToken, contact.userId.toString(), contact.name);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'name': contact.name,
      'image': contact.profileImage,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.outgoing
    };
    if (contact.fcmToken?.isNotEmpty == true) {
      FCMApiService.instance.sendCallPush(
          contact.fcmToken ?? '',
          user.fcmToken,
          'START_CALL',
          callBody,
          callBody.callId,
          user.id.toString(),
          user.name,
          user.image,
          true);
    }
    hideLoading(ref);
    Navigator.pushNamed(context, RouteList.bChatVideoCall, arguments: map);
  } else {
    hideLoading(ref);
  }
  // ref.read(fcm)
  // FCMApiService.instance
  //     .sendChatPush(chat, toToken, fromUserId, senderName, type);
}

Future receiveCall(String authToken, String callId, String image, bool hasVideo,
    BuildContext context) async {
  final response =
      await BChatApiService.instance.receiveCall(authToken, callId);
  if (response.status == 'successfull' && response.body != null) {
    final CallBody callBody = response.body!;
    Map<String, dynamic> map = {
      'name': callBody.callerName,
      'image': image,
      'call_info': callBody,
      'call_direction_type': CallDirectionType.incoming
    };

    Navigator.pushNamed(
        context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
        arguments: map);
  }
}

Future receiveCallWithBody(String authToken, CallBody callBody, String image,
    bool hasVideo, BuildContext context) async {
  // final response =
  //     await BChatApiService.instance.receiveCall(authToken, callId);

}

// Future receiveAudioCall(
//     String callId, String image, WidgetRef ref, BuildContext context) async {
//   if (!await handleCameraAndMic(Permission.microphone)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need microphone permission');
//       return;
//     }
//   }

//   final user = await getMeAsUser();
//   if (user == null) {
//     return;
//   }
//   final response =
//       await ref.read(apiBChatProvider).receiveCall(user.authToken, callId);
//   if (response.status == 'successfull' && response.body != null) {
//     final CallBody callBody = response.body!;
//     Map<String, dynamic> map = {
//       'name': callBody.callerName,
//       'image': '',
//       // 'caller': user,
//       'call_info': callBody,
//       'call_direction_type': CallDirectionType.incoming
//     };
//     hideLoading(ref);
//     Navigator.pushNamed(context, RouteList.bChatAudioCall, arguments: map);
//   } else {
//     hideLoading(ref);
//   }
// }

// Future receiveVideoCall(
//     String callId, String image, WidgetRef ref, BuildContext context) async {
//   if (!await handleCameraAndMic(Permission.microphone)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need microphone permission');
//       return;
//     }
//   }
//   if (!await handleCameraAndMic(Permission.camera)) {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       AppSnackbar.instance.error(context, 'Need camera permission');
//       return;
//     }
//   }
//   final user = await getMeAsUser();
//   if (user == null) {
//     return;
//   }
//   final response =
//       await ref.read(apiBChatProvider).receiveCall(user.authToken, callId);
//   if (response.status == 'successfull' && response.body != null) {
//     final CallBody callBody = response.body!;
//     Map<String, dynamic> map = {
//       'name': callBody.callerName,
//       'image': image,
//       'call_info': callBody,
//       'call_direction_type': CallDirectionType.incoming
//     };

//     hideLoading(ref);
//     Navigator.pushNamed(context, RouteList.bChatVideoCall, arguments: map);
//   } else {
//     hideLoading(ref);
//   }
// }
