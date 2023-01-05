import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/helpers/bchat_group_manager.dart';
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

  Future init() async {
    _groupConversationMap.clear();
    final list = await BchatGroupManager.loadGroupConversationsList();
    for (var item in list) {
      _groupConversationMap.addAll({item.id: item});
    }
    notifyListeners();
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
    notifyListeners();
  }

  Future updateConversationMessage(ChatMessage lastMessage, String groupId) async {
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
    // notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
