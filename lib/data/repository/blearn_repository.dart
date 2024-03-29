import '../models/models.dart';
import '../services/blearn_api_service.dart';

class BLearnRepository {
  static const successfull = 'successfull';
  final BLearnApiService _api;
  final String _authToken;

  BLearnRepository(this._api, this._authToken);

  Future<BlearnHomeBody?> getHome() async {
    final result = await _api.getHomeList(_authToken);

    // print('result: ${result.status} ${result.body?.toJson()}');
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  // Future<HomeBody?> getHome() async {
  //   final result = await _api.getHomeList(_authToken);
  //   // print('result: ${result.status} ${result.body?.toJson()}');
  //   if (result.status == successfull && result.body != null) {
  //     return result.body;
  //   } else {
  //     return null;
  //   }
  // }

  Future<Categories?> getCategories() async {
    final result = await _api.getCategories(_authToken);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<SubCategories?> getSubCategories(String catId) async {
    final result = await _api.getSubCategories(_authToken, catId);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<Courses?> getCoursesFromCategories(String catId) async {
    final result = await _api.getCourseFromCategories(_authToken, catId);
    if (result.status == "success" && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<BaseResponse> setCourseProgress(
      int courseId, int videoId, int lessonId) async {
    final result =
        await _api.setCourseProgress(_authToken, courseId, videoId, lessonId);
    if (result.status == successfull && result.body != null) {
      return result;
    } else {
      return BaseResponse();
    }
  }

  Future<Courses?> getCourses(String catId) async {
    final result = await _api.getCourses(_authToken, catId.toString());
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

//post method to filter search
  Future<SearchResults?> getSearchedCourses(String searchTerm) async {
    final result = await _api.loadSearch(_authToken, searchTerm);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<Courses?> getAllCourses() async {
    final result = await _api.getAllCourses(_authToken);
    if (result.status == "successfully" && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<Lessons?> getLessons(int courseId) async {
    final result = await _api.getLessons(_authToken, courseId);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<BaseResponse?> subscribeCourse(int courseId) async {
    final result = await _api.subscribeCourse(_authToken, courseId);
    if (result.status == "success" && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<BaseResponse?> changeinWishlist(int courseId) async {
    final result = await _api.wishlistAddorRemove(_authToken, courseId);
    if (result.status == "success" && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<WishlistCoursesBody?> getWishlistCourses() async {
    final result = await _api.getWishlistCoursesList(_authToken);
    if (result.status == "success" && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<Instructors?> getInstructors() async {
    final result = await _api.getIntructors(_authToken);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<LMSLiveClasses?> getLiveClasses() async {
    final result = await _api.getLiveClasses(_authToken);
    if (result.status == successfull && result.body != null) {
      // print('result: ${result.status} ${result.body?.toJson()}');
      return result.body;
    } else {
      return null;
    }
  }

  Future<ProfileDetailBody?> getProfileDetail(String id) async {
    final result = await _api.getProfileDetail(_authToken, id);
    if (result.status == successfull && result.body != null) {
      return result.body!;
    } else {
      return null;
    }

    //
  }

  Future<CourseDetailBody?> getCourseDetail(int courseId) async {
    final result = await _api.getCourseDetail(_authToken, courseId);
    // print("result in course detail is ${result.body?.courses}");
    // print(result.body?.toJson());
    if (result.status == 'success' && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  // Future<ProfileBody?> getInstructorProfile(String instructorId) async {
  //   final result = await _api.getInstructorProfile(_authToken, instructorId);
  //   if (result.status == successfull && result.body != null) {
  //     return result.body!;
  //   } else {
  //     return null;
  //   }
  // }

  Future<List<InstructorCourse>?> getInstructorCourses(
      String instructorId) async {
    final result = await _api.getCoursesByInstructor(_authToken, instructorId);
    // print('message ${result.message}  ${result.body}');
    if (result.status == successfull && result.body != null) {
      return result.body!;
    } else {
      print('Error ${result.message ?? 'Error'} ');
      return null;
    }
  }

  Future<List<FollowedInstructor>?> followInstructor(
      String instructorId) async {
    final result = await _api.followInstructor(_authToken, instructorId);
    // print('message ${result.message}  ${result.body}');
    if (result.status == successfull && result.body != null) {
      return result.body!;
    } else {
      print('Error ${result.message ?? 'Error'} ');
      return null;
    }
  }

  Future<LikedCourseResponse?> getLikedCourse(int courseId) async {
    final result = await _api.likeCourse(_authToken, courseId.toString());
    if (result.status == successfull && result.body != null) {
      return result;
    } else {
      return null;
    }
  }

  Future<BaseResponse> setfeedback(
      String courseId, int rating, String comment) async {
    final result =
        await _api.courseFeedback(_authToken, courseId, rating, comment);
    if (result.status == "successfully" && result.body != null) {
      return result;
    } else {
      return BaseResponse(status: 'error', message: '${result.status}');
    }
  }
}
