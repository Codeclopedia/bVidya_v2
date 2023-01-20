import 'dart:async';

import 'package:bvidya/core/state.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

enum TypingCommand { typingStart, typingEnd }

class TypingUser {
  final String userId;
  final TypingCommand status;

  TypingUser(this.userId, this.status);
}

final typingProvider = StateNotifierProvider
    .family<TypingHelper, TypingUser, String>((ref, to) => TypingHelper(to));

class TypingHelper extends StateNotifier<TypingUser> {
  String to;
  TypingHelper(this.to) : super(TypingUser(to, TypingCommand.typingEnd));
  int _previousChangedTimeStamp = 0;

  // TypingCommand _currentCommand =TypingCommand.typingEnd;

  void textChange() {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - _previousChangedTimeStamp > 5000) {
      print('sending_command');
      _sendBeginTyping(to, TypingCommand.typingStart);
      _previousChangedTimeStamp = currentTimestamp;
    }
  }

  void _sendBeginTyping(String to, TypingCommand command) async {
    try {
      final msg = ChatMessage.createCmdSendMessage(
        targetId: to,
        action: command.name,
        deliverOnlineOnly: true,
      );
      msg.chatType = ChatType.Chat;
      ChatClient.getInstance.chatManager.sendMessage(msg);
    } catch (e) {}
  }

  Timer? _timer;
  void beginTimer() {
    print('received command');
    _timer?.cancel();
    state = TypingUser(to, TypingCommand.typingStart);
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        cancelTimer();
      },
    );
  }

  void cancelTimer() {
    _timer?.cancel();
    state = TypingUser(to, TypingCommand.typingEnd);
  }
}
