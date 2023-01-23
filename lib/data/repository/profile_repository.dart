import 'dart:io';

import '../models/models.dart';

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

  Future updateProfile(String name, String email, String phone, String address,
      String age) async {
    final result = await _api.updateUserProfile(
        token: _authToken,
        name: name,
        email: email,
        phone: phone.toString(),
        address: address,
        age: age.toString(),
        bio: "",
        city: "",
        state: "",
        country: "");
    if (result.status != null && result.status == successfull) {
      
      return null;
    }

    return result;
  }

//updateimage
  Future<String?> updateProfileImage(File file) async {
    final result = await _api.updateProfilePic(_authToken, file);
    if (result.status != null && result.status == successfull) {
      return null;
    }
    return result.message ?? 'Error in updating image';
  }
}
