import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/data/models/response/base_response.dart';
import '/core/utils/request_utils.dart';
import '/core/constants.dart';
// import 'fcm_api_service.dart';
import '/firebase_options.dart';

import '../models/call_message_body.dart';
import '../network/dio_services.dart';

String get webPushKey => isReleaseBuild
    ? 'AAAAG8bzeow:APA91bEQai_ldUEZoR-i2WWNqPhjycgkH93YSE90pjKBF2LjjT6HrgtRfbTxvMh0wPsTWMquzBRHp29BX8iPykTbeMYThG4r7SVzQwGsRuVd0rOhyJsrB593XsKopDdVEjIdqyEuESxT'
    : 'AAAAgYFiXhQ:APA91bFY7G3nD7GtydIzctAaSO585gguQbbWEq5zIURsjFYRB7BBwl4ZDUU689TWAokrNfUHSAQ47zD_Wi9U26Z4jjoDsfDPF7zKjPQoD3iXJeCG5GQSDjioBNfavCHIHhiyUVZf2jlR'; //Demo

class PushApiService {
  static PushApiService instance = PushApiService._();

  late Dio _apiDio;
  late Dio _dio;

  PushApiService._() {
    _apiDio = DioServices.instance.dio;

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
    _dio.options.headers['Authorization'] = 'key=  $webPushKey';
  }

  Future sendCallEndPush(
    String authToken,
    bool isIos,
    String token,
    String action,
    String fromId,
    String callId,
    String name,
    String image,
    bool hasVideo,
  ) async {
    final data = {
      'type': NotiConstants.typeCall,
      'action': action,
      'call_id': callId,
      'from_id': fromId,
      'name': name,
      'image': image,
      'has_video': hasVideo ? 'video' : 'audio'
    };
    if (isIos) {
      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      return _sendToIOS(authToken, token, data);
    }
    return _sendToAndroid([token], data);
  }

  Future sendCallStartPush(String authToken, bool isIos, String token,
      String fromId, String callId, String msgId, CallMessegeBody body) async {
    final data = {
      'call_id': callId,
      'type': NotiConstants.typeCall,
      'action': NotiConstants.actionCallStart,
      'f': fromId,
      'e': jsonEncode(body),
      'm': msgId
    };
    if (isIos) {
      // print('$authToken');

      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      return _sendToIOS(authToken, token, data);
    }
    return _sendToAndroid([token], data);
  }

  Future pushContactAlert(
      String authToken,
      bool isIos,
      String token,
      String fromId,
      String toId,
      String title,
      String message,
      ContactAction action) async {
    final data = {
      'type': NotiConstants.typeContact,
      'action': action.name,
      'f': fromId,
      't': toId,
      'tm': DateTime.now().millisecondsSinceEpoch
    };

    if (isIos) {
      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      return _sendToIOSNotification(authToken, token, title, message, data);
    }
    return _sendToAndroidNotification([token], title, message, data);
  }

  Future pushContactDeleteAlert(
    String authToken,
    bool isIos,
    String token,
    String fromId,
    String toId,
  ) async {
    final data = {
      'type': NotiConstants.typeContact,
      'action': ContactAction.deleteContact.name,
      'f': fromId,
      't': toId,
      'tm': DateTime.now().millisecondsSinceEpoch
    };
    if (isIos) {
      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      return _sendToIOS(authToken, token, data);
    }
    return _sendToAndroid([token], data);
  }

  Future sendGroupMemberUpdatePush(
    String authToken,
    List<String> fcmTokens,
    List<String> apnTokens,
    String action,
    String grpName,
    int fromId,
    String grpId,
    String title,
    String body,
  ) async {
    final data = {
      'type': NotiConstants.typeGroupMemberUpdate,
      'action': action,
      'f': fromId,
      'g': grpId,
    };

    if (fcmTokens.isNotEmpty) {
      await _sendToAndroid(fcmTokens, data);
    }
    if (apnTokens.isNotEmpty) {
      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      for (var token in apnTokens) {
        await _sendToIOS(authToken, token, data);
      }
    }
  }

  Future sendGroupCallStartPush(
      String authToken,
      List<String> fcmTokens,
      List<String> apnTokens,
      int fromId,
      String grpId,
      String callId,
      GroupCallMessegeBody body) async {
    final data = {
      'call_id': callId,
      'type': NotiConstants.typeGroupCall,
      'action': NotiConstants.actionCallStart,
      'f': fromId,
      'g': grpId,
      'e': jsonEncode(body)
    };

    if (fcmTokens.isNotEmpty) {
      await _sendToAndroid(fcmTokens, data);
    }
    if (apnTokens.isNotEmpty) {
      // _apiDio.options.headers['X-Auth-Token'] = authToken;
      for (var token in apnTokens) {
        await _sendToIOS(authToken, token, data);
      }
    }
  }

  Future sendGroupCallEndPush(
    String authToken,
    List<String> fcmTokens,
    List<String> apnTokens,
    String action,
    int fromId,
    String grpId,
    String callId,
    String name,
    String image,
    bool hasVideo,
  ) async {
    final data = {
      'call_id': callId,
      'type': NotiConstants.typeGroupCall,
      'action': action,
      'name': name,
      'image': image,
      'has_video': hasVideo ? 'video' : 'audio',
      'from_id': fromId,
      'grp_id': grpId,
    };

    if (fcmTokens.isNotEmpty) {
      await _sendToAndroid(fcmTokens, data);
    }
    if (apnTokens.isNotEmpty) {
      for (var token in apnTokens) {
        await _sendToIOS(authToken, token, data);
      }
    }

    // return _sendToAndroid(token, data);
  }

  Future<String?> _sendToAndroidNotification(List<String> fcmTokens,
      String title, String body, Map<String, dynamic> payload) async {
    final data = {
      'registration_ids': fcmTokens,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': payload,
      // 'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      debugPrint('fcm response.data:${response.data}');
      return null;
    } else {
      debugPrint(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }

    // final data = {
    //   'device_os': 'android',
    //   'token': token,
    //   'payload': {
    //     'notification': {
    //       'title': title,
    //       'body': body,
    //     },
    //     'data': payload,
    //   },
    // };
    // var response =
    //     await _apiDio.post('${baseUrlApi}notification-server/send', data: data);
    // if (response.statusCode == 200) {
    //   return null;
    // }
    // return "Error ${response.statusCode}";
  }

  Future<String?> _sendToAndroid(
      List<String> fcmTokens, Map<String, dynamic> payload) async {
    final data = {
      'registration_ids': fcmTokens,
      'notification': {},
      'data': payload,
      // 'ttl': '30s',
      'android': {'priority': 'normal'},
      'priority': 10
    };
    var response =
        await _dio.post('https://fcm.googleapis.com/fcm/send', data: data);
    if (response.statusCode == 200) {
      debugPrint('fcm response.data:${response.data}');
      return null;
    } else {
      debugPrint(
          'error code: ${response.statusCode} response.data:${response.data}');
      return null;
    }

    // final payload = {
    //   'device_os': 'android',
    //   'token': token,
    //   'payload': {
    //     'notification': {},
    //     'data': payload,
    //   },
    // };
    // var response =
    //     await _apiDio.post('${baseUrlApi}notification-server/send', data: data);
    // if (response.statusCode == 200) {
    //   return null;
    // }
    // return "Error ${response.statusCode}";
  }

  Future<BaseResponse> _sendToIOS(
      String authToken, String apnToken, Map<String, dynamic> payload) async {
    final payloadx = {
      "aps": {
        "content-available": 1,
        // "alert": "",
        // 'sound': '',
        // 'badge': 1,
      },
      "data": payload,
      "no_alert": 1
    };
    final data = {
      'device_os': 'ios',
      'token': apnToken,
      'payload': jsonEncode(payloadx),
      'sandbox': isReleaseBuild ? 0 : 1,
      'background': 1,
    };
    _apiDio.options.headers['X-Auth-Token'] = authToken;
    // print(authToken);
    return _send(data);
  }

  Future<BaseResponse> _sendToIOSNotification(String authToken, String apnToken,
      String title, String body, Map<String, dynamic> payload) async {
    final payloadx = {
      "aps": {
        'alert': {
          'title': title,
          'body': body,
        },
        'sound': 'default',
        'badge': 1,
        "content-available": 1,
      },
      "data": payload,
    };
    final data = {
      'device_os': 'ios',
      'token': apnToken,
      'sandbox': isReleaseBuild ? 0 : 1,
      'background': 0,
      'payload': jsonEncode(payloadx),
    };
    _apiDio.options.headers['X-Auth-Token'] = authToken;
    return _send(data);
  }

  Future<BaseResponse> _send(Map<String, dynamic> data) async {
    try {
      debugPrint("Req => ${data}");
      var response = await _apiDio.post(
          'https://app.bvidya.com/api/notification-server/send',
          data: data);
      debugPrint("Success => ${response.data}");
      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data);
      }
      return BaseResponse(
          status: 'error',
          message: '${response.statusCode}- ${response.statusMessage}');

      // "Error ${response.statusCode}  ${response.statusMessage}";
    } on DioError catch (error) {
      debugPrint('Error loading ${error.response}');
      // return "Error : $error";
    } catch (e) {
      debugPrint("errorx $e");
      // return "Error : $e";
    }
    return BaseResponse(status: 'error', message: 'Unknown error');
  }
}

// enum GroupMemberUpdateAction {
//   addedMember,
//   leftMember,
//   removeMember,
//   deleteContact;
// }
