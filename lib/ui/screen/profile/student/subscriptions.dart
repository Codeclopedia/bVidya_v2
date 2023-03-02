import '/controller/profile_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/screen/profile/base_settings_noscroll.dart';
import '/ui/screens.dart';
import '/ui/widget/shimmer_tile.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '/core/constants.dart';
import '/core/utils/razorpay.dart';

final selectedSubscriptionIndex = StateProvider.autoDispose(
  (ref) {
    return -1;
  },
);

class SubscriptionPlans extends HookConsumerWidget {
  const SubscriptionPlans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late Razorpay _razorpay;

    useEffect(
      () {
        _razorpay = Razorpay();
        return () {
          _razorpay.clear();
        };
      },
    );
    return BaseNoScrollSettings(
        bodyContent: Consumer(builder: (context, ref, child) {
      final subscriptionPlansData = ref.watch(subscriptionPlansProvider);
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.w,
                ),
                Text(
                  S.current.Select_subscription_title,
                  style: textStyleBlack,
                ),
                subscriptionPlansData.when(
                  data: (data) {
                    if (data == null) {
                      return buildEmptyPlaceHolder(S.current.error);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.plans?.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedSubscriptionIndex.notifier).state =
                                index;
                          },
                          child: subscriptionPlantile(
                            planName: "${data.plans?[index].name} Plan",
                            numberofCourses:
                                "${data.plans?[index].courseCredit} Courses",
                            desc:
                                "*subscribe any ${data.plans?[index].courseCredit} courses through this subscription",
                            price: "₹ ${data.plans?[index].price}",
                            isSelected: true,
                            ref: ref,
                            index: index,
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return buildEmptyPlaceHolder(S.current.error);
                  },
                  loading: () {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 2.w),
                        CustomizableShimmerTile(height: 20.w, width: 100.w),
                        SizedBox(height: 2.w),
                        CustomizableShimmerTile(height: 20.w, width: 100.w),
                        SizedBox(height: 2.w),
                        CustomizableShimmerTile(height: 20.w, width: 100.w),
                        SizedBox(height: 2.w),
                        CustomizableShimmerTile(height: 20.w, width: 100.w),
                      ],
                    );
                  },
                ),
                // ListView.builder(itemBuilder: (context, index) {
                //   // return subscriptionPlantile(planName, numberofCourses, price, desc)
                // },)
              ],
            ),
          ),
          ref.watch(selectedSubscriptionIndex) == -1
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.iconGreyColor.withOpacity(0.4),
                            offset: Offset(0, -2.w),
                            blurRadius: 5.w)
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.total_incltax_title,
                              style: textStyleBlack,
                            ),
                            subscriptionPlansData.when(
                              data: (data) {
                                return Text(
                                  "₹ ${data?.plans?[ref.watch(selectedSubscriptionIndex)].price}",
                                  style: textStyleHeading,
                                );
                              },
                              error: (error, stackTrace) {
                                return Text(
                                  "₹ ...",
                                  style: textStyleHeading,
                                );
                              },
                              loading: () {
                                return Text(
                                  "₹ ...",
                                  style: textStyleHeading,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 2.w),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: S.current
                                  .subscription_term_condition_title_part1,
                              style: textStyleDesc.copyWith(fontSize: 3.w)),
                          TextSpan(
                              text: S.current
                                  .subscription_term_condition_title_part2,
                              style: textStyleDesc.copyWith(
                                  fontSize: 3.w,
                                  color: AppColors.primaryColor)),
                        ])),
                        SizedBox(height: 2.w),
                        ElevatedButton(
                          onPressed: () async {
                            showLoading(ref);
                            try {
                              await paymentProcess(
                                  _razorpay,
                                  ref,
                                  subscriptionPlansData
                                          .value
                                          ?.plans?[ref
                                              .read(selectedSubscriptionIndex)]
                                          .id
                                          .toString() ??
                                      "");
                              ref.refresh(creditHistoryProvider);
                            } catch (e) {
                              hideLoading(ref);
                              EasyLoading.showError(S.current.error);
                            }
                          },
                          style: elevatedButtonStyle.copyWith(
                              fixedSize: MaterialStatePropertyAll<Size?>(
                                  Size(100.w, 15.w))),
                          child: Text(S.current.get_plan_title),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      );
    }));
  }

  paymentProcess(Razorpay razorpay, WidgetRef ref, String planId) async {
    final value =
        await ref.read(profileRepositoryProvider).getpaymentId(planId);
    if (value.key != null && value.plan?.price != null && value.user != null) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      var options = {
        "key": value.key,
        "amount": value.plan!.price! *
            100, // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
        "currency": "INR",
        "name": "Bvidya",
        "description": "Bvidya ${value.plan?.name}",
        "image": "https://bvidya.com/assets/images/logo.png",
        "order_id": value.orderId,

        "prefill": {
          "name": value.user?.name,
          "email": value.user?.email,
          "contact": value.user?.phone
        },

        "theme": {"color": "#3399cc"}
        // "theme": {"color": "#660629"}
        // 'key': value?.orderId,
        // 'amount': value?.plan?.price ?? 99 * 100,
        // 'name': "Bvidya ${value?.plan?.name}",
        // 'description': value?.plan?.name,
        // // 'retry': {'enabled': true, 'max_count': 1},
        // 'send_sms_hash': true,
        // 'prefill': {'contact': user?.phone, 'email': user?.email},
        // 'external': {
        //   'wallets': [
        //     'paytm',
        //     'freecharge',
        //     'payzapp',
        //     'airtelmoney',
        //     'mobikwik',
        //     'jiomoney',
        //     'olamoney',
        //     'phonepe',
        //     'phonepeswitch',
        //     'paypal',
        //     'amazonpay'
        //   ]
        // }
      };
      hideLoading(ref);
      razorpay.open(options);
    }
    // return ref.read(paymentIdProvider(planId)).when(
    //   data: (data) {
    //     data.then((value) {
    //       var options = {
    //         "key": value?.key,
    //         "amount": value!.plan!.price! *
    //             100, // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
    //         "currency": "INR",
    //         "name": "Bvidya",
    //         "description": "Bvidya ${value.plan?.name}",
    //         "image": "https://bvidya.com/assets/images/logo.png",
    //         "order_id": value.orderId,

    //         "prefill": {
    //           "name": value.user?.name,
    //           "email": value.user?.email,
    //           "contact": value.user?.phone
    //         },

    //         "theme": {"color": "#3399cc"}
    //         // "theme": {"color": "#660629"}
    //         // 'key': value?.orderId,
    //         // 'amount': value?.plan?.price ?? 99 * 100,
    //         // 'name': "Bvidya ${value?.plan?.name}",
    //         // 'description': value?.plan?.name,
    //         // // 'retry': {'enabled': true, 'max_count': 1},
    //         // 'send_sms_hash': true,
    //         // 'prefill': {'contact': user?.phone, 'email': user?.email},
    //         // 'external': {
    //         //   'wallets': [
    //         //     'paytm',
    //         //     'freecharge',
    //         //     'payzapp',
    //         //     'airtelmoney',
    //         //     'mobikwik',
    //         //     'jiomoney',
    //         //     'olamoney',
    //         //     'phonepe',
    //         //     'phonepeswitch',
    //         //     'paypal',
    //         //     'amazonpay'
    //         //   ]
    //         // }
    //       };
    //       hideLoading(ref);
    //       razorpay.open(options);
    //     });
    //     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //   },
    //   error: (error, stackTrace) {
    //     return buildEmptyPlaceHolder(S.current.error);
    //   },
    //   loading: () {
    //     return const CircularProgressIndicator.adaptive();
    //   },
    // );
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    await getpaymentSuccessDetails(response.orderId ?? "",
        response.paymentId ?? "", response.signature ?? "");
  }

  _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.showError(response.message ?? S.current.transaction_error);

    // Do something when payment fails
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

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
            boxShadow: ref.watch(selectedSubscriptionIndex) == index
                ? [
                    BoxShadow(
                        blurRadius: 2.w,
                        offset: Offset(1.w, 1.w),
                        color: Colors.grey.withOpacity(0.4))
                  ]
                : [],
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
                color: ref.watch(selectedSubscriptionIndex) == index
                    ? AppColors.primaryColor
                    : Colors.transparent)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 4.w,
                      width: 4.w,
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.w),
                          color: ref.watch(selectedSubscriptionIndex) == index
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          border: Border.all(color: AppColors.primaryColor)),
                    ),
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
                      width: 6.w,
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
