import '../core/state.dart';
import '../core/utils/date_utils.dart';
import '../data/models/models.dart';
import '../data/repository/blive_repository.dart';
import '../data/services/blive_api_services.dart';

final apiBLiveProvider = Provider<BLiveApiService>(
  (_) => BLiveApiService.instance,
);

final bLiveRepositoryProvider = Provider<BLiveRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return BLiveRepository(ref.read(apiBLiveProvider), token);
});

final bLiveClassesListProvider =
    FutureProvider.autoDispose<LMSLiveClasses?>((ref) {
  return ref.read(bLiveRepositoryProvider).getLiveClasses();
});


final selectedDateProvider = StateProvider.autoDispose<DateTime>((_) => DateTime.now());


final bLiveSelectedHistoryProvider = FutureProvider.autoDispose<List<LMSLiveClass>>((ref) async {
  final meetings = ref.watch(bLiveClassesListProvider).valueOrNull;
  if (meetings?.liveClasses?.isNotEmpty == true) {
    final date = ref.watch(selectedDateProvider);
    // print('Filter list of Live Class of ${date.toString()} ');
    final list = meetings?.liveClasses??[];
    return list.where((item) => isSameDate(item.startsAt??'', date)).toList();
  }
  return [];
});
