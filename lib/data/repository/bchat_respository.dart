// ignore_for_file: avoid_print

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../models/models.dart';
import '../services/bchat_api_service.dart';

class BChatRepository {
  static const successfull = 'success';

  final BChatApiService api;
  final String token;
  BChatRepository(this.api, this.token);

  Future<SearchContactBody?> searchContact(String term) async {
    final result = await api.searchContact(token, term);
    if (result.status == successfull) {
      return result.body;
    }
    return null;
  }

  Future<String?> addContact(SearchContactResult contact) async {
    final result = await api.addContact(token, contact.userId!.toString());
    if (result.status == successfull) {
      return null;
    }
    return result.message ?? 'Error while adding to contact';
  }

  Future<ContactsBody?> getContacts() async {
    final result = await api.getContacts(token);
    if (result.status == successfull) {
      return result.body;
    }
    return null;
  }

  Future<List<Contact>?> getContactsByIds(String userIds) async {
    final result = await api.getContactsByIds(token, userIds);
    if (result.status == successfull) {
      return result.body?.contacts ?? [];
    }
    return null;
  }

  Future<List<Contact>?> getGroupsMembersOnly(ChatGroup group) async {
    List<String> membersIds = group.memberList ?? [];
    if (membersIds.isEmpty) {
      // print('loading members: ${membersIds.join(',')} - $ownerId');
      try {
        final users = await ChatClient.getInstance.groupManager
            .fetchMemberListFromServer(group.groupId);
        for (var u in users.data) {
          membersIds.add(u);
        }
        // adminIds = group.adminList ?? [];
      } catch (e) {
        print('error in loading members of ${group.name}');
      }
    }
    return await getContactsByIds(membersIds.join(','));
  }

  Future<List<Contact>?> getGroupsMembers(ChatGroup group) async {
    String groupId = group.groupId;
    String ownerId = group.owner ?? '';

    List<String> membersIds = group.memberList ?? [];
    List<String> adminIds = group.adminList ?? [];

    if (membersIds.isEmpty || adminIds.isEmpty || ownerId.isEmpty) {
      try {
        ChatGroup grp = await ChatClient.getInstance.groupManager
            .fetchGroupInfoFromServer(groupId, fetchMembers: true);
        print('loading members: ${membersIds.join(',')} - $ownerId');
        membersIds = grp.memberList ?? [];
        adminIds = grp.adminList ?? [];

        print(' list of size  m:${membersIds.length} - a:${adminIds.length} ');
      } catch (e) {
        print('error in loading members of ${group.name}');
      }
    }

    if (membersIds.isEmpty || adminIds.isEmpty) {
      // print('loading members: ${membersIds.join(',')} - $ownerId');
      try {
        final users = await ChatClient.getInstance.groupManager
            .fetchMemberListFromServer(groupId);
        for (var u in users.data) {
          membersIds.add(u);
        }
        // adminIds = group.adminList ?? [];
      } catch (e) {
        print('error in loading members of ${group.name}');
      }
    }
    if (adminIds.isEmpty) {
      adminIds.add(ownerId);
      print('loaded members of ${adminIds.length} - ${membersIds.length}');
      // return null;
    }

    print('loading user: ${membersIds.join(',')} - $ownerId');
    final result =
        await api.getGroupUsers(token, membersIds, ownerId, adminIds, groupId);
    if (result.status == successfull) {
      return result.body?.contacts ?? [];
    }
    return null;
  }

  Future<String?> uploadImage(File file) async {
    final result = await api.uploadImage(token, file);
    // if (result.status == successfull) {
    //   return result.body?.source;
    // }
    return result.body?.source;
  }

  // getGroupMediaList(ChatGroup groupInfo) {}
}
