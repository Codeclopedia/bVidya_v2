import 'dart:convert';

import '/core/utils/request_utils.dart';
import '/data/models/call_message_body.dart';
import '/firebase_options.dart';
import 'package:dio/dio.dart';
import '/core/constants.dart';

String get webPushKey => isReleaseBuild
    ? 'AAAAG8bzeow:APA91bEQai_ldUEZoR-i2WWNqPhjycgkH93YSE90pjKBF2LjjT6HrgtRfbTxvMh0wPsTWMquzBRHp29BX8iPykTbeMYThG4r7SVzQwGsRuVd0rOhyJsrB593XsKopDdVEjIdqyEuESxT'
    : 'AAAAgYFiXhQ:APA91bFY7G3nD7GtydIzctAaSO585gguQbbWEq5zIURsjFYRB7BBwl4ZDUU689TWAokrNfUHSAQ47zD_Wi9U26Z4jjoDsfDPF7zKjPQoD3iXJeCG5GQSDjioBNfavCHIHhiyUVZf2jlR'; //Demo
// 'AAAAG8bzeow:APA91bEQai_ldUEZoR-i2WWNqPhjycgkH93YSE90pjKBF2LjjT6HrgtRfbTxvMh0wPsTWMquzBRHp29BX8iPykTbeMYThG4r7SVzQwGsRuVd0rOhyJsrB593XsKopDdVEjIdqyEuESxT'; //Release todo

class FCMApiService {
  static final FCMApiService instance = FCMApiService._private();

  late Dio _dio;
  FCMApiService._private() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://fcm.googleapis.com',
      receiveDataWhenStatusError: true,
    );
    _dio = Dio(options);
    _dio.options.headers["Accept"] = "application/json";
    // _dio.options.connectTimeout = 150000;
    // _dio.options.sendTimeout = 100000;
    // _dio.options.receiveTimeout = 120000;
    _dio.options.connectTimeout = const Duration(seconds: 150);
    _dio.options.sendTimeout = const Duration(seconds: 100);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
  }

  Future sendCallEndPush(
    String toToken,
    String action,
    String fromId,
    String callId,
    String name,
    String image,
    bool hasVideo,
  ) async {
    //p2p_call
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': [toToken],
      'type': NotiConstants.typeCall,
      'content_available': true,
      'notification': {},
      'data': {
        'type': NotiConstants.typeCall,
        'action': action,
        'call_id': callId,
        'from_id': fromId,
        'name': name,
        'image': image,
        'has_video': hasVideo ? 'video' : 'audio'
      },
      'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      // EasyLoading.showToast('FCMResponse=${response.data['success']}',toastPosition: EasyLoadingToastPosition.bottom);
      // return Autogenerated.fromJson(response.data);
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      // EasyLoading.showToast('FCMResponse=${response.statusMessage}',toastPosition: EasyLoadingToastPosition.bottom);
      return null;
    }
  }

  Future sendGroupCallEndPush(
    List<String> toTokens,
    String action,
    int fromId,
    String grpId,
    String callId,
    String name,
    String image,
    bool hasVideo,
  ) async {
    //p2p_call
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': toTokens,
      'type': NotiConstants.typeGroupCall,
      'content_available': true,
      'notification': {},
      'data': {
        'call_id': callId,
        'type': NotiConstants.typeGroupCall,
        'action': action,
        'name': name,
        'image': image,
        'has_video': hasVideo ? 'video' : 'audio',
        'from_id': fromId,
        'grp_id': grpId,
      },
      'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    // print('fcm request.callId: $callId , grpId:$grpId');
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  Future sendGroupMemberUpdatePush(
    List<String> toTokens,
    String action,
    String grpName,
    int fromId,
    String grpId,
    String title,
    String body,
  ) async {
    //p2p_call
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': toTokens,
      'type': NotiConstants.typeGroupMemberUpdate,
      'content_available': true,
      'notification': {'title': title, 'body': body},
      'data': {
        'type': NotiConstants.typeGroupMemberUpdate,
        'action': action,
        'f': fromId,
        'g': grpId,
      },
      // 'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    // print('fcm request.callId: $callId , grpId:$grpId');
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  Future sendCallStartPush(String toToken, String fromId, String callId,
      String msgId, CallMessegeBody body) async {
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    // print('token:=> $toToken');
    final data = {
      'registration_ids': [toToken],
      'content_available': true,
      'type': NotiConstants.typeCall,
      'notification': {},
      'data': {
        'call_id': callId,
        'type': NotiConstants.typeCall,
        'action': NotiConstants.actionCallStart,
        'f': fromId,
        'e': jsonEncode(body),
        'm': msgId
      },
      'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    // print('fcm request.callId: $callId ');
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  Future sendGroupCallStartPush(List<String> toTokens, int fromId, String grpId,
      String callId, GroupCallMessegeBody body) async {
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': toTokens,
      'type': NotiConstants.typeGroupCall,
      'content_available': true,
      'notification': {},
      'data': {
        'call_id': callId,
        'type': NotiConstants.typeGroupCall,
        'action': NotiConstants.actionCallStart,
        'f': fromId,
        'g': grpId,
        'e': jsonEncode(body)
      },
      'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  Future pushContactAlert(String toToken, String fromId, String toId,
      String title, String message, ContactAction action) async {
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': [toToken],
      'type': NotiConstants.typeContact,
      'content_available': true,
      'notification': {
        'title': title,
        'body': message,
      },
      'data': {
        'type': NotiConstants.typeContact,
        'action': action.name,
        'f': fromId,
        't': toId,
        'tm': DateTime.now().millisecondsSinceEpoch
      },
      // 'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  Future pushContactDeleteAlert(
    String toToken,
    String fromId,
    String toId,
  ) async {
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';

    final data = {
      'registration_ids': [toToken],
      'type': NotiConstants.typeContact,
      'content_available': true,
      'notification': {},
      'data': {
        'type': NotiConstants.typeContact,
        'action': ContactAction.deleteContact.name,
        'f': fromId,
        't': toId,
        'tm': DateTime.now().millisecondsSinceEpoch
      },
      // 'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      print('fcm response.data:${response.data}');
      return null;
    } else {
      print(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }
  }

  // Future pushGroupMemberAlert(String toToken, String fromId, String groupId,
  //     String title, String message, GroupMemberUpdateAction action) async {
  //   _dio.options.headers['Authorization'] = 'key=  $webPushKey';

  //   final data = {
  //     'registration_ids': [toToken],
  //     'type': NotiConstants.typeGroupMemberUpdate,
  //     'content_available': true,
  //     'notification': {
  //       'title': title,
  //       'body': message,
  //     },
  //     'data': {
  //       'type': NotiConstants.typeGroupMemberUpdate,
  //       'action': action.name,
  //       'f': fromId,
  //       'g': groupId,
  //       'tm': DateTime.now().millisecondsSinceEpoch
  //     },
  //     // 'ttl': '30s',
  //     'android': {'priority': 'normal'},
  //     'priority': 10
  //   };
  //   var response =
  //       await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
  //   if (response.statusCode == 200) {
  //     print('fcm response.data:${response.data}');
  //     return null;
  //   } else {
  //     print(
  //         'error code: ${response.statusCode} response.data:${response.data}');
  //     return null;
  //   }
  // }
}

enum GroupMemberUpdateAction {
  addedMember,
  leftMember,
  removeMember,
  deleteContact;
}
