import '../../../../core/constants.dart';
import '../../../../core/ui_core.dart';

import '../base_settings.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Text(
                S.current.settingHelp,
                style: textStyleSettingHeading,
              ),
            ),

            // S.current.hello;
            getTwoRowSettingItem(S.current.contact_title, S.current.contactDesc,
                "help_contacts.svg", () {
              Navigator.pushNamed(context, RouteList.contactUs);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ContactUsScreen()),
              // );
            }),
            getTwoRowSettingItem(
                S.current.faq_title, S.current.faqDesc, "help_question.svg",
                () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CoursesUsersUi()),
              // );
            }),
            getTwoRowSettingItem(S.current.report_title, S.current.reposrtDesc,
                "help_report.svg", () {
              Navigator.pushNamed(context, RouteList.reportProblem);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ReportProblemScreen()),
              // );
            }),
            getTwoRowSettingItem(S.current.privacy_title, S.current.privacyDesc,
                "help_privacy.svg", () {}),
            getTwoRowSettingItem(S.current.terms_title, S.current.termsDesc,
                "help_terms.svg", () {}),
            Container(
              width: 0.5.w,
            )
          ]),
    );
  }

  Widget _buildSetting() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: Text(
        S.current.settingHelp,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          fontFamily: kFontFamily,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  // Widget _buildContent(
  //     String title, String desc, String icon, Function() onClick) {
  //   return InkWell(
  //     onTap: onClick,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 3.h),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.max,
  //             children: [
  //               CircleAvatar(
  //                 backgroundColor: Colors.grey[
  //                     200], //back ground colors//opectional give opacity of background
  //                 radius: 2.5.h,
  //                 child: getSvgIcon(icon,
  //                     width: 4.w, color: AppColors.primaryColor, height: 4.h),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   margin: EdgeInsets.only(left: 4.w),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.max,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         title,
  //                         style: TextStyle(
  //                           fontSize: 14.sp,
  //                           color: Colors.black,
  //                           fontFamily: kFontFamily,
  //                         ),
  //                       ),
  //                       Text(
  //                         desc,
  //                         style: TextStyle(
  //                             fontFamily: kFontFamily,
  //                             fontSize: 10.sp,
  //                             color: Colors.grey[900]),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               getSvgIcon('arrow_right.svg',
  //                   width: 2.w, color: Colors.black, height: 2.h)
  //             ],
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(top: 1.9.h),
  //             height: 0.1.h,
  //             color: Colors.grey[400],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
