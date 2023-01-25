import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/controller/providers/bchat/chat_conversation_list_provider.dart';

import 'package:clipboard/clipboard.dart';
import 'package:intl/intl.dart';

import '/data/models/models.dart';
import '/controller/bmeet_providers.dart';
import '/controller/blive_providers.dart';
import '/controller/profile_providers.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/controller/blearn_providers.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
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
  await loadChats(ref);
  // await ref
  //     .read(chatConversationProvider.notifier)
  //     .setup(ref.read(bChatProvider), user);
  await ref.read(groupConversationProvider.notifier).setup();
  await ref.read(callListProvider.notifier).setup();
  return null;
}

Future updateUser(WidgetRef ref, User user) async {
  ref.read(loginRepositoryProvider).updateUser(user);
  ref.read(userAuthChangeProvider.notifier).updateUser(user);
}

Future updateProfile(WidgetRef ref, Profile profile) async {
  final user = await ref.read(userAuthChangeProvider.notifier).loadUser();
  if (user != null) {
    final map = user.toJson()
      ..addAll({
        'name': profile.name ?? user.name,
        'email': profile.email ?? user.email,
        'phone': profile.phone ?? user.phone,
      });
    final newUser = User.fromJson(map);
    // final newUser = User(
    //     id: user.id,
    //     authToken: user.authToken,
    //     name: profile.name ?? user.name,
    //     email: profile.email ?? user.email,
    //     phone: profile.phone ?? user.phone,
    //     role: user.role,
    //     fcmToken: user.fcmToken,
    //     image: user.image);
    updateUser(ref, newUser);
  }
}

Future updateProfileData(WidgetRef ref, UpdatedProfile profile) async {
  final user = await ref.read(userAuthChangeProvider.notifier).loadUser();
  if (user != null) {
    final map = user.toJson()
      ..addAll({
        'name': profile.name ?? user.name,
        'email': profile.email ?? user.email,
        'phone': profile.phone ?? user.phone,
      });
    final newUser = User.fromJson(map);
    // final newUser = User(
    //     id: user.id,
    //     authToken: user.authToken,
    //     name: profile.name ?? user.name,
    //     email: profile.email ?? user.email,
    //     phone: profile.phone ?? user.phone,
    //     role: user.role,
    //     fcmToken: user.fcmToken,
    //     image: user.image);
    updateUser(ref, newUser);
  }
}

Future updateUserImage(WidgetRef ref, String image) async {
  final user = await ref.read(userAuthChangeProvider.notifier).loadUser();
  if (user != null) {
    final map = user.toJson()..addAll({'image': image});
    final newUser = User.fromJson(map);
    updateUser(ref, newUser);
  }
}

Future copyToClipboard(List<ChatMessage> messages) async {
  if (messages.isNotEmpty) {
    String content = '';
    for (var msg in messages) {
      if (msg.body.type == MessageType.TXT) {
        content +=
            '[${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(msg.serverTime))}]: ';
        content += (msg.body as ChatTextMessageBody).content;
        content += '\n';
      }
    }
    if (content.isNotEmpty) {
      await FlutterClipboard.copy(
          content); //.then(( value ) => print('copied'));
    }
  }
}

Future copyToClipboardGroup(List<ChatMessage> messages) async {
  if (messages.isNotEmpty) {
    String content = '';

    for (var msg in messages) {
      if (msg.body.type == MessageType.TXT) {
        String name = msg.attributes?['from_name'] ?? '';
        content +=
            '[${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(msg.serverTime))}] ';

        if (name.isNotEmpty) {
          content += '$name : ';
        } else {
          content += ' : ';
        }
        content += (msg.body as ChatTextMessageBody).content;
        content += '\n';
      }
    }
    if (content.isNotEmpty) {
      await FlutterClipboard.copy(
          content); //.then(( value ) => print('copied'));
    }
  }
}
