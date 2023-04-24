import '/core/constants.dart';
import '/core/ui_core.dart';

final complementryItems = {
  'Managemet courses': const AssetImage('assets/images/execution.png'),
  'Financial courses': const AssetImage('assets/images/stock.png'),
};

final complementryItemsColors = {
  'Managemet courses': AppColors.cardWhite,
  'Financial courses': const Color(0xFFFFDB84),
};

class ComplementryCourseItem extends StatelessWidget {
  final Color? color;
  final String? title;
  final ImageProvider? image;

  const ComplementryCourseItem({super.key, this.color, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.h,
      height: 12.h,
      margin: EdgeInsets.only(
        left: 0.5.h,
        right: 0.5.h,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: color ?? AppColors.cardWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.w),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      title ?? 'Management courses',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: kFontFamily,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 1.w,
            top: 1.w,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: image ?? const AssetImage('assets/images/execution.png'),
                height: 10.h,
                width: 8.h,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
