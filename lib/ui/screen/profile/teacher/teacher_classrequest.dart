// import 'package:flutter/material.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:bvidya/core/utils/chat_utils.dart';
// import 'package:path/path.dart';

import '../../../widget/sliding_tab.dart';
import '/core/constants/route_list.dart';
import '/controller/bmeet_providers.dart';
import '/core/state.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/widget/shimmer_tile.dart';

import '/data/models/response/bmeet/class_request_response.dart';
import '../base_settings_noscroll.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';
// import '../base_settings.dart';

final teacherClassesTabProvider = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);

class TeacherClasses extends StatelessWidget {
  const TeacherClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
        showName: false,
        bodyContent: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 5.h),
          child: Consumer(builder: (context, ref, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, bottom: 3.w),
                  child: SlidingTab(
                    label1: "scheduled Class",
                    label2: S.current.tp_classes,
                    selectedIndex: ref.watch(teacherClassesTabProvider),
                    callback: (p0) {
                      ref.read(teacherClassesTabProvider.notifier).state = p0;
                    },
                  ),
                ),
                Text(
                  S.current.tp_classes,
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      color: AppColors.primaryColor,
                      fontSize: 5.5.w,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    return ref.watch(bmeetClassesProvider).when(
                      data: (data) {
                        if (data == null) {
                          return buildEmptyPlaceHolder(
                              S.current.empty_class_request);
                        }
                        if (data.personalClasses?.isEmpty ?? false) {
                          return buildEmptyPlaceHolder(
                              S.current.empty_class_request);
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: data.personalClasses?.length ?? 0,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) =>
                              const Divider(color: AppColors.divider),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    RouteList.teacherRequestedClassDetail,
                                    arguments: data.personalClasses?[index] ??
                                        PersonalClass());
                              },
                              child: _buildRequestRow(
                                  context,
                                  data.personalClasses?[index] ??
                                      PersonalClass()),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return buildEmptyPlaceHolder("Error");
                      },
                      loading: () {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: CustomizableShimmerTile(
                                  height: 20.w, width: 100.w),
                            );
                          },
                        );
                      },
                    );
                  }),
                )
              ],
            );
          }),
        ));
  }

  Widget _buildRequestRow(BuildContext context, PersonalClass data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          getCicleAvatar(data.studentName ?? 'A', data.studentImage ?? '',
              radius: 3.h),
          SizedBox(width: 5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.studentName ?? "",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: kFontFamily,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
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
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                chatwithstudent(
                  context,
                  data.userId ?? 0,
                );
              },
              icon: getSvgIcon('icon_req_chat.svg'))
        ],
      ),
    );
  }

  chatwithstudent(BuildContext context, int studentId) async {
    final model = await getConversationModel(studentId.toString());
    if (model != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteList.chatScreenDirect, (route) => false,
          arguments: model);
    }
  }
}
