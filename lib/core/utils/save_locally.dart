import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/state.dart';
import '/ui/screens.dart';
import 'package:dio/dio.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as p;

import '../ui_core.dart';

final Dio dio = Dio();

void saveFile(
    WidgetRef ref, String fileName, String url, MessageType filetype) async {
  try {
    // get status permission
    final status = await Permission.storage.status;

    // check status permission
    if (status.isDenied) {
      // request permission
      await Permission.storage.request();
      return;
    }

    showLoading(ref);

    switch (filetype) {
      case MessageType.IMAGE:
        await _doSave(url, fileName, "Images");
        break;
      case MessageType.VIDEO:
        break;
      // case MessageType.CUSTOM:
      //   ChatCustomMessageBody body = message.body as ChatCustomMessageBody;
      //   if (message.chatType == ChatType.GroupChat) {
      //     try {
      //       // print('JSON=> ${body.event}');
      //       final callBody =
      //           GroupCallMessegeBody.fromJson(jsonDecode(body.event));

      //       return _callBody(callBody.callType);
      //     } catch (e) {
      //       // print('Error Grp=> $e');
      //       break;
      //     }
      //   } else if (message.chatType == ChatType.Chat) {
      //     try {
      //       final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));

      //       return _callBody(callBody.callType);
      //     } catch (e) {
      //       break;
      //     }
      //   } else {
      //     break;
      //   }

      case MessageType.FILE:
        await _doSave(url, fileName, "Documents");
        break;

      case MessageType.VOICE:
        await _doSave(url, fileName, "Audios");
        break;
      default:
      // return const SizedBox.shrink();
    }

    // do save

  } catch (e) {
    print(e.toString());
  } finally {
    hideLoading(ref);
    EasyLoading.showToast("Download Complete",
        toastPosition: EasyLoadingToastPosition.bottom);
  }
}

void save(WidgetRef ref, String url, String filename, String filetype) async {
  try {
    // get status permission
    final status = await Permission.storage.status;

    // check status permission
    if (status.isDenied) {
      // request permission
      await Permission.storage.request();
      return;
    }

    showLoading(ref);

    // do save
    await _doSave(url, filename, filetype);
  } catch (e) {
    print(e.toString());
  } finally {
    hideLoading(ref);
    EasyLoading.showToast("Download Complete",
        toastPosition: EasyLoadingToastPosition.bottom);
  }
}

// void saveDocuments(WidgetRef ref, String url, String filename) async {
//   try {
//     // get status permission
//     final status = await Permission.storage.status;

//     // check status permission
//     if (status.isDenied) {
//       // request permission
//       await Permission.storage.request();
//       return;
//     }

//     showLoading(ref);

//     // do save
//     await _doSaveFileCustom(url, filename);
//   } catch (e) {
//     print(e.toString());
//   } finally {
//     hideLoading(ref);
//     EasyLoading.showToast("Download Complete",
//         toastPosition: EasyLoadingToastPosition.bottom);
//   }
// }

// void saveFolderFileExt(WidgetRef ref, String url) async {
//   try {
//     // get status permission
//     final status = await Permission.storage.status;

//     // check status permission
//     if (status.isDenied) {
//       // request permission
//       await Permission.storage.request();
//       return;
//     }

//     showLoading(ref);

//     // do save
//     await _doSave(url);
//   } catch (e) {
//     print(e.toString());
//   } finally {
//     hideLoading(ref);
//   }
// }

// Don't forget to check
// device permission
// Future<void> _doSaveFileCustom(String url, String filename) async {
//   final dir = await p.getExternalStorageDirectory();
//   final filepath = dir!.path + ('/$filename');
//   print("file url is $url");
//   await dio.download(url, filepath, onReceiveProgress: (rec, total) {
//     // setState(() {
//     //   progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
//     // });
//   });

//   // if you want to get original of Image
//   // don't give a value of width or height
//   // cause default is return width = 0, height = 0
//   // which will make it to get the original image
//   // just write like this
//   // remove originFile default = false
//   final result = await FolderFileSaver.saveFileIntoCustomDir(
//     dirNamed: "documents",
//     filePath: filepath,
//     removeOriginFile: true,
//   );
//   print(result);
// }

// Don't forget to check
// device permission
Future<void> _doSave(String urlImage, String filename, String filetype) async {
  final dir = await p.getExternalStorageDirectory();
  print("Name of the image is $filename");
  final pathImage = dir!.path + ('/$filename');

  await dio.download(urlImage, pathImage, onReceiveProgress: (rec, total) {
    // setState(() {
    //   progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
    // });
  });
  // if you want to get original of Image
  // don't give a value of width or height
  // cause default is return width = 0, height = 0
  // which will make it to get the original image
  // just write like this
  // remove originFile default = false
  final result = await FolderFileSaver.saveFileIntoCustomDir(
    filePath: pathImage,
    dirNamed: filetype,
    removeOriginFile: true,
  );
  print(result);
}

// Don't forget to check
// device permission
// Future<void> _doSave(String urlVideo) async {
//   final dir = await p.getTemporaryDirectory();
//   // prepare the file and type extension that you want to download
//   // remove originFile after success default = false
//   final filePath = dir.path +
//       ('/your_file_named ${DateTime.now().millisecondsSinceEpoch}.mp4');
//   await dio.download(urlVideo, filePath, onReceiveProgress: (rec, total) {
//     // setState(() {
//     //   progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
//     // });
//   });
//   final result = await FolderFileSaver.saveFileToFolderExt(
//     filePath,
//     removeOriginFile: true,
//   );
//   print(result);
// }

// Don't forget to check
// device permission
// void saveFile(String urlVideo) async {
//   final dir = await p.getTemporaryDirectory();
//   // prepare the file and type extension that you want to download
//   final filePath = dir.path +
//       ('/your_file_named ${DateTime.now().millisecondsSinceEpoch}.mp4');
//   try {
//     await dio.download(urlVideo, filePath);
//     final result = await FolderFileSaver.saveFileToFolderExt(filePath);
//     print(result);
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }

// // Don't foreget check your permission
// void copyFileToNewFolder(WidgetRef ref) async {
//   showLoading(ref);
//   // get your path from your device your device
//   // final fileToCopy = '/storage/emulated/0/DCIM/Camera/20200102_202226.jpg'; // example
//   // remove originFile default = false
//   final fileToCopy = '<local_path_from_your_device>';
//   try {
//     await FolderFileSaver.saveFileToFolderExt(fileToCopy);
//   } catch (e) {
//     print(e);
//   }
//   hideLoading(ref);
// }
