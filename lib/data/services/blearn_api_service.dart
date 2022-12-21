import 'dart:convert';

import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BLearnApiService {
  static BLearnApiService instance = BLearnApiService._();

  late Dio _dio;

  BLearnApiService._() {
    _dio = DioServices.instance.dio;
  }

  //Get
  Future<HomeResponse> getHomeList(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final response = await _dio.get(baseUrlApi + ApiList.lmsHome);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return HomeResponse.fromJson(response.data);
      } else {
        return HomeResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return HomeResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<CategoriesResponse> getCategories(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get(baseUrlApi + ApiList.lmsCategories);
      if (response.statusCode == 200) {
        return CategoriesResponse.fromJson(response.data);
      } else {
        return CategoriesResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return CategoriesResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<SubCategoriesResponse> getSubCategories(
      String token, String catId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsSubCategories}$catId');
      if (response.statusCode == 200) {
        // print('response ${response.data} . ${response.realUri}');
        return SubCategoriesResponse.fromJson(response.data);
      } else {
        return SubCategoriesResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return SubCategoriesResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<CoursesResponse> getCourses(String token, String subCatId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsCourses}/$subCatId');
      if (response.statusCode == 200) {
        return CoursesResponse.fromJson(response.data);
      } else {
        return CoursesResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return CoursesResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<LessonsResponse> getLessons(String token, String subCatId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsLessons}/$subCatId');
      if (response.statusCode == 200) {
        return LessonsResponse.fromJson(response.data);
      } else {
        return LessonsResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LessonsResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<IntructionsResponse> getIntructors(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get('$baseUrlApi${ApiList.lmsInstructors}');
      if (response.statusCode == 200) {
        return IntructionsResponse.fromJson(response.data);
      } else {
        return IntructionsResponse(
            status: 'error',
            message: '${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      return IntructionsResponse(status: 'error', message: 'Unknown error -$e');
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

  Future<LMSSearchResponse> loadSearch(String token, String query) async {
    try {
      _dio.options.headers["X-Auth-Token"] = token;
      final requestParam = {'term': query};

      final response = await _dio.post('$baseUrlApi${ApiList.lmsSearch}',
          data: requestParam);
      if (response.statusCode == 200) {
        return LMSSearchResponse.fromJson(response.data);
      } else {
        return LMSSearchResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LMSSearchResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<InstructorProfileResponse> getInstructorProfile(
      String authToken, String instructorId) async {
    try {
      _dio.options.headers["X-Auth-Token"] = authToken;
      print('$authToken $instructorId');
      final response = await _dio
          .get('$baseUrlApi${ApiList.lmsInstructorProfile}$instructorId');

      if (response.statusCode == 200) {
        print('${jsonEncode(response.data)}');
        return InstructorProfileResponse.fromJson(response.data);
      } else {
        return InstructorProfileResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      print('error: $e');
      return InstructorProfileResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<InstructorCoursesResponse> getCoursesByInstructor(
      String authToken, String instructorId) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      final response = await _dio
          .get('$baseUrlApi${ApiList.lmsCourseByInstructor}$instructorId');
      if (response.statusCode == 200) {
        return InstructorCoursesResponse.fromJson(response.data);
      } else {
        return InstructorCoursesResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return InstructorCoursesResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }
}
