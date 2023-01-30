import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/constants.dart';

import '../models/attach_type.dart';
import '/core/ui_core.dart';

class AttachedFileView extends StatelessWidget {
  final AttachedFile attFile;
  const AttachedFileView({Key? key, required this.attFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: attFile.messageType == MessageType.IMAGE
          ? ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(1.w),
              ),
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(
                    File(attFile.file.thumbPath ?? attFile.file.path)),
              ),
            )
          : (attFile.messageType == MessageType.VIDEO
              ? (attFile.file.thumbPath == null
                  ? getSvgIcon(
                      width: 10.h - 4.w,
                      'icon_chat_media.svg',
                      color: AppColors.primaryColor,
                      fit: BoxFit.contain)
                  : ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.w),
                      ),
                      child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(
                              attFile.file.thumbPath ?? attFile.file.path))),
                    ))
              : getSvgIcon('icon_chat_doc.svg',
                  color: AppColors.primaryColor,
                  width: 10.h - 4.w,
                  fit: BoxFit.contain)),
    );
  }
}
