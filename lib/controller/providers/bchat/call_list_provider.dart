import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/data/models/call_message_body.dart';
import '/core/sdk_helpers/bchat_call_manager.dart';
import '/core/state.dart';

final callListProvider =
    StateNotifierProvider<CallMessageNotifier, List<CallListModel>>(
        (ref) => CallMessageNotifier());

final groupCallListProvider =
    StateNotifierProvider<GroupCallMessageNotifier, List<GroupCallListModel>>(
        (ref) => GroupCallMessageNotifier());

class CallMessageNotifier extends StateNotifier<List<CallListModel>> {
  CallMessageNotifier() : super([]); //listMessages.reversed.toList()

  final Map<String, CallListModel> _callListMap = {};
  bool _loading = false;

  // CallListModel? getLast() {
  //   if (state.isEmpty) return null;
  //   return state[0];
  //   // return state[length - 1];
  // }

  void addCall(CallListModel message) {
    // state = [...state, todo];
    _callListMap.addAll({message.body.callId: message});
    state = _callListMap.values.toList();
  }

  void addMessage(ChatMessage m) {
    if (m.body.type == MessageType.CUSTOM) {
      try {
        ChatCustomMessageBody body = m.body as ChatCustomMessageBody;
        final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
        CallListModel model = CallListModel(m.to.toString(), callBody.toName,
            callBody.toImage, true, m.serverTime, m.msgId, callBody);
        _callListMap.addAll({callBody.callId: model});
      } catch (_) {}
      state = _callListMap.values.toList();
    }
  }

  void remove(CallListModel message) {
    _callListMap.remove(message.body.callId);
    state = _callListMap.values.toList();

    // List<CallListModel> newState = [];
    // for (var c in state) {
    //   if (c.body.callId != message.body.callId) {
    //     newState.add(c);
    //   }
    // }
    // state = newState;
    // state = [...state, todo];
  }

  Future delete(CallListModel message) async {
    try {
      await (await ChatClient.getInstance.chatManager
              .getConversation(message.userId, createIfNeed: false))
          ?.deleteMessage(message.msgId);
      remove(message);
    } catch (e) {}
  }

  void clear() {
    _callListMap.clear();
    state = [];
  }

  Future setup() async {
    if (_loading) return;
    _loading = true;
    _callListMap.clear();
    final calls = await getCallList();
    _callListMap.addAll({...calls});
    state = _callListMap.values.toList();
    _loading = false;
    // ref.read(callListLoading.notifier).state = false;
  }
}

class GroupCallMessageNotifier extends StateNotifier<List<GroupCallListModel>> {
  GroupCallMessageNotifier() : super([]); //listMessages.reversed.toList()

  final Map<String, GroupCallListModel> _callListMap = {};
  bool _loading = false;

  // CallListModel? getLast() {
  //   if (state.isEmpty) return null;
  //   return state[0];
  //   // return state[length - 1];
  // }

  void addCall(GroupCallListModel message) {
    // state = [...state, todo];
    _callListMap.addAll({message.body.callId: message});
    state = _callListMap.values.toList();
  }

  void remove(GroupCallListModel message) {
    _callListMap.remove(message.body.callId);
    state = _callListMap.values.toList();

    // List<CallListModel> newState = [];
    // for (var c in state) {
    //   if (c.body.callId != message.body.callId) {
    //     newState.add(c);
    //   }
    // }
    // state = newState;
    // state = [...state, todo];
  }

  void addMessage(ChatMessage m) {
    if (m.body.type == MessageType.CUSTOM) {
      ChatCustomMessageBody body = m.body as ChatCustomMessageBody;
      final callBody = GroupCallMessegeBody.fromJson(jsonDecode(body.event));
      GroupCallListModel model = GroupCallListModel(
          m.to.toString(),
          callBody.groupName,
          callBody.groupImage,
          true,
          m.serverTime,
          m.msgId,
          callBody);
      _callListMap.addAll({callBody.callId: model});
      state = _callListMap.values.toList();
    }
  }

  Future delete(GroupCallListModel message) async {
    try {
      await (await ChatClient.getInstance.chatManager
              .getConversation(message.groupId, createIfNeed: false))
          ?.deleteMessage(message.msgId);
      remove(message);
    } catch (e) {}
  }

  void clear() {
    _callListMap.clear();
    state = [];
  }

  Future setup() async {
    if (_loading) return;
    _loading = true;
    _callListMap.clear();
    _callListMap.addAll({...await getGroupCallList()});
    state = _callListMap.values.toList();
    _loading = false;
  }
}
