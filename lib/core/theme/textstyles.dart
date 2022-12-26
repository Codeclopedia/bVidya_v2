import '../constants.dart';
import '../ui_core.dart';

final textStyleUnselect = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.black,
  fontSize: 10.sp,
  fontWeight: FontWeight.w500,
);

final textStyleSelect = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.white,
  fontSize: 10.sp,
  fontWeight: FontWeight.w500,
);

final textButtonStyle = TextButton.styleFrom(
  foregroundColor: AppColors.primaryColor,
  disabledForegroundColor: Colors.grey,
  padding: const EdgeInsets.all(12.0),
);

final textButtonTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 11.sp,
  fontFamily: kFontFamily,
);

final textStyleWhite = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 8.sp,
  fontFamily: kFontFamily,
  color: Colors.white,
);

final textStyleBlack = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12.sp,
  fontFamily: kFontFamily,
  color: Colors.black,
);

final textStyleHeading = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16.sp,
  fontFamily: kFontFamily,
  color: AppColors.primaryColor,
);

final textStyleSettingHeading = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16.sp,
  fontFamily: kFontFamily,
  color: AppColors.primaryColor,
);

final textStyleSettingTitle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 11.sp,
  fontFamily: kFontFamily,
  color: const Color(0xFF000E08),
);

final textStyleSettingDesc = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 9.sp,
  fontFamily: kFontFamily,
  color: const Color(0xFF797C7B),
);

final textStyleCaption = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 11.sp,
  fontFamily: kFontFamily,
  color: AppColors.primaryColor,
);

final textStyleTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 9.sp,
  fontFamily: kFontFamily,
  color: AppColors.titleTextColor,
);

final textStyleDesc = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 8.sp,
  fontFamily: kFontFamily,
  color: AppColors.descTextColor,
);

final elevationTextButtonTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 13.sp,
  fontFamily: kFontFamily,
);

final footerTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 10.sp,
  fontFamily: kFontFamily,
  color: Colors.black,
);
final footerTextButtonStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: kFontFamily,
  fontSize: 11.sp,
  color: AppColors.primaryColor,
);

final buttonTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 11.sp,
  color: Colors.white,
);
final normalTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: kFontFamily,
  fontSize: 12.sp,
  color: Colors.black,
);

final elevatedButtonTextStyle = ElevatedButton.styleFrom(
  textStyle: buttonTextStyle,
  backgroundColor: AppColors.primaryColor,
  padding: EdgeInsets.all(4.w),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
);

final elevatedButtonStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.sp,
    color: Colors.white,
  ),
  backgroundColor: AppColors.primaryColor,
  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.w),
  ),
);

get elevatedButtonEndStyle => ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 8.sp,
        color: Colors.white,
      ),
      backgroundColor: AppColors.redBColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
    );

get elevatedButtonYellowStyle => ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11.sp,
      ),
      foregroundColor: AppColors.primaryColor,
      backgroundColor: AppColors.yellowAccent,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.7.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
    );

final elevatedButtonSecondaryStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.sp,
    color: Colors.black,
  ),
  foregroundColor: Colors.black,
  backgroundColor: AppColors.cardWhite,
  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.w),
  ),
);

final dialogElevatedButtonSecondaryStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 8.sp,
    color: Colors.black,
  ),
  foregroundColor: Colors.black,
  backgroundColor: AppColors.cardWhite,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.w),
  ),
);

final dialogElevatedButtonStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 8.sp,
    color: Colors.white,
  ),
  backgroundColor: AppColors.primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.w),
  ),
);
//B-Learn

final textButtonFilledStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontFamily: kFontFamily, color: AppColors.primaryColor, fontSize: 10.sp),
  elevation: 0.0,
  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.7.h),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
  backgroundColor: AppColors.yellowAccent,
  foregroundColor: AppColors.primaryColor,
);

final textButtonOutlineStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontFamily: kFontFamily, color: AppColors.black, fontSize: 10.sp),
  elevation: 0.0,
  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.7.h),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2.w),
      side: const BorderSide(color: Color(0xFFEDEDED), width: 0.8)),
  backgroundColor: Colors.white,
  foregroundColor: AppColors.black,
);
