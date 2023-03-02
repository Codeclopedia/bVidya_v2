import '/controller/profile_providers.dart';
import '/core/utils.dart';
import '/ui/screen/blearn/components/common.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/route_list.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';

class SubscriptionDetail extends StatelessWidget {
  const SubscriptionDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.popAndPushNamed(context, RouteList.profile);
        return true;
      },
      child: Scaffold(
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
                  Consumer(builder: (context, ref, child) {
                    return ref.watch(creditHistoryProvider).when(
                      data: (creditsDetails) {
                        if (creditsDetails == null) {
                          return buildEmptyPlaceHolder(S.current.error);
                        }
                        return Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.current.active_plan_title,
                                        style: textStyleHeading,
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),
                                      subscriptionPlantile(
                                        planName:
                                            "${creditsDetails.subscriptionPurchaseHistory?[0].name} Plan",
                                        numberofCourses:
                                            "${creditsDetails.avilableCourseCredits} Courses",
                                        desc:
                                            "*subscribe any ${creditsDetails.avilableCourseCredits} courses through this subscription",
                                        price:
                                            "₹ ${creditsDetails.subscriptionPurchaseHistory?[0].price}",
                                        isSelected: true,
                                        ref: ref,
                                        index: 0,
                                      ),
                                      SizedBox(height: 2.w),
                                      Text(
                                        S.current.credits_title,
                                        style: textStyleHeading,
                                      ),
                                      SizedBox(height: 2.w),
                                      Row(
                                        children: [
                                          getPngIcon('coin.png', width: 12.5.w),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            "${creditsDetails.avilableCourseCredits} Course Credit",
                                            style: textStyleBlack.copyWith(
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.w),
                                      Text(
                                        S.current.credit_description,
                                        style: textStyleBlack.copyWith(
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 10.w),
                                      Text(
                                        S.current.transaction_title,
                                        style: textStyleBlack.copyWith(
                                          fontSize: 5.w,
                                        ),
                                      ),
                                      SizedBox(height: 8.w),
                                      creditsDetails
                                                  .creditUsesHistory?.isEmpty ??
                                              false
                                          ? Center(
                                              child: Text(
                                                S.current.no_transaction_title,
                                                style: textStyleBlack.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey),
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: creditsDetails
                                                      .creditUsesHistory
                                                      ?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          creditsDetails
                                                                  .creditUsesHistory?[
                                                                      index]
                                                                  .courseName ??
                                                              "",
                                                          style: textStyleBlack
                                                              .copyWith(
                                                                  fontSize:
                                                                      4.w),
                                                        ),
                                                        Text(
                                                          DateFormat.yMMMEd()
                                                              .format(creditsDetails
                                                                      .creditUsesHistory?[
                                                                          index]
                                                                      .createdAt ??
                                                                  DateTime
                                                                      .now()),
                                                          style: textStyleBlack
                                                              .copyWith(
                                                                  fontSize: 2.w,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        getPngIcon('coin.png',
                                                            width: 2.w),
                                                        SizedBox(width: 1.w),
                                                        Text(
                                                          creditsDetails
                                                                  .creditUsesHistory?[
                                                                      index]
                                                                  .creditUsed
                                                                  .toString() ??
                                                              "0",
                                                          style:
                                                              textStyleCaption
                                                                  .copyWith(
                                                                      fontSize:
                                                                          4.w),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      },
                      error: (error, stackTrace) {
                        return buildEmptyPlaceHolder(S.current.error);
                      },
                      loading: () {
                        return buildLoading;
                      },
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, RouteList.profile);
                        },
                        icon: getSvgIcon('arrow_back.svg', color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteList.subscriptionPlans);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add_circle,
                                color: Colors.white, size: 4.5.w),
                            SizedBox(width: 1.w),
                            Text(
                              S.current.add_plan_title,
                              style: textStyleSettingTitle.copyWith(
                                  color: Colors.white),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),
                      )
                    ],
                  ),
                  FutureBuilder(
                    future: getMeAsUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Container(
                              height: 12.5.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: getImageProvider(
                                          snapshot.data?.image ?? ''),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),

                  // _buildHeader(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Widget buildUser() {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
  //     child: const BlearnUserTopBar(),
  //   );
  // }

  Widget subscriptionPlantile(
      {required String planName,
      required String numberofCourses,
      required String price,
      required String desc,
      required bool isSelected,
      required int index,
      required WidgetRef ref}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 4.w),
        decoration: BoxDecoration(
            color: AppColors.cardWhite,
            // boxShadow: ref.watch(selectedSubscriptionIndex) == index
            //     ? [
            //         BoxShadow(
            //             blurRadius: 2.w,
            //             offset: Offset(1.w, 1.w),
            //             color: Colors.grey.withOpacity(0.4))
            //       ]
            //     : [],
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
                color:
                    // ref.watch(selectedSubscriptionIndex) == index
                    //     ? AppColors.primaryColor
                    //     :
                    Colors.transparent)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 2.w,
                    ),
                    SizedBox(
                      width: 25.w,
                      child: Text(
                        planName,
                        style: textStyleBlack,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.yellowAccent.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2.w)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      child: Text(
                        numberofCourses,
                        style: textStyleCaption.copyWith(fontSize: 3.5.w),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 2.w,
                    ),
                    SizedBox(
                      width: 62.w,
                      child: Text(
                        desc,
                        style: textStyleSettingDesc,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              price,
              style: textStyleHeading,
            )
          ],
        ),
      ),
    );
  }
}
