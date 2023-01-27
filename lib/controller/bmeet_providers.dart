import '/core/helpers/duration.dart';
import '/core/state.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '/data/repository/bmeet_repository.dart';
import '/data/services/bmeet_api_services.dart';
import 'providers/bmeet_provider.dart';

final callTimerProvider =
    StateNotifierProvider.autoDispose<DurationNotifier, DurationModel>(
  (_) => DurationNotifier(),
);

final apiBMeetProvider = Provider<BMeetApiService>(
  (_) => BMeetApiService.instance,
);

final bMeetRepositoryProvider = Provider<BMeetRepository>((ref) {
  String token = ref.read(loginRepositoryProvider).user?.authToken ?? '';
  return BMeetRepository(ref.read(apiBMeetProvider), token);
});

final bMeetHistoryProvider = FutureProvider.autoDispose<Meetings?>(
  (ref) => ref.watch(bMeetRepositoryProvider).fetchMeetingList(),
);

final selectedDateProvider =
    StateProvider.autoDispose<DateTime>((_) => DateTime.now());

final selectedClassDateProvider =
    StateProvider.autoDispose<DateTime>((_) => DateTime.now());

final bMeetSelectedHistoryProvider =
    FutureProvider.autoDispose<List<ScheduledMeeting>>((ref) async {
  final meetings = ref.watch(bMeetHistoryProvider).valueOrNull;
  if (meetings?.meetings?.isNotEmpty == true) {
    final date = ref.watch(selectedDateProvider);
    // print('Filter list of Meetings of ${date.toString()} ');
    final list = meetings?.meetings ?? [];
    // return list;
    return list.where((item) => isSameDate(item.startsAt, date)).toList();
  }
  return [];
});

final bMeetCallChangeProvider =
    ChangeNotifierProvider.autoDispose<BMeetProvider>(
        (ref) => BMeetProvider(ref.read(callTimerProvider.notifier)));

final bmeetClassesProvider = FutureProvider.autoDispose<ClassRequestBody?>(
  (ref) => ref.watch(bMeetRepositoryProvider).getClassRequests(),
);
// final bMeetInitProvider = Provider.family<BMeetProvider, Meeting>(
//     (ref, meeting) => ref.read(bMeetChangeProvider).init(meeting, false));
