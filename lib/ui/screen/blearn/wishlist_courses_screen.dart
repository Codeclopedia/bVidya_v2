import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/wishlist_courses_response.dart';
import '/ui/screen/blearn/components/common.dart';
import '/ui/screen/profile/base_settings_noscroll.dart';
import '/ui/screens.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

import '/controller/blearn_providers.dart';

class WishlistCourses extends StatelessWidget {
  const WishlistCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(bodyContent: Consumer(
      builder: (context, ref, child) {
        return ref.watch(blearnWishlistCoursesProvider).when(
              data: (data) {
                if (data?.wishlistedCourses?.isNotEmpty == true) {
                  return _buildUI(ref, data!.wishlistedCourses!);
                } else {
                  return const Center(
                    child: Text("No Wishlisted Course"),
                  );
                }
              },
              error: (error, stackTrace) => buildEmptyPlaceHolder("Error"),
              loading: () => buildLoading,
            );
      },
    ));
  }

  Widget _buildUI(WidgetRef ref, List<WishlistedCourse?>? wishlistedCourses) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.w,
          ),
          Text(
            "Liked Courses",
            style: textStyleHeading,
          ),
          SizedBox(
            height: 5.w,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wishlistedCourses?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.w,
                          width: 20.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: getImageProvider(
                                      wishlistedCourses?[index]?.image ?? ""),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 40.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wishlistedCourses?[index]?.name ?? "",
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 2.5.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Duration: ",
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 3.w,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                      "${wishlistedCourses?[index]?.duration} hours",
                                      style: TextStyle(
                                          fontSize: 3.w,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                              SizedBox(
                                height: 2.5.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    wishlistedCourses?[index]?.rating ?? '',
                                    style: TextStyle(
                                        color: AppColors.yellowAccent,
                                        fontSize: 10.sp,
                                        fontFamily: kFontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  buildRatingBar(double.parse(
                                      wishlistedCourses?[index]?.rating ??
                                          '0.0')),
                                ],
                              ),
                              SizedBox(
                                height: 2.5.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "lesson: ",
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 3.w,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                      "${wishlistedCourses?[index]?.numberOfLesson}",
                                      style: TextStyle(
                                          fontSize: 3.w,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              showLoading(ref);
                              ref.watch(blearnAddorRemoveinWishlistProvider(
                                  wishlistedCourses?[index]?.id ?? 0));
                              ref.refresh(blearnWishlistCoursesProvider);
                              hideLoading(ref);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowAccent),
                            child: const Text(
                              "Remove",
                              style: TextStyle(color: AppColors.primaryColor),
                            ))
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
