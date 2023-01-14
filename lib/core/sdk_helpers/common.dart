import 'package:bvidya/controller/providers/bchat/chat_conversation_provider.dart';

import '../../controller/bchat_providers.dart';
import '../../controller/providers/bchat/call_list_provider.dart';
import '../../controller/providers/bchat/groups_conversation_provider.dart';
import '/controller/providers/user_auth_provider.dart';
// import 'package:bvidya/core/ui_core.dart';

import '../state.dart';
import 'bchat_sdk_controller.dart';

Future<String?> postLoginSetup(WidgetRef ref) async {
  final user = await ref.read(userAuthChangeProvider).loadUser();
  if (user == null) {
    // hideLoading(ref);
    // AppSnackbar.instance
    //     .error(context, 'Error occurred, Please restart app');
    return 'Error occurred, Please restart app';
  }
  // AppSnackbar.instance.message(context, 'Registration successfully');
  // ref.read(signUpOTPGeneratedProvider.notifier).state = true;
  // ref.read(signUpTimerProvider.notifier).reset();
  await ref.read(userAuthChangeProvider).loadUser();
  // ref.read(userAuthChangeProvider).setUserSigned(true);
  print('init from splash');
  // await BChatSDKController.instance.initChatSDK(next.value!);

  await BChatSDKController.instance.initChatSDK(user);
  await BChatSDKController.instance.loadAllContactsGroup();

  await ref
      .read(chatConversationProvider.notifier)
      .setupWithoutInitSDK(ref.read(bChatProvider), user);
  await ref.read(groupConversationProvider.notifier).setup();
  await ref.read(callListProvider.notifier).setup();
  return null;
}
