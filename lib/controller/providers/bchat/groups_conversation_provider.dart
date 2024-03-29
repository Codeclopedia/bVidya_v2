import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../bchat_providers.dart';
import '/core/utils/chat_utils.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';
import '/core/state.dart';
import '/data/models/models.dart';

// final groupConversationProvider =
//     ChangeNotifierProvider((ref) => GroupConversationChangeProvider.instance);

final groupLoadingStateProvider = StateProvider<bool>((ref) => false);

final groupConversationProvider = StateNotifierProvider<
    GroupConversationChangeNotifier,
    List<GroupConversationModel>>((ref) => GroupConversationChangeNotifier());

class GroupConversationChangeNotifier
    extends StateNotifier<List<GroupConversationModel>> {
  GroupConversationChangeNotifier() : super([]);
  final Map<String, GroupConversationModel> _groupConversationMap = {};
  bool _isLoading = false;

  Future setup() async {
    if (_isLoading) return;
    _isLoading = true;
    _groupConversationMap.clear();
    final list = await BchatGroupManager.loadGroupConversationsList();
    for (var item in list) {
      _groupConversationMap.addAll({item.id: item});
    }
    _isLoading = false;
    state = _groupConversationMap.values.toList();
  }

  Future<GroupConversationModel?> getGroupConversation(String groupId) async {
    return _groupConversationMap[groupId] ??
        (await getGroupConversationModel(groupId));
  }

  Future<GroupConversationModel?> addConveration(ChatGroup grp) async {
    GroupConversationModel model;
    try {
      final conv = await ChatClient.getInstance.chatManager
          .getConversation(grp.groupId, type: ChatConversationType.GroupChat);
      if (conv == null) return null;
      final lastMessage = await conv.latestMessage();

      model = GroupConversationModel(
          id: grp.groupId,
          badgeCount: await conv.unreadCount(),
          groupInfo: grp,
          conversation: conv,
          lastMessage: lastMessage,
          image: BchatGroupManager.getGroupImage(grp),
          mute: await BchatGroupManager.isGroupMuteStateFor(grp.groupId));
    } catch (e) {
      return null;
    }
    _groupConversationMap.addAll({grp.groupId: model});
    // notifyListeners();
    state = _groupConversationMap.values.toList();
    return model;
  }

  Future updateConversation(ChatGroup grp) async {
    GroupConversationModel model;
    try {
      final conv = await ChatClient.getInstance.chatManager
          .getConversation(grp.groupId, type: ChatConversationType.GroupChat);
      if (conv == null) return;
      final lastMessage = await conv.latestMessage();

      model = GroupConversationModel(
          id: grp.groupId,
          badgeCount: await conv.unreadCount(),
          groupInfo: grp,
          conversation: conv,
          lastMessage: lastMessage,
          image: BchatGroupManager.getGroupImage(grp),
          mute: await BchatGroupManager.isGroupMuteStateFor(grp.groupId));
    } catch (e) {
      return;
    }
    _groupConversationMap.update(grp.groupId, (v) => model,
        ifAbsent: () => model);
    // notifyListeners();
    state = _groupConversationMap.values.toList();
  }

  Future updateConversationMessage(ChatMessage lastMessage, String groupId,
      {bool update = false}) async {
    try {
      final model = _groupConversationMap[groupId];
      if (model != null) {
        final newModel = GroupConversationModel(
            id: groupId,
            badgeCount: await model.conversation?.unreadCount() ?? 0,
            groupInfo: model.groupInfo,
            conversation: model.conversation,
            lastMessage: lastMessage,
            image: model.image,
            mute: model.mute);
        // model.lastMessage = (GroupConversationModel);
        _groupConversationMap.update(groupId, (v) => newModel,
            ifAbsent: () => newModel);
      } else {
        final grp = await ChatClient.getInstance.groupManager
            .fetchGroupInfoFromServer(groupId, fetchMembers: true);
        await addConveration(grp);
      }
    } catch (e) {
      return;
    }
    state = _groupConversationMap.values.toList();

    //
  }

  void updateConversationOnly(String groupId) async {
    final model = _groupConversationMap[groupId];
    if (model != null) {
      final newModel = GroupConversationModel(
          id: groupId,
          groupInfo: model.groupInfo,
          conversation: model.conversation,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          lastMessage: await model.conversation?.latestMessage(),
          image: model.image,
          mute: model.mute);
      _groupConversationMap.update(groupId, (v) => newModel,
          ifAbsent: () => newModel);
    }
    state = _groupConversationMap.values.toList();
    // notifyListeners();
  }

  Future<GroupConversationModel?> addConversationOnly(String groupId) async {
    final model = _groupConversationMap[groupId];
    if (model == null) {
      final grp = await ChatClient.getInstance.groupManager
          .fetchGroupInfoFromServer(groupId, fetchMembers: true);
      return await addConveration(grp);
    }
    return model;
    // notifyListeners();
  }

  // void update() {
  //   // notifyListeners();
  // }

  Future removeEntry(String groupId) async {
    _groupConversationMap.remove(groupId);
    state = _groupConversationMap.values.toList();
  }

  Future delete(String groupId) async {
    await BchatGroupManager.deleteGroup(groupId);
    _groupConversationMap.remove(groupId);
    state = _groupConversationMap.values.toList();
  }

  // Future leave(String groupId) async {
  //   try {
  //     // await ChatClient.getInstance.groupManager.leaveGroup(groupId);
  //     _groupConversationMap.remove(groupId);
  //     state = _groupConversationMap.values.toList();
  //     return null;
  //   } catch (e) {
  //     return 'Error in leaving group';
  //   }
  // }

  void reset(WidgetRef ref) async {
    // print('Loading groups $_isLoading');
    if (_isLoading) return;
    _isLoading = true;
    // ref.read(groupLoadingStateProvider.notifier).state = _isLoading;
    _groupConversationMap.clear();

    final list = await BchatGroupManager.loadGroupConversationsList();
    for (var item in list) {
      _groupConversationMap.addAll({item.id: item});
    }
    _isLoading = false;
    // ref.read(groupLoadingStateProvider.notifier).state = _isLoading;
    // print('Loaded groups : ${list.length}');
    state = _groupConversationMap.values.toList();
    ref.invalidate(groupUnreadCountProvider); //Reset Group Unread count
  }

  void update() {
    state = _groupConversationMap.values.toList();
  }

  void deleteConversationOnly(String groupId) {
    _groupConversationMap.remove(groupId);
    state = _groupConversationMap.values.toList();
  }

  void clear() {
    _groupConversationMap.clear();
    state = [];
  }

  Future updateConversationMute(String groupId) async {
    final model = _groupConversationMap[groupId];
    if (model != null) {
      final newModel = GroupConversationModel(
          id: groupId,
          groupInfo: model.groupInfo,
          conversation: model.conversation,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          lastMessage: await model.conversation?.latestMessage(),
          image: model.image,
          mute: await BchatGroupManager.isGroupMuteStateFor(groupId));
      _groupConversationMap.update(groupId, (v) => newModel,
          ifAbsent: () => newModel);
    }
    state = _groupConversationMap.values.toList();
  }
}

// class GroupConversationChangeProvider extends ChangeNotifier {
//   static GroupConversationChangeProvider instance =
//       GroupConversationChangeProvider._();
//   GroupConversationChangeProvider._();

//   final Map<String, GroupConversationModel> _groupConversationMap = {};

//   List<GroupConversationModel> get groupConversationList =>
//       _groupConversationMap.values.toList();

//   bool _isLoading = true;

//   bool get isLoading => _isLoading;

//   // bool _initialized = false;

//   Future setup() async {
//     _groupConversationMap.clear();
//     final list = await BchatGroupManager.loadGroupConversationsList();
//     for (var item in list) {
//       _groupConversationMap.addAll({item.id: item});
//     }
//     _isLoading = false;
//   }

//   // Future init() async {
//   //   // if (_initialized) {
//   //   //   return;
//   //   // }
//   //   _initialized = true;
//   //   _isLoading = true;
//   //   _groupConversationMap.clear();
//   //   final list = await BchatGroupManager.loadGroupConversationsList();
//   //   for (var item in list) {
//   //     _groupConversationMap.addAll({item.id: item});
//   //   }
//   //   _isLoading = false;
//   //   notifyListeners();
//   // }

//   Future<GroupConversationModel?> getGroupConversation(String groupId) async {
//     return _groupConversationMap[groupId] ??
//         (await getGroupConversationModel(groupId));
//   }

//   Future addConveration(ChatGroup grp) async {
//     GroupConversationModel model;
//     try {
//       final conv = await ChatClient.getInstance.chatManager
//           .getConversation(grp.groupId, type: ChatConversationType.GroupChat);
//       if (conv == null) return;
//       final lastMessage = await conv.latestMessage();

//       model = GroupConversationModel(
//           id: grp.groupId,
//           badgeCount: await conv.unreadCount(),
//           groupInfo: grp,
//           conversation: conv,
//           lastMessage: lastMessage,
//           image: BchatGroupManager.getGroupImage(grp));
//     } catch (e) {
//       return;
//     }
//     _groupConversationMap.addAll({grp.groupId: model});
//     // notifyListeners();
//   }

//   Future updateConversation(ChatGroup grp) async {
//     GroupConversationModel model;
//     try {
//       final conv = await ChatClient.getInstance.chatManager
//           .getConversation(grp.groupId, type: ChatConversationType.GroupChat);
//       if (conv == null) return;
//       final lastMessage = await conv.latestMessage();

//       model = GroupConversationModel(
//           id: grp.groupId,
//           badgeCount: await conv.unreadCount(),
//           groupInfo: grp,
//           conversation: conv,
//           lastMessage: lastMessage,
//           image: BchatGroupManager.getGroupImage(grp));
//     } catch (e) {
//       return;
//     }
//     _groupConversationMap.update(grp.groupId, (v) => model,
//         ifAbsent: () => model);
//     // notifyListeners();
//   }

//   Future updateConversationMessage(ChatMessage lastMessage, String groupId,
//       {bool update = false}) async {
//     try {
//       final model = _groupConversationMap[groupId];
//       if (model != null) {
//         final newModel = GroupConversationModel(
//             id: groupId,
//             badgeCount: await model.conversation?.unreadCount() ?? 0,
//             groupInfo: model.groupInfo,
//             conversation: model.conversation,
//             lastMessage: lastMessage,
//             image: model.image);
//         // model.lastMessage = (GroupConversationModel);
//         _groupConversationMap.update(groupId, (v) => newModel,
//             ifAbsent: () => newModel);
//       } else {
//         final grp = await ChatClient.getInstance.groupManager
//             .fetchGroupInfoFromServer(groupId, fetchMembers: true);
//         await addConveration(grp);
//       }
//     } catch (e) {
//       return;
//     }
//     if (update) {
//       notifyListeners();
//     }
//     //
//   }

//   void updateConversationOnly(String groupId) async {
//     final model = _groupConversationMap[groupId];
//     if (model != null) {
//       // await model.conversation?.markAllMessagesAsRead();
//       final newModel = GroupConversationModel(
//           id: groupId,
//           groupInfo: model.groupInfo,
//           conversation: model.conversation,
//           badgeCount: await model.conversation?.unreadCount() ?? 0,
//           lastMessage: await model.conversation?.latestMessage(),
//           image: model.image);
//       // model.lastMessage = (GroupConversationModel);
//       _groupConversationMap.update(groupId, (v) => newModel,
//           ifAbsent: () => newModel);
//     }
//     notifyListeners();
//   }

//   void update() {
//     notifyListeners();
//   }

//   Future delete(String groupId) async {
//     await BchatGroupManager.deleteGroup(groupId);
//     _groupConversationMap.remove(groupId);
//   }

//   Future remove(String groupId) async {
//     final model = _groupConversationMap.remove(groupId);
//   }

//   @override
//   void dispose() {
//     // _initialized = false;

//     _isLoading = false;

//     _groupConversationMap.clear();

//     super.dispose();
//   }
// }
