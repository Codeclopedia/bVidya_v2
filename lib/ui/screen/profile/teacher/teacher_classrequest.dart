// import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';

import '../base_settings_noscroll.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';
// import '../base_settings.dart';

class TeacherClassRequest extends StatelessWidget {
  const TeacherClassRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
        showName: false,
        bodyContent: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Class Request",
                style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontSize: 5.5.w,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 80,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) =>
                      const Divider(color: AppColors.divider),
                  itemBuilder: (context, index) {
                    return _buldFollwedRow();
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget _buldFollwedRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          getCicleAvatar('A', '', radius: 3.h),
          SizedBox(width: 5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Name",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: kFontFamily,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.3.h),
                  child: Text(
                    "2K Followers",
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
                print("Hello");
              },
              icon: getSvgIcon('icon_req_chat.svg'))
        ],
      ),
    );
  }
}
