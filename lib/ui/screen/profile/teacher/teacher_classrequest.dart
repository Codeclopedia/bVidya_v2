// import 'package:flutter/material.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:intl/intl.dart';

import '/data/models/models.dart';
import '/controller/profile_providers.dart';
import '/core/utils/chat_utils.dart';
// import '/data/models/response/profile/scheduled_class_instructor_model.dart';

import '/ui/widget/sliding_tab.dart';
import '/core/constants/route_list.dart';
import '/controller/bmeet_providers.dart';
import '/core/state.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/widget/shimmer_tile.dart';

import '../base_settings_noscroll.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';
// import '../base_settings.dart';

final teacherClassesTabProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

class TeacherClasses extends StatelessWidget {
  const TeacherClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
        showName: false,
        bodyContent: Consumer(builder: (context, ref, child) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(scheduledClassesAsInstructor);
              ref.refresh(bmeetClassesProvider);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.w, bottom: 3.w),
                    child: SlidingTab(
                      label1: "Scheduled Class",
                      label2: S.current.tp_classes,
                      selectedIndex: ref.watch(teacherClassesTabProvider),
                      callback: (p0) {
                        ref.read(teacherClassesTabProvider.notifier).state = p0;
                      },
                    ),
                  ),
                  ref.watch(teacherClassesTabProvider) == 0
                      ? scheduledClassWidget()
                      : classRequestWidget()
                ],
              ),
            ),
          );
        }));
  }

  Widget scheduledClassWidget() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(scheduledClassesAsInstructor).when(
          data: (data) {
            if (data == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (data.scheduledClasses?.isEmpty ?? true) {
              return buildEmptyPlaceHolder('No scheduled class.');
            }
            return scheduledClasseslist(data.scheduledClasses ?? [], context);
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

  Widget classRequestWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 2.w,
          // ),
          // Text(
          //   S.current.tp_classes,
          //   style: TextStyle(
          //       fontFamily: kFontFamily,
          //       color: AppColors.primaryColor,
          //       fontSize: 5.5.w,
          //       fontWeight: FontWeight.w500),
          // ),
          SizedBox(height: 1.h),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              return ref.watch(bmeetClassesProvider).when(
                data: (data) {
                  if (data == null) {
                    return buildEmptyPlaceHolder(S.current.empty_class_request);
                  }
                  if (data.personalClasses?.isEmpty ?? false) {
                    return buildEmptyPlaceHolder(S.current.empty_class_request);
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.personalClasses?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const Divider(color: AppColors.dividerCall),
                    itemBuilder: (context, index) {
                      return _buildRequestRow(context,
                          data.personalClasses?[index] ?? PersonalClass());
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
                        child:
                            CustomizableShimmerTile(height: 20.w, width: 100.w),
                      );
                    },
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget scheduledClasseslist(
      List<InstructorScheduledClass> scheduledRequests, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: scheduledRequests.length,
      itemBuilder: (context, index) {
        return scheduledClassRow(scheduledRequests[index], context);
      },
    );
  }

  Widget scheduledClassRow(
      InstructorScheduledClass scheduledClass, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(2.w)),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                DateFormat("MMMM \n d")
                    .format(scheduledClass.scheduledAt ?? DateTime.now()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: kFontFamily,
                  fontSize: 10.sp,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              // Expanded(
              // width: 40.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheduledClass.title ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: kFontFamily,
                      fontSize: 13.sp,
                    ),
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
                        scheduledClass.participants?.length.toString() ?? "",
                        style: TextStyle(
                            fontSize: 8.sp,
                            fontFamily: kFontFamily,
                            color: AppColors.iconGreyColor),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.notes,
                        size: 3.w,
                        color: AppColors.iconGreyColor,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        scheduledClass.type ?? "",
                        style: TextStyle(
                            fontSize: 8.sp,
                            fontFamily: kFontFamily,
                            color: AppColors.iconGreyColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 3.w,
                        color: AppColors.iconGreyColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        DateFormat('hh:mm a').format(
                            scheduledClass.scheduledAt ?? DateTime.now()),
                        style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: kFontFamily,
                            color: AppColors.iconGreyColor),
                      )
                    ],
                  )
                ],
              ),
              //     ),
              //   ],
              // ),
            ),
            InkWell(
              onTap: () {
                // Navigator.pushNamed(
                //               context, RouteList.teacherRequestedClassDetail,
                //               arguments: data.personalClasses?[index] ??
                //                   PersonalClass());
                Navigator.pushNamed(context, RouteList.classScheduledDetail,
                    arguments: scheduledClass);
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRequestRow(BuildContext context, PersonalClass data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, RouteList.teacherRequestedClassDetail,
                    arguments: data);
              },
              child: Row(
                children: [
                  getCicleAvatar(
                      data.studentName ?? 'A', data.studentImage ?? '',
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
                          child: Row(
                            children: [
                              Text(
                                data.type ?? "",
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: AppColors.descTextColor,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                " || ${DateFormat.yMEd().format(DateFormat('yyyy-mm-dd hh:mm:ss').parse(data.preferred_date_time ?? DateTime.now().toString()))}",
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: AppColors.descTextColor,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              chatwithstudent(
                context,
                data.userId ?? 0,
              );
            },
            child: getSvgIcon(
              'icon_req_chat.svg',
              width: 6.w,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(width: 1.w),
        ],
      ),
    );
  }

  chatwithstudent(BuildContext context, int studentId) async {
    final model = await getConversationModel(studentId.toString());
    if (model != null) {
      Navigator.pushNamed(context, RouteList.chatScreen, arguments: model);
      // Navigator.pushNamedAndRemoveUntil(
      //     context, RouteList.chatScreenDirect, (route) => false,
      //     arguments: model);
    }
  }
}
