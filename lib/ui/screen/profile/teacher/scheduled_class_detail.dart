// import '/data/models/response/profile/scheduled_class_instructor_model.dart';
import 'package:intl/intl.dart';

import '/core/constants.dart';
import '../../../screens.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '/core/ui_core.dart';
import '/core/helpers/extensions.dart';

class InstructorScheduledClassDetailScreen extends StatelessWidget {
  final InstructorScheduledClass scheduledClass;
  const InstructorScheduledClassDetailScreen(
      {super.key, required this.scheduledClass});

  @override
  Widget build(BuildContext context) {
    // print(scheduledClass.toJson());
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.gradientTopColor,
                AppColors.gradientLiveBottomColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 9.h),
                    padding: EdgeInsets.only(top: 12.5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          topLeft: Radius.circular(10.w)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.class_Scheduled_title,
                                style:
                                    textStyleHeading.copyWith(fontSize: 10.sp),
                              ),
                              SizedBox(
                                height: 1.w,
                              ),
                              Text(
                                scheduledClass
                                        .participants?[0].instructor?.name ??
                                    "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  customTile(
                                      title: S.current.request_class_topic,
                                      data: scheduledClass.title ?? ""),
                                  customTile(
                                      title: S.current.request_class_type,
                                      data: scheduledClass.type ?? ""),
                                  customTile(
                                      title: S.current.dateAndtime,
                                      data:
                                          "${DateFormat.yMMMd().format(scheduledClass.scheduledAt ?? DateTime.now())}, ${DateFormat.jm().format(scheduledClass.scheduledAt ?? DateTime.now())}"),
                                  customTile(
                                      title:
                                          S.current.request_class_description,
                                      data: scheduledClass
                                              .participants?[0].description ??
                                          ""),
                                  SizedBox(
                                    height: 6.w,
                                  ),
                                  participantBox()
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: UserConsumer(
                              builder: (context, user, ref) {
                                return Padding(
                                  padding: EdgeInsets.all(0.4.w),
                                  child: ElevatedButton(
                                      style: elevatedButtonTextStyle.copyWith(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.zero),
                                          fixedSize: MaterialStatePropertyAll(
                                              Size(100.w, 12.5.w))),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScheduledInstructorClassMeetingScreen(
                                                        scheduledClassDetails:
                                                            scheduledClass)));
                                      },
                                      child: Text(
                                        S.current.class_scheduled_start_title,
                                        style: textStyleBlack.copyWith(
                                            color: AppColors.cardWhite,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      )),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: getSvgIcon('arrow_back.svg', color: Colors.white),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Container(
                      height: 12.5.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: getImageProvider(scheduledClass
                                      .participants?[0]
                                      .instructorImage
                                      ?.image ??
                                  ''),
                              fit: BoxFit.cover)),
                    ),
                  ),
                )
                // _buildHeader(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget participantBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${S.current.class_participants_title} (${scheduledClass.participants?.length})",
          style: TextStyle(
              fontFamily: kFontFamily,
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4.w,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: scheduledClass.participants?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final participant = scheduledClass.participants?[index];
            return participantTile(
                participant ?? ScheduledClassParticipantDetail());
          },
        )
      ],
    );
  }

  Widget participantTile(ScheduledClassParticipantDetail participant) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getCicleAvatar("", participant.userImage?.image ?? "",
                      radius: 4.w),
                  SizedBox(width: 2.w),
                  Text(
                    participant.user?.name?.toTitleCase() ?? "",
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.black,
                        fontSize: 4.w,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  getSvgIcon(
                      participant.paymentDetail?.razorpayPaymentLinkStatus ==
                              "paid"
                          ? 'Paid.svg'
                          : 'Unpaid.svg',
                      width: 4.w),
                  SizedBox(width: 2.w),
                  Text(
                    participant.paymentDetail?.razorpayPaymentLinkStatus
                            ?.toCapitalized() ??
                        "",
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.black,
                        fontSize: 4.w,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget customTile({required String title, required String data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.w,
        ),
        Text(
          title,
          style: TextStyle(
              fontFamily: kFontFamily,
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 2.w,
        ),
        Text(
          data,
          style: TextStyle(
              fontFamily: kFontFamily,
              color: AppColors.inputHintText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  paymentforClass(String paymentShortUrl, WidgetRef ref, BuildContext context) {
    showLoading(ref);
    final arg = {'url': paymentShortUrl};
    hideLoading(ref);
    if (arg['url'] == null) {}
    Navigator.pushNamed(context, RouteList.webview, arguments: arg);
  }
}
