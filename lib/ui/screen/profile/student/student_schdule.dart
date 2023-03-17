// import '/core/constants/route_list.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';

import '/core/utils.dart';
import '/ui/screens.dart';

import '/core/constants.dart';
import '/data/models/response/profile/schduled_classes_model.dart';
import '/controller/profile_providers.dart';
import '/core/ui_core.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/widget/sliding_tab.dart';
import '/ui/widgets.dart';

import '/core/state.dart';
import '/data/models/response/bmeet/requested_class_response.dart';
import '../base_settings_noscroll.dart';

final scheduledClassTabIndexProvider = StateProvider<int>((ref) => 0);

class StudentScheduleScreen extends StatelessWidget {
  const StudentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Consumer(builder: (context, ref, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.w, bottom: 3.w),
              child: SlidingTab(
                label1: "Scheduled Class",
                label2: "Request sent",
                selectedIndex: ref.watch(scheduledClassTabIndexProvider),
                callback: (p0) {
                  ref.read(scheduledClassTabIndexProvider.notifier).state = p0;
                },
              ),
            ),
            ref.watch(scheduledClassTabIndexProvider) == 0
                ? scheduledClasses()
                : requestedClasses(ref)
          ],
        );

        // Column(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.symmetric(vertical: 5.w),
        //       child: SlidingTab(
        //         label1: "scheduled Class",
        //         label2: "Request sent",
        //         selectedIndex: ref.watch(scheduledClassTabIndexProvider),
        //         callback: (p0) {
        //           ref.read(scheduledClassTabIndexProvider.notifier).state = p0;
        //         },
        //       ),
        //     ),
        //     ref.watch(scheduledClassTabIndexProvider) == 0
        //         ? scheduledClasses()
        //         : requestedClasses(ref)
        //   ],
        // );
      }),
    );
  }

  Widget requestedClasses(WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: ref.watch(requestedClassesProvider).when(
              data: (data) {
                // print(data);
                if (data == null) {
                  return Center(
                    child: buildEmptyPlaceHolder(
                        S.current.t_no_requested_class_title),
                  );
                }
                if (data.requestedClasses?.isEmpty ?? false) {
                  return Center(
                    child: buildEmptyPlaceHolder(
                        S.current.t_no_requested_class_title),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.requestedClasses?.length,
                  itemBuilder: (context, index) {
                    return _buildRequestRow(
                        data.requestedClasses?[index] ?? RequestedClass(),
                        context);
                  },
                );
              },
              error: (error, stackTrace) => buildEmptyPlaceHolder('Error'),
              loading: () => ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: CustomizableShimmerTile(height: 20.w, width: 100.w),
                  );
                },
              ),
            ),
      ),
    );
  }

  Widget scheduledClasses() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(scheduledClassesAsStudent).when(
          data: (data) {
            if (data == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (data.scheduledRequests?.isEmpty ?? true) {
              return buildEmptyPlaceHolder(S.current.s_no_schedule_class);
            }
            return scheduledClasseslist(data.scheduledRequests ?? []);
          },
          error: (error, stackTrace) {
            return buildEmptyPlaceHolder(S.current.error);
          },
          loading: () {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: CustomizableShimmerTile(height: 30.w, width: 100.w),
                );
              },
            );
          },
        );
      }),
    ));
  }

  Widget scheduledClasseslist(
      List<StudentScheduledClassDetails> scheduledRequests) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduledRequests.length,
      itemBuilder: (context, index) {
        return scheduledClassRow(scheduledRequests[index], context);
      },
    );
  }

  Widget _buildRequestRow(RequestedClass data, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteList.requestedClassDetail,
              arguments: data);
        },
        child: Row(
          children: [
            getCicleAvatar(
                data.instructorName ?? 'U', data.instructorImage ?? '',
                radius: 3.h),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.instructorName ?? "",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: kFontFamily,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      getSvgIcon("class_type.svg",
                          width: 3.w, fit: BoxFit.contain),
                      SizedBox(
                        width: 1.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.3.h),
                        child: Text(
                          data.type ?? "",
                          style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.descTextColor,
                              fontFamily: kFontFamily,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            getSvgIcon("request_sent.svg")
          ],
        ),
      ),
    );
  }

  Widget scheduledClassRow(
      StudentScheduledClassDetails scheduledClassdetail, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat("MMMM \n d").format(
                      scheduledClassdetail.scheduledClass?.scheduledAt ??
                          DateTime.now()),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 3.5.w),
                ),
                SizedBox(
                  width: 4.w,
                ),
                SizedBox(
                  width: 40.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheduledClassdetail.scheduledClass?.title ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 4.5.w),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColors.iconGreyColor,
                            size: 3.w,
                          ),
                          Text(
                            scheduledClassdetail
                                    .scheduledClass?.participants?.length
                                    .toString() ??
                                "",
                            style: TextStyle(
                                fontSize: 3.w, color: AppColors.iconGreyColor),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.notes,
                            size: 3.w,
                            color: AppColors.iconGreyColor,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            scheduledClassdetail.type ?? "",
                            style: TextStyle(
                                fontSize: 3.w, color: AppColors.iconGreyColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 3.w,
                            color: AppColors.iconGreyColor,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            DateFormat('hh:mm a').format(scheduledClassdetail
                                    .scheduledClass?.scheduledAt ??
                                DateTime.now()),
                            style: TextStyle(
                                fontSize: 3.w, color: AppColors.iconGreyColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Consumer(builder: (context, ref, child) {
              return InkWell(
                onTap: () async {
                  // Navigator.pushNamed(
                  //               context, RouteList.teacherRequestedClassDetail,
                  //               arguments: data.personalClasses?[index] ??
                  //                   PersonalClass());

                  showLoading(ref);
                  final user = await getMeAsUser();
                  if (user == null) {
                    hideLoading(ref);
                  }
                  final indexOfUser = scheduledClassdetail
                      .scheduledClass?.participants
                      ?.indexWhere((element) => element.user?.id == user?.id);
                  final userPaymentDetails = scheduledClassdetail.scheduledClass
                      ?.participants?[indexOfUser ?? 0].paymentDetail;
                  // print(
                  //     "user details: ${userPaymentDetails?.razorpayPaymentLinkStatus}");
                  if (userPaymentDetails?.razorpayPaymentLinkStatus == 'paid') {
                    hideLoading(ref);

                    Navigator.pushNamed(
                        context, RouteList.scheduledClassMeetingScreen,
                        arguments: scheduledClassdetail);
                  } else {
                    final arg = {
                      'url': userPaymentDetails?.paymentLinkShortUrl
                    };
                    hideLoading(ref);
                    if (arg['url'] == null) {}
                    Navigator.pushNamed(context, RouteList.webview,
                        arguments: arg);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.yellowAccent,
                  radius: 5.w,
                  child: Icon(
                    Icons.adaptive.arrow_forward,
                    size: 5.w,
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
