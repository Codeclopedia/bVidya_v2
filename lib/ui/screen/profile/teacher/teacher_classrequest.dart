import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../base_settings.dart';

class TeacherClassRequest extends StatelessWidget {
  const TeacherClassRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: 80,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    height: 10.h,
                    width: 100.w,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 7.w,
                          backgroundImage:
                              AssetImage("assets/images/dummy_profile.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 4.5.w,
                                    fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.3.h),
                                child: Text(
                                  "1000 followers",
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
