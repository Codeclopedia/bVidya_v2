import '/core/ui_core.dart';

class BAppBar extends StatelessWidget {
  final String title;
  const BAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: (() => Navigator.pop(context)),
            icon: getSvgIcon('arrow_back.svg'),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
