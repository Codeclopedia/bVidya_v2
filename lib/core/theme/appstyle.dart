import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pinput.dart';

import '../constants.dart';
import '../ui_core.dart';

final kFontFamily = GoogleFonts.poppins().fontFamily;

TextStyle? inputBoxCaptionStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.black,
          fontFamily: kFontFamily,
          fontSize: 12.sp,
        );

TextStyle? screenHeaderTitleStyle(BuildContext context) =>
    Theme.of(context).textTheme.headline4?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          fontFamily: kFontFamily,
          fontSize: 25.sp,
        );

// InputDecorationTheme inputBoxStyle(BuildContext context) =>
//     Theme.of(context).inputDecorationTheme.copyWith(
//           labelStyle: const TextStyle(
//             fontSize: 11,
//             color: AppColors.inputHintText,
//           ),
//           hintStyle: const TextStyle(
//             fontSize: 11,
//             color: AppColors.inputHintText,
//           ),
//         );

final boxDecorationTopRound = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
        blurRadius: 10,
        offset: const Offset(-5, 5),
        color: Colors.black.withAlpha(0x0D)),
  ],
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.w),
    topRight: Radius.circular(10.w),
  ),
);

final PinTheme defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    color: AppColors.inputBoxFill,
    border: Border.all(color: AppColors.inputBoxBorder),
    borderRadius: BorderRadius.circular(8),
  ),
);

final PinTheme focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(8),
);

final PinTheme submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: const Color.fromRGBO(234, 239, 243, 1),
  ),
);
