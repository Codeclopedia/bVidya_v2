// ignore_for_file: use_build_context_synchronously

import '/core/utils/common.dart';
import 'package:flutter/gestures.dart';
import 'package:pinput/pinput.dart';

// import '/controller/providers/user_auth_provider.dart';
// import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../screens.dart';
import '../../widgets.dart';

class LoginOtpScreen extends HookWidget {
  //
  LoginOtpScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mobileTextController = useTextEditingController(text: '');

    return BaseWilPopupScreen(
      onBack: () async {
        Navigator.pushReplacementNamed(context, RouteList.login);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: RoundedTopBox(
              logoWidth: 80.w,
              topPadding: 30.h,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        S.current.otp_login_header_title,
                        style: screenHeaderTitleStyle(context),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        S.current.otp_login_mobile_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      Consumer(
                        builder: (context, ref, child) {
                          final isOtpSent =
                              ref.watch(loginOtpGeneratedProvider);

                          return TextFormField(
                            controller: mobileTextController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            textInputAction: TextInputAction.done,
                            // initialValue: mobileTextController.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.current.otp_login_mobile_empty;
                              }
                              if (value.length != 10) {
                                return S.current.otp_login_mobile_invalid;
                              }
                              return null;
                            },
                            decoration: inputDirectionStyle.copyWith(
                              enabled: !isOtpSent,
                              hintText: S.current.otp_login_mobile_hint,
                              prefix: Text(
                                '🇮🇳+91 ',
                                style: normalTextStyle.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 2.h),
                      _buildOtpBox(),
                      SizedBox(height: 2.h),
                      Consumer(
                        builder: (context, ref, child) {
                          final isOtpSent =
                              ref.watch(loginOtpGeneratedProvider);
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: elevatedButtonTextStyle,
                              onPressed: () async {
                                if (!isOtpSent &&
                                    _formKey.currentState?.validate() == true) {
                                  EasyLoading.show();
                                  final result = await ref
                                      .read(loginRepositoryProvider)
                                      .loginOtpGenerate(
                                          mobileTextController.text);
                                  EasyLoading.dismiss();
                                  if (result != null) {
                                    AppSnackbar.instance.error(context, result);
                                  } else {
                                    AppSnackbar.instance.message(
                                        context, 'OTP Sent successfully');
                                    ref
                                        .read(
                                            loginOtpGeneratedProvider.notifier)
                                        .state = true;
                                    ref
                                        .read(loginTimerProvider.notifier)
                                        .start();
                                  }
                                } else {
                                  final enteredOTP =
                                      ref.read(loginEnteredOTPProvider);
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    if (!enteredOTP.isNotEmpty) {
                                      AppSnackbar.instance.error(context,
                                          S.current.signup_error_otp_empty);
                                      return;
                                    }
                                    _onLogin(ref, context, enteredOTP);
                                  }
                                }
                                // ref.read(loginRepositoryProvider).
                              },
                              child: Text(
                                isOtpSent
                                    ? S.current.otp_login_btn_verify
                                    : S.current.otp_login_btn_send,
                                style: elevationTextButtonTextStyle,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          style: textButtonStyle,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, RouteList.login);
                          },
                          child: Text(
                            S.current.login_btx_login_password,
                            style: textButtonTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.w,
                      ),
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
                                    print('Tap Here onTap');
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
              )),
        ),
      ),
    );
  }

  Future _onLogin(
      WidgetRef ref, BuildContext context, String enteredOTP) async {
    ref.read(loginTimerProvider.notifier).reset();
    showLoading(ref);
    final result =
        await ref.read(loginRepositoryProvider).loginOtpVerify(enteredOTP);
    if (result != null) {
      hideLoading(ref);

      AppSnackbar.instance.error(context, result);
    } else {
      final error = await postLoginSetup(ref);
      if (error != null) {
        hideLoading(ref);
        AppSnackbar.instance.error(context, error);
        return;
      }
      hideLoading(ref);
      AppSnackbar.instance.message(context, 'Logged In successfully');
      Navigator.pushReplacementNamed(context, RouteList.home);
    }
  }

  _buildOtpBox() {
    return Consumer(
      builder: (context, ref, child) {
        final timerRunning = ref.watch(loginTimerProvider).running;
        final otpSent = ref.watch(loginOtpGeneratedProvider);
        final value = ref.watch(loginTimerProvider);
        return otpSent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.otp_login_otp_caption,
                    style: inputBoxCaptionStyle(context),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Pinput(
                    length: 6,
                    errorText: S.current.otp_login_error_invalid,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // validator: (s) {
                    //   return s == '222222' ? null : 'Pin is incorrect';
                    // },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) =>
                        ref.read(loginEnteredOTPProvider.notifier).state = pin,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      timerRunning
                          ? Text(S.current
                              .otp_login_txt_in_seconds(value.timeLeft))
                          : const SizedBox.shrink(),
                      TextButton(
                        style: textButtonStyle,
                        onPressed: timerRunning
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() == true) {
                                  EasyLoading.show();
                                  final result = await ref
                                      .read(loginRepositoryProvider)
                                      .loginOtpReGenerate();
                                  EasyLoading.dismiss();
                                  if (result != null) {
                                    AppSnackbar.instance.error(context, result);
                                  } else {
                                    AppSnackbar.instance.message(
                                        context, 'OTP Sent successfully');
                                    ref
                                        .read(
                                            loginOtpGeneratedProvider.notifier)
                                        .state = true;
                                    ref
                                        .read(loginTimerProvider.notifier)
                                        .start();
                                  }
                                }
                              },
                        child: Text(
                          S.current.otp_login_btn_resend,
                          style: textButtonTextStyle,
                        ),
                      )
                    ],
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
