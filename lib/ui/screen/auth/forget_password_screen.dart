// ignore_for_file: use_build_context_synchronously

import '../../../core/constants.dart';
import '../../../core/state.dart';
import '../../../core/ui_core.dart';
import '../../../core/utils.dart';
import '../../../data/services/auth_api_service.dart';
import '../../screens.dart';
import '../../widgets.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  //
  final _formKey = GlobalKey<FormState>();
//
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController = useTextEditingController(text: '');
    return BaseWilPopupScreen(
      onBack: () async {
        Navigator.pushReplacementNamed(context, RouteList.login);
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
                      S.current.fp_header_title,
                      style: screenHeaderTitleStyle(context),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      S.current.fp_desc_message,
                      style: footerTextStyle,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      S.current.fp_email_caption,
                      style: inputBoxCaptionStyle(context),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: emailTextController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.fp_email_empty;
                        }
                        if (!isValidEmail(value)) {
                          return S.current.fp_email_invalid;
                        }
                        return null;
                      },
                      decoration: inputDirectionStyle.copyWith(
                        hintText: S.current.fp_email_hint,
                      ),
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState?.validate() == true) {
                          _onForgotSumitted(
                              context, ref, emailTextController.text);
                        }
                        //todo
                      },
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: elevatedButtonTextStyle,
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              _onForgotSumitted(
                                  context, ref, emailTextController.text);
                            }
                          },
                          child: Text(
                            S.current.fp_btn_submit,
                            style: elevationTextButtonTextStyle,
                          )),
                    ),
                    SizedBox(height: 1.5.h),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: textButtonStyle,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteList.login);
                        },
                        child: Text(
                          S.current.fp_btx_login_back,
                          style: textButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onForgotSumitted(BuildContext context, WidgetRef ref, String email) async {
    showLoading(ref);
    final response = await ApiAuthService.instance.requestForgotPassword(email);
    if (response.status != 'successfull') {
      AppSnackbar.instance
          .error(context, response.message ?? 'Unknown error occurred!!');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
    hideLoading(ref);
  }
}
