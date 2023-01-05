import '/core/utils.dart';
import '/data/services/blearn_api_service.dart';

sendVideoPlayback(int videoId, int instructorId) async {
  final user = await getMeAsUser();
  if (user == null) {
    return;
  }
  await BLearnApiService.instance.recordVideoPlayback(
      user.authToken, instructorId.toString(), videoId.toString());
}
