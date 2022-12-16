import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../core/state.dart';
import '../data/models/models.dart';
import '../data/repository/auth_repository.dart';
import '../data/services/auth_api_service.dart';
import 'providers/chat_messagelist_provider.dart';
import 'providers/chat_reply_provider.dart';
import 'providers/chat_conversations_provider.dart';

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

final authLoadProvider = FutureProvider.autoDispose(
  (_) async => _.watch(loginRepositoryProvider).init(),
);

final loginEnteredOTPProvider = StateProvider.autoDispose<String>(
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

final signUpOTPGeneratedProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);
final signUpEnteredOTPProvider = StateProvider.autoDispose<String>(
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

//Mute
final muteProvider = StateProvider.autoDispose<bool>(
  ((_) => true),
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

//Loading Previous Chat
final chatLoadingPreviousProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

//Loading Previous Chat
final chatHasMoreOldMessageProvider = StateProvider.autoDispose<bool>(
  ((ref) => true),
);

//Loading Previous Chat Curson
// final chatChatCursorMessageProvider = StateProvider.autoDispose<String?>(
//   ((_) => ''),
// );

final chatModelProvider =
    ChangeNotifierProvider.autoDispose<ChatScreenModel>((ref) {
  return ChatScreenModel();
});

final chatMessageListProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
        (ref) => ChatMessageNotifier());
