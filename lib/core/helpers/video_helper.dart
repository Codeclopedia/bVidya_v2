import '/data/models/response/blearn/base_response_watch_time.dart';

import '/controller/blearn_providers.dart';
import '/core/state.dart';
import '/core/utils.dart';
import '/data/services/blearn_api_service.dart';

Future<BaseResponseWatchTime> sendVideoPlayback(
    WidgetRef ref, int instructorId) async {
  final user = await getMeAsUser();
  final videoId = ref.read(currentVideoIDProvider);
  // if (user == null) {
  //   return;
  // }
  print("hitted one minute counter");
  final response = await BLearnApiService.instance
      .recordVideoPlayback(user?.authToken ?? '', instructorId, videoId);
  return response;
}
