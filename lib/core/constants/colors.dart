// import 'dart:ui';

import '../ui_core.dart';

// class ColorConstant {
// static final Color lightPink = HexColor("#FFAAC9");
// static final Color darkBlue = HexColor("#3874BA");
// static final Color white = HexColor("#FFFFFF");
// static final Color black = HexColor("#000000");
// static final Color greenEnd = HexColor("#1FD7A6");
// static final Color gray = HexColor("#6C7B8A");
// static final Color grayBorder = HexColor("#F6F6F6");
// static final Color deepLightPink = HexColor("#fff9f6");
// static final Color buttonPink = HexColor("#e44e98");
// static final Color notificationGreen = HexColor("#1ED7A6");
// static final Color replaybluegray = HexColor("#ECEFF1");
// }

class AppColors {
  AppColors._();
  //Todo
  static const Color primaryColor = Color(0xFF500D34);

  static const Color black = Color(0xFF000000);

  static const Color inputBoxFill = Color(0xFFF5F5F5);

  static const Color inputBoxBorder = Color(0xFF707070);

  static const Color inputHeaderText = Color(0xFF010101);

  static const Color inputHintText = Color(0x99010101);

  static const Color yellowAccent = Color(0xFFFFC948);

  static const Color redBColor = Color(0xFFDD1515);

  static const Color darkChatColor = Color(0xFF111A23);

  static const Color searchBoxColor = Color(0xFFFFC948);

  static const Color searchIconColor = Color(0xFF671336);

  static const Color textColorSecondary = Color(0XBFFFFFFF);

  static const Color textColorSecondaryInverse = Color(0xFF000E08);

  static const Color textColorSecondary2 = Color(0XBDFFFFFF);

  static const Color cameraFillColor = Color(0xFF91E1FF);

  static const Color imageFillColor = Color(0xFF9491FF);

  static const Color audioFillColor = Color(0xFFFF8282);

  static const Color docFillColor = Color(0xFFFFC948);

  static const Color iconGreyColor = Color(0xFF989E9C);

  static const Color circularFillColor = Color(0xFFCECECE);

  static const Color audioMessageBoxColor = Color(0xFFF2F7FB);

  static const Color loginBgColor = Color(0xFFE6EAFE);

  static const Color gradientTopColor = Color(0xFF360C35);
  static const Color gradientBottomColor = Color(0xFF770F34);
  static const Color gradientLiveBottomColor = Color(0xFF9C1132);

  static const Color drawerBackgroundColor = Color(0xFF480b2f);

  static const Color contactNameTextColor = Color(0xFF010101);

  static const Color contactBadgeUnreadTextColor = Color(0xFFFFC948);

  static const Color contactBadgeReadTextColor = Color(0xFF6A6A6A);

  static const Color newMessageBorderColor = Color(0xFFDD1515);

  static const Color chatBoxBackgroundMine = Color(0xFF480b2f);

  static const Color chatBoxBackgroundOthers = Color(0xFFFFC948);

  static const Color chatBoxMessageOthers = Color(0xFF000E08);

  static const Color chatBoxTimeOthers = Color(0xFFFFFFFF);

  static const Color chatBoxMessageMine = Color(0xFFFFFFFF);

  static const Color chatBoxTimeMine = Color(0xFFFFFFFF);

  static const Color chatInputBackground = Color(0xFFF3F6F6);

  static const Color audioChatBackground = Color(0xFFF2F7FB);

  static const Color titleTextColor = Color(0xFF010101);

  static const Color descTextColor = Color(0xFF8D8D8D);

  static const Color cardWhite = Color(0xFFF5F5F5);

  static const Color cardBackground = Color(0xFFFAFAFA);

  static const Color cardBorder = Color(0xFF707070);

  static const Color divider = Color(0xAA707070);
  //old colors

  // static const Color gray = Color(0xFF6C7B8A);

  // static const Color darkModeBlack = Color(0xFF424242);

  // static const Color white = Color(0xFFFFFFFF);

  // static const Color cardWhite = Color(0xFFF5F5F5);

  // static const Color dividerColor = Color(0xFFBDBDBD);

  // static const Color yellow = Color(0xFFFFEB3B);

  // static const Color lightBlue = Color(0xFF3874BA);

  // static const Color redColor = Color(0xFFf02b25);

  // static const Color redDarkColor = Color(0xffE93C3C);

  // static const Color cardColor = Color(0xff4d4d4d);

  // static const Color cardContainerColor = Color(0xff696969);

  // static const Color chatred = Color(0xffff5f6d);

  // static const Color chatgray = Color(0xFFFAFAFA);

  // static const Color buttonColor = Color(0xFFE93C3C);

  // static const Color chatYellow = Color(0xFFffbf71);

  // static const Color appNewDarkThemeColor = Color(0xFF5c0e35);

  // static const Color appNewLightThemeColor = Color(0xFF901133);

  // static const Color addedColor = Color(0xffffc948);

  // static const Color bgColor = Color.fromARGB(255, 232, 177, 154);

}

const avatarPlaceHolderColors = [
  Color(0xFF1abc9c),
  Color(0xFFf1c40f),
  Color(0xFF8e44ad),
  Color(0xFFe74c3c),
  Color(0xFFd35400),
  Colors.green,
  Colors.blue,
  Color(0xFF7f8c8d),
];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
