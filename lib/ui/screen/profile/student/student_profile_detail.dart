import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/models/models.dart';
import '/core/state.dart';
import '/core/theme/appstyle.dart';
import '/core/theme/inputstyle.dart';
import '/core/theme/textstyles.dart';
import '../../../../generated/l10n.dart';
import '../base_settings.dart';

class StudentProfileDetail extends HookWidget {
  final Profile profile;
  const StudentProfileDetail({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: profile.name);
    final emailController = useTextEditingController(text: profile.email);
    final phoneController = useTextEditingController(text: profile.phone);
    final ageController = useTextEditingController(text: profile.age);
    final addressController = useTextEditingController(text: profile.address);

    useEffect(
      () {},
    );
    return BaseSettings(
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              "${S.current.profile_title} Detail", //didn't added throught l10n
              style: textStyleHeading,
            ),
            SizedBox(height: 2.h),
            Text(
              "Name", //didn't added throught l10n
              style: inputBoxCaptionStyle(context),
            ),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: inputDirectionStyle.copyWith(
                hintText: profile.name,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Email Address", //didn't added throught l10n
              style: inputBoxCaptionStyle(context),
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: inputDirectionStyle.copyWith(
                hintText: S.current.login_email_hint,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Phone Number", //didn't added throught l10n
              style: inputBoxCaptionStyle(context),
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: inputDirectionStyle.copyWith(
                hintText: S.current.signup_mobile_hint,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Age", //didn't added throught l10n
              style: inputBoxCaptionStyle(context),
            ),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: inputDirectionStyle.copyWith(
                hintText: S.current.prof_hint_age,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Address", //didn't added throught l10n
              style: inputBoxCaptionStyle(context),
            ),
            TextFormField(
              controller: addressController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: inputDirectionStyle.copyWith(
                hintText: S.current.prof_edit_address,
              ),
            ),
            SizedBox(height: 4.h),
            Consumer(
              builder: (context, ref, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: elevatedButtonTextStyle,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: elevationTextButtonTextStyle,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
