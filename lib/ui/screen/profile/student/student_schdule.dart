import '/controller/profile_providers.dart';
import '/core/ui_core.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/widget/sliding_tab.dart';
import '/ui/widgets.dart';

import '/core/constants/colors.dart';
import '/core/state.dart';
import '/data/models/response/bmeet/requested_class_response.dart';
import '../base_settings_noscroll.dart';

final scheduledClassTabIndexProvider = StateProvider<int>(
  (ref) => 0,
);

class StudentSchdule extends StatelessWidget {
  const StudentSchdule({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Consumer(builder: (context, ref, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: SlidingTab(
                label1: "scheduled Class",
                label2: "Request sent",
                selectedIndex: ref.watch(scheduledClassTabIndexProvider),
                callback: (p0) {
                  ref.read(scheduledClassTabIndexProvider.notifier).state = p0;
                },
              ),
            ),
            ref.watch(scheduledClassTabIndexProvider) == 0
                ? scheduledClasses()
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: ref.watch(requestedClassesProvider).when(
                            data: (data) {
                              if (data?.requestedClasses?.isEmpty ?? false) {
                                return Center(
                                  child: buildEmptyPlaceHolder(
                                      "No requested classes"),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data?.requestedClasses?.length,
                                itemBuilder: (context, index) {
                                  return _buildRequestRow(
                                      data?.requestedClasses?[index] ??
                                          RequestedClass());
                                },
                              );
                            },
                            error: (error, stackTrace) =>
                                buildEmptyPlaceHolder('Error '),
                            loading: () => ListView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: CustomizableShimmerTile(
                                      height: 20.w, width: 100.w),
                                );
                              },
                            ),
                          ),
                    ),
                  )
          ],
        );
      }),
    );
  }

  Widget scheduledClasses() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
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
                  Text(
                    "Jan \n ${DateTime.now().day.toString()} ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 5.w),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Course name",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 5.w),
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
                            "Instructor name",
                            style: TextStyle(
                                fontSize: 3.w, color: AppColors.iconGreyColor),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.notes,
                            size: 3.w,
                            color: AppColors.iconGreyColor,
                          ),
                          Text(
                            "Instructor name",
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
                            "11:00 AM - 12:00 PM",
                            style: TextStyle(
                                fontSize: 3.w, color: AppColors.iconGreyColor),
                          )
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.yellowAccent,
                    radius: 5.w,
                    child: Icon(
                      Icons.adaptive.arrow_forward,
                      size: 5.w,
                      color: AppColors.primaryColor,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget _buildRequestRow(RequestedClass data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          getCicleAvatar('A', data.instructorImage ?? '', radius: 3.h),
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
                // chatwithstudent(data.studentName ?? "", data.userId ?? 0,
                //     data.instructorId ?? 0);
              },
              icon: getSvgIcon('icon_req_chat.svg'))
        ],
      ),
    );
  }
}
