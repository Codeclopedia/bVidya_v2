import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class SlidingTab extends StatelessWidget {
  final String label1;
  final String label2;
  final int selectedIndex;
  final Function(int) callback;
  const SlidingTab(
      {super.key,
      required this.label1,
      required this.label2,
      required this.selectedIndex,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = ref.watch(selectedTabLearningProvider);
    // print(selectedIndex);
    return CustomSlidingSegmentedControl<int>(
      initialValue: selectedIndex,
      fixedWidth: 40.w,
      height: 9.w,
      // innerPadding: EdgeInsets.all(3.w),
      children: {
        0: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            label1,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 10.sp,
                color: selectedIndex == 0 ? Colors.white : Colors.black),
          ),
        ),

        //  Text(
        //   label1,
        //   style: TextStyle(
        //       fontFamily: kFontFamily,
        //       fontSize: 12.sp,
        //       color: selectedIndex == 0 ? Colors.white : Colors.black),
        // ),
        1: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            label2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 10.sp,
                color: selectedIndex == 1 ? Colors.white : Colors.black),
          ),
        )
      },
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(3.w),
      ),
      thumbDecoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(2.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      onValueChanged: (index) {
        callback(index);
      },
    );
  }
}
