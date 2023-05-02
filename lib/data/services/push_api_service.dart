import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/utils/request_utils.dart';
import '../models/call_message_body.dart';
import '../network/dio_services.dart';
import '/core/constants.dart';

class PushApiService {
  static PushApiService instance = PushApiService._();

  late Dio _dio;

  PushApiService._() {
    _dio = DioServices.instance.dio;
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
    _dio.options.headers['X-Auth-Token'] = authToken;
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
      return _sendToIOS(token, data);
    }
    return _sendToAndroid(token, data);
  }

  Future sendCallStartPush(String authToken, bool isIos, String token,
      String fromId, String callId, String msgId, CallMessegeBody body) async {
    _dio.options.headers['X-Auth-Token'] = authToken;

    final data = {
      'call_id': callId,
      'type': NotiConstants.typeCall,
      'action': NotiConstants.actionCallStart,
      'f': fromId,
      'e': jsonEncode(body),
      'm': msgId
    };
    if (isIos) {
      return _sendToIOS(token, data);
    }
    return _sendToAndroid(token, data);
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
    _dio.options.headers['X-Auth-Token'] = authToken;
    final data = {
      'type': NotiConstants.typeContact,
      'action': action.name,
      'f': fromId,
      't': toId,
      'tm': DateTime.now().millisecondsSinceEpoch
    };

    if (isIos) {
      return _sendToIOSNotification(token, title, message, data);
    }
    return _sendToAndroidNotification(token, title, message, data);
  }

  Future pushContactDeleteAlert(
    String authToken,
    bool isIos,
    String token,
    String fromId,
    String toId,
  ) async {
    _dio.options.headers['X-Auth-Token'] = authToken;
    final data = {
      'type': NotiConstants.typeContact,
      'action': ContactAction.deleteContact.name,
      'f': fromId,
      't': toId,
      'tm': DateTime.now().millisecondsSinceEpoch
    };
    if (isIos) {
      return _sendToIOS(token, data);
    }
    return _sendToAndroid(token, data);
  }

  Future sendGroupCallStartPush(
      String authToken,
      List<String> toTokens,
      int fromId,
      String grpId,
      String callId,
      GroupCallMessegeBody body) async {
    _dio.options.headers['X-Auth-Token'] = authToken;

    final data = {
      'call_id': callId,
      'type': NotiConstants.typeGroupCall,
      'action': NotiConstants.actionCallStart,
      'f': fromId,
      'g': grpId,
      'e': jsonEncode(body)
    };
  }

  Future sendGroupCallEndPush(
    String authToken,
    List<String> toTokens,
    String action,
    int fromId,
    String grpId,
    String callId,
    String name,
    String image,
    bool hasVideo,
  ) async {
    _dio.options.headers['X-Auth-Token'] = authToken;

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

    // return _sendToAndroid(token, data);
  }

  Future<String?> _sendToAndroidNotification(String token, String title,
      String body, Map<String, dynamic> payload) async {
    final data = {
      'device_os': 'android',
      'token': token,
      'payload': {
        'notification': {
          'title': title,
          'body': body,
        },
        'data': payload,
      },
    };
    var response =
        await _dio.post('${baseUrlApi}notification-server/send', data: data);
    if (response.statusCode == 200) {
      return null;
    }
    return "Error ${response.statusCode}";
  }

  Future<String?> _sendToAndroid(
      String token, Map<String, dynamic> payload) async {
    final data = {
      'device_os': 'android',
      'token': token,
      'payload': {
        'notification': {},
        'data': payload,
      },
    };
    var response =
        await _dio.post('${baseUrlApi}notification-server/send', data: data);
    if (response.statusCode == 200) {
      return null;
    }
    return "Error ${response.statusCode}";
  }

  Future<String?> _sendToIOS(String token, Map<String, dynamic> payload) async {
    final data = {
      'device_os': 'ios',
      'token': token,
      'payload': {
        "aps": {
          "content-available": 1,
        },
        "data": payload,
      },
    };
    var response =
        await _dio.post('${baseUrlApi}notification-server/send', data: data);
    if (response.statusCode == 200) {
      return null;
    }
    return "Error ${response.statusCode}";
  }

  Future<String?> _sendToIOSNotification(String token, String title,
      String body, Map<String, dynamic> payload) async {
    final data = {
      'device_os': 'ios',
      'token': token,
      'payload': {
        "aps": {
          'alert': {
            'title': title,
            'body': body,
          },
          'sound': 'default',
          'badge': 1,
          "content-available": 1,
        },
        //  "{"aps":{"alert":{"title":"Bvidya Notification","body":"Hi Chetan! Welcome To Bvidya. Your application for Sunday working is accepted and soon all Saturdays will be ON and for now its going to 9 to 6."},"sound":"default","badge":1}}",
        "data": payload,
      },
    };
    var response =
        await _dio.post('${baseUrlApi}notification-server/send', data: data);
    if (response.statusCode == 200) {
      return null;
    }
    return "Error ${response.statusCode}";
  }
}
