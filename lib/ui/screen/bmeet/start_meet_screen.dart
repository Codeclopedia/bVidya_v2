// ignore_for_file: use_build_context_synchronously

import '../../dialog/bmeet_forward_link_dialog.dart';
import '/app.dart';
// import '/ui/dialog/forward_dialog.dart';
// import '/ui/screen/bmeet/bmeet_forward_link_dialog.dart';

import '/core/constants.dart';
import '/core/helpers/bmeet_helper.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '../profile/base_settings_noscroll.dart';
import '../../base_back_screen.dart';

final muteStartMeetingProvider = StateProvider<bool>(
  (_) => false,
);
final videoOffStartMeetingProvider = StateProvider<bool>(
  (_) => false,
);

class StartMeetScreen extends StatelessWidget {
  final ScheduledMeeting scheduledMeeting;
  const StartMeetScreen({Key? key, required this.scheduledMeeting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.gradientTopColor,
      body: BaseWilPopupScreen(
        onBack: () async {
          return true;
        },
        child: BaseNoScrollSettings(
          bodyContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(S.current.bmeet_start_heading, style: textStyleHeading),
                SizedBox(height: 5.h),
                Text(S.current.bmeet_start_option, style: textStyleCaption),
                SizedBox(height: 3.h),
                Consumer(
                  builder: (context, ref, child) {
                    bool mute = ref.watch(muteStartMeetingProvider);
                    return _buildSettingRow(S.current.bmeet_mute_title,
                        S.current.bmeet_mute_desc, mute, (value) {
                      ref.read(muteStartMeetingProvider.notifier).state = value;
                    });
                  },
                ),
                SizedBox(height: 3.h),
                Consumer(
                  builder: (context, ref, child) {
                    final camOff = ref.watch(videoOffStartMeetingProvider);
                    return _buildSettingRow(S.current.bmeet_videooff_title,
                        S.current.bmeet_videooff_desc, camOff, (value) {
                      ref.read(videoOffStartMeetingProvider.notifier).state =
                          value;
                    });
                  },
                ),
                SizedBox(height: 4.h),
                Text(S.current.bmeet_sharable_caption, style: textStyleCaption),
                SizedBox(height: 2.h),
                _linkCard(),
                const Spacer(),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      style: elevatedButtonTextStyle,
                      onPressed: () {
                        final camOff = ref.read(videoOffStartMeetingProvider);
                        final micOff = ref.read(muteStartMeetingProvider);
                        print("the value before $camOff $micOff");
                        startMeeting(
                            context, ref, scheduledMeeting, camOff, micOff);
                      },
                      child: Text(S.current.bmeet_btn_start),
                    );
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _linkCard() => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
          border: Border.all(color: const Color(0xFF989898), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.bmeet_sharable_title, style: textStyleCaption),
                  SizedBox(height: 0.4.h),
                  Text(scheduledMeeting.meetingId, style: textStyleTitle),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                _buildshareWidget();
              },
              child: Column(
                children: [
                  Icon(
                    Icons.share,
                    color: AppColors.primaryColor,
                    size: 7.w,
                  ),
                  Text(
                    S.current.bmeet_share,
                    style: textStyleTitle.copyWith(fontSize: 7.sp),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Future _buildshareWidget() async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Center(
          child: Container(
            height: 40.w,
            width: 60.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3.w)),
            child: Column(
              children: [
                Text(
                  "Share with",
                  style: textStyleHeading.copyWith(color: Colors.white),
                ),
                SizedBox(height: 6.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        final user = await getMeAsUser();
                        if (user == null) return;
                        String content =
                            '${user.name} just invited you to a bvidya Instant Meeting.\n'
                            'Instant Meeting code -${scheduledMeeting.meetingId}\n'
                            'To join, copy the code and enter it on the bvidya app or website.';

                        await showBmeetForwardList(
                            context, content, user.id.toString());
                        // await showForwardList(
                        //     context,
                        //     [
                        //       ChatMessage.createTxtSendMessage(
                        //           targetId: '184', content: 'tessting')
                        //     ],
                        //     user?.id.toString() ?? "");
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getPngIcon('menu_bchat.png', width: 12.w),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: S.current.bchat.substring(0, 1),
                              style: textStyleBlack.copyWith(
                                  fontSize: 10.sp, color: Colors.white),
                            ),
                            TextSpan(
                              text: S.current.bchat.substring(1, 5),
                              style: textStyleBlack.copyWith(
                                  fontSize: 10.sp,
                                  color: AppColors.yellowAccent),
                            ),
                          ]))
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () {
                        shareUserMeetContent('Meeting Id',
                            scheduledMeeting.meetingId, 'Instant Meeting');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getPngImage('apps-icon-png-5.jpg', width: 12.w),
                          Text(
                            'Other Apps',
                            style: textStyleBlack.copyWith(
                                fontSize: 10.sp, color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingRow(
      String title, String desc, bool value, Function(bool) onTapSetting) {
    return InkWell(
      onTap: () {
        onTapSetting(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyleTitle),
                SizedBox(height: 0.4.h),
                Text(desc, style: textStyleDesc),
              ],
            ),
          ),
          mySwitch(value, onTapSetting),
        ],
      ),
    );
  }
}
