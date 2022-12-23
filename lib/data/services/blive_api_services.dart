import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '/core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BLiveApiService {
  static BLiveApiService instance = BLiveApiService._();

  late Dio _dio;

  BLiveApiService._() {
    _dio = DioServices.instance.dio;
  }

  Future<ScheduleClassResponse> createClass(String authToken,
      {required String title,
      required String desc,
      required DateTime date,
      required DateTime time,
      required File image}) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        'name': title,
        'description': desc,
        'date': DateFormat.yMMMd(date),
        'time': DateFormat.Hm(time),
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.post(baseUrlApi + ApiList.createLiveClass, data: formData);
      if (response.statusCode == 200) {
        return ScheduleClassResponse.fromJson(response.data);
      } else {
        return ScheduleClassResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ScheduleClassResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<LiveClassResponse> getLiveClass(
      String authToken, String broadcastStreamId) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.get(baseUrlApi + ApiList.liveClass + broadcastStreamId);
      print('result: ${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return LiveClassResponse.fromJson(response.data);
      } else {
        return LiveClassResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LiveClassResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<BaseResponse> deleteLiveClass(String authToken, String id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response = await _dio.get(baseUrlApi + ApiList.deleteLiveClass + id);
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

  Future<LMSLiveClassesResponse> getLiveClasses(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get('$baseUrlApi${ApiList.lmsLiveClasses}');

      if (response.statusCode == 200) {
        return LMSLiveClassesResponse.fromJson(response.data);
      } else {
        return LMSLiveClassesResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LMSLiveClassesResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<LiveRTMResponse> fetchLiveRTMToken(String authToken, int id) async {
    try {
      print('$authToken');
      _dio.options.headers['X-Auth-Token'] = authToken;
      var response =
          await _dio.get(baseUrlApi + ApiList.fetchLiveRtm + id.toString());
      if (response.statusCode == 200) {
        print('${jsonEncode(response.data)}');
        return LiveRTMResponse.fromJson(response.data);
      } else {
        return LiveRTMResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LiveRTMResponse(status: 'error', message: 'Unknown error -$e');
    }
  }
}
