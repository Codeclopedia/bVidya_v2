import '/core/ui_core.dart';
import '../base_settings.dart';
import 'show_notifications.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Text(
                S.current.settingsNoti,
                style: textStyleSettingHeading,
              ),
            ),
            getTwoRowSwitchSettingItem(S.current.dndTitle, S.current.dndDesc,
                "noti_dnd.svg", false, (value) {}),
            getTwoRowSettingItem(
                S.current.showNoty, S.current.notyDesc, "noti_show.svg", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShowNotifications()),
              );
            }),
            getTwoRowSettingItem(S.current.soundTitle, S.current.soundDesc,
                "noti_sound.svg", () {}),
            getTwoRowSwitchSettingItem(S.current.privateClassTitle,
                S.current.privateDesc, "noti_private.svg", true, (value) {}),
            getTwoRowSettingItem(S.current.resetNoty, S.current.resetDesc,
                "noti_settings.svg", () {}),
            Container(
              width: 0.5.w,
            )
          ]),
    );
  }
}
