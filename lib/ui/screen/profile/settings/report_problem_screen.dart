
import '../../../../controller/profile_providers.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../base_back_screen.dart';
import '../base_settings.dart';

// String? options = S.current.bmeet;

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  late final TextEditingController _textEditController;

  String options = S.current.bmeet;

  @override
  void initState() {
    _textEditController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: BaseSettings(
        bodyContent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(S.current.reportTitle, style: textStyleSettingHeading),
                SizedBox(height: 1.5.h),
                Text(S.current.reportDesc, style: textStyleSettingDesc),
                _buildRadioOption(S.current.bmeet, () {}),
                _buildRadioOption(S.current.blive, () {}),
                _buildRadioOption(S.current.bchat, () {}),
                _buildRadioOption(S.current.blearn, () {}),
                SizedBox(height: 1.5.h),
                Consumer(
                  builder: (context, ref, child) {
                    return _buildIssues(() async {
                      showLoading(ref);
                      final result = await ref
                          .read(profileRepositoryProvider)
                          .reportProblem(options, _textEditController.text);
                      hideLoading(ref);
                      if (result == null) {
                        // ignore: use_build_context_synchronously
                        AppSnackbar.instance
                            .message(context, 'Report Submitted Successfully');
                      } else {
                        // ignore: use_build_context_synchronously
                        AppSnackbar.instance.error(context, result);
                      }
                    });
                  },
                ),
                SizedBox(height: 2.h),
              ]),
        ),
      ),
    );
  }

  Widget _buildIssues(Function() onClick) {
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
          controller: _textEditController,
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
          onPressed: onClick,
          child: Text(S.current.submitBtn),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String title, Function() onClick) {
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
                groupValue: 'options',
                onChanged: (value) {
                  options = value.toString();
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
