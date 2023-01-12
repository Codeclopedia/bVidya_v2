import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/sdk_helpers/bchat_group_manager.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

final groupConversationProvider =
    ChangeNotifierProvider((ref) => GroupConversationChangeProvider.instance);

class GroupConversationChangeProvider extends ChangeNotifier {
  static GroupConversationChangeProvider instance =
      GroupConversationChangeProvider._();
  GroupConversationChangeProvider._();

  final Map<String, GroupConversationModel> _groupConversationMap = {};

  List<GroupConversationModel> get groupConversationList =>
      _groupConversationMap.values.toList();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  // bool _initialized = false;

  Future init() async {
    // if (_initialized) {
    //   return;
    // }
    // _initialized = true;
    _groupConversationMap.clear();
    final list = await BchatGroupManager.loadGroupConversationsList();
    for (var item in list) {
      _groupConversationMap.addAll({item.id: item});
    }
    _isLoading = false;
    notifyListeners();
  }

  Future addConveration(ChatGroup grp) async {
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
          image: BchatGroupManager.getGroupImage(grp));
    } catch (e) {
      return;
    }
    _groupConversationMap.addAll({grp.groupId: model});
    // notifyListeners();
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
          image: BchatGroupManager.getGroupImage(grp));
    } catch (e) {
      return;
    }
    _groupConversationMap.update(grp.groupId, (v) => model,
        ifAbsent: () => model);
    // notifyListeners();
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
            image: model.image);
        // model.lastMessage = (GroupConversationModel);
        _groupConversationMap.update(groupId, (v) => newModel,
            ifAbsent: () => newModel);
      } else {
        final grp = await ChatClient.getInstance.groupManager
            .fetchGroupInfoFromServer(groupId, fetchMembers: true);
        addConveration(grp);
      }
    } catch (e) {
      return;
    }
    if (update) {
      notifyListeners();
    }
    //
  }

  void updateConversationOnly(String groupId) async {
    final model = _groupConversationMap[groupId];
    if (model != null) {
      // await model.conversation?.markAllMessagesAsRead();
      final newModel = GroupConversationModel(
          id: groupId,
          groupInfo: model.groupInfo,
          conversation: model.conversation,
          badgeCount: await model.conversation?.unreadCount() ?? 0,
          lastMessage: await model.conversation?.latestMessage(),
          image: model.image);
      // model.lastMessage = (GroupConversationModel);
      _groupConversationMap.update(groupId, (v) => newModel,
          ifAbsent: () => newModel);
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  Future delete(String groupId) async {
    await BchatGroupManager.deleteGroup(groupId);
     _groupConversationMap.remove(groupId);
  }


  Future remove(String groupId) async {
    final model = _groupConversationMap.remove(groupId);
  }

  @override
  void dispose() {
    // _initialized = false;
    _groupConversationMap.clear();

    super.dispose();
  }
}
