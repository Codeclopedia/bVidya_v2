import '../models/models.dart';
// import '../models/response/profile/subscribed_Courses_Response.dart';
import '../services/profile_api_service.dart';

class ProfileRepository {
  static const successfull = 'successfull';
  final ProfileApiService _api;
  final String _authToken;

  ProfileRepository(this._api, this._authToken);

  Future<String?> reportProblem(String module, String message) async {
    final result = await _api.reportProblem(_authToken, module, message);
    if (result.status == successfull) {
      return null;
    } else {
      return result.message ?? 'Unknown error';
    }
  }

  Future<Profile?> getUserProfile() async {
    final result = await _api.getUserProfile(_authToken);
    if (result.status == successfull) {
      return result.body;
    } else {
      return null;
    }
  }

  Future<SubscribedCourseBody?> getSubscribeCourses() async {
    final result = await _api.getSubscribedCourses(_authToken);
    print("result inside repo :${result.body?.toJson()}");
    if (result.status == "success") {
      return result.body;
    } else {
      return null;
    }
  }

  Future<List<FollowedInstructor>?> followedInstructor() async {
    final result = await _api.followedInstructor(_authToken);

    if (result.status == 'successfully' && result.body != null) {
      return result.body!;
    } else {
      print('Error ${result.message ?? 'Error'} ');
      return null;
    }
  }
}
