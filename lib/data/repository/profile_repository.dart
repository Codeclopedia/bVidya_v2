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
}
