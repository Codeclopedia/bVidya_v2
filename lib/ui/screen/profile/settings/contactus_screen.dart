import '../../../../core/ui_core.dart';
import '../base_settings_noscroll.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                S.current.contact_title,
                style: textStyleSettingHeading,
              ),
              SizedBox(height: 3.h),
              Text(
                S.current.contactQuery,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black,
                  fontFamily: kFontFamily,
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: inputDirectionStyle.copyWith(
                  hintText: S.current.contactHint,
                ),
                minLines: 6,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
              ),
              const Spacer(),
              ElevatedButton(
                style: elevatedButtonTextStyle,
                onPressed: () {},
                child: Text(S.current.submitBtn),
              ),
              SizedBox(height: 2.h),
            ]),
      ),
    );
  }
}
