import '../../core/constants.dart';
import '../../core/ui_core.dart';

class RoundedTopBox extends StatelessWidget {
  final Widget child;
  final double topPadding;
  final double logoWidth;

  const RoundedTopBox(
      {Key? key,
      required this.child,
      required this.topPadding,
      required this.logoWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.loginBgColor,
      child: Stack(
        children: [
          SizedBox(
            width: 100.w,
            child: const Image(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: topPadding,
              ),
              Expanded(
                child: Container(
                  width: 100.w,
                  height: double.infinity,
                  padding: EdgeInsets.only(top: 7.h),
                  decoration: boxDecorationTopRound,
                  child: SingleChildScrollView(
                    child: child,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Sizer(
              builder: (_, orientation, deviceType) {
                return Container(
                  padding: EdgeInsets.only(top: topPadding / 10.0),
                  width: deviceType == DeviceType.tablet
                      ? logoWidth * 0.7
                      : logoWidth,
                  child: const Image(
                    image: AssetImage('assets/images/login_logo.png'),
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
