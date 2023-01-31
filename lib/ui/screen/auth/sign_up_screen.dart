// ignore_for_file: use_build_context_synchronously

import '/core/utils/common.dart';
import 'package:flutter/gestures.dart';
import 'package:pinput/pinput.dart';

// import '/core/sdk_helpers/bchat_sdk_controller.dart';
// import '/controller/providers/user_auth_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '../../screens.dart';
import '../../widgets.dart';

class SignUpScreen extends HookWidget {
  //
  SignUpScreen({Key? key}) : super(key: key);
//
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final formKey = ref.watch(formKeyProvider);
    final fullNameTextController = useTextEditingController(text: '');
    final emailTextController = useTextEditingController(text: '');
    final mobileTextController = useTextEditingController(text: '');
    final passwordTextController = useTextEditingController(text: '');
    final confirmPasswordTextController = useTextEditingController(text: '');

    return BaseWilPopupScreen(
      onBack: () async {
        Navigator.pushReplacementNamed(context, RouteList.login);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: RoundedTopBox(
            logoWidth: 65.w,
            topPadding: 20.h,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        S.current.signup_header_title,
                        style: screenHeaderTitleStyle(context),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        S.current.signup_fullname_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: fullNameTextController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return null;
                        },
                        decoration: inputDirectionStyle.copyWith(
                          hintText: S.current.signup_fullname_hint,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        S.current.signup_email_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.current.signup_email_empty;
                          }
                          if (!isValidEmail(value)) {
                            return S.current.signup_email_invalid;
                          }
                          return null;
                        },
                        decoration: inputDirectionStyle.copyWith(
                          hintText: S.current.signup_email_hint,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        S.current.signup_password_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      Consumer(
                        builder: (context, ref, child) {
                          bool showPassword =
                              ref.watch(signUpShowPasswordProvider);
                          return TextFormField(
                            obscureText: !showPassword,
                            textInputAction: TextInputAction.next,
                            controller: passwordTextController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.current.signup_password_hint;
                              }
                              if (value.length < 8) {
                                return S.current.signup_password_invalid;
                              }
                              return null;
                            },
                            decoration: inputDirectionStyle.copyWith(
                              hintText: S.current.signup_password_hint,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  ref
                                      .read(signUpShowPasswordProvider.notifier)
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
                      SizedBox(height: 2.h),
                      Text(
                        S.current.signup_confirm_password_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: confirmPasswordTextController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.current.signup_confirm_password_hint;
                          }
                          if (value != passwordTextController.text) {
                            return S.current.signup_confirm_password_invalid;
                          }
                          return null;
                        },
                        decoration: inputDirectionStyle.copyWith(
                          hintText: S.current.signup_password_hint,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        S.current.signup_mobile_caption,
                        style: inputBoxCaptionStyle(context),
                      ),
                      SizedBox(height: 1.h),
                      Consumer(
                        builder: (context, ref, child) {
                          final otpSent = ref.watch(signUpOTPGeneratedProvider);
                          return TextFormField(
                            controller: mobileTextController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState?.validate() == true) {
                                if (!otpSent) {
                                  _sendOtp(
                                      context, ref, mobileTextController.text);
                                } else {
                                  _doRegistration(
                                      context,
                                      ref,
                                      fullNameTextController.text,
                                      emailTextController.text,
                                      passwordTextController.text,
                                      confirmPasswordTextController.text);
                                }
                              }
                            },
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.current.signup_mobile_empty;
                              }
                              if (value.length != 10) {
                                return S.current.signup_mobile_invalid;
                              }
                              return null;
                            },
                            decoration: inputDirectionStyle.copyWith(
                              enabled: !otpSent,
                              hintText: S.current.signup_mobile_hint,
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
                          final otpSent = ref.watch(signUpOTPGeneratedProvider);
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: elevatedButtonTextStyle,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() == true) {
                                  if (!otpSent) {
                                    _sendOtp(context, ref,
                                        mobileTextController.text);
                                  } else {
                                    _doRegistration(
                                      context,
                                      ref,
                                      fullNameTextController.text,
                                      emailTextController.text,
                                      passwordTextController.text,
                                      confirmPasswordTextController.text,
                                    );
                                  }
                                }
                              },
                              child: Text(
                                otpSent
                                    ? S.current.signup_btn_submit
                                    : S.current.signup_btn_send_otp,
                                style: elevationTextButtonTextStyle,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: S.current.signup_footer_have_account_,
                                  style: footerTextStyle),
                              TextSpan(
                                text: S.current.signup_footer_btx_login,
                                style: footerTextButtonStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, RouteList.login);
                                    // print('Tap Here onTap');
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendOtp(BuildContext context, WidgetRef ref, String mobile) async {
    showLoading(ref);
    final result =
        await ref.read(loginRepositoryProvider).generateRegistrationOtp(mobile);
    hideLoading(ref);
    if (result != null) {
      AppSnackbar.instance.error(context, result);
    } else {
      AppSnackbar.instance.message(context, 'OTP Sent successfully');
      ref.read(signUpOTPGeneratedProvider.notifier).state = true;
      ref.read(signUpTimerProvider.notifier).start();
    }
  }

  void _doRegistration(BuildContext context, WidgetRef ref, String name,
      String email, String password, String confirmPass) async {
    final enteredOTP = ref.read(signUpEnteredOTPProvider);
    if (!enteredOTP.isNotEmpty) {
      AppSnackbar.instance.error(context, S.current.signup_error_otp_empty);
      return;
    }
    showLoading(ref);
    final result = await ref
        .read(loginRepositoryProvider)
        .verifyRegistrationOtp(name, email, password, confirmPass, enteredOTP);

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
      AppSnackbar.instance.message(context, 'Registration successfully');
      hideLoading(ref);
      Navigator.pushReplacementNamed(context, RouteList.home);
    }
  }

  _buildOtpBox() {
    return Consumer(
      builder: (context, ref, child) {
        final timerRunning = ref.watch(signUpTimerProvider).running;
        final otpSent = ref.watch(signUpOTPGeneratedProvider);
        final value = ref.watch(signUpTimerProvider);

        return otpSent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.signup_otp_caption,
                      style: inputBoxCaptionStyle(context)),
                  SizedBox(height: 1.h),
                  Pinput(
                    length: 6,
                    errorText: S.current.signup_error_otp_invalid,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // validator: (s) {
                    //   return s == '222222' ? null : 'Pin is incorrect';
                    // },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) =>
                        ref.read(signUpEnteredOTPProvider.notifier).state = pin,
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
                                  showLoading(ref);
                                  final result = await ref
                                      .read(loginRepositoryProvider)
                                      .reSendRegistrationOtp();
                                  hideLoading(ref);
                                  if (result != null) {
                                    AppSnackbar.instance.error(context, result);
                                  } else {
                                    AppSnackbar.instance.message(
                                        context, 'OTP Sent successfully');
                                    ref
                                        .read(
                                            signUpOTPGeneratedProvider.notifier)
                                        .state = true;

                                    ref
                                        .read(signUpTimerProvider.notifier)
                                        .start();
                                  }
                                }
                              },
                        child: Text(
                          S.current.signup_btn_send_otp,
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
