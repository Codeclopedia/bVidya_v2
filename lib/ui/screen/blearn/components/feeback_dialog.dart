// import '/core/constants.dart';
// ignore_for_file: use_build_context_synchronously

import '/core/state.dart';
import '/data/models/models.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '/controller/blearn_providers.dart';
import '../../../base_back_screen.dart';
import '/core/ui_core.dart';

final ratingProvider = StateProvider<int>((ref) => 3);
final inputFeedbackTextProvider = StateProvider<String>((ref) => '');

class FeedbackPopup extends HookWidget {
  final Course course;
  final Function() onClose;
  const FeedbackPopup({Key? key, required this.course, required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedbackMessageController = useTextEditingController();

    return Consumer(
      builder: (context, ref, child) {
        int rating = ref.watch(ratingProvider);
        feedbackMessageController.text = ref.read(inputFeedbackTextProvider);
        return Container(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          child: Container(
            // height: 100.w,
            // width: 100.w,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFBDBDBD),
                      blurRadius: 5.0,
                      offset: Offset(1, -3)),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.w),
                    topRight: Radius.circular(5.w))),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.w),
                Text(
                  'Rate Your Experience',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp),
                ),
                Text(
                  'Are you satisfied with the experience?',
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
                  child: RatingBar.builder(
                    initialRating: rating.roundToDouble(),
                    itemCount: 5,
                    itemSize: 12.5.w,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    // itemBuilder: (context, index) {
                    //   switch (index) {
                    //     case 0:
                    //       return const Icon(
                    //         Icons.sentiment_very_dissatisfied,
                    //         color: Colors.red,
                    //       );

                    //     case 1:
                    //       return const Icon(
                    //         Icons.sentiment_dissatisfied,
                    //         color: Colors.redAccent,
                    //       );
                    //     case 2:
                    //       return const Icon(
                    //         Icons.sentiment_neutral,
                    //         color: Colors.amber,
                    //       );
                    //     case 3:
                    //       return const Icon(
                    //         Icons.sentiment_satisfied,
                    //         color: Colors.lightGreen,
                    //       );
                    //     case 4:
                    //       return const Icon(
                    //         Icons.sentiment_very_satisfied,
                    //         color: Colors.green,
                    //       );
                    //   }
                    //   return Container();
                    // },
                    onRatingUpdate: (rating) {
                      ref.read(ratingProvider.notifier).state = rating.toInt();
                    },
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tell us what can be improved?",
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp),
                  ),
                ),
                SizedBox(height: 1.w),
                TextField(
                  controller: feedbackMessageController,
                  decoration: inputMultiLineStyle.copyWith(
                      hintText: 'Write your feedback'),
                  minLines: 4,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onChanged: (input) {
                    ref.read(inputFeedbackTextProvider.notifier).state = input;
                  },
                ),
                SizedBox(height: 4.w),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 10.w,
                    width: 77.w,
                    child: ElevatedButton(
                        style: elevatedButtonStyle,
                        onPressed: () async {
                          String input = feedbackMessageController.text.trim();
                          ref.read(inputFeedbackTextProvider.notifier).state =
                              input;
                          if (input.isEmpty) {
                            showTopSnackBar(
                              Overlay.of(context)!,
                              const CustomSnackBar.error(
                                message: 'Please Fill all the details.',
                              ),
                            );
                          } else {
                            ref.read(inputFeedbackTextProvider.notifier).state =
                                '';
                            feedbackMessageController.text = '';
                            showLoading(ref);

                            final BaseResponse response = await ref
                                .read(bLearnRepositoryProvider)
                                .setfeedback(
                                    course.id.toString(), rating, input);
                            ref.refresh(
                                bLearnCourseDetailProvider(course.id ?? 0));

                            // ref.read(isModelSheetOpened.notifier).state = false;
                            debugPrint(response.status);
                            hideLoading(ref);
                            onClose();
                            showTopSnackBar(
                              Overlay.of(context)!,
                              const CustomSnackBar.success(
                                message: 'Feedback Submitted',
                              ),
                            );
                          }
                        },
                        child: const Text("Submit")),
                  ),
                ),
                SizedBox(height: 2.w),
                // Container(
                // height: 15.w,
                // width: 70.w,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //       color: AppColors.primaryColor,
                //       borderRadius: BorderRadius.circular(15)),
                //   child: Text(
                //     "Submit",
                //     style: TextStyle(
                //         color: AppColors.cardWhite,
                //         fontSize: 12.5.sp,
                //         fontWeight: FontWeight.w500),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget feedbackform(int rating, WidgetRef ref,
  //     TextEditingController feedbackMessageController, BuildContext context) {
  //   return;
  // }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.835, size.height);

    path.quadraticBezierTo(size.width * 0.7, size.height * 0.825,
        size.width * 0.85, size.height * 0.775);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.765, size.width, size.height * 0.9);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
