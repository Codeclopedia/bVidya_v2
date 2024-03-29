import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/helpers/duration.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';

import '/core/helpers/extensions.dart';
import '/core/utils.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
// import '/core/helpers/duration.dart';

import '/core/state.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';
import '/data/repository/bchat_respository.dart';

// import 'providers/bchat/chat_conversation_provider.dart';
import 'providers/bchat/contact_list_provider.dart';
import 'providers/bchat/group_call_provider.dart';
import 'providers/bchat/groups_conversation_provider.dart';
// import 'providers/p2p_call_provider.dart';
// import 'providers/chat_messagelist_provider.dart';

final apiBChatProvider =
    Provider<BChatApiService>((_) => BChatApiService.instance);

//Loading Previous Chat
final chatLoadingPreviousProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

//Loading Previous Chat
final chatHasMoreOldMessageProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

final loadingChatProvider = StateProvider<bool>(
  (_) => true,
);

//Chat API CALLS

final bChatProvider = Provider<BChatRepository>((ref) {
  User? user = ref.read(loginRepositoryProvider).user;
  return BChatRepository(
    ref.read(apiBChatProvider),
    user?.authToken ?? '',
  );
});

final searchQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final searchQueryGroupProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final searchChatContact =
    FutureProvider.autoDispose<List<SearchContactResult>>((ref) async {
  final term = ref.watch(searchQueryProvider).trim();
  User? user = ref.read(loginRepositoryProvider).user;
  if (term.isNotEmpty && user != null) {
    final result = await ref.read(bChatProvider).searchContact(term);
    // if (result?.contacts?.isNotEmpty == true) {
    return result?.contacts?.where((e) => e.userId != user.id).toList() ?? [];
    // }
    // return [];
  } else {
    return [];
  }
});

// final publicGroupList = FutureProvider<List<ChatGroupInfo>>(
//     (ref) => BchatGroupManager.fetchPublicGroups());

final searchTermGroupProvider =
    FutureProvider.autoDispose<List<GroupConversationModel>>((ref) {
  final term = ref.watch(searchQueryGroupProvider).trim();
  final list = ref.watch(groupConversationProvider);
  if (term.isNotEmpty && list.isNotEmpty) {
    final items = list.where((element) {
      if (element.groupInfo.name?.isNotEmpty == true) {
        return element.groupInfo.name!
            .toLowerCase()
            .contains(term.toLowerCase());
      }
      return false;
    })
        // .map((e) => e.id)
        .toList();
    return items;
    // return BchatGroupManager.loadPublicGroupsInfo(items);
  } else {
    return [];
  }
});

// final searchGroupProvider = FutureProvider.autoDispose<List<ChatGroup>>((ref) {
//   final term = ref.watch(searchQueryGroupProvider).trim();
//   final list = ref.watch(publicGroupList).valueOrNull;
//   if (term.isNotEmpty && list != null) {
//     final items = list
//         .where((element) {
//           if (element.name?.isNotEmpty == true) {
//             return element.name!.contains(term);
//           }
//           return false;
//         })
//         .map((e) => e.groupId)
//         .toList();
//     return BchatGroupManager.loadPublicGroupsInfo(items);
//   } else {
//     return [];
//   }
// });

// final myContactsList = FutureProvider<List<Contacts>>((ref) async {
//   // final ids = await BChatContactManager.getContacts();
//   // final contacts = await ref.read(bChatProvider).getContactsByIds(ids);
//   return ref.watch(chatConversationProvider.select((value) => value.contacts));
// });

// final groupMembersList =
//     FutureProvider.family<List<Contacts>, String>((ref, ids) async {
//   final contacts = await ref.read(bChatProvider).getContactsByIds(ids);
//   return contacts ?? [];
// });

// final groupUsersList = FutureProvider.autoDispose
//     .family<List<Contacts>, ChatGroup>((ref, grp) async {
//   final contacts = await ref.read(bChatProvider).getGroupsMembersOnly(grp);
//   return contacts ?? [];
// });

final groupMembersInfo = FutureProvider.family
    .autoDispose<GroupMeberInfo?, String>((ref, groupId) async {
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
      final userId = (await getMeAsUser())!.id.toString();
      final contacts = await ref.read(bChatProvider).getContactsByIds(userIds);
      return GroupMeberInfo(
          contacts
                  ?.map((e) => Contacts.fromContact(e, ContactStatus.group))
                  .toList() ??
              [],
          info,
          userId);
    }
  } catch (e) {
    // print('error in loading members of $groupId');
  }
  return null;
});

final groupMediaProvier = FutureProvider.autoDispose
    .family<List<ChatGroupSharedFileEx>, String>((ref, groupId) async {
  final list = await ChatClient.getInstance.groupManager
      .fetchGroupFileListFromServer(groupId);
  final List<ChatGroupSharedFileEx> results = [];
  if (list.isNotEmpty) {
    // print('file list count ${results.length} ');
    int count = 0;
    for (var fId in list) {
      if (fId.fileId != null) {
        if (count < 3) {
          File file =
              File('${Directory.systemTemp.path}/${groupId}_${fId.fileId}');
          await ChatClient.getInstance.groupManager.downloadGroupSharedFile(
              groupId: groupId, fileId: fId.fileId!, savePath: file.path);
          count++;
          results.add(ChatGroupSharedFileEx(file, fId));
        } else {
          results.add(ChatGroupSharedFileEx(null, fId));
        }
      }
    }
  }

  return results;
});

// final chatContactsList =
//     FutureProvider.autoDispose<List<Contacts>>((ref) async {
//   final result = await ref.read(bChatProvider).getContacts();
//   return result?.contacts ?? [];
//   // if (result?.contacts?.isNotEmpty == true) {
//   // }
//   // return [];
// });

// final chatUnreadCount = FutureProvider((ref) => Chat,)

final groupUnreadCountProvider = FutureProvider<int>((ref) {
  return BchatGroupManager.getGroupUnreadCount();
});

final chatImageFiles = FutureProvider.autoDispose
    .family<List<ChatMediaFile>, String>((ref, convId) async {
  return BChatContactManager.loadMediaFiles(convId);
});

class GroupMeberInfo {
  final List<Contacts> members;
  final ChatGroup group;
  final String userId;
  GroupMeberInfo(this.members, this.group, this.userId);
}

class ForwardModel {
  final String id;
  final String name;
  final String image;
  final ChatType chatType;

  ForwardModel(this.id, this.name, this.image, this.chatType);
}

final forwardListProvider = FutureProvider.autoDispose
    .family<List<ForwardModel>, String>((ref, id) async {
  final List<Contacts> contacts = ref.watch(contactListProvider);
  final List<ChatGroup> groups = ref
          .watch(joinedGroupsListProvier)
          .valueOrNull ??
      [] as List<ChatGroup>; //.maybeWhen(orElse: () => [] as List<ChatGroup>);
  final List<ForwardModel> results = [];

  for (var contact in contacts) {
    if (contact.userId.toString() == id) continue;
    final model = ForwardModel(contact.userId.toString(), contact.name,
        contact.profileImage, ChatType.Chat);
    results.add(model);
  }
  for (var grp in groups) {
    if (grp.groupId == id) continue;
    final model = ForwardModel(grp.groupId.toString(), grp.name ?? '',
        BchatGroupManager.getGroupImage(grp), ChatType.GroupChat);
    results.add(model);
  }
  return results;
});

final joinedGroupsListProvier = FutureProvider<List<ChatGroup>>((ref) {
  return BchatGroupManager.loadGroupList();
});

final commonGroupsProvider = FutureProvider.family
    .autoDispose<List<ChatGroup>, String>((ref, contactId) async {
  List<ChatGroup> groupList = [];
  final list = ref.read(groupConversationProvider);
  if (list.isNotEmpty) {
    for (var item in list) {
      print(
          'members:${item.groupInfo.memberList?.join(',')} -- ${item.groupInfo.owner}');
      if (item.groupInfo.memberList?.contains(contactId) == true ||
          item.groupInfo.owner == contactId) {
        groupList.add(item.groupInfo);
      }
    }
  } else {
    final groups = ref.watch(joinedGroupsListProvier).valueOrNull;
    if (groups?.isNotEmpty == true) {
      for (var item in groups!) {
        List<String> members = item.memberList ?? [];
        if (members.isEmpty) {
          item = await ChatClient.getInstance.groupManager
              .fetchGroupInfoFromServer(item.groupId, fetchMembers: true);
          members = item.memberList ?? [];
        }
        print('members2:${members.join(',')}   -- ${item.owner}');
        if (members.contains(contactId) == true || item.owner == contactId) {
          groupList.add(item);
        }
      }
    }
  }
  return groupList;
});

final groupCallTimerProvider =
    StateNotifierProvider.autoDispose<DurationNotifier, DurationModel>(
  (_) => DurationNotifier(),
);

final bGroupCallChangeProvider =
    ChangeNotifierProvider.autoDispose<GroupCallProvider>(
        (ref) => GroupCallProvider(ref.read(groupCallTimerProvider.notifier)));
