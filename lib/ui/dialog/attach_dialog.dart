import '/core/constants.dart';
import '/core/ui_core.dart';

const cameraColor = Color(0xFF91E1FF);
const recordColor = Color(0xFFF5B696);
const mediaColor = Color(0xFF9491FF);

const audioColor = Color(0xFFFF8282);
const documentColor = Color(0xFFFFC948);

// enum AttachType {
//   camera,
//   media,
//   audio,
//   docs,
// }

class AttachDialog extends StatelessWidget {
  const AttachDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.card,
      child: Container(
        padding: EdgeInsets.all(4.w),
        constraints: BoxConstraints(minHeight: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.w),
            topRight: Radius.circular(7.w),
          ),
        ),
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
              // S.current.im_picker_camera_desc,
              '',
              'icon_chat_camera.svg',
              cameraColor,
              () => Navigator.pop(context, AttachType.cameraPhoto),
            ),
            _buildOption(
              S.current.atc_record,
              // S.current.im_picker_camera_desc,
              '',
              'icon_chat_record.svg',
              recordColor,
              () => Navigator.pop(context, AttachType.cameraVideo),
            ),
            _buildOption(
              S.current.atc_media,
              S.current.atc_media_desc,
              'icon_chat_media.svg',
              mediaColor,
              () => Navigator.pop(context, AttachType.media),
            ),
            _buildOption(
              S.current.atc_audio,
              S.current.atc_audio_desc,
              'icon_chat_audio.svg',
              audioColor,
              () => Navigator.pop(context, AttachType.audio),
            ),
            _buildOption(
              S.current.atc_content,
              S.current.atc_document_desc,
              'icon_chat_doc.svg',
              documentColor,
              () => Navigator.pop(context, AttachType.docs),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
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
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
