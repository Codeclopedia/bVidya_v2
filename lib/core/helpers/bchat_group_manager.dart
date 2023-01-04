import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/controller/bchat_providers.dart';
import '/core/state.dart';
import '../../data/models/models.dart';

class BchatGroupManager {
  BchatGroupManager._();
  static Future<ChatGroup?> createNewGroup(
      String name, String? desc, List<String> ids, String image) async {
    try {
      ChatGroup group = await ChatClient.getInstance.groupManager.createGroup(
          groupName: name,
          desc: desc,
          inviteMembers: ids,
          options:
              ChatGroupOptions(style: ChatGroupStyle.PrivateOnlyOwnerInvite));

      Map<String, dynamic> ext = {'image': image};
      await ChatClient.getInstance.groupManager
          .updateGroupExtension(group.groupId, jsonEncode(ext));
      return group;
    } catch (e) {
      print('Error creating group $e');
    }
    return null;
  }

  static Future<List<GroupConversationModel>> loadGroupConversationsList(
      {bool firstTime = false}) async {
    List<GroupConversationModel> conversations = [];
    List<ChatGroup> groups = [];
    try {
      // groups = await ChatClient.getInstance.groupManager.getJoinedGroups();
      // if (groups.isEmpty) {
      groups = await ChatClient.getInstance.groupManager
          .fetchJoinedGroupsFromServer();
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
      final map = jsonDecode(ext!);
      image = map['image'];
    }
    return image ?? '';
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
