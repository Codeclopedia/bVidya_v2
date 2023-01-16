import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../models/attach_type.dart';
import '/core/ui_core.dart';

class AttachedFileView extends StatelessWidget {
  final AttachedFile attFile;
  const AttachedFileView({Key? key, required this.attFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: attFile.messageType == MessageType.IMAGE
          ? ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(1.w),
              ),
              child: Image(
                image: FileImage(
                    File(attFile.file.thumbPath ?? attFile.file.path)),
              ),
            )
          : (attFile.messageType == MessageType.VIDEO
              ? (attFile.file.thumbPath == null
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: getSvgIcon('icon_chat_media.svg'),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.w),
                      ),
                      child: Image(
                          image: FileImage(File(
                              attFile.file.thumbPath ?? attFile.file.path))),
                    ))
              : SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: getSvgIcon('icon_chat_doc.svg'),
                )),
    );
  }
}
