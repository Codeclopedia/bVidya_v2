import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_plus/image_picker_plus.dart' as ipp;

import '/ui/base_back_screen.dart';
import '../models/media.dart';
import '/core/state.dart';
import '/core/constants.dart';
import '../widgets/attached_file.dart';
import '../models/attach_type.dart';
import '/core/ui_core.dart';

final attachedFile = StateProvider.autoDispose<AttachedFile?>((_) => null);
final attachedFiles = StateProvider.autoDispose<List<AttachedFile>>((_) => []);

Widget buildAttachedFile(Widget chatInputBox,
    Future Function(AttachedFile file, WidgetRef ref) onSendMediaFile) {
  return Consumer(
    builder: (context, ref, child) {
      List<AttachedFile> attaches = ref.watch(attachedFiles);
      if (attaches.isNotEmpty) {
        return _attachFilesView(attaches, () async {
          showLoading(ref);
          for (var attFile in attaches) {
            await onSendMediaFile(attFile, ref);
          }
          ref.read(attachedFiles.notifier).state = [];
          hideLoading(ref);
        });
      }

      AttachedFile? attFile = ref.watch(attachedFile);
      return attFile == null
          ? chatInputBox
          : _attachFileView(attFile, () async {
              showLoading(ref);
              await onSendMediaFile(attFile, ref);
              ref.read(attachedFile.notifier).state = null;
              hideLoading(ref);
            });
    },
  );
}

pickFile(AttachType type, WidgetRef ref, BuildContext context) async {
  ImagePicker picker = ImagePicker();
  switch (type) {
    case AttachType.cameraPhoto:
      // SelectedImagesDetails? details =
      //     await picker.pickImage(source: ImageSource.camera);
      XFile? xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        // File file = xFile.path;
        final Media media = Media(
            path: xFile.path,
            size: (await xFile.length()),
            thumbPath: xFile.path);
        ref.read(attachedFile.notifier).state =
            AttachedFile(media, MessageType.IMAGE);
      }
      break;
    case AttachType.cameraVideo:
      XFile? xFile = await picker.pickVideo(source: ImageSource.camera);
      if (xFile != null) {
        final thumb = await VideoThumbnail.thumbnailFile(
          video: xFile.path,
          thumbnailPath: Directory.systemTemp.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128,
          quality: 25,
        );
        final Media media = Media(
            path: xFile.path, size: (await xFile.length()), thumbPath: thumb);
        ref.read(attachedFile.notifier).state =
            AttachedFile(media, MessageType.VIDEO);
      }
      break;
    case AttachType.media:
      ipp.ImagePickerPlus pickerPlus = ipp.ImagePickerPlus(context);
      ipp.SelectedImagesDetails? details = await pickerPlus.pickBoth(
          multiSelection: true,
          source: ipp.ImageSource.gallery); //done picking both
      if (details != null && details.selectedFiles.isNotEmpty) {
        if (details.selectedFiles.length == 1) {
          ref.read(attachedFile.notifier).state =
              await _getMediaFile(details.selectedFiles.first);
          return;
        }
        List<AttachedFile> files = [];
        for (var f in details.selectedFiles) {
          files.add(await _getMediaFile(f));
        }
        ref.read(attachedFile.notifier).state = null;
        ref.read(attachedFiles.notifier).state = files;
      }
      break;
    case AttachType.audio:
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['aac', 'mp3', 'wav'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        final Media media =
            Media(path: file.path!, size: (await File(file.path!).length()));
        ref.read(attachedFile.notifier).state =
            AttachedFile(media, MessageType.VOICE);
      }
      // fileExts = ['aac', 'mp3', 'wav'];
      break;
    case AttachType.docs:
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        final Media media =
            Media(path: file.path!, size: (await File(file.path!).length()));
        ref.read(attachedFile.notifier).state =
            AttachedFile(media, MessageType.FILE);
      }
      break;
  }
}

Widget _attachFilesView(List<AttachedFile> attaches, Function() onSend) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
    margin: EdgeInsets.only(bottom: 1.h),
    alignment: Alignment.center,
    height: 10.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFFECECEC),
      borderRadius: BorderRadius.circular(3.w),
    ),
    // constraints: BoxConstraints(
    //   minHeight: 2.h,
    //   maxHeight: 10.h,
    // ),
    child: Row(
      children: [
        Expanded(
            child: ListView.separated(
          itemCount: attaches.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 4),
          itemBuilder: (context, index) {
            final attFile = attaches[index];
            return SizedBox(
              width: 10.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(1.w),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  image: FileImage(
                      File(attFile.file.thumbPath ?? attFile.file.path)),
                ),
              ),
            );
          },
        )),
        InkWell(
          onTap: () {
            onSend();
          },
          child: CircleAvatar(
            radius: 5.w,
            backgroundColor: AppColors.primaryColor,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    ),
  );
}

Widget _attachFileView(AttachedFile attFile, Function() onSend) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minHeight: 4.w,
            maxHeight: 20.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.all(Radius.circular(3.w))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.bmeet_user_you,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          attFile.messageType == MessageType.VIDEO
                              ? Icons.voice_chat_rounded
                              : Icons.image,
                          size: 4.w,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 1.w),
                        Flexible(
                          child: Text(
                            attFile.file.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: kFontFamily,
                                color: Colors.grey,
                                fontSize: 10.sp),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.h,
                child: AttachedFileView(attFile: attFile),
              ),
              // IconButton(
              //   onPressed: () {
              //     ref.read(attachedFile.notifier).state = null;
              //   },
              //   icon: const Icon(Icons.close, color: Colors.red),
              // )
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () async {
          onSend();
        },
        child: CircleAvatar(
          radius: 5.w,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
      SizedBox(width: 3.w),
    ],
  );
}

Future<AttachedFile> _getMediaFile(ipp.SelectedByte f) async {
  File file = f.selectedFile;
  // bool isImage = file.path.toLowerCase().endsWith('png') ||
  //     file.path.toLowerCase().endsWith('jpg') ||
  //     file.path.toLowerCase().endsWith('jpeg');
  if (f.isThatImage) {
    final Media media = Media(
        path: file.absolute.path,
        size: (await file.length()),
        thumbPath: file.absolute.path);
    // files.add(AttachedFile(media, MessageType.IMAGE));
    return AttachedFile(media, MessageType.IMAGE);
    // ref.read(attachedFile.notifier).state =
    //     AttachedFile(media, MessageType.IMAGE);
  } else {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: Directory.systemTemp.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    final Media media = Media(
        path: file.absolute.path,
        size: (await file.length()),
        thumbPath: thumb);
    // files.add(AttachedFile(media, MessageType.VIDEO));
    return AttachedFile(media, MessageType.VIDEO);
  }
}
