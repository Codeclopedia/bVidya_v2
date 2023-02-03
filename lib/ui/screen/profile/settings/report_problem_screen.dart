import '/controller/profile_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../base_back_screen.dart';
import '../base_settings.dart';

// String? options = S.current.bmeet;
final problemTypeProvider = StateProvider.autoDispose<String>(
  (ref) => "",
);

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: BaseSettings(
        bodyContent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Consumer(builder: (context, ref, child) {
            return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(S.current.reportTitle, style: textStyleSettingHeading),
                  SizedBox(height: 1.5.h),
                  Text(S.current.reportDesc, style: textStyleSettingDesc),
                  _buildRadioOption(S.current.bmeet, () {}, ref),
                  _buildRadioOption(S.current.blive, () {}, ref),
                  _buildRadioOption(S.current.bchat, () {}, ref),
                  _buildRadioOption(S.current.blearn, () {}, ref),
                  SizedBox(height: 1.5.h),
                  _buildIssues((message) async {
                    showLoading(ref);
                    final result;
                    message == ""
                        ? {
                            hideLoading(ref),
                            EasyLoading.showError(
                                S.current.issueDescriptionError),
                          }
                        : {
                            ref.watch(problemTypeProvider) == ""
                                ? {
                                    hideLoading(ref),
                                    EasyLoading.showError(
                                        S.current.ProblemTypeError),
                                  }
                                : {
                                    result = await ref
                                        .read(profileRepositoryProvider)
                                        .reportProblem(
                                            ref.watch(problemTypeProvider),
                                            message),
                                    hideLoading(ref),
                                    if (result == null)
                                      {
                                        // ignore: use_build_context_synchronously
                                        AppSnackbar.instance.message(context,
                                            'Report Submitted Successfully'),
                                        Navigator.pop(context),
                                      }
                                    else
                                      {
                                        // ignore: use_build_context_synchronously
                                        AppSnackbar.instance
                                            .error(context, result),
                                      }
                                  }
                          };
                  }),
                  SizedBox(height: 2.h),
                ]);
          }),
        ),
      ),
    );
  }

  Widget _buildIssues(Function(String content) onClick) {
    final textEditController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.current.issues,
          style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.5.h),
        TextField(
          controller: textEditController,
          decoration: inputDirectionStyle.copyWith(
            hintText: S.current.issuesDesc,
          ),
          minLines: 6,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: 1.5.h),
        ElevatedButton(
          style: elevatedButtonStyle,
          onPressed: () => onClick(textEditController.text.trim()),
          child: Text(S.current.submitBtn),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String title, Function() onClick, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Radio(
                value: title,
                fillColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.primaryColor),
                groupValue: ref.watch(problemTypeProvider),
                onChanged: (value) {
                  ref.read(problemTypeProvider.notifier).state =
                      value.toString();
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 4.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: kFontFamily,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 1.h),
            height: 0.5,
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }
}
