// ignore_for_file: use_build_context_synchronously

import '/core/utils.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';

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
            // getTwoRowSettingItem(S.current.contact_title, S.current.contactDesc,
            //     "help_contacts.svg", () {
            //   Navigator.pushNamed(context, RouteList.contactUs);

            //   // Navigator.push(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //       builder: (context) => const ContactUsScreen()),
            //   // );
            // }),

            getTwoRowSettingItem(
                S.current.faq_title, S.current.faqDesc, "help_question.svg",
                () async {
              final user = await getMeAsUser();

              Navigator.pushNamed(context, RouteList.webview, arguments: {
                'url': user?.role == "instructor" || user?.role == "teacher"
                    ? "https://bvidya.com/app-faqs"
                    : "https://bvidya.com/app-faq-learner",
              });
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CoursesUsersUi()),
              // );
            }),
            getTwoRowSettingItem(S.current.report_title, S.current.reposrtDesc,
                "help_report.svg", () {
              Navigator.pushNamed(context, RouteList.reportProblem);
            }),
            getTwoRowSettingItem(S.current.privacy_title, S.current.privacyDesc,
                "help_privacy.svg", () {
              Navigator.pushNamed(context, RouteList.webview, arguments: {
                'url': "https://bvidya.com/app-privacy",
              });
            }),
            getTwoRowSettingItem(
                S.current.terms_title, S.current.termsDesc, "help_terms.svg",
                () {
              Navigator.pushNamed(context, RouteList.webview, arguments: {
                'url': "https://bvidya.com/app-tc",
              });
            }),
            Container(
              width: 0.5.w,
            )
          ]),
    );
  }

  // Widget _buildSetting() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 4.h),
  //     child: Text(
  //       S.current.settingHelp,
  //       style: TextStyle(
  //         fontSize: 20.sp,
  //         fontWeight: FontWeight.bold,
  //         fontFamily: kFontFamily,
  //         color: AppColors.primaryColor,
  //       ),
  //     ),
  //   );
  // }
}
