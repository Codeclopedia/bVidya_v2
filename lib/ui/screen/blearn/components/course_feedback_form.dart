import 'package:animate_icons/animate_icons.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/ui_core.dart';

class CustomFeedbackForm extends StatelessWidget {
  final Function(bool) callback;
  const CustomFeedbackForm({super.key, required this.callback});

  AnimateIconController get initializeAnimationController =>
      AnimateIconController();

  @override
  Widget build(BuildContext context) {
    AnimateIconController animateIconController = initializeAnimationController;
    return CircleAvatar(
      backgroundColor: AppColors.primaryColor,
      radius: 8.w,
      child: AnimateIcons(
        startIcon: Icons.message,
        endIcon: Icons.close,
        controller: animateIconController,
        size: 8.w,
        onStartIconPress: () {
          callback(true);
          return true;
        },
        onEndIconPress: () {
          callback(false);
          return true;
        },
        duration: const Duration(milliseconds: 500),
        startIconColor: Colors.white,
        endIconColor: Colors.white,
        clockwise: true,
      ),
    );
  }
}
