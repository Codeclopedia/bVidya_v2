import '../core/state.dart';
import '../data/repository/profile_repository.dart';
import '../data/services/profile_api_service.dart';

final apiProfileProvider = Provider<ProfileApiService>(
  (_) => ProfileApiService.instance,
);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return ProfileRepository(ref.read(apiProfileProvider), token);
});
