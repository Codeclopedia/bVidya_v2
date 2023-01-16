import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/foundation.dart';

import '../../ui/screen/bchat/models/reply_model.dart';

class ChatScreenModel extends ChangeNotifier {
  bool _isReplyBoxVisible = false;
  bool get isReplyBoxVisible => _isReplyBoxVisible;

  ReplyModel? _replyOn;
  ReplyModel? get replyOn => _replyOn;

  void setReplyOn(ChatMessage message, String fromName) {
    _replyOn = ReplyModel(message: message, fromName: fromName);
    _isReplyBoxVisible = true;
    notifyListeners();
  }

  void clearReplyBox() {
    _replyOn = null;
    _isReplyBoxVisible = false;
    notifyListeners();
  }
}
