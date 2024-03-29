// import 'dart:convert';
import 'dart:convert';

import '/core/state.dart';
import '/data/models/response/blearn/base_response_watch_time.dart';
import 'package:dio/dio.dart';
import '/core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BLearnApiService {
  static BLearnApiService instance = BLearnApiService._();

  late Dio _dio;

  BLearnApiService._() {
    _dio = DioServices.instance.dio;
  }

  //Get
  Future<BlearnHomeResponse> getHomeList(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final response = await _dio.get(baseUrlApi + ApiList.lmsHome);
      if (response.statusCode == 200) {
        return BlearnHomeResponse.fromJson(response.data);
      } else {
        return BlearnHomeResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print("blearn check $e");
      return BlearnHomeResponse(
        status: 'error',
      );
    }
  }

  // //Get
  // Future<HomeResponse> getHomeList(String token) async {
  //   _dio.options.headers['X-Auth-Token'] = token;
  //   try {
  //     final response = await _dio.get(baseUrlApi + ApiList.lmsHome);
  //     // print('response ${response.data} . ${response.realUri}');
  //     if (response.statusCode == 200) {
  //       return HomeResponse.fromJson(response.data);
  //     } else {
  //       return HomeResponse(
  //         status: 'error',
  //       );
  //     }
  //   } catch (e) {
  //     return HomeResponse(
  //       status: 'error',
  //     );
  //   }
  // }

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

  Future<CoursesResponse> getCourseFromCategories(
      String token, String categoryId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio
          .get(baseUrlApi + ApiList.lmsCourseFromCategory + categoryId);
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

  Future<CoursesResponse> getAllCourses(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get('$baseUrlApi${ApiList.lmsCourses}');
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

  Future<CourseDetailResponse> getCourseDetail(
      String token, int courseId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('requst id ${courseId}');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsCoursesDetail}$courseId');

      if (response.statusCode == 200) {
        return CourseDetailResponse.fromJson(response.data);
      } else {
        return CourseDetailResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print('error $e');
      return CourseDetailResponse(
        status: 'error',
      );
    }
  }

//to add or remove course in wishlist
  Future<BaseResponse> wishlistAddorRemove(String token, int courseId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('requst id ${courseId}');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmswishlist}$courseId');
      if (response.statusCode == 200) {
        // print(response);
        // print(BaseResponse.fromJson(response.data));
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(message: "Something went wrong", status: "error");
      }
    } catch (e) {
      return BaseResponse(message: "Something went wrong", status: "error");
    }
  }

  //list of all wishlist courses
  Future<WishlistResponse> getWishlistCoursesList(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('requst id ${courseId}');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsgetwishlistCourses}');
      if (response.statusCode == 200) {
        // print(response.data);
        // print(BaseResponse.fromJson(response.data));
        return WishlistResponse.fromJson(response.data);
      } else {
        return WishlistResponse(status: "error");
      }
    } catch (e) {
      return WishlistResponse(status: "error");
    }
  }

  Future<LessonsResponse> getLessons(String token, int courseId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('requst id ${courseId}');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsLessons}$courseId');
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

  //Post- set course progress
  Future<BaseResponse> setCourseProgress(
      String token, int courseId, int videoId, int lessonId) async {
    try {
      _dio.options.headers["X-Auth-Token"] = token;
      final requestParam = {
        'course_id': courseId,
        "lesson_id": lessonId,
        "video_id": videoId
      };

      final response = await _dio.post(
          '$baseUrlApi${ApiList.lmsSetCourseProgress}',
          data: requestParam);
      if (response.statusCode == 200) {
        // print(response);
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

//to subscribe course
  Future<BaseResponse> subscribeCourse(String token, int courseId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('requst id ${courseId}');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsSubscribeCourse}$courseId');
      if (response.statusCode == 200) {
        // print(response.statusCode);
        // print(response);
        // print(response.data);
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

  // Future<InstructorProfileResponse> getInstructorProfile(
  //     String authToken, String instructorId) async {
  //   try {
  //     _dio.options.headers["X-Auth-Token"] = authToken;
  //     // print('$authToken - $instructorId');
  //     final response = await _dio
  //         .get('$baseUrlApi${ApiList.lmsInstructorProfile}$instructorId');

  //     if (response.statusCode == 200) {
  //       print('${jsonEncode(response.data)}');
  //       return InstructorProfileResponse.fromJson(response.data);
  //     } else {
  //       return InstructorProfileResponse(
  //           status: 'error',
  //           message: '${response.statusCode}- ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     print('error: $e');
  //     return InstructorProfileResponse(
  //         status: 'error', message: 'Unknown error - $e');
  //   }
  // }
  Future<ProfileDetailResponse> getProfileDetail(
      String authToken, String id) async {
    try {
      _dio.options.headers["X-Auth-Token"] = authToken;
      // print('$authToken - $instructorId');
      final response =
          await _dio.get('$baseUrlApi${ApiList.lmsProfileDetail}$id');

      if (response.statusCode == 200) {
        // print('${jsonEncode(response.data)}');
        return ProfileDetailResponse.fromJson(response.data);
      } else {
        return ProfileDetailResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print('error: $e');
      return ProfileDetailResponse(
        status: 'error',
      );
    }
  }

  Future<InstructorCoursesResponse> getCoursesByInstructor(
      String authToken, String instructorId) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      // print('$authToken $instructorId');
      final response = await _dio
          .get('$baseUrlApi${ApiList.lmsCourseByInstructor}$instructorId');
      // print('${jsonEncode(response.data)}');
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

  Future<FollowInstructorResponse> followInstructor(
      String authToken, String instructorId) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      // print('authtoken instructorId $authToken $instructorId');
      final response = await _dio
          .get('$baseUrlApi${ApiList.lmsFollowInstructor}$instructorId');
      // print('response data ${jsonEncode(response.data)}');
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

  Future<BaseResponseWatchTime> recordVideoPlayback(
      String authToken, int userId, int videoId) async {
    try {
      _dio.options.headers['X-Auth-Token'] = authToken;

      final data = {
        'user_id': userId,
        'video_id': videoId,
      };
      final response = await _dio
          .post('$baseUrlApi${ApiList.lmsRecordVideoPlayback}', data: data);
      print("hitted one minute counter $response");
      if (response.statusCode == 200) {
        return BaseResponseWatchTime.fromJson(response.data);
      } else {
        return BaseResponseWatchTime.fromJson(response.data);
      }
    } catch (e) {
      print("hitted one minute counter error $e");
      return BaseResponseWatchTime(
        message: 'error',
        status: 'error',
      );
    }
  }

  Future<BaseResponse> courseFeedback(
      String token, String courseId, int rating, String comment) async {
    final data = {'course_id': courseId, 'rating': rating, 'comment': comment};
    try {
      _dio.options.headers["X-Auth-Token"] = token;

      final response =
          await _dio.post('${baseUrlApi}feedback-course', data: data);
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

  Future<LikedCourseResponse> likeCourse(String token, String id) async {
    try {
      _dio.options.headers['X-Auth-Token'] = token;
      final response =
          await _dio.get('${StringConstant.BASE_URL}likecourse/$id');
      if (response.statusCode == 200) {
        return LikedCourseResponse.fromJson(response.data);
      } else {
        return LikedCourseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
        // print(response.statusMessage);
        // return null;
      }
    } catch (e) {
      print('error : $e');
      return LikedCourseResponse(status: 'error', message: 'Unknown error -$e');
    }
  }
}
