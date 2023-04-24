// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';

import '../../base_back_screen.dart';
import '/controller/blive_providers.dart';
import '/core/constants.dart';
import '/core/helpers/blive_helper.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/date_utils.dart';
import '/data/models/models.dart';
import '../../widget/calendar_view.dart';
import '../../widgets.dart';
import '../blearn/components/common.dart';

class BLiveHomeScreen extends HookWidget {
  const BLiveHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = useTextEditingController();

    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: LiveDrawerScreen(
        currentIndex: DrawerMenu.bLive,
        baseBody: SafeArea(
          child: Container(
            alignment: Alignment.bottomCenter,
            width: 100.w,
            margin: EdgeInsets.only(bottom: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final date = ref.watch(bLiveSelectedDateProvider);
                      final txt = DateUtils.isSameDay(date, DateTime.now())
                          ? S.current.blive_today_meeting
                          : S.current.blive_date_meeting(
                              DateFormat('dd MMM').format(date));
                      return Text(txt, style: textStyleCaption);
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                _buildHistory(),
              ],
            ),
          ),
        ),
        overlayBody: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.w),
                    bottomRight: Radius.circular(7.w),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.gradientTopColor,
                      AppColors.gradientLiveBottomColor,
                    ],
                  ),
                ),
                child: _buildCalendar(context, controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(
      BuildContext context, TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SafeArea(child: SizedBox(height: 1)),
        _buildCard(context, controller),
        SizedBox(height: 2.h),
        Text(
          S.current.blive_txt_schedule,
          style: textStyleWhite.copyWith(
            fontSize: 12.sp,
          ),
        ),
        // SizedBox(height: 0.5.h),
        Consumer(builder: (context, ref, child) {
          return CalendarView(
            onSelectedDate: (date) {
              ref.read(bLiveSelectedDateProvider.notifier).state = date;
            },
          );
        })
      ],
    );
  }

  Widget _buildCard(BuildContext context, TextEditingController controller) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 90.w,
            // height: 27.h,
            margin: EdgeInsets.only(top: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(4.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SizedBox(height: 2.h),
                // SizedBox(height: 18.w),
                Container(
                  padding: EdgeInsets.only(top: 1.h),
                  alignment: Alignment.topRight,
                  child: UserConsumer(
                    builder: (context, user, ref) {
                      return user.role.toLowerCase() == 'instructor' ||
                              user.role.toLowerCase() == 'admin' ||
                              user.role.toLowerCase() == 'teacher'
                          ? InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteList.bLiveSchedule);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.yellowAccent,
                                radius: 5.w,
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                  size: 4.w,
                                ),
                                // getSvgIcon('icon_next.svg', width: 4.5.w)
                              ),
                            )
                          : SizedBox(height: 10.w);
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(height: 8.w),
                // Center(
                //   child: Consumer(
                //     builder: (context, ref, child) {
                //       return Text(user?.name ?? '', style: textStyleBlack);
                //     },
                //   ),
                // ),
                // SizedBox(height: 3.h),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.blive_txt_start_title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                            fontFamily: kFontFamily,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          S.current.blive_txt_start_desc,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 7.sp,
                            fontFamily: kFontFamily,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Consumer(builder: (context, ref, child) {
                      return ElevatedButton(
                          style: elevatedButtonYellowStyle,
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              String broadcastStreamId = controller.text;
                              joinBroadcast(context, ref, broadcastStreamId);
                            } else {}
                          },
                          child: Text(S.current.bmeet_btn_start));
                    })
                  ],
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {},
                  decoration: inputDirectionStyle.copyWith(
                    hintText: S.current.blive_hint_link,
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
        Center(
          child: UserConsumer(
            builder: (context, user, ref) {
              return Column(
                children: [
                  getRectFAvatar(
                      size: 22.w,
                      user.name,
                      user.image,
                      cacheHeight: (50.w * devicePixelRatio).round(),
                      cacheWidth: (50.w * devicePixelRatio).round()),
                  SizedBox(height: 0.5.h),
                  Text(user.name, style: textStyleBlack)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistory() {
    return Container(
      height: 20.h,
      alignment: Alignment.bottomLeft,
      child: Consumer(
        builder: (context, ref, child) {
          return ref.watch(bLiveSelectedHistoryProvider).when(
              data: (liveBroadcasts) {
                if (liveBroadcasts.isNotEmpty) {
                  return _buildData(liveBroadcasts, ref);
                } else {
                  return buildEmptyPlaceHolder(S.current.blive_no_meetings);
                }
              },
              error: (err, str) => buildEmptyPlaceHolder('$err'),
              loading: () => buildLoading);
        },
      ),
    );
  }

  Widget _buildData(List<LMSLiveClass> broadcastList, WidgetRef ref) {
    return ListView.builder(
      itemCount: broadcastList.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final broadcast = broadcastList[index];
        return liveClassRow(broadcast, () {
          // joinBroadcast(context, ref, broadcast.streamId ?? '');
        }, ref);
      },
    );
  }

  Widget liveClassRow(
      LMSLiveClass broadcast, Function() onJoin, WidgetRef ref) {
    bool pastDate = false;
    int compare = DateTime.now()
        .subtract(const Duration(days: 1))
        .compareTo(ref.watch(bLiveSelectedDateProvider));
    pastDate = compare == 1 ? true : false;
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.all(3.w),
      height: 20.h,
      width: 35.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(
            color: pastDate ? AppColors.iconGreyColor : const Color(0xFF707070),
            width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(4.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.current.blive_txt_broadcast,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 8.sp,
                fontFamily: kFontFamily,
                color: pastDate ? AppColors.iconGreyColor : AppColors.black,
              )),
          SizedBox(height: 1.w),
          Text(
            broadcast.name ?? '',
            //'${(broadcast.name ?? '')} - ${broadcast.id}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
              fontFamily: kFontFamily,
              color:
                  pastDate ? AppColors.iconGreyColor : AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            // "",
            parseMeetingTime(broadcast.startsAt ?? ''),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 8.sp,
              fontFamily: kFontFamily,
              color: pastDate ? AppColors.iconGreyColor : AppColors.black,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.blive_btx_join,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 8.sp,
                    fontFamily: kFontFamily,
                    color:
                        pastDate ? AppColors.iconGreyColor : AppColors.black),
              ),
              // GestureDetector(
              //   onTap: () {
              //     pastDate ? null : onJoin();
              //     // startMeeting(context, ref, meeting, true, false);
              //   },
              //   child:
              CircleAvatar(
                backgroundColor:
                    pastDate ? AppColors.iconGreyColor : AppColors.yellowAccent,
                radius: 1.5.h,
                child: getSvgIcon('icon_next.svg', width: 1.4.h),
              ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  // _joinLiveClass(
  //     BuildContext context, WidgetRef ref, LMSLiveClass broadcast) async {
  //   showLoading(ref);

  //   final result = await ref
  //       .read(bLiveRepositoryProvider)
  //       .getLiveClass(broadcast.streamId!);
  //   if (result != null) {
  //     final rtmToken =
  //         await ref.read(bLiveRepositoryProvider).fetchLiveRTM(result.id);
  //     if (rtmToken != null) {
  //       hideLoading(ref);
  //       Navigator.pushNamed(context, RouteList.bLiveClass);
  //       return;
  //     }
  //   }
  //   hideLoading(ref);
  // }

  void dipose() {}
}
