
import '../models/models.dart';
import '../services/blearn_api_service.dart';

// const successfull = 'successfull';

class BLearnRepository {
  static const successfull = 'successfull';
  final BLearnApiService _api;
  final String _authToken;

  BLearnRepository(this._api, this._authToken);

  Future<HomeBody?> getHome() async {
    final result = await _api.getHomeList(_authToken);
    // print('result: ${result.status} ${result.body?.toJson()}');
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

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

  Future<Courses?> getCourses(String catId) async {
    final result = await _api.getCourses(_authToken, catId.toString());
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<Lessons?> getLessons(String catId) async {
    final result = await _api.getLessons(_authToken, catId.toString());
    if (result.status == successfull && result.body != null) {
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

  Future<ProfileBody?> getInstructorProfile(String instructorId) async {
    final result = await _api.getInstructorProfile(_authToken, instructorId);
    if (result.status == successfull && result.body != null) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<List<Course>?> getInstructorCourses(String instructorId) async {
    final result = await _api.getCoursesByInstructor(_authToken, instructorId);
    if (result.status == successfull && result.body != null) {
      return result.body!;
    } else {
      return null;
    }
  }
}
