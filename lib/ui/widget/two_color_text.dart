import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class TwoColorText extends StatelessWidget {
  final String first;
  final String second;
  const TwoColorText({Key? key, required this.first, required this.second})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      children: [
        TextSpan(
            text: first,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 16.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
            )),
        TextSpan(
          text: ' $second',
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 16.sp,
            color: AppColors.yellowAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ));
  }
}
