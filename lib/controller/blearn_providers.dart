import '../core/state.dart';
import '/data/models/models.dart';
import '/data/repository/blearn_repository.dart';
import '/data/services/blearn_api_service.dart';

final apiBLearnProvider = Provider<BLearnApiService>(
  (_) => BLearnApiService.instance,
);

final bLearnRepositoryProvider = Provider<BLearnRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return BLearnRepository(ref.read(apiBLearnProvider), token);
});

final bLearnHomeProvider = FutureProvider.autoDispose<HomeBody?>((ref) {
  return ref.read(bLearnRepositoryProvider).getHome();
});

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

final bLearnLessonsProvider =
    FutureProvider.family<Lessons?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getLessons(id);
});

final bLearnInstructorsProvider = FutureProvider<Instructors?>((ref) {
  return ref.read(bLearnRepositoryProvider).getInstructors();
});

final bLearnInstructorCoursesProvider =
    FutureProvider.autoDispose.family<List<Course>?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getInstructorCourses(id);
});

final bLearnInstructorProfileProvider =
    FutureProvider.autoDispose.family<ProfileBody?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getInstructorProfile(id);
});
