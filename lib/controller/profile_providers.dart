import 'package:collection/collection.dart';

import '../core/state.dart';
import '/data/models/models.dart';
import '/data/repository/profile_repository.dart';
import '/data/services/profile_api_service.dart';

final apiProfileProvider = Provider<ProfileApiService>(
  (_) => ProfileApiService.instance,
);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return ProfileRepository(ref.read(apiProfileProvider), token);
});

final profileUserProvider = FutureProvider.autoDispose<Profile?>((ref) {
  return ref.read(profileRepositoryProvider).getUserProfile();
});

final follwedInstructorsProvider =
    FutureProvider.autoDispose<List<FollowedInstructor>?>((ref) {
  return ref.read(profileRepositoryProvider).followedInstructor();
});

// final isFollowedInstructor =
//     FutureProvider.autoDispose.family<bool, String>((ref, id) async {
//   final list = await ref.read(profileRepositoryProvider).followedInstructor();
//   return list?.firstWhereOrNull((e) => e.instructorId?.toString() == id) !=
//       null;
// });

final isFollowedInstructor =
    FutureProvider.autoDispose.family<bool, String>((ref, id) async {
  final list = await ref.read(profileRepositoryProvider).followedInstructor();
  return list?.firstWhereOrNull((e) => e.instructorId?.toString() == id) !=
      null;
});
