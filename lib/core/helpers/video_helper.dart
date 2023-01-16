import 'package:bvidya/core/state.dart';
import 'package:bvidya/ui/screens.dart';

import '/core/utils.dart';
import '/data/services/blearn_api_service.dart';

sendVideoPlayback(WidgetRef ref, int instructorId) async {
  final user = await getMeAsUser();
  final videoId = ref.read(currentVideoIdProvider);
  if (user == null) {
    return;
  }
  await BLearnApiService.instance.recordVideoPlayback(
      user.authToken, instructorId.toString(), videoId.toString());
}
