import '/core/state.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
// import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

import '/core/constants/colors.dart';
import '/core/ui_core.dart';
// import '../screen/blearn/course_detail_screen.dart';
import '../screen/profile/student/my_learning_screen.dart';

class SlidingTab extends StatelessWidget {
  final String label1;
  final String label2;
  final int selectedIndex;
  // final WidgetRef ref;
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
    print(selectedIndex);
    return CustomSlidingSegmentedControl<int>(
      initialValue: selectedIndex,
      fixedWidth: 40.w,
      children: {
        0: Text(
          label1,
          style: TextStyle(
              color: selectedIndex == 0 ? Colors.white : Colors.black),
        ),
        1: Text(label2,
            style: TextStyle(
                color: selectedIndex == 1 ? Colors.white : Colors.black)),
      },
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      thumbDecoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(6),
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
        // ref.read(selectedTabLearningProvider.notifier).state = index;

        callback(index);
      },
    );
  }
}
