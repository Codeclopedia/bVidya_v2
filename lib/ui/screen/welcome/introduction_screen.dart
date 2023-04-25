import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/ui/screens.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({super.key});

  @override
  State<IntroductionScreenPage> createState() => _IntroScreenDefaultState();
}

class _IntroScreenDefaultState extends State<IntroductionScreenPage> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/Screen 1 Welcome.gif',
        title: S.current.intro_screen_1_title,
        desc: S.current.intro_screen_1_desc));
    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/Screen 2 bchat.gif',
        title: S.current.intro_screen_2_title,
        desc: S.current.intro_screen_2_desc));
    // listContentConfig.add(contentTile(
    //     lottiePath: 'intro_screen_lottie/Screen 3 bmeet.json',
    //     title: S.current.intro_screen_3_title,
    //     desc: S.current.intro_screen_3_desc));
    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/Screen 3 bmeet.gif',
        title: S.current.intro_screen_3_title,
        desc: S.current.intro_screen_3_desc));
    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/Screen4 Proto bvidya intro.gif',
        title: S.current.intro_screen_4_title,
        desc: S.current.intro_screen_4_desc));

    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/screen 5 blearn.gif',
        title: S.current.intro_screen_5_title,
        desc: S.current.intro_screen_5_desc));
    listContentConfig.add(contentTile(
        iconPath: 'intro_screen_icon/screen 6 Explore bvidya.gif',
        title: S.current.intro_screen_6_title,
        desc: S.current.intro_screen_6_desc));
  }

  onDonePress(BuildContext context, WidgetRef ref) async {
    showLoading(ref);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('intro_loaded', true);
    hideLoading(ref);
    Navigator.pushReplacementNamed(context, RouteList.login);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return IntroSlider(
        key: UniqueKey(),

        skipButtonStyle: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white70),
            textStyle: MaterialStatePropertyAll(
                textStyleBlack.copyWith(color: Colors.white))),
        // indicatorConfig:
        indicatorConfig: IndicatorConfig(
          sizeIndicator: 2.2.w,
          colorIndicator: Colors.white54,
          colorActiveIndicator: Colors.white,
        ),
        nextButtonStyle: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            textStyle: MaterialStatePropertyAll(
                textStyleBlack.copyWith(color: Colors.white))),
        doneButtonStyle: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            textStyle: MaterialStatePropertyAll(
                textStyleBlack.copyWith(color: Colors.white))),
        listContentConfig: listContentConfig,
        onDonePress: () => onDonePress(context, ref),
      );
    });
  }

  ContentConfig contentTile(
      {required String iconPath, required String title, required String desc}) {
    return ContentConfig(
      centerWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: [
            getPngImage(iconPath,
                height: 70.w, width: 70.w, fit: BoxFit.contain),
            SizedBox(height: 5.w),
            Text(
              title,
              style: textStyleHeading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 5.w),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: textStyleBlack.copyWith(
                  color: const Color.fromARGB(255, 227, 226, 226),
                  fontSize: 10.sp),
            )
          ],
        ),
      ),
      colorBegin: const Color(0xFF340E33),
      colorEnd: const Color(0xFF6C1933),
    );
  }
}
