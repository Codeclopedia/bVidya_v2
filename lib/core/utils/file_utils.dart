// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';

handleChatFileOption(
    BuildContext context, ChatFileMessageBody body, bool isOwnMessage) async {
  String fileName = body.displayName ?? '';
  if (fileName.isEmpty) return;

  if (fileName.contains('.')) {
    String fileType = fileName.split('.').last;
    // print('File type $fileType ');
    switch (fileType) {
      case 'pdf':
        if (body.fileStatus == DownloadStatus.SUCCESS) {
          try {
            // print('File local ${body.localPath}');
            File file = File(body.localPath);
            if (await file.exists()) {
              PDFDocument doc = await PDFDocument.fromFile(file);
              Navigator.pushNamed(context, RouteList.pdfFileViewer,
                  arguments: doc);
            }
          } catch (e) {
            AppSnackbar.instance.error(context, 'Error in opening file');
          }
        } else {
          // File file = File();
          if (isOwnMessage) {
            File file = File(body.localPath);
            if (await file.exists()) {
              PDFDocument doc = await PDFDocument.fromFile(file);
              Navigator.pushNamed(context, RouteList.pdfFileViewer,
                  arguments: doc);
            }
            return;
          }
          if (body.remotePath?.isNotEmpty == true) {
            PDFDocument doc = await PDFDocument.fromURL(body.remotePath!);
            Navigator.pushNamed(context, RouteList.pdfFileViewer,
                arguments: doc);
          } else {
            AppSnackbar.instance.error(context, 'Error in opening file');
          }
          print('File remote ${body.remotePath}');
          // FlutterFilePreview.openFile(body.remotePath,
          //     title: body.displayName ?? '');
          // FilePreview.
        }
        break;
      // case 'doc':
      // case 'docx':
      //   break;
      // case 'txt':
      //   break;
      default:
        // AppSnackbar.instance.message(context, 'Error in opening file');
        break;
    }
  }
}
