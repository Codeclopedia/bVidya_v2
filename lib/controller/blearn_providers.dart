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

final bLearnsetCourseProgressProvider =
    FutureProvider.family<BaseResponse?, Map>((ref, data) {
  return ref
      .read(bLearnRepositoryProvider)
      .setCourseProgress(data["courseId"], data["videoId"], data["lessonId"]);
});

final bLearnSearchCoursesProvider =
    FutureProvider.family<SearchResults?, String>((ref, term) {
  if (term == "" || term.isEmpty) {
    return null;
  } else {
    return ref.read(bLearnRepositoryProvider).getSearchedCourses(term);
  }
});

final bLearnAllCoursesProvider = FutureProvider<Courses?>((ref) {
  return ref.read(bLearnRepositoryProvider).getAllCourses();
});

final blearnSubscribeCourseProvider =
    FutureProvider.autoDispose.family<BaseResponse?, int>((ref, id) {
  return ref.read(bLearnRepositoryProvider).subscribeCourse(id);
});

// final blearnAddorRemoveinWishlistProvider =
//     FutureProvider.autoDispose.family<BaseResponse?, int>((ref, id) {
//   return ref.read(bLearnRepositoryProvider).changeinWishlist(id);
// });

final blearnWishlistCoursesProvider =
    FutureProvider.autoDispose<WishlistCoursesBody?>((ref) {
  return ref.read(bLearnRepositoryProvider).getWishlistCourses();
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

final bLearnProfileProvider =
    FutureProvider.autoDispose.family<ProfileDetailBody?, String>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getProfileDetail(id);
});

final bLearnFollowInstructorProvider = FutureProvider.autoDispose
    .family<List<FollowedInstructor>, String>((ref, id) async {
  final result = await ref.read(bLearnRepositoryProvider).followInstructor(id);
  ref.refresh(isFollowedInstructor(id));
  // ref.read(bLearnInstructorProfileProvider(id));
  // ref.read(isFollowedInstructor(id));

  return result ?? [];
});

final bLearnCourseDetailProvider =
    FutureProvider.autoDispose.family<CourseDetailBody?, int>((ref, id) {
  return ref.read(bLearnRepositoryProvider).getCourseDetail(id);
});

final currentVideoUrlProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final currentVideoIDProvider = StateProvider<int>(
  (ref) {
    return 0;
  },
);

final selectedLessonIndexProvider = StateProvider.autoDispose<int>((ref) => -1);

final currentLessonIdProvider = StateProvider<int>((ref) => -1);
