import '/controller/bmeet_providers.dart';
import '/controller/blive_providers.dart';
import '/controller/profile_providers.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/controller/blearn_providers.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/data/models/response/auth/login_response.dart';
import '/controller/providers/user_auth_provider.dart';
// import '/core/ui_core.dart';

import '../state.dart';
import '../sdk_helpers/bchat_sdk_controller.dart';

Future<String?> postLoginSetup(WidgetRef ref) async {
  final user = await ref.read(userAuthChangeProvider).loadUser();
  if (user == null) {
    return 'Error occurred, Please restart app';
  }

  ref.refresh(bLearnRepositoryProvider);
  ref.refresh(bMeetRepositoryProvider);
  ref.refresh(bLiveRepositoryProvider);
  ref.refresh(profileRepositoryProvider);
  ref.refresh(bChatProvider);
  print('Post login initialization');
  // await BChatSDKController.instance.initChatSDK(next.value!);
  await BChatSDKController.instance.initChatSDK(user);
  await BChatSDKController.instance.loadAllContactsGroup();

  await ref
      .read(chatConversationProvider.notifier)
      .setup(ref.read(bChatProvider), user);
  await ref.read(groupConversationProvider.notifier).setup();
  await ref.read(callListProvider.notifier).setup();
  return null;
}

Future updateUser(WidgetRef ref, User user) async {
  ref.read(loginRepositoryProvider).updateUser(user);
  ref.read(userAuthChangeProvider.notifier).updateUser(user);
}