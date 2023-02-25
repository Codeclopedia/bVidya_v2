import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../controller/bchat_providers.dart';
import '../state.dart';
import '/data/models/models.dart';

class BchatGroupManager {
  BchatGroupManager._();

  static Future<ChatGroup?> getGroupInfo(String groupId) async {
    try {
      // return await ChatClient.getInstance.groupManager.fetchMemberListFromServer(groupId)
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<List<Contact>> fetchContactsOfGroup(
      WidgetRef ref, String groupId) async {
    try {
      ChatGroup info =
          await ChatClient.getInstance.groupManager.getGroupWithId(groupId) ??
              await ChatClient.getInstance.groupManager
                  .fetchGroupInfoFromServer(groupId, fetchMembers: true);
      final membersIds = info.memberList ?? [];
      if (!membersIds.contains(info.owner)) {
        membersIds.add(info.owner!);
      }
      String userIds = membersIds.join(',');
      if (userIds.isNotEmpty) {
        final contacts =
            await ref.read(bChatProvider).getContactsByIds(userIds);
        return contacts ?? [];
      }
    } catch (e) {
      print('error in loading members of $groupId');
    }
    return [];
  }

  static Future<ChatGroup?> getGroupById(String groupId) async {
    try {
      return await ChatClient.getInstance.groupManager
          .fetchGroupInfoFromServer(groupId, fetchMembers: true);
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<ChatGroup?> createNewGroup(
      String name, String? desc, List<String> ids, String image,
      {bool public = true}) async {
    try {
      ChatGroup group = await ChatClient.getInstance.groupManager.createGroup(
          groupName: name,
          desc: desc,
          inviteMembers: ids,
          options: ChatGroupOptions(
              style: public
                  ? ChatGroupStyle.PublicOpenJoin
                  : ChatGroupStyle.PrivateMemberCanInvite));

      Map<String, dynamic> ext = {'image': image};
      await ChatClient.getInstance.groupManager
          .updateGroupExtension(group.groupId, jsonEncode(ext));
      return group;
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<ChatGroup?> updateMembers(
      String groupId, List<String> ids, List<String> removeIds) async {
    try {
      if (ids.isNotEmpty) {
        await ChatClient.getInstance.groupManager.addMembers(groupId, ids);
      }
      if (removeIds.isNotEmpty) {
        await ChatClient.getInstance.groupManager
            .removeMembers(groupId, removeIds);
      }

      return await ChatClient.getInstance.groupManager
          .fetchGroupInfoFromServer(groupId, fetchMembers: true);
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<ChatGroup?> editGroup(
      String groupId,
      String name,
      String? desc,
      List<String> ids,
      List<String> removeIds,
      String image,
      bool updateImage) async {
    try {
      await ChatClient.getInstance.groupManager.changeGroupName(groupId, name);

      if (ids.isNotEmpty) {
        await ChatClient.getInstance.groupManager.addMembers(groupId, ids);
      }
      if (removeIds.isNotEmpty) {
        await ChatClient.getInstance.groupManager
            .removeMembers(groupId, removeIds);
      }

      if (image.isNotEmpty) {
        Map<String, dynamic> ext = {'image': image};
        await ChatClient.getInstance.groupManager
            .updateGroupExtension(groupId, jsonEncode(ext));
      }
      final ChatGroup group = await ChatClient.getInstance.groupManager
          .fetchGroupInfoFromServer(groupId, fetchMembers: true);
      return group;
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<List<ChatGroup>> loadGroupList() async {
    List<ChatGroup> groups = [];
    try {
      groups =
          await ChatClient.getInstance.groupManager.fetchJoinedGroupsFromServer(
        needMemberCount: true,
        needRole: true,
      );
      // }
    } catch (e) {
      print('Error: $e');
    }
    return groups;
  }

  static Future<List<GroupConversationModel>> loadGroupConversationsList(
      {bool firstTime = false}) async {
    List<GroupConversationModel> conversations = [];
    List<ChatGroup> groups = [];
    try {
      groups =
          await ChatClient.getInstance.groupManager.fetchJoinedGroupsFromServer(
        needMemberCount: true,
        needRole: true,
      );
      // }
    } catch (e) {
      print('Error: $e');
    }
    // if (groups.isEmpty) {
    //   final list = ['202732014206977', '202468308877313'];
    //   for (String id in list) {
    //     try {
    //       final grp = await ChatClient.getInstance.groupManager
    //           .fetchGroupInfoFromServer(id, fetchMembers: true);
    //       groups.add(grp);
    //     } catch (e) {
    //       print('Error group id $id : $e');
    //     }
    //   }
    //   // await ChatClient.getInstance.groupManager.getGroupWithId(groupId)
    // }

    for (ChatGroup group in groups) {
      GroupConversationModel model;

      try {
        final grp = await ChatClient.getInstance.groupManager
            .fetchGroupInfoFromServer(group.groupId, fetchMembers: true);

        final conv = await ChatClient.getInstance.chatManager
            .getConversation(grp.groupId, type: ChatConversationType.GroupChat);
        if (conv == null) continue;
        final lastMessage = await conv.latestMessage();

        model = GroupConversationModel(
            id: grp.groupId,
            badgeCount: await conv.unreadCount(),
            groupInfo: grp,
            conversation: conv,
            lastMessage: lastMessage,
            image: getGroupImage(grp));
      } catch (e) {
        continue;
      }
      conversations.add(model);
    }
    return conversations;
  }

  static String getGroupImage(ChatGroup group) {
    final ext = group.extension;
    String? image;
    if (ext?.isNotEmpty == true) {
      // print('ext : ${group.extension} - ${group.name}');
      final map = jsonDecode(ext!);
      image = map['image'];
    }
    return image ?? '';
  }

  static Future chageGroupMuteStateFor(String userId, bool mute) async {
    try {
      final chatparam = ChatSilentModeParam.remindType(
          mute ? ChatPushRemindType.ALL : ChatPushRemindType.NONE);
      await ChatClient.getInstance.pushManager.setConversationSilentMode(
        conversationId: userId,
        param: chatparam,
        type: ChatConversationType.GroupChat,
      );
      // return result.remindType ?? ChatPushRemindType.ALL;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
  }

  static Future<ChatPushRemindType> fetchGroupMuteStateFor(
      String userId) async {
    try {
      final result = await ChatClient.getInstance.pushManager
          .fetchConversationSilentMode(
              conversationId: userId, type: ChatConversationType.GroupChat);
      ChatPushRemindType? remindType = result.remindType;
      // print('mute style  ${remindType?.name ?? 'UNKNOWN'}');
      return remindType ?? ChatPushRemindType.ALL;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
    return ChatPushRemindType.ALL;
  }

  static Future deleteGroup(String groupId) async {
    try {
      await ChatClient.getInstance.groupManager.destroyGroup(groupId);
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
  }

  static Future<bool> isGroupBlocked(String groupId) async {
    try {
      return (await ChatClient.getInstance.groupManager.getGroupWithId(groupId))
              ?.messageBlocked ??
          false;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
    return false;
  }

  static Future blockGroup(String groupId) async {
    try {
      await ChatClient.getInstance.groupManager.blockGroup(groupId);
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
  }

  static Future unBlockGroup(String groupId) async {
    try {
      await ChatClient.getInstance.groupManager.unblockGroup(groupId);
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
  }

  // static searchGroup(String term) async {
  //   try {
  //     final list = await ChatClient.getInstance.groupManager
  //         .fetchPublicGroupsFromServer();
  //         if(list.data.isNotEmpty==true){
  //           for()
  //         }
  //   } on ChatError catch (e) {
  //     print('Error: ${e.code}- ${e.description} ');
  //   } catch (e) {
  //     print('Error2: ${e} ');
  //   }
  // }
  static Future<List<ChatGroupInfo>> fetchPublicGroups() async {
    try {
      final list = await ChatClient.getInstance.groupManager
          .fetchPublicGroupsFromServer();
      if (list.data.isNotEmpty == true) {
        return list.data;
      }
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
    return [];
  }

  static Future addPublicGroup(String groupId) async {
    try {
      await ChatClient.getInstance.groupManager.joinPublicGroup(groupId);
      return null;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
      // return  '${e.code}- ${e.description} ';
    } catch (e) {
      print('Error2: ${e} ');
      // return  'Error while joining group';
    }
    return 'Error while joining group';
  }

  static Future<List<ChatGroup>> loadPublicGroupsInfo(
      List<String> items) async {
    try {
      final List<ChatGroup> infos = [];
      for (var groupId in items) {
        infos.add(await ChatClient.getInstance.groupManager
            .fetchGroupInfoFromServer(groupId));
      }
      return infos;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
    return [];
  }

  // static Future<List<Contacts>> loadGroupMemebers(
  //     ChatGroup groupInfo, WidgetRef ref) async {
  //   final groups = groupInfo.memberList ?? [];
  //   if (groups.isNotEmpty) {
  //     final List<Contacts> empty = [];
  //     final list = ref
  //         .read(groupMembersList(groups.join(',')))
  //         .maybeWhen(orElse: () => empty);
  //     return list;
  //   }
  //   return [];
  // }
}
