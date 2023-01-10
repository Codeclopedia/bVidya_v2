import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/helpers/bchat_group_manager.dart';
import 'package:bvidya/core/utils.dart';
import 'package:bvidya/data/models/models.dart';
import 'package:bvidya/data/services/bchat_api_service.dart';

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
    final pushtemplate =
        await ChatClient.getInstance.pushManager.getPushTemplate();
    print('pushtemplate: $pushtemplate');
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
