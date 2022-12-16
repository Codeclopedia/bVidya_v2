import '../../core/ui_core.dart';



class ErrorJoiningBroadcast extends StatelessWidget {
  const ErrorJoiningBroadcast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      // width: 260.0,
      // height: 300.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3.w)),
        // image: DecorationImage(
        //     fit: BoxFit.fill,
        //     image: AssetImage("assets/images/whitebackground.png")),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/sad.png", height: 10.h),
          SizedBox(height: 1.h),
          Text(
            "Oops!",
            style: TextStyle(
                fontSize: 17.sp,
                color: const Color(0xFFE93C3C),
                fontWeight: FontWeight.bold,
                letterSpacing: .5),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Oops! Broadcast is not started yet! \nPlease wait for moment.",
            style: TextStyle(fontSize: 10.sp, letterSpacing: .5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              //isShow = false;
              Navigator.pop(context);
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF450d35),
                      Color(0xFF4a0d36),
                      Color(0xFF4e1141),
                      Color(0xFF520e35),
                      Color(0xFF520e35),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Okay",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
