import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '/core/constants/api_list.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BMeetApiService {
  static BMeetApiService instance = BMeetApiService._();

  late Dio _dio;

  BMeetApiService._() {
    _dio = DioServices.instance.dio;
  }

  Future<ScheduleResponse> createInstantMeeting(String authToken) async {
    try {
      final data = {
        'name': 'INSTANT MEET',
        'description': 'INSTANT MEETING',
        'date': '1970-01-01',
        'start_time': '00:00',
        'end_time': '00:00',
        'repeatable': '0',
        'disable_video': '0',
        'disable_audio': '0',
      };
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.post(baseUrlApi + ApiList.createMeet, data: data);
      if (response.statusCode == 200) {
        return ScheduleResponse.fromJson(response.data);
      } else {
        return ScheduleResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ScheduleResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<BaseResponse> deleteMeeting(String authToken, String id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response = await _dio.get(baseUrlApi + ApiList.deleteMeet + id);
      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<ScheduleResponse> createMeeting(String authToken,
      {required String title,
      required String subject,
      required DateTime date,
      required DateTime startAt,
      required DateTime endAt,
      required bool noAudio,
      required bool noVideo}) async {
    try {
      final data = {
        'name': title,
        'description': subject,
        'date': DateFormat('y-MM-dd').format(date),
        'start_time': DateFormat.Hm().format(startAt),
        'end_time': DateFormat.Hm().format(endAt),
        'repeatable': '0',
        'disable_video': noVideo ? '0' : '1',
        'disable_audio': noAudio ? '0' : '1',
      };
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.post(baseUrlApi + ApiList.createMeet, data: data);
      if (response.statusCode == 200) {
        return ScheduleResponse.fromJson(response.data);
      } else {
        return ScheduleResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ScheduleResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  //

  Future<StartMeetingResponse> startHostMeet(String authToken, int id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response =
          await _dio.get(baseUrlApi + ApiList.startMeet + id.toString());

      if (response.statusCode == 200) {
        // print('Loading meeting list ${jsonEncode(response.data)}');
        return StartMeetingResponse.fromJson(response.data);
      } else {
        return StartMeetingResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return StartMeetingResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<JoinMeetingResponse> joinMeet(String authToken, String id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response = await _dio.get(baseUrlApi + ApiList.joinMeet + id);

      if (response.statusCode == 200) {
        // print('Join meeting ${jsonEncode(response.data)}');
        return JoinMeetingResponse.fromJson(response.data);
      } else {
        return JoinMeetingResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return JoinMeetingResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<BaseResponse> updateMeet(String authToken, Map arg) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final data = {
        'id': arg['id'],
        'name': arg['name'],
        'description': arg['description'],
        'date': arg['date'],
        'start_time': arg['start_time'],
        'end_time': arg['end_time'],
        'repeatable': arg['repeatable'],
        'disable_video': arg['disable_video'],
        'disable_audio': arg['disable_audio']
      };

      final response = await _dio
          .post(baseUrlApi + ApiList.updateMeet + arg['id'], data: data);

      if (response.statusCode == 200) {
        // print('Join meeting ${jsonEncode(response.data)}');
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<BaseResponse> leaveMeet(String authToken, int meetingId) async {
    try {
      // print('Leaving Meet $authToken ---- $meetingId');
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response =
          await _dio.get(baseUrlApi + ApiList.leaveMeet + meetingId.toString());

      if (response.statusCode == 200) {
        // print('Leave Meet ${jsonEncode(response.data)}');
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: 'Unknown error occurred');
    }
  }

  //
  Future<StartMeetingResponse> startScheduledClass(
      String authToken, int id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response = await _dio
          .get(baseUrlApi + ApiList.startPersonalClass + id.toString());

      if (response.statusCode == 200) {
        // print('Loading meeting list ${jsonEncode(response.data)}');
        return StartMeetingResponse.fromJson(response.data);
      } else {
        return StartMeetingResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return StartMeetingResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<JoinMeetingResponse> joinScheduledClass(
      String authToken, String id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      print("class meeting id $id");
      print(baseUrlApi + ApiList.joinPersonalClass + id);
      final response =
          await _dio.get(baseUrlApi + ApiList.joinPersonalClass + id);

      if (response.statusCode == 200) {
        // print('Join meeting ${jsonEncode(response.data)}');
        return JoinMeetingResponse.fromJson(response.data);
      } else {
        return JoinMeetingResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      print(e);
      return JoinMeetingResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<RTMUserTokenResponse?> fetchUserToken(
      String authToken, int id, String name) async {
    try {
      final data = {'id': id.toString(), 'name': name};
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.post(baseUrlApi + ApiList.fetchRtmMeet, data: data);
      if (response.statusCode == 200) {
        return RTMUserTokenResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }

    //
    // Future<RTMUserNameFetchModal> rtmFetchUserName(
    //     String token, String iD, String name) async {
    //   _dio.options.headers['X-Auth-Token'] = '${token}';
    //   dynamic data = {'id': iD, 'name': name};
    //   var response = await _dio
    //       .post(StringConstant.BASE_URL + 'meeting-rtm-token', data: data);
    //   if (response.statusCode == 200) {
    //     return RTMUserNameFetchModal.fromJson(response.data);
    //   } else {
    //     Helper.showMessage(response.statusMessage);
    //     return null;
    //   }
    // }
  }

  Future<MeetingListResponse> fetchMeetingList(String authToken) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response = await _dio.get(baseUrlApi + ApiList.meetingList);

      if (response.statusCode == 200) {
        // print('Loading meeting list ');
        return MeetingListResponse.fromJson(response.data);
      } else {
        return MeetingListResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return MeetingListResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<BaseResponse> requestPersonalClass(
      {required String authToken,
      required String topic,
      required String description,
      required String classType,
      required int instructorid,
      required DateTime datetime,
      required DateTime time}) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;

      final data = {
        'topic': topic,
        'description': description,
        'classtype': classType,
        'instructor_id': instructorid,
        'date': DateFormat('y-MM-dd').format(datetime),
        'time': DateFormat.Hms().format(time),
      };

      final response =
          await _dio.post(baseUrlApi + ApiList.requestClass, data: data);

      if (response.statusCode == 200) {
        // print('request class ${jsonEncode(response.data)}');
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: 'Unknown error occurred');
    }
  }

  Future<ClassRequestResponse> getClassRequestList(String authToken) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      final response =
          await _dio.get(baseUrlApi + ApiList.personalClassRequests);

      if (response.statusCode == 200) {
        return ClassRequestResponse.fromJson(response.data);
      } else {
        return ClassRequestResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print(e);
      return ClassRequestResponse(
        status: 'error',
      );
    }
  }
}
