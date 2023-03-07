import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/controller/providers/bchat/groups_conversation_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../state.dart';
import '../ui_core.dart';
import '../utils/notification_controller.dart';
import '/data/services/bchat_api_service.dart';
import '/data/services/fcm_api_service.dart';
import '/core/utils.dart';
import '/data/models/models.dart';

enum GroupMemberAction { added, joined, removed, left }

class GroupMembers {
  final List<MemberInfo> infos;
  GroupMembers(this.infos);

  GroupMembers.fromJson(Map<String, dynamic> json)
      : infos = List.from(json['members'])
            .map((e) => MemberInfo.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['members'] = infos.map((e) => e.toJson()).toList();
    return data;
  }
}

class MemberInfo {
  final String? name;
  final int id;

  MemberInfo(this.id, {this.name});

  MemberInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

GroupMemberAction? groupActionFrom(String? name) {
  if (name == null) return null;
  if (name == GroupMemberAction.joined.name) {
    return GroupMemberAction.joined;
  }
  if (name == GroupMemberAction.added.name) {
    return GroupMemberAction.added;
  }
  if (name == GroupMemberAction.left.name) {
    return GroupMemberAction.left;
  }
  if (name == GroupMemberAction.removed.name) {
    return GroupMemberAction.removed;
  }
  return null;
}

class GroupMemberHelper {
  GroupMemberHelper._();

  static Future handleNotification(RemoteNotification? notification,
      GroupMemberAction action, String fromId, String grpId, bool foreground,
      {WidgetRef? ref}) async {
    // print('Action  $action');
    switch (action) {
      case GroupMemberAction.added:
        if (foreground) {
          ref
              ?.read(groupConversationProvider.notifier)
              .addConversationOnly(grpId);
          if (notification != null) {
            NotificationController.showContactActionNotification(
                fromId,
                notification.title ?? '',
                notification.body ?? '',
                Colors.green);
          }
        }
        break;
      case GroupMemberAction.joined:
        // await ContactRequestHelper.removeFromSendList(fromId);
        // if (foreground) {
        //   ref
        //       ?.read(groupConversationProvider.notifier)
        //       .addConversationOnly(grpId);
        //   if (notification != null) {
        //     NotificationController.showContactActionNotification(
        //         fromId,
        //         notification.title ?? '',
        //         notification.body ?? '',
        //         Colors.green);
        //   }
        // }
        break;
      case GroupMemberAction.left:
        if (foreground) {
          // ref?.read(groupConversationProvider.notifier).removeEntry(grpId);
          // NotificationController.showContactActionNotification(fromId,
          //     notification?.title ?? '', notification?.body ?? '', Colors.red);
        }
        break;
      case GroupMemberAction.removed:
        if (foreground) {
          ref?.read(groupConversationProvider.notifier).removeEntry(grpId);
          if (notification != null) {
            NotificationController.showContactActionNotification(fromId,
                notification.title ?? '', notification.body ?? '', Colors.blue);
          }
        }

        break;
      default:
    }
  }

  static Future sendMembersAddedToGroup(
      String groupId, String groupName, List<String> newMembers) async {
    try {
      User? me = await getMeAsUser();
      if (me == null) {
        return;
      }

      final result = await BChatApiService.instance
          .getContactsByIds(me.authToken, newMembers.join(','));
      final List<MemberInfo> membersInfo;
      if (result.body?.contacts?.isNotEmpty == true) {
        membersInfo = result.body!.contacts!
            .map((e) => MemberInfo(e.userId, name: e.name))
            .toList();
      } else {
        membersInfo = newMembers.map((e) => MemberInfo(int.parse(e))).toList();
      }
      final map = {
        'type': 'member_update',
        'action': GroupMemberAction.added.name,
        'members': jsonEncode(GroupMembers(membersInfo).toJson())
      };
      final event = jsonEncode(map);
      final message = ChatMessage.createCustomSendMessage(
          targetId: groupId, event: event, chatType: ChatType.GroupChat);

      message.attributes = {
        //   "em_apns_ext": {
        //     "em_push_title": groupName,
        //     "em_push_content": '${me.name} added you in Group',
        //     'type': 'group_chat',
        //   },
      };
      message.attributes?.addAll({'from_name': me.name});
      message.attributes?.addAll({'from_image': me.image});
      message.attributes?.addAll({"em_force_notification": false});

      await ChatClient.getInstance.chatManager.sendMessage(message);
      if (result.body?.contacts?.isNotEmpty == true) {
        final fcmIds =
            result.body!.contacts!.map((e) => e.fcmToken ?? '').toList();
        FCMApiService.instance.sendGroupMemberUpdatePush(
            fcmIds,
            GroupMemberAction.added.name,
            groupName,
            me.id,
            groupId,
            groupName,
            '${me.name} added you in Group');
      }
    } catch (_) {}
  }

  static Future sendMembersRemovedFromGroup(
      String groupId, String groupName, List<String> members) async {
    try {
      User? me = await getMeAsUser();
      if (me == null) {
        return;
      }
      final result = await BChatApiService.instance
          .getContactsByIds(me.authToken, members.join(','));
      final List<MemberInfo> membersInfo;
      if (result.body?.contacts?.isNotEmpty == true) {
        membersInfo = result.body!.contacts!
            .map((e) => MemberInfo(e.userId, name: e.name))
            .toList();
      } else {
        membersInfo = members.map((e) => MemberInfo(int.parse(e))).toList();
      }

      final map = {
        'type': 'member_update',
        'action': GroupMemberAction.removed.name,
        'members': jsonEncode(GroupMembers(membersInfo).toJson())
      };
      final event = jsonEncode(map);
      final message = ChatMessage.createCustomSendMessage(
          targetId: groupId, event: event, chatType: ChatType.GroupChat);

      message.attributes ??= {
        //   "em_apns_ext": {
        //     "em_push_title": groupName,
        //     "em_push_content": '${me.name} removed you from Group',
        //     'type': 'group_chat',
        //   },
      };
      message.attributes?.addAll({'from_name': me.name});
      message.attributes?.addAll({'from_image': me.image});
      message.attributes?.addAll({"em_force_notification": false});

      await ChatClient.getInstance.chatManager.sendMessage(message);

      if (result.body?.contacts?.isNotEmpty == true) {
        final fcmIds =
            result.body!.contacts!.map((e) => e.fcmToken ?? '').toList();
        FCMApiService.instance.sendGroupMemberUpdatePush(
            fcmIds,
            GroupMemberAction.removed.name,
            groupName,
            me.id,
            groupId,
            groupName,
            '${me.name} removed you from Group');
      }
    } catch (_) {}
  }

  static Future sendMemberJoinToGroup(String groupId, String groupName) async {
    try {
      User? me = await getMeAsUser();
      if (me == null) {
        return;
      }
      final map = {
        'type': 'member_update',
        'action': GroupMemberAction.joined.name,
        'members': jsonEncode(
            GroupMembers([MemberInfo(me.id, name: me.name)]).toJson())
      };
      final event = jsonEncode(map);
      final message = ChatMessage.createCustomSendMessage(
          targetId: groupId, event: event, chatType: ChatType.GroupChat);

      message.attributes ??= {};
      message.attributes?.addAll({'from_name': me.name});
      message.attributes?.addAll({'from_image': me.image});
      message.attributes?.addAll({"em_force_notification": false});

      await ChatClient.getInstance.chatManager.sendMessage(message);
    } catch (_) {}
  }

  static Future<bool> sendMemberLeftFromGroup(String groupId) async {
    try {
      User? me = await getMeAsUser();
      if (me == null) {
        return false;
      }

      final map = {
        'type': 'member_update',
        'action': GroupMemberAction.left.name,
        'members': jsonEncode(
            GroupMembers([MemberInfo(me.id, name: me.name)]).toJson())
      };
      final event = jsonEncode(map);
      final message = ChatMessage.createCustomSendMessage(
          targetId: groupId, event: event, chatType: ChatType.GroupChat);
      message.attributes ??= {};
      message.attributes?.addAll({'from_name': me.name});
      message.attributes?.addAll({'from_image': me.image});
      message.attributes?.addAll({"em_force_notification": false});
      await ChatClient.getInstance.chatManager.sendMessage(message);
      await ChatClient.getInstance.groupManager.leaveGroup(groupId);
      return true;
    } catch (_) {}
    return false;
  }
}
