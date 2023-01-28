import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'dart:async';
import 'dart:convert';
import '../state.dart';

class GroupTypingUser {
  final String userId;
  final String name;
  final String profile;
  final int startTime;
  // final Timer? timer;
  GroupTypingUser(this.userId, this.name, this.profile, this.startTime);
}

final groupTypingUsersProvider = StateNotifierProvider.family<GroupTypingHelper,
    List<GroupTypingUser>, String>((ref, to) => GroupTypingHelper(to));

class GroupTypingHelper extends StateNotifier<List<GroupTypingUser>> {
  String to;
  GroupTypingHelper(this.to) : super([]);
  Timer? _timer;
  final Map<String, GroupTypingUser> _groupUsersMap = {};
  int _previousChangedTimeStamp = 0;

  void textChange(String id, String name, String image) {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - _previousChangedTimeStamp > 5000) {
      _sendBeginTyping(id, name, image);
      _previousChangedTimeStamp = currentTimestamp;
    }
  }

  void _sendBeginTyping(String id, String name, String image) async {
    try {
      final map = {
        // 'action': TypingCommand.typingStart.name,
        'd': id,
        'n': name,
        'i': image
      };
      final msg = ChatMessage.createCmdSendMessage(
        targetId: to,
        action: jsonEncode(map),
        deliverOnlineOnly: true,
      );
      msg.chatType = ChatType.GroupChat;
      ChatClient.getInstance.chatManager.sendMessage(msg);
    } catch (e) {}
  }

  void onReceiveCommandMessage(List<ChatCmdMessageBody> chats) {
    final users = [];
    for (var msg in chats) {
      if (msg.action.isNotEmpty) {
        final map = jsonDecode(msg.action);
        print('user=> ${map}');
        final user = GroupTypingUser(map['d'], map['n'], map['i'],
            DateTime.now().millisecondsSinceEpoch);
        _groupUsersMap.addAll({user.userId: user});
      }
    }

    // print('received command');
    for (var user in users) {
      user.startTime = DateTime.now().millisecondsSinceEpoch;
      _groupUsersMap.addAll({user._groupId: user});
    }
    state = _groupUsersMap.values.toList();
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        cancelTimer();
      },
    );
  }

  void removeTyping(String? userId) {
    if (userId == null) return;
    if (_groupUsersMap.containsKey(userId)) {
      _groupUsersMap.remove(userId);
    }
  }

  void cancelTimer() {
    int now = DateTime.now().millisecondsSinceEpoch;
    for (var user in state) {
      if (now - user.startTime > 5000) {
        _groupUsersMap.remove(user.userId);
      }
    }
    if (_groupUsersMap.isEmpty) {
      _timer?.cancel();
      state = [];
    } else {
      state = _groupUsersMap.values.toList();
    }
  }
}
