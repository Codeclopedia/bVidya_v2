// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../core/ui_core.dart';

const cameraColor = Color(0xFF91E1FF);
const mediaColor = Color(0xFF9491FF);

Future<File?> showImageFilePicker(BuildContext context) {
  return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.w))),
      builder: (BuildContext bc) {
        return ImagePickerDialog();
      });
}

class ImagePickerDialog extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  ImagePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      constraints: BoxConstraints(minHeight: 20.h),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(7.w),
      //     topRight: Radius.circular(7.w),
      //   ),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.atc_content,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          _buildOption(
            S.current.atc_camera,
            S.current.im_picker_camera_desc,
            'icon_chat_camera.svg',
            cameraColor,
            () async {
              File? file = await _imgFromCamera();
              if (file != null) {
                Navigator.pop(context, file);
              }
            },
          ),
          _buildOption(
            S.current.atc_media,
            S.current.im_picker_gallery_desc,
            'icon_chat_media.svg',
            mediaColor,
            () async {
              File? file = await _imgFromGallery();
              if (file != null) {
                Navigator.pop(context, file);
              }
            },
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }

  _buildOption(
      String title, String desc, String icon, Color color, Function() action) {
    return InkWell(
      onTap: action,
      splashColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: getSvgIcon(icon, color: Colors.white, width: 20),
            ),
            SizedBox(
              width: 2.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 9.sp,
                      color: Colors.black),
                ),
                if (desc.isNotEmpty)
                  Text(
                    desc,
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 9.sp,
                        color: Colors.grey),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<File?> _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      return file;
      // ref.read(selectedImageFileStateProvider.notifier).state = file;
    }
    return null;
    // setState(() {
    //   _image = File(image.path);
    // });
  }

  Future<File?> _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      final file = File(image.path);
      return file;
    }
    return null;
  }
}
