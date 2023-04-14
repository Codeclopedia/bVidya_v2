import 'package:bvidya/app.dart';
import 'package:intl/intl.dart';

import '../../../dialog/ok_dialog.dart';
import '/controller/profile_providers.dart';
import '../../../dialog/basic_dialog.dart';
import '/core/state.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';
import '/data/models/response/bmeet/requested_class_response.dart';
// import './dialog/image_picker_dialog.dart';

class RequestDetailScreen extends StatelessWidget {
  final RequestedClass requestdata;
  const RequestDetailScreen({super.key, required this.requestdata});

  @override
  Widget build(BuildContext context) {
    final dateFormated = DateFormat('yyyy-MM-dd hh:mm:ss')
        .parse(requestdata.preferred_date_time ?? DateTime.now().toString());

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
                                S.current.class_request_title,
                                style: textStyleHeading.copyWith(
                                    fontSize: 12.5.sp),
                              ),
                              SizedBox(
                                height: 1.w,
                              ),
                              Text(
                                requestdata.instructorName ?? "",
                                style: textStyleBlack.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  customTile(
                                      title: S.current.request_class_topic,
                                      data: requestdata.topic ?? ""),
                                  customTile(
                                      title: S.current.request_class_type,
                                      data: requestdata.type ?? ""),
                                  customTile(
                                      title:
                                          S.current.request_class_description,
                                      data: requestdata.description ?? ""),
                                  customTile(
                                    title: S.current.preferredDate,
                                    data:
                                        DateFormat.yMEd().format(dateFormated),
                                  ),
                                  customTile(
                                    title: S.current.preferredTime,
                                    data: DateFormat.jm().format(dateFormated),
                                  ),
                                  if (requestdata.status != 'pending')
                                    customTile(
                                        title: 'status',
                                        data: requestdata.status ?? ''),
                                ],
                              ),
                            ],
                          ),
                          if (requestdata.status == 'pending')
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showBasicDialog(
                                        context,
                                        S.current.requested_class_delete,
                                        S.current.requested_class_delete_msg,
                                        S.current.menu_delete, () async {
                                      // await handler(true);
                                      final res = await ref
                                          .read(profileRepositoryProvider)
                                          .deleteClassRequest(
                                              requestdata.id.toString());

                                      if (res.status == 'success') {
                                        if (navigatorKey
                                            .currentContext!.debugDoingBuild) {}
                                        showOkDialog(
                                          context,
                                          S.current.requested_class_delete,
                                          S.current.requested_class_delete_msg,
                                          type: true,
                                          positiveAction: () async {
                                            await ref
                                                .read(profileRepositoryProvider)
                                                .deleteClassRequest(
                                                    requestdata.id.toString());
                                            if (navigatorKey.currentContext!
                                                .debugDoingBuild) {}
                                            Navigator.pop(context);
                                          },
                                        );
                                      } else {
                                        if (navigatorKey
                                            .currentContext!.debugDoingBuild) {}
                                        AppSnackbar.instance.error(context,
                                            res.message ?? S.current.error);
                                        if (navigatorKey
                                            .currentContext!.debugDoingBuild) {}
                                        Navigator.pop(context);
                                      }
                                      ref.refresh(requestedClassesProvider);
                                    }, negativeAction: () async {
                                      // await handler(false);
                                    }, negativeButton: S.current.dltCancel);
                                  },
                                  style: elevatedButtonTextStyle.copyWith(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(100.w, 12.5.w))),
                                  child: Text(
                                    'Delete Request',
                                    style: textStyleBlack.copyWith(
                                        color: Colors.white, fontSize: 12.5.sp),
                                  )),
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
                                  requestdata.instructorImage ?? ''),
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
              color: Colors.grey, fontSize: 4.w, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
