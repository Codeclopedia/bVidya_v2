// import '/data/models/response/profile/scheduled_class_instructor_model.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/helpers/bmeet_helper.dart';
import '../../../../core/utils.dart';
import '../../../screens.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class StudentScheduledClassDetailScreen extends StatelessWidget {
  final StudentScheduledClassDetails scheduledClass;
  const StudentScheduledClassDetailScreen(
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
                                style: textStyleHeading,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),
                              Text(
                                scheduledClass.instructor?.name ?? "",
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
                                      data: scheduledClass
                                              .scheduledClass?.title ??
                                          ""),
                                  customTile(
                                      title: S.current.request_class_type,
                                      data: scheduledClass.type ?? ""),
                                  customTile(
                                      title: S.current.Class_timing_title,
                                      data: DateFormat.yMMMEd().format(
                                          scheduledClass.scheduledClass
                                                  ?.scheduledAt ??
                                              DateTime.now())),
                                  SizedBox(
                                    height: 6.w,
                                  ),
                                  Text(
                                    S.current.class_participants_title,
                                    style: TextStyle(
                                        fontFamily: kFontFamily,
                                        color: AppColors.primaryColor,
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 2.w,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: scheduledClass.scheduledClass
                                            ?.participants?.length ??
                                        0,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${index + 1}. ${scheduledClass.scheduledClass?.participants?[index].user?.name ?? ""}",
                                              style: TextStyle(
                                                  fontFamily: kFontFamily,
                                                  color: Colors.black,
                                                  fontSize: 4.w,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              scheduledClass
                                                      .scheduledClass
                                                      ?.participants?[index]
                                                      .paymentDetail
                                                      ?.razorpayPaymentLinkStatus ??
                                                  "",
                                              style: TextStyle(
                                                  fontFamily: kFontFamily,
                                                  color: Colors.black,
                                                  fontSize: 4.w,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: UserConsumer(
                              builder: (context, user, ref) {
                                final indexOfUser = scheduledClass
                                    .scheduledClass?.participants
                                    ?.indexWhere((element) =>
                                        element.user?.id == user.id);
                                final userPaymentDetails = scheduledClass
                                    .scheduledClass
                                    ?.participants?[indexOfUser ?? 0]
                                    .paymentDetail;
                                return ElevatedButton(
                                  style: elevatedButtonTextStyle.copyWith(
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(100.w, 15.w))),
                                  onPressed: () async {
                                    showLoading(ref);

                                    if (userPaymentDetails
                                            ?.razorpayPaymentLinkStatus ==
                                        'paid') {
                                      hideLoading(ref);

                                      Navigator.pushNamed(context,
                                          RouteList.scheduledClassMeetingScreen,
                                          arguments: scheduledClass);
                                    } else {
                                      hideLoading(ref);
                                      paymentforClass(
                                          scheduledClass
                                                  .scheduledClass
                                                  ?.participants?[
                                                      indexOfUser ?? 0]
                                                  .paymentDetail
                                                  ?.paymentLinkShortUrl ??
                                              "",
                                          ref,
                                          context);
                                    }
                                  },
                                  child: userPaymentDetails
                                              ?.razorpayPaymentLinkStatus ==
                                          'paid'
                                      ? Text(
                                          S.current.bmeet_btn_join,
                                          style: textStyleBlack.copyWith(
                                              color: AppColors.cardWhite,
                                              fontSize: 15.sp),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.attach_money,
                                                color: AppColors.yellowAccent,
                                                size: 7.w),
                                            SizedBox(width: 1.w),
                                            Text('Pay',
                                                style: textStyleBlack.copyWith(
                                                    color: AppColors.cardWhite,
                                                    fontSize: 15.sp)),
                                          ],
                                        ),
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
                                      .scheduledClass
                                      ?.participants?[0]
                                      .userImage
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

  // showLoading(ref);
  //                 final user = await getMeAsUser();
  //                 if (user == null) {
  //                   hideLoading(ref);
  //                   return;
  //                 }
  //                 final indexOfUser = scheduledClassdetail
  //                     .scheduledClass?.participants
  //                     ?.indexWhere((element) => element.user?.id == user.id);
  //                 final userPaymentDetails = scheduledClassdetail.scheduledClass
  //                     ?.participants?[indexOfUser ?? 0].paymentDetail;

  //                 hideLoading(ref);

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
              fontSize: 4.w,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 2.w,
        ),
        Text(
          data,
          style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 4.w,
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
