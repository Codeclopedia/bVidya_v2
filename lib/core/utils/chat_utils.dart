// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';
import '/ui/screens.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../constants/route_list.dart';
import '../state.dart';
import '../ui_core.dart';

String parseChatPresenceToReadable(ChatPresence? presence) {
  if (presence == null) {
    return '';
  }
  // double now = DateTime.now().millisecondsSinceEpoch / 1000;
  // double diff = now - presence.lastTime;
  if (presence.statusDetails?.values.isNotEmpty == true) {
    for (var status in presence.statusDetails!.values) {
      if (status == 1) {
        return 'Online';
      }
    }

    // int value = presence.statusDetails!.values.first;
    // if (value == 1) {
    //   return 'Online';
    // }
  }

  // print('$now  ${presence.lastTime}  : $diff');
  debugPrint(
      'Online status =${presence.statusDetails} ${presence.lastTime} ${presence.statusDescription}  ${presence.expiryTime}');
// DateUtils.addMonthsToMonthDate(monthDate, monthsToAdd)
  // if(presence.lastTime)
  return formatSince(presence.lastTime);
}

String formatSince(int diffSecond) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(diffSecond * 1000);
  if (!DateTime.now().difference(time).isNegative) {
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "a few seconds ago";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "${DateTime.now().difference(time).inMinutes} minutes ago";
    } else if (DateTime.now().difference(time).inMinutes < 1440) {
      return "${DateTime.now().difference(time).inHours} hours ago";
    } else if (DateTime.now().difference(time).inMinutes > 1440) {
      return "${DateTime.now().difference(time).inDays} days ago";
    }
  }
  return '';
  //  if (DateTime.sin) {
}

Future<ChatPresence?> fetchOnlineStatus(String userId) async {
  final list = await fetchOnlineStatuses([userId]);
  if (list.isNotEmpty) {
    return list[0];
  } else {
    return null;
  }
}

Future<List<ChatPresence>> fetchOnlineStatuses(List<String> contacts) async {
  try {
    return await ChatClient.getInstance.presenceManager
        .fetchPresenceStatus(members: contacts);
  } on ChatError catch (e) {
    print('chatError: ${e.code}- ${e.description}');
    return [];
  } catch (e) {
    print('error: $e');
    return [];
  }
}

Future handleRemoteMessage(RemoteMessage message, BuildContext context,
    {WidgetRef? ref,
    // bool replace = true,
    String fallbackScreen = RouteList.home}) async {
  try {
    debugPrint('getInitialMessage : ${message.toMap()}');
    if (message.data['alert'] != null && message.data['e'] != null) {
      if (ref != null) {
        showLoading(ref);
      }
      //open specific screen
      print('Data: ${message.data}');
      String? type = jsonDecode(message.data['e'])['type'];
      print('type: $type');
      dynamic from = message.data['f'];
      print('From $from');

      if (from == null) {
        if (fallbackScreen.isNotEmpty) {
          Navigator.pushReplacementNamed(context, fallbackScreen);
        }
        return;
      }
      if (type == 'chat') {
        final model = await getConversationModel(from.toString());
        if (ref != null) {
          hideLoading(ref);
        }
        if (model != null) {
          await Navigator.pushReplacementNamed(
              context, RouteList.chatScreenDirect,
              arguments: model);
          return;
        }
      } else if (type == 'group_chat') {
        final model = await getGroupConversationModel(from.toString());
        if (ref != null) {
          hideLoading(ref);
        }
        if (model != null) {
          await Navigator.pushReplacementNamed(
              context, RouteList.groupChatScreenDirect,
              arguments: model);
          return;
        }
      }
      if (fallbackScreen.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, fallbackScreen);
        });
      }
    }
  } catch (e) {
    print('Error $e');
    if (ref != null) {
      hideLoading(ref);
    }
    if (fallbackScreen.isNotEmpty) {
      Navigator.pushReplacementNamed(context, fallbackScreen);
    }
  }
}

Future<ConversationModel?> getConversationModel(String fromId) async {
  final user = await getMeAsUser();
  if (user == null) {
    return null;
  }

  final response =
      await BChatApiService.instance.getContactsByIds(user.authToken, fromId);
  if (response.body?.contacts?.isNotEmpty == true) {
    final conv =
        await ChatClient.getInstance.chatManager.getConversation(fromId);
    final contact = response.body!.contacts!.first;
    return ConversationModel(
        id: fromId,
        contact: contact,
        badgeCount: 0,
        conversation: conv,
        lastMessage: null);
  } else {
    return null;
  }
}

Future<GroupConversationModel?> getGroupConversationModel(
    String groupId) async {
  try {
    final user = await getMeAsUser();
    if (user == null) {
      return null;
    }
    final ChatGroup group =
        await ChatClient.getInstance.groupManager.getGroupWithId(groupId) ??
            await ChatClient.getInstance.groupManager
                .fetchGroupInfoFromServer(groupId);

    final conv =
        await ChatClient.getInstance.chatManager.getConversation(groupId);

    return GroupConversationModel(
        id: groupId,
        groupInfo: group,
        badgeCount: 0,
        conversation: conv,
        image: BchatGroupManager.getGroupImage(group),
        lastMessage: null);
  } catch (e) {
    return null;
  }
}

openChatScreen(BuildContext context, Contacts contact, WidgetRef ref) async {
  final conv = await ChatClient.getInstance.chatManager.getConversation(
      contact.userId.toString(),
      type: ChatConversationType.Chat);
  if (conv != null) {
    ConversationModel model = ConversationModel(
      id: contact.userId.toString(),
      badgeCount: await conv.unreadCount(),
      contact: contact,
      conversation: conv,
      lastMessage: await conv.latestMessage(),
      // isOnline: null,
    );
    ref.read(chatConversationProvider).addOrUpdateConversation(model);
    Navigator.pushReplacementNamed(context, RouteList.chatScreen,
        arguments: model);
  }
}
