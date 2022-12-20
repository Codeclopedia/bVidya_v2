import '../constants.dart';
import '../ui_core.dart';

final InputDecoration inputDirectionStyle = InputDecoration(
  fillColor: AppColors.inputBoxFill,
  filled: true,
  hintStyle: TextStyle(
    fontSize: 9.sp,
    fontFamily: kFontFamily,
    color: AppColors.inputHintText,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.inputBoxBorder, width: 1.0),
  ),
  border: OutlineInputBorder(
    gapPadding: 4.0,
    borderRadius: BorderRadius.circular(12.0),
  ),
);

final InputDecoration chatInputDirectionStyle = InputDecoration(
  fillColor: AppColors.inputBoxFill,
  contentPadding: const EdgeInsets.all(0),
  filled: true,
  hintStyle: TextStyle(
    fontSize: 10.sp,
    fontFamily: kFontFamily,
    color: AppColors.inputHintText,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.w)),
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.w)),
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.w)),
    gapPadding: 1.0,
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
);

final InputDecoration searchInputDirectionStyle = InputDecoration(
  prefixIcon: Padding(
    padding: EdgeInsets.all(3.w),
    child: getSvgIcon('icon_pr_search.svg', color: Colors.black),
  ),
  contentPadding: const EdgeInsets.all(2.0),
  fillColor: AppColors.inputBoxFill,
  filled: true,
  hintStyle: TextStyle(
    fontSize: 10.sp,
    fontFamily: kFontFamily,
    color: AppColors.inputHintText,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.w)),
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.w)),
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.w)),
    gapPadding: 1.0,
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
  ),
);

final InputDecoration inputMeetStyle = InputDecoration(
  fillColor: AppColors.inputBoxFill,
  filled: true,
  hintStyle: TextStyle(
    fontSize: 9.sp,
    fontFamily: kFontFamily,
    color: AppColors.inputHintText,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.inputBoxBorder, width: 1.0),
  ),
  border: OutlineInputBorder(
    gapPadding: 4.0,
    borderRadius: BorderRadius.circular(12.0),
  ),
);

final InputDecoration inputNewGroupStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
  fillColor: AppColors.inputBoxFill,
  filled: true,
  hintStyle: TextStyle(
    fontSize: 9.sp,
    fontFamily: kFontFamily,
    color: AppColors.inputHintText,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.inputBoxBorder, width: 1.0),
  ),
  border: OutlineInputBorder(
    gapPadding: 4.0,
    borderRadius: BorderRadius.circular(12.0),
  ),
);

InputDecoration get inputEditProfileStyle => InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      fillColor: const Color(0xFFF5F5F5),
      filled: true,
      suffixIcon: Padding(
        padding: EdgeInsets.all(3.w),
        child: Icon(Icons.edit, size: 5.w),
      ),
      hintStyle: TextStyle(
        fontSize: 9.sp,
        fontFamily: kFontFamily,
        color: AppColors.inputHintText,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFF989898), width: 1.0),
      ),
      border: OutlineInputBorder(
        gapPadding: 4.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
