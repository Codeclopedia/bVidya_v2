// ignore_for_file: use_build_context_synchronously

import '/core/constants.dart';
import '/core/helpers/bmeet_helper.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '../../base_back_screen.dart';
import '../profile/base_settings_noscroll.dart';

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
                    Text(S.current.bmeet_start_heading,
                        style: textStyleHeading),
                    SizedBox(height: 5.h),
                    Text(S.current.bmeet_start_option, style: textStyleCaption),
                    SizedBox(height: 3.h),
                    // _buildSettingRow(S.current.bmeet_mute_title,
                    //     S.current.bmeet_mute_desc, false, (value) {}),
                    Consumer(
                      builder: (context, ref, child) {
                        bool mute = ref.watch(muteStartMeetingProvider);
                        return _buildSettingRow(S.current.bmeet_mute_title,
                            S.current.bmeet_mute_desc, mute, (value) {
                          ref.read(muteStartMeetingProvider.notifier).state =
                              value;
                        });
                      },
                    ),
                    SizedBox(height: 3.h),
                    // _buildSettingRow(S.current.bmeet_videooff_title,
                    //     S.current.bmeet_videooff_desc, true, (value) {}),
                    Consumer(
                      builder: (context, ref, child) {
                        final camOff = ref.watch(videoOffStartMeetingProvider);
                        return _buildSettingRow(S.current.bmeet_videooff_title,
                            S.current.bmeet_videooff_desc, camOff, (value) {
                          ref
                              .read(videoOffStartMeetingProvider.notifier)
                              .state = value;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),
                    Text(S.current.bmeet_sharable_caption,
                        style: textStyleCaption),
                    SizedBox(height: 2.h),
                    _linkCard(context),
                    const Spacer(),
                    Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          style: elevatedButtonTextStyle,
                          onPressed: () {
                            final camOff =
                                ref.watch(videoOffStartMeetingProvider);
                            final micOff = ref.watch(muteStartMeetingProvider);
                            startMeeting(
                                context, ref, scheduledMeeting, camOff, micOff);
                            // showLoading(ref);
                            // final meeting = await ref
                            //     .read(bMeetRepositoryProvider)
                            //     .startHostMeeting(
                            //         scheduledMeeting.id.toString());

                            // if (meeting == null) {
                            //   AppSnackbar.instance
                            //       .error(context, 'Error joining meeting');
                            //   hideLoading(ref);
                            // } else {
                            //   await _startMeeting(context, meeting, ref);
                            // }
                          },
                          child: Text(S.current.bmeet_btn_start),
                        );
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],
                ))),
      ),
    );
  }

  // _buildScreen() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final user = ref.watch(loginRepositoryProvider).user;
  //       if (user == null) return const SizedBox.expand();
  //       return Container(
  //         // padding: EdgeInsets.only(top: 4.h),
  //         decoration: const BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               AppColors.gradientTopColor,
  //               AppColors.gradientLiveBottomColor,
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Stack(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(top: 9.h),
  //                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(4.w),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     SizedBox(height: 5.h),
  //                     Center(
  //                       child: Text(user.name, style: textStyleBlack),
  //                     ),
  //                     SizedBox(height: 5.h),
  //                     Text(S.current.bmeet_start_heading,
  //                         style: textStyleHeading),
  //                     SizedBox(height: 5.h),
  //                     Text(S.current.bmeet_start_option,
  //                         style: textStyleCaption),
  //                     SizedBox(height: 3.h),
  //                     _buildSettingRow(S.current.bmeet_mute_title,
  //                         S.current.bmeet_mute_desc, false, (value) {}),
  //                     SizedBox(height: 3.h),
  //                     _buildSettingRow(S.current.bmeet_videooff_title,
  //                         S.current.bmeet_videooff_desc, true, (value) {}),
  //                     SizedBox(height: 4.h),
  //                     Text(S.current.bmeet_sharable_caption,
  //                         style: textStyleCaption),
  //                     SizedBox(height: 2.h),
  //                     _linkCard(context),
  //                     const Spacer(),
  //                     ElevatedButton(
  //                       style: elevatedButtonTextStyle,
  //                       onPressed: () {},
  //                       child: Text(S.current.bmeet_btn_start),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                   ],
  //                 ),
  //               ),
  //               IconButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   icon: getSvgIcon('arrow_back.svg')),
  //               Container(
  //                 alignment: Alignment.topCenter,
  //                 margin: EdgeInsets.only(top: 4.h),
  //                 child: getRectFAvatar(size: 22.w, user.name, user.image),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _linkCard(BuildContext context) {
    return Container(
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
            onTap: () {
              shareUserMeetContent(
                  'Meeting Id', scheduledMeeting.meetingId, 'Instant Meeting');
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
