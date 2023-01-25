// import 'package:animate_icons/animate_icons.dart';
import 'package:spring/spring.dart';

import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class CustomFeedbackButton extends StatelessWidget {
  final Function(bool) callback;
  final bool isOpen;
  const CustomFeedbackButton(
      {super.key, required this.isOpen, required this.callback});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.primaryColor,
      radius: 7.w,
      child: isOpen
          ? Spring.rotate(
              startAngle: 90,
              endAngle: 0,
              animDuration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.cardWhite,
                ),
                iconSize: 8.w,
                onPressed: () {
                  callback(false);
                },
              ))
          : Spring.rotate(
              startAngle: -90,
              endAngle: 0,
              animDuration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: const Icon(
                  Icons.message,
                  color: AppColors.cardWhite,
                ),
                iconSize: 8.w,
                onPressed: () {
                  callback(true);
                },
              ),
            ),
    );
  }
}
