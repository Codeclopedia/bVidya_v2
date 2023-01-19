import '/core/constants.dart';
import '/core/ui_core.dart';

class CoursesCircularIndicator extends StatefulWidget {
  final double progressValue;
  const CoursesCircularIndicator({super.key, required this.progressValue});

  @override
  State<CoursesCircularIndicator> createState() =>
      _CoursesCircularIndicatorState();
}

class _CoursesCircularIndicatorState extends State<CoursesCircularIndicator>
    with SingleTickerProviderStateMixin {
  //Circular progress animation controller
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    controller.animateTo((widget.progressValue) / 100,
        duration: const Duration(seconds: 3), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9.h,
      width: 9.h,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Center(
              child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Text(
              "${widget.progressValue.toString()}%",
              style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold),
            ),
          )),
          SizedBox(
            height: 9.h,
            width: 9.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.5.w,
              backgroundColor: AppColors.circularFillColor,
              value: controller.value,
              color: AppColors.yellowAccent,
            ),
          ),
        ],
      ),
    );
  }
}
