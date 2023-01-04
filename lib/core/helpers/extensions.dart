import 'dart:convert';

import '/data/models/response/bchat/p2p_call_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

extension RemoteMessageExt on RemoteMessage {
  Map<String, dynamic> getContent() {
    return jsonDecode(data["content"]);
  }

  CallBody? payload() {
    return CallBody?.fromJson(getContent());
  }
}
