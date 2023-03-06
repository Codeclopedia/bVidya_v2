// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';
import '/ui/screens.dart';

import '../constants/route_list.dart';
import '../state.dart';
import '../ui_core.dart';

bool isOnline(ChatPresence? presence) {
  if (presence == null) {
    return false;
  }
  if (presence.statusDetails?.values.isNotEmpty == true) {
    for (var status in presence.statusDetails!.values) {
      if (status == 1) {
        return true;
      }
    }
  }
  return false;
}

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

String formatSince(int lastSeen) {
  if (lastSeen == 0) {
    return 'A long time ago';
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(lastSeen * 1000);
  if (!DateTime.now().difference(time).isNegative) {
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "last seen just now";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "last seen ${DateTime.now().difference(time).inMinutes} min ago";
    } else if (DateTime.now().difference(time).inMinutes < 1440) {
      return "last seen ${DateTime.now().difference(time).inHours} hrs ago";
    } else if (DateTime.now().difference(time).inMinutes > 1440) {
      return "last seen ${DateTime.now().difference(time).inDays} days ago";
    } else if (DateTime.now().difference(time).inDays > 30) {
      return 'last seen more than a month ago';
    } else if (DateTime.now().difference(time).inDays > 60) {
      return 'last seen a long time ago';
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

// Future handleRemoteMessage(RemoteMessage message, BuildContext context,
//     {WidgetRef? ref,
//     // bool replace = true,
//     String fallbackScreen = RouteList.home}) async {
//   try {
//     debugPrint('getInitialMessage : ${message.toMap()}');
//     if (message.data['alert'] != null && message.data['e'] != null) {
//       if (ref != null) {
//         showLoading(ref);
//       }
//       //open specific screen
//       print('Data: ${message.data}');
//       String? type = jsonDecode(message.data['e'])['type'];
//       print('type: $type');
//       dynamic from = message.data['f'];
//       print('From $from');

//       if (from == null) {
//         if (fallbackScreen.isNotEmpty) {
//           Navigator.pushReplacementNamed(context, fallbackScreen);
//         }
//         return;
//       }
//       if (type == 'chat') {
//         final model = await getConversationModel(from.toString());
//         if (ref != null) {
//           hideLoading(ref);
//         }
//         if (model != null) {
//           await Navigator.pushReplacementNamed(
//               context, RouteList.chatScreenDirect,
//               arguments: model);
//           return;
//         }
//       } else if (type == 'group_chat') {
//         dynamic gId = message.data['g'];
//         print('From $gId');
//         if (gId == null) {
//           if (fallbackScreen.isNotEmpty) {
//             Navigator.pushReplacementNamed(context, fallbackScreen);
//           }
//           return;
//         }

//         final model = await getGroupConversationModel(gId.toString());
//         if (ref != null) {
//           hideLoading(ref);
//         }
//         if (model != null) {
//           await Navigator.pushReplacementNamed(
//               context, RouteList.groupChatScreenDirect,
//               arguments: model);
//           return;
//         }
//       }
//       if (fallbackScreen.isNotEmpty) {
//         Navigator.pushReplacementNamed(context, fallbackScreen);
//       }
//     }
//   } catch (e) {
//     print('Error $e');
//     if (ref != null) {
//       hideLoading(ref);
//     }
//     if (fallbackScreen.isNotEmpty) {
//       Navigator.pushReplacementNamed(context, fallbackScreen);
//     }
//   }
// }

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
        contact: Contacts.fromContact(contact, ContactStatus.unknown),
        badgeCount: 0,
        conversation: conv,
        lastMessage: null,
        mute: false,
        isOnline: null);
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

openGroupChat() {}

openChatScreen(BuildContext context, Contacts contact, WidgetRef ref,
    {bool sendInviateMessage = false, String message = ''}) async {
  final User? user = await getMeAsUser();
  final conv = await ChatClient.getInstance.chatManager
      .getConversation(contact.userId.toString(),
          // createIfNeed: true,
          type: ChatConversationType.Chat);
  if (conv != null) {
    if (sendInviateMessage) {
      final inviateMessage = ChatMessage.createTxtSendMessage(
          targetId: contact.userId.toString(),
          content: message.isEmpty ? 'Hi' : message);
      inviateMessage.attributes = {
        "em_apns_ext": {
          "em_push_title": "${user?.name ?? ''} sent you a message",
          "em_push_content":
              // message.isEmpty ? 'Hi' :
              message,
          'type': 'chat',
        },
      };
      inviateMessage.attributes?.addAll({"em_force_notification": true});
      await ChatClient.getInstance.chatManager.sendMessage(inviateMessage);
    }
    final model = await addNewContact(contact, ref);
    if (model == null) return;
    // ConversationModel model = ConversationModel(
    //   id: contact.userId.toString(),
    //   badgeCount: await conv.unreadCount(),
    //   contact: contact,
    //   conversation: conv,
    //   lastMessage: await conv.latestMessage(),
    //   // isOnline: null,
    // );
    // ref.read(chatConversationProvider).addOrUpdateConversation(model);
    hideLoading(ref);
    Navigator.pushReplacementNamed(context, RouteList.chatScreen,
        arguments: model);
  }
}
