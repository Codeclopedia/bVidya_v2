// import '/data/models/models.dart';

import '/core/state.dart';
import '/data/repository/auth_repository.dart';
import '/data/services/auth_api_service.dart';
import 'providers/chat_reply_provider.dart';

final apiServiceProvider = Provider<ApiAuthService>(
  (_) => ApiAuthService.instance,
);

//OTP timer
final loginTimerProvider =
    StateNotifierProvider.autoDispose<TimerNotifier, TimerModel>(
  (_) => TimerNotifier(),
);

//Login
final loginRepositoryProvider = Provider<AuthRepository>(
  (_) => AuthRepository(_.read(apiServiceProvider)),
);

// final loadUserProvider = FutureProvider<User?>(
//   (ref) => ref.watch(loginRepositoryProvider).init(),
// );

final authLoadProvider = FutureProvider.autoDispose(
  (ref) async => ref.watch(loginRepositoryProvider).init(),
);

final loginEnteredOTPProvider = StateProvider<String>(
  (_) => '',
);

final loginOtpGeneratedProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

final loginShowPasswordProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

//Sign up
final signUpTimerProvider =
    StateNotifierProvider.autoDispose<TimerNotifier, TimerModel>(
  (_) => TimerNotifier(),
);

final signUpOTPGeneratedProvider = StateProvider<bool>(
  (_) => false,
);
final signUpEnteredOTPProvider = StateProvider<String>(
  (_) => '',
);

final signUpShowPasswordProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

//Search
final inputTextProvider = StateProvider.autoDispose<String>(
  (_) => '',
);

//Loading
final loadingStateProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

// //Drawer
// final drawerOpenProvider = StateProvider.autoDispose<bool>(
//   (_) => false,
// );
// final drawerLiveOpenProvider = StateProvider<bool>(
//   (_) => false,
// );
// final drawerBLiveOpenProvider = StateProvider<bool>(
//   (_) => false,
// );

//Loading Previous Chat Curson
// final chatChatCursorMessageProvider = StateProvider.autoDispose<String?>(
//   ((_) => ''),
// );

final chatModelProvider =
    ChangeNotifierProvider.autoDispose<ChatScreenModel>((ref) {
  return ChatScreenModel();
});
