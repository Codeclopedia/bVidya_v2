import '../core/utils/date_utils.dart';
import '/core/helpers/duration.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '/data/repository/blive_repository.dart';
import '/data/services/blive_api_services.dart';
import 'providers/blive_provider.dart';

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

final bLiveSelectedDateProvider =
    StateProvider.autoDispose<DateTime>((_) => DateTime.now());

final bLiveSelectedHistoryProvider =
    FutureProvider.autoDispose<List<LMSLiveClass>>((ref) async {
  final liveClasses = ref.watch(bLiveClassesListProvider).valueOrNull;
  if (liveClasses?.liveClasses?.isNotEmpty == true) {
    final date = ref.watch(bLiveSelectedDateProvider);
    print('Filter list of Live Class of ${date.toString()} ');
    final list = liveClasses?.liveClasses ?? [];
    return list.where((item) => isSameDate(item.startsAt ?? '', date)).toList();
    // return liveClasses!.liveClasses!;
  } else {
    print('Empty List of live classes');
  }
  return [];
});

final bLiveCallTimerProvider =
    StateNotifierProvider.autoDispose<DurationNotifier, DurationModel>(
  (_) => DurationNotifier(),
);

final bLiveMessageListProvider = StateNotifierProvider.autoDispose<
    RTMChatMessageNotifier,
    List<RTMMessageModel>>((ref) => RTMChatMessageNotifier());

final bLiveCallChangeProvider =
    ChangeNotifierProvider.autoDispose<BLiveProvider>((ref) => BLiveProvider());

final bLiveChatVisible = StateProvider<bool>((ref) => true);

// final bLiveFloatingVisible = StateProvider<bool>((ref) => false);

