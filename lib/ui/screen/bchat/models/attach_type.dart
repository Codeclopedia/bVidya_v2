// import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:images_picker/images_picker.dart';

class AttachedFile {
  final Media file;
  final MessageType messageType;

  AttachedFile(this.file, this.messageType);
}
