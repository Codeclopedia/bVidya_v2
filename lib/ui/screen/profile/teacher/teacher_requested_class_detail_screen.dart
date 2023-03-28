import 'package:bvidya/controller/profile_providers.dart';
import 'package:bvidya/ui/dialog/ok_dialog.dart';
import 'package:bvidya/ui/screens.dart';
import 'package:intl/intl.dart';

import '/core/constants.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '/core/ui_core.dart';

final remarkTextProvider = StateProvider<String?>(
  (ref) {
    return null;
  },
);

class TeacherRequestedClassDetailScreen extends StatelessWidget {
  final PersonalClass requestedClass;
  const TeacherRequestedClassDetailScreen(
      {super.key, required this.requestedClass});

  @override
  Widget build(BuildContext context) {
    // print(requestedClass.toJson());

    final preferredDate = DateFormat('yyyy-MM-dd hh:mm:ss')
        .parse(requestedClass.preferred_date_time ?? DateTime.now().toString());
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
                                S.current.class_requested_title,
                                style: textStyleHeading,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),
                              Text(
                                requestedClass.studentName ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    customTile(
                                        title: S.current.request_class_topic,
                                        data: requestedClass.topic ?? ""),
                                    customTile(
                                        title: S.current.request_class_type,
                                        data: requestedClass.type ?? ""),
                                    customTile(
                                        title:
                                            S.current.request_class_description,
                                        data: requestedClass.description ?? ""),
                                    customTile(
                                        title: S.current.preferredDate,
                                        data: DateFormat.yMEd()
                                            .format(preferredDate)),
                                    customTile(
                                        title: S.current.preferredTime,
                                        data: DateFormat.jm()
                                            .format(preferredDate)),
                                    if (requestedClass.status != "pending")
                                      customTile(
                                          title: 'status',
                                          data: requestedClass.status ?? ''),

                                    // customTile(
                                    //     title: S.current.preferredDate,
                                    //     data: DateFormat.yMEd().format(
                                    //         requestedClass.preferred_date_time ??
                                    //             DateTime.now())),
                                    // customTile(
                                    //     title: S.current.preferredTime,
                                    //     data: DateFormat.yMEd().format(
                                    //         requestedClass.preferred_date_time ??
                                    //             DateTime.now()))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (requestedClass.status == "pending")
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return remarkPopUp(true);
                                          },
                                        );
                                      },
                                      style:
                                          elevatedButtonSecondaryStyle.copyWith(
                                              backgroundColor:
                                                  const MaterialStatePropertyAll(
                                                      AppColors.primaryColor)),
                                      child: Text(
                                          S.current.class_request_accept,
                                          style: textStyleTitle.copyWith(
                                              color: AppColors.cardWhite)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return remarkPopUp(false);
                                          },
                                        );
                                      },
                                      style: elevatedButtonPrimaryStyle.copyWith(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                                  AppColors.cardWhite)),
                                      child: Text(
                                        S.current.class_request_reject,
                                        style: textStyleTitle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
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
                              image: getImageProvider(
                                  requestedClass.studentImage ?? ''),
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

  Widget remarkPopUp(bool isAccepted) {
    final formkey = GlobalKey<FormState>();

    return Center(
      child: Consumer(builder: (context, ref, child) {
        return Container(
            width: 80.w,
            height: 90.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.w,
                ),
              ],
              borderRadius: BorderRadius.circular(6.w),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getSvgIcon(isAccepted ? 'accept.svg' : 'reject.svg',
                    width: 20.w, fit: BoxFit.fitWidth),
                SizedBox(height: 2.w),
                Text(
                  S.current.remark,
                  style: textStyleHeading.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 2.w),
                Form(
                  key: formkey,
                  child: TextFormField(
                      minLines: 2,
                      maxLines: 4,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        ref.read(remarkTextProvider.notifier).state = value;
                      },
                      onFieldSubmitted: (value) async {
                        if (formkey.currentState!.validate()) {
                          showLoading(ref);

                          final arg = {
                            'classID': requestedClass.id,
                            'accepted': true,
                            'remark': ref.read(remarkTextProvider)
                          };
                          final res = await ref
                              .read(profileRepositoryProvider)
                              .updateClassStatus(arg);
                          hideLoading(ref);

                          if (res == "success") {
                            Navigator.popUntil(context,
                                ModalRoute.withName(RouteList.teacherSchedule));
                            showOkDialog(
                              context,
                              'Request Accepted',
                              'Request accepted Notification is sent to the student.',
                              positiveAction: () {
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            EasyLoading.showError(S.current.error);
                          }

                          if (context.debugDoingBuild) {}
                          Navigator.pop(context);
                        }
                      },
                      validator: (value) {
                        if (value?.trim() == null || value!.isEmpty) {
                          return S.current.class_request_remark_empty_hint;
                        }

                        return null;
                      },
                      decoration: inputMultiLineStyle.copyWith(
                        hintText: isAccepted
                            ? S.current.class_request_accept_remark_hint
                            : S.current.class_request_reject_remark_hint,
                      )),
                ),
                SizedBox(height: 4.w),
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        showLoading(ref);

                        final arg = {
                          'classID': requestedClass.id,
                          'accepted': true,
                          'remark': ref.read(remarkTextProvider)
                        };
                        final res = await ref
                            .read(profileRepositoryProvider)
                            .updateClassStatus(arg);
                        hideLoading(ref);
                        print(res);
                        if (res == "success") {
                          Navigator.popUntil(context,
                              ModalRoute.withName(RouteList.teacherSchedule));

                          showOkDialog(
                            context,
                            'Request Accepted',
                            'Request accepted Notification is sent to the student.',
                            positiveAction: () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          EasyLoading.showError(S.current.error);
                        }

                        if (context.debugDoingBuild) {}
                        Navigator.pop(context);
                      }
                    },
                    style: elevatedButtonStyle.copyWith(
                        fixedSize:
                            MaterialStatePropertyAll(Size(30.w, 12.5.w))),
                    child: Text(
                      S.current.submitBtn,
                      style: textStyleTitle.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ));
      }),
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
              color: Colors.grey,
              fontSize: 4.w,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
