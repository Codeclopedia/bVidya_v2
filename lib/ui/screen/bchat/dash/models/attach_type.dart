import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class AttachedFile {
  final File file;
  final MessageType messageType;

  AttachedFile(this.file, this.messageType);
}
