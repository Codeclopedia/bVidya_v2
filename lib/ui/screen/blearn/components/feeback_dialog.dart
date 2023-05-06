// ignore_for_file: use_build_context_synchronously

import '/ui/dialog/ok_dialog.dart';
import 'package:spring/spring.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/constants.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '/controller/blearn_providers.dart';
import '../../../base_back_screen.dart';
import '/core/ui_core.dart';

final ratingProvider = StateProvider<int>((ref) => 3);

final isfeedbackSubmitted = StateProvider.autoDispose<bool>((ref) => false);

class FeedbackPopup extends StatefulWidget {
  final Course course;
  final Function() onClose;
  const FeedbackPopup({Key? key, required this.course, required this.onClose})
      : super(key: key);

  static final formkey = GlobalKey<FormState>();

  @override
  State<FeedbackPopup> createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> {
  late final TextEditingController feedbackMessageController;

  @override
  void initState() {
    super.initState();
    feedbackMessageController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    feedbackMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (consumerContext, ref, child) {
        int rating = ref.watch(ratingProvider);

        return Center(
            child: ref.watch(isfeedbackSubmitted)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                    child: Spring.fadeIn(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 8.w,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Thank You for Your Feedback",
                                  style: textStyleBlack,
                                ),
                                Text(
                                  "We’re so happy to hear from you! Thank you for your valuable feedback.",
                                  style: textStyleBlack.copyWith(
                                      fontSize: 8.sp,
                                      color: AppColors.inputHintText),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : feedbackform(rating, ref, feedbackMessageController,
                    FeedbackPopup.formkey, context));
      },
    );
  }

  Widget feedbackform(
      int rating,
      WidgetRef ref,
      TextEditingController feedbackMessageController,
      GlobalKey<FormState> formkey,
      BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 6.w),
        Text(
          'Rate Your Experience',
          style: TextStyle(
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp),
        ),
        Text(
          'Are you satisfied with the experience?',
          style: TextStyle(
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w400,
              fontSize: 9.sp),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.w),
          child: RatingBar.builder(
            initialRating: 3,
            wrapAlignment: WrapAlignment.center,
            itemCount: 5,
            itemSize: 12.w,
            // allowHalfRating: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ref.read(ratingProvider.notifier).state = rating.toInt();
            },
          ),
        ),
        SizedBox(height: 1.w),
        SizedBox(
          width: 60.w,
          child: Form(
            key: formkey,
            child: TextFormField(
              controller: feedbackMessageController,
              style: textStyleBlack.copyWith(fontWeight: FontWeight.w500),
              decoration:
                  inputMultiLineStyle.copyWith(hintText: 'Write your feedback'),
              maxLines: 3,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'feedback can\'t be empty';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
            ),
          ),
        ),
        SizedBox(height: 4.w),
        ElevatedButton(
          onPressed: () async {
            if (formkey.currentState?.validate() ?? false) {
              showLoading(ref);

              final BaseResponse response = await ref
                  .read(bLearnRepositoryProvider)
                  .setfeedback(widget.course.id.toString(), rating,
                      feedbackMessageController.text.trim());
              ref.refresh(bLearnCourseDetailProvider(widget.course.id ?? 0));

              // ref.read(isModelSheetOpened.notifier).state = false;
              debugPrint(response.status);
              hideLoading(ref);
              if (response.status == "successfully") {
                showOkDialog(context, "Feedback Submitted",
                    "We’re so happy to hear from you! Thank you for your valuable feedback.",
                    type: true);
                feedbackMessageController.text = '';
                ref.read(isfeedbackSubmitted.notifier).state = true;
                await Future.delayed(const Duration(seconds: 5));
                ref.refresh(bLearnCourseDetailProvider(widget.course.id ?? 0));
              } else {
                showTopSnackBar(
                    Overlay.of(context)!,
                    CustomSnackBar.error(
                      message: S.current.error,
                    ));
              }
            }
          },
          style: elevatedButtonTextStyle.copyWith(
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              fixedSize: MaterialStatePropertyAll(Size(35.w, 10.w))),
          child: Text(
            S.current.submitBtn,
            style: textStyleCaption.copyWith(
                color: AppColors.cardWhite, fontSize: 10.sp),
          ),
        ),
        SizedBox(height: 3.w),
      ],
    );
  }
}

// Container(
//           alignment: Alignment.bottomCenter,
//           clipBehavior: Clip.none,
//           child: Container(
//             // height: 100.w,
//             // width: 100.w,
//             margin: EdgeInsets.only(top: 2.h),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: const [
//                   BoxShadow(
//                       color: Color(0xFFBDBDBD),
//                       blurRadius: 5.0,
//                       offset: Offset(1, -3)),
//                 ],
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(5.w),
//                     topRight: Radius.circular(5.w))),
//             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 2.w),
//                 Text(
//                   'Rate Your Experience',
//                   style: TextStyle(
//                       fontFamily: kFontFamily,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15.sp),
//                 ),
//                 Text(
//                   'Are you satisfied with the experience?',
//                   style: TextStyle(
//                       fontFamily: kFontFamily,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 10.sp),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
//                   child: RatingBar.builder(
//                     initialRating: rating.roundToDouble(),
//                     itemCount: 5,
//                     itemSize: 12.5.w,
//                     itemBuilder: (context, _) => const Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     onRatingUpdate: (rating) {
//                       ref.read(ratingProvider.notifier).state = rating.toInt();
//                     },
//                   ),
//                 ),
//                 const Divider(),

//                 SizedBox(height: 1.w),
//                 TextField(
//                   controller: feedbackMessageController,
//                   decoration: inputMultiLineStyle.copyWith(
//                       hintText: 'Write your feedback'),
//                   minLines: 4,
//                   maxLines: 4,
//                   keyboardType: TextInputType.multiline,
//                   onChanged: (input) {
//                     ref.read(inputFeedbackTextProvider.notifier).state = input;
//                   },
//                 ),
//                 SizedBox(height: 4.w),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: SizedBox(
//                     height: 10.w,
//                     width: 77.w,
//                     child: ElevatedButton(
//                         style: elevatedButtonStyle,
//                         onPressed: () async {
//                           String input = feedbackMessageController.text.trim();
//                           ref.read(inputFeedbackTextProvider.notifier).state =
//                               input;
//                           if (input.isEmpty) {
//                             showTopSnackBar(
//                               Overlay.of(context)!,
//                               const CustomSnackBar.error(
//                                 message: 'Please Fill all the details.',
//                               ),
//                             );
//                           } else {
//                             ref.read(inputFeedbackTextProvider.notifier).state =
//                                 '';
//                             feedbackMessageController.text = '';
//                             showLoading(ref);

//                             final BaseResponse response = await ref
//                                 .read(bLearnRepositoryProvider)
//                                 .setfeedback(
//                                     course.id.toString(), rating, input);
//                             ref.refresh(
//                                 bLearnCourseDetailProvider(course.id ?? 0));

//                             // ref.read(isModelSheetOpened.notifier).state = false;
//                             debugPrint(response.status);
//                             hideLoading(ref);
//                             onClose();
//                             showTopSnackBar(
//                               Overlay.of(context)!,
//                               const CustomSnackBar.success(
//                                 message: 'Feedback Submitted',
//                               ),
//                             );
//                           }
//                         },
//                         child: const Text("Submit")),
//                   ),
//                 ),
//                 SizedBox(height: 2.w),
//                 // Container(
//                 // height: 15.w,
//                 // width: 70.w,
//                 //   alignment: Alignment.center,
//                 //   decoration: BoxDecoration(
//                 //       color: AppColors.primaryColor,
//                 //       borderRadius: BorderRadius.circular(15)),
//                 //   child: Text(
//                 //     "Submit",
//                 //     style: TextStyle(
//                 //         color: AppColors.cardWhite,
//                 //         fontSize: 12.5.sp,
//                 //         fontWeight: FontWeight.w500),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         );

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
