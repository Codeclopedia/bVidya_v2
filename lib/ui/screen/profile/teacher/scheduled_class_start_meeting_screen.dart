import 'package:intl/intl.dart';

import '/data/models/models.dart';
import '/core/constants/colors.dart';

import '../base_settings_noscroll.dart';
import '/core/helpers/bmeet_helper.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

final muteJoinMeetSchMeetingProvider = StateProvider<bool>(
  (_) => false,
);
final videoOffMeetSchJoinMeetingProvider = StateProvider<bool>(
  (_) => false,
);

class ScheduledInstructorClassMeetingScreen extends HookWidget {
  final InstructorScheduledClass scheduledClassDetails;
  const ScheduledInstructorClassMeetingScreen(
      {Key? key, required this.scheduledClassDetails})
      : super(key: key);

  // late TextEditingController _controller;

//if (value.body.meeting.status == "streaming") {
  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   controller = TextEditingController();
    //   return dipose;
    // }, []);
    final scheduledDate = scheduledClassDetails.scheduledAt;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BaseNoScrollSettings(
          bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 6.w),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Class',
                          style: textStyleHeading.copyWith(fontSize: 12.5.sp)),
                      Text(scheduledClassDetails.participants?[0].topic ?? "",
                          style: textStyleHeading.copyWith(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkChatColor)),
                      SizedBox(height: 5.w),
                      Text(
                          scheduledClassDetails
                                  .participants?[0].instructor?.name ??
                              "",
                          style: textStyleCaption.copyWith(
                              color: AppColors.iconGreyColor, fontSize: 10.sp)),
                      Row(
                        children: [
                          Text(
                              DateFormat.yMEd()
                                  .format(scheduledDate ?? DateTime.now()),
                              style: textStyleCaption.copyWith(
                                  color: AppColors.iconGreyColor,
                                  fontSize: 10.sp)),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                              DateFormat.jm()
                                  .format(scheduledDate ?? DateTime.now()),
                              style: textStyleCaption.copyWith(
                                  color: AppColors.iconGreyColor,
                                  fontSize: 10.sp))
                        ],
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Row(
                        children: [
                          Icon(Icons.group,
                              color: AppColors.primaryColor, size: 7.w),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                              scheduledClassDetails.participants?.length
                                      .toString() ??
                                  '0',
                              style: textStyleCaption.copyWith(
                                  color: AppColors.iconGreyColor,
                                  fontSize: 15.sp))
                        ],
                      ),
                      SizedBox(height: 8.w),
                      Consumer(
                        builder: (context, ref, child) {
                          bool mute = ref.watch(muteJoinMeetSchMeetingProvider);
                          return _buildSettingRow(S.current.bmeet_mute_title,
                              S.current.bmeet_mute_desc, mute, (value) {
                            ref
                                .read(muteJoinMeetSchMeetingProvider.notifier)
                                .state = value;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      Consumer(
                        builder: (context, ref, child) {
                          final camOff =
                              ref.watch(videoOffMeetSchJoinMeetingProvider);
                          return _buildSettingRow(
                              S.current.bmeet_videooff_title,
                              S.current.bmeet_videooff_desc,
                              camOff, (value) {
                            ref
                                .read(
                                    videoOffMeetSchJoinMeetingProvider.notifier)
                                .state = value;
                          });
                        },
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    style: elevatedButtonTextStyle,
                    onPressed: () {
                      final camOff =
                          ref.watch(videoOffMeetSchJoinMeetingProvider);
                      final micOff = ref.watch(muteJoinMeetSchMeetingProvider);

                      startScheduledClass(
                          context,
                          ref,
                          scheduledClassDetails.meetingId ?? 1,
                          scheduledClassDetails.instructorId ?? 1,
                          camOff,
                          micOff);
                    },
                    child: Text(S.current.bmeet_btn_start),
                  );
                },
              ),
            ]),
      )),
    );
  }

  void dipose() {}

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
  // _buildCo() {
  //   return Consumer(
  //     builder: (context, ref, child) {
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
  //                 // height: 100.h,
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
  //                         child: Text(
  //                       user.name,
  //                       style: textStyleBlack,
  //                     )),
  //                     SizedBox(height: 5.h),
  //                     Text(S.current.bmeet_join_heading,
  //                         style: textStyleHeading),
  //                     SizedBox(height: 5.h),
  //                     Text(S.current.bmeet_join_caption,
  //                         style: textStyleCaption),

  //                     SizedBox(height: 5.h),
  //                     Text(S.current.bmeet_join_desc, style: textStyleDesc),
  //                     SizedBox(height: 4.h),
  //                     _buildSettingRow(S.current.bmeet_mute_title,
  //                         S.current.bmeet_mute_desc, false, (value) {}),
  //                     SizedBox(height: 3.h),
  //                     _buildSettingRow(S.current.bmeet_videooff_title,
  //                         S.current.bmeet_videooff_desc, true, (value) {}),
  //                     SizedBox(height: 7.h),

  //                     // _linkCard(),
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
}

// Widget _linkCard() {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
//     decoration: BoxDecoration(
//       color: AppColors.cardWhite,
//       borderRadius: BorderRadius.all(Radius.circular(4.w)),
//       border: Border.all(color: const Color(0xFF989898), width: 0.5),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(S.current.bmeet_sharable_title, style: textStyleCaption),
//               SizedBox(height: 0.4.h),
//               Text('z87jNlKHKL', style: textStyleTitle),
//             ],
//           ),
//         ),
//         Column(
//           children: [
//             Icon(
//               Icons.share,
//               color: AppColors.primaryColor,
//               size: 7.w,
//             ),
//             Text(
//               S.current.bmeet_share,
//               style: textStyleTitle.copyWith(fontSize: 7.sp),
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }

