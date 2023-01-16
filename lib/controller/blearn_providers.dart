import '../data/models/response/blearn/blearn_home_response.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '/data/repository/blearn_repository.dart';
import '/data/services/blearn_api_service.dart';
import 'profile_providers.dart';

final apiBLearnProvider = Provider<BLearnApiService>(
  (_) => BLearnApiService.instance,
);

final bLearnRepositoryProvider = Provider<BLearnRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return BLearnRepository(ref.read(apiBLearnProvider), token);
});

final bLearnHomeProvider = FutureProvider.autoDispose<BlearnHomeBody?>((ref) {
  return ref.read(bLearnRepositoryProvider).getHome();
});

// final bLearnHomeProvider = FutureProvider.autoDispose<HomeBody?>((ref) {
//   return ref.read(bLearnRepositoryProvider).getHome();
// });

final bLearnCategoriesProvider = FutureProvider<Categories?>((ref) {
  return ref.read(bLearnRepositoryProvider).getCategories();
});

final bLearnSubCategoriesProvider =
    FutureProvider.family<SubCategories?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getSubCategories(id);
});

final bLearnCoursesProvider =
    FutureProvider.family<Courses?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getCourses(id);
});

final bLearnLessonsProvider = FutureProvider.family<Lessons?, int>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getLessons(id);
});

final bLearnInstructorsProvider = FutureProvider<Instructors?>((ref) {
  return ref.read(bLearnRepositoryProvider).getInstructors();
});

final bLearnInstructorCoursesProvider =
    FutureProvider.family<List<InstructorCourse>?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getInstructorCourses(id);
});

final bLearnInstructorProfileProvider =
    FutureProvider.autoDispose.family<ProfileDataBody?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getTeacherProfileDetail(id);
});

final bLearnFollowInstructorProvider = FutureProvider.autoDispose
    .family<List<FollowedInstructor>, String>((ref, id) async {
  final result = await ref.read(bLearnRepositoryProvider).followInstructor(id);

  return result ?? [];
});
