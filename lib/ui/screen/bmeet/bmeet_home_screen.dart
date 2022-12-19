// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';

import '../../../controller/bmeet_providers.dart';
import '../../../core/constants.dart';
import '../../../core/helpers/bmeet_helper.dart';
import '../../../core/state.dart';
import '../../../core/ui_core.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/models.dart';
import '../../base_back_screen.dart';
import '../../widget/calendar_view.dart';
import '../../widgets.dart';
import '../blearn/widget/common.dart';

class BMeetHomeScreen extends StatelessWidget {
  const BMeetHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isOpen = ref.watch(drawerBMeetOpenProvider);
    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: LiveDrawerScreen(
        screenName: RouteList.bMeet,
        anotherContent: SafeArea(
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
                      final date = ref.watch(selectedDateProvider);
                      final txt = DateUtils.isSameDay(date, DateTime.now())
                          ? S.current.bmeet_today_meeting
                          : S.current.bmeet_date_meeting(
                              DateFormat('dd MMM').format(date));
                      return Text(
                        txt,
                        style: textStyleCaption,
                      );
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                _buildHistory(),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: double.infinity,
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
                    Color(0xFF9C1132),
                  ],
                ),
              ),
              child: _buildCalendar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SafeArea(child: SizedBox(height: 1)),
          _buildCard(context),
          SizedBox(height: 2.h),
          Text(
            S.current.bmeet_txt_schedule,
            style: textStyleWhite.copyWith(fontSize: 12.sp),
          ),
          // SizedBox(height: 0.5.h),
          Consumer(builder: (context, ref, child) {
            return CalendarView(
              onSelectedDate: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Container(
      height: 20.h,
      alignment: Alignment.bottomLeft,
      child: Consumer(
        builder: (context, ref, child) {
          return ref.watch(bMeetSelectedHistoryProvider).when(
              data: (meetings) {
                if (meetings.isNotEmpty == true) {
                  return _buildList(meetings, ref);
                } else {
                  return buildEmptyPlaceHolder(S.current.bmeet_no_meetings);
                }
              },
              error: (err, str) => buildEmptyPlaceHolder('$err'),
              loading: () => buildLoading);
        },
      ),
    );
  }

  Widget _buildList(List<ScheduledMeeting> meetings, WidgetRef ref) {
    return ListView.builder(
      itemCount: meetings.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return _buildCardRow(meeting, () {
          startMeeting(context, ref, meeting, true, false);
        });
      },
    );
  }

  Widget _buildCardRow(ScheduledMeeting meeting, Function() onJoin) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.all(3.w),
      width: 35.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(4.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.current.bmeet_txt_meeting,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 7.sp,
                fontFamily: kFontFamily,
                color: AppColors.black,
              )),
          SizedBox(height: 1.w),
          Text(
            meeting.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9.sp,
              fontFamily: kFontFamily,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '${parseMeetingTime(meeting.startsAt)} - ${parseMeetingTime(meeting.endsAt)}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 7.sp,
              fontFamily: kFontFamily,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.bmeet_btx_join,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 7.sp,
                    fontFamily: kFontFamily,
                    color: AppColors.black),
              ),
              GestureDetector(
                onTap: () {
                  onJoin();
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.yellowAccent,
                  radius: 1.5.h,
                  child: getSvgIcon('icon_next.svg', width: 1.4.h),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
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
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 2.h),
                SizedBox(height: 18.w),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.bmmet_txt_start_title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              fontFamily: kFontFamily,
                              color: Colors.black),
                        ),
                        Text(
                          S.current.bmeet_txt_start_desc,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 7.sp,
                              fontFamily: kFontFamily,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    _buildButtonStart(),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: elevatedButtonStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, RouteList.bMeetJoin);
                        },
                        child: Text(S.current.bmeet_btn_join),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            style: elevatedButtonStyle,
                            onPressed: () async {
                              final update = await Navigator.pushNamed(
                                  context, RouteList.bMeetSchedule);
                              if (update != null && update is bool && update) {
                                ref.refresh(bMeetHistoryProvider);
                                ref.read(selectedDateProvider.notifier).state =
                                    DateTime.now();
                              }
                            },
                            child: Text(S.current.bmeet_btn_schedule),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
        Center(
          child: Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(loginRepositoryProvider).user;
              return Column(
                children: [
                  getRectFAvatar(
                      size: 22.w, user?.name ?? '', user?.image ?? ''),
                  SizedBox(height: 0.5.h),
                  Text(user?.name ?? '', style: textStyleBlack),
                ],
              );
            },
          ),
        ),
      ],
    );
    //   },
    // );
  }

  Widget _buildButtonStart() {
    return Consumer(
      builder: (context, ref, child) {
        return InkWell(
          onTap: () async {
            showLoading(ref);
            final result =
                await ref.read(bMeetRepositoryProvider).createInstantMeeting();
            hideLoading(ref);
            if (result != null) {
              Navigator.pushNamed(context, RouteList.bMeetStart,
                  arguments: result);
            } else {
              AppSnackbar.instance
                  .error(context, 'Error occurred while creating meeting');
            }
          },
          child: CircleAvatar(
              backgroundColor: AppColors.yellowAccent,
              radius: 5.w,
              // onPressed: () {},
              child: getSvgIcon('icon_next.svg', width: 4.5.w)),
        );
      },
    );
  }
}
