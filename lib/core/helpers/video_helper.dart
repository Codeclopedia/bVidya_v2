import '/controller/blearn_providers.dart';
import '/core/state.dart';
import '/core/utils.dart';
import '/data/services/blearn_api_service.dart';

sendVideoPlayback(WidgetRef ref, int instructorId) async {
  final user = await getMeAsUser();
  final videoId = ref.read(currentVideoIDProvider);
  if (user == null) {
    return;
  }
  // print("hitted one minute counter");
  await BLearnApiService.instance.recordVideoPlayback(
      user.authToken, instructorId.toString(), videoId.toString());
}
