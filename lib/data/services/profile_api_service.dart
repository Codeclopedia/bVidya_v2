import 'dart:convert';


import 'package:dio/dio.dart';

import '/core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class ProfileApiService {
  static ProfileApiService instance = ProfileApiService._();

  late Dio _dio;
  ProfileApiService._() {
    _dio = DioServices.instance.dio;
  }

  //Get
  Future<BaseResponse> reportProblem(
      String token, String module, String message) async {
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final data = {
        'module': module,
        'message': message,
      };

      final response =
          await _dio.post(baseUrlApi + ApiList.reportProblem, data: data);
      // print('response ${response.data} . ${response.realUri}');
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

  Future<UserProfileResponse> getUserProfile(String token) async {
    print(token);
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final response = await _dio.get(baseUrlApi + ApiList.userProfile);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
      } else {
        return UserProfileResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return UserProfileResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<SubscribedCoursesResponse> getSubscribedCourses(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response = await _dio.get(baseUrlApi + ApiList.subscribedList);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return SubscribedCoursesResponse.fromJson(response.data);
      } else {
        return SubscribedCoursesResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return SubscribedCoursesResponse(status: 'error');
    }
  }

  Future<FollowInstructorResponse> followedInstructor(String authToken) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.instructorFollowed}');
      print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return FollowInstructorResponse.fromJson(response.data);
      } else {
        return FollowInstructorResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return FollowInstructorResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }
}
