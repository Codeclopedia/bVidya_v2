// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';

import '../../../core/sdk_helpers/common.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/controller/providers/user_auth_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';

class LoginScreen extends HookWidget {
  //
  final _formKey = GlobalKey<FormState>();
  //
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final emailTextController = useTextEditingController(text: '');

    final passwordTextController = useTextEditingController(text: '');

    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: RoundedTopBox(
            logoWidth: 80.w,
            topPadding: 25.h,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      S.current.login_header_title,
                      style: screenHeaderTitleStyle(context),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      S.current.login_email_caption,
                      style: inputBoxCaptionStyle(context),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.login_email_empty;
                        }
                        if (!isValidEmail(value)) {
                          return S.current.login_email_invalid;
                        }
                        return null;
                      },
                      decoration: inputDirectionStyle.copyWith(
                        hintText: S.current.login_email_hint,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      S.current.login_password_caption,
                      style: inputBoxCaptionStyle(context),
                    ),
                    SizedBox(height: 1.h),
                    Consumer(
                      builder: (_, ref, child) {
                        final showPassword =
                            ref.watch(loginShowPasswordProvider);
                        return TextFormField(
                          controller: passwordTextController,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.login_password_empty;
                            }
                            if (value.length < 8) {
                              return S.current.login_password_invalid;
                            }
                            return null;
                          },
                          obscureText: !showPassword,
                          keyboardType: TextInputType.visiblePassword,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState?.validate() == true) {
                              _doLogin(ref, emailTextController.text,
                                  passwordTextController.text, context);
                            }
                          },
                          decoration: inputDirectionStyle.copyWith(
                            hintText: S.current.login_password_hint,
                            suffixIcon: IconButton(
                              onPressed: () {
                                ref
                                    .read(loginShowPasswordProvider.notifier)
                                    .state = !showPassword;
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: textButtonStyle,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteList.forgotPassword);
                        },
                        child: Text(
                          S.current.login_btx_forgot_password_,
                          style: textButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Consumer(
                      builder: (_, ref, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: elevatedButtonTextStyle,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() == true) {
                                _doLogin(ref, emailTextController.text,
                                    passwordTextController.text, context);
                              }
                            },
                            child: Text(
                              S.current.login_btn_signin,
                              style: elevationTextButtonTextStyle,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 1.5.h),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: textButtonStyle,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteList.loginOtp);
                        },
                        child: Text(
                          S.current.login_btx_login_otp,
                          style: elevationTextButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: S.current.login_footer_no_account,
                                style: footerTextStyle),
                            TextSpan(
                              text: S.current.login_btx_signup,
                              style: footerTextButtonStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, RouteList.signup);
                                  // print('Tap Here onTap');
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _doLogin(
    WidgetRef ref,
    String email,
    String pass,
    BuildContext context,
  ) async {
    showLoading(ref);
    final error = await ref.read(loginRepositoryProvider).login(email, pass);

    if (error == null) {
      final error2 = await postLoginSetup(ref);
      // final user = await getMeAsUser();
      // final user = await ref.read(userAuthChangeProvider).loadUser();
      if (error2 != null) {
        hideLoading(ref);
        AppSnackbar.instance.error(context, error2);
        return;
      }
      hideLoading(ref);
      Navigator.pushReplacementNamed(context, RouteList.home);
    } else {
      hideLoading(ref);
      AppSnackbar.instance.error(context, error);
    }
  }
}
