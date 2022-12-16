// ignore_for_file: must_be_immutable

import 'package:intl/intl.dart';

import '../../../controller/blive_providers.dart';
import '../../../core/constants.dart';
import '../../../core/state.dart';
import '../../../core/ui_core.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/models.dart';
import '../../widget/calendar_view.dart';
import '../../widgets.dart';
import '../blearn/widget/common.dart';

class BLiveHomeScreen extends HookWidget {
  BLiveHomeScreen({Key? key}) : super(key: key);

  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _controller = TextEditingController();
      return dipose;
    }, []);
    return LiveDrawerScreen(
      screenName: RouteList.bLive,
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
                        ? S.current.blive_today_meeting
                        : S.current.blive_date_meeting(
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
            child: _buildCalendar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SafeArea(child: SizedBox(height: 1)),
        _buildCard(context),
        SizedBox(height: 2.h),
        Text(
          S.current.blive_txt_schedule,
          style: textStyleWhite.copyWith(
            fontSize: 12.sp,
          ),
        ),
        // SizedBox(height: 0.5.h),
        CalendarView(
          onSelectedDate: (date) {},
        )
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    // return Consumer(
    //   builder: (context, ref, child) {
    //     final user = ref.watch(loginRepositoryProvider).user;
    //     if (user == null) return const SizedBox.shrink();
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
                SizedBox(height: 5.h),
                Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(loginRepositoryProvider).user;
                      return Text(user?.name ?? '', style: textStyleBlack);
                    },
                  ),
                ),
                SizedBox(height: 3.h),
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
                    InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                          backgroundColor: AppColors.yellowAccent,
                          radius: 5.w,
                          child: getSvgIcon('icon_next.svg', width: 4.5.w)),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: _controller,
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
          child: Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(loginRepositoryProvider).user;
              return getRectFAvatar(
                  size: 22.w, user?.name ?? '', user?.image ?? '');
            },
          ),
        ),
      ],
    );
    //   },
    // );
  }

  Widget _buildHistory() {
    return Container(
      height: 20.h,
      alignment: Alignment.bottomLeft,
      child: Consumer(
        builder: (context, ref, child) {
          return ref.watch(bLiveSelectedHistoryProvider).when(
              data: (liveBroadcasts) {
                if (liveBroadcasts.isNotEmpty == true) {
                  return _buildData(liveBroadcasts);
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

  Widget _buildData(List<LMSLiveClass> broadcastList) {
    return ListView.builder(
      itemCount: broadcastList.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final broadcast = broadcastList[index];
        return Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(3.w),
          height: 20.h,
          width: 35.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: const Color(0xFF707070), width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.current.blive_txt_broadcast,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 7.sp,
                    fontFamily: kFontFamily,
                    color: AppColors.black,
                  )),
              SizedBox(height: 1.w),
              Text(
                broadcast.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9.sp,
                  fontFamily: kFontFamily,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                // "",
                '${parseMeetingTime(broadcast.startsAt ?? '')}}',
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
                    S.current.blive_btx_join,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 7.sp,
                        fontFamily: kFontFamily,
                        color: AppColors.black),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return GestureDetector(
                        onTap: () {
                          // startMeeting(context, ref, meeting, true, false);
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.yellowAccent,
                          radius: 1.5.h,
                          child: getSvgIcon('icon_next.svg', width: 1.4.h),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void dipose() {}
}
