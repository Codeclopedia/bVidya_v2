import '/data/models/response/blearn/instructors_response.dart';

import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'common.dart';

class RequestClassForm extends StatelessWidget {
  final Instructor instructor;
  const RequestClassForm({super.key, required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTopColor,
              AppColors.gradientLiveBottomColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(top: 9.h),
                padding: EdgeInsets.only(top: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.w),
                      topLeft: Radius.circular(10.w)),
                ),
                child: Consumer(builder: (context, ref, child) {
                  return ref
                      .watch(bLearnInstructorProfileProvider(
                          instructor.id.toString()))
                      .when(
                        data: (data) {
                          if (data == null) {
                            return SizedBox(
                              height: 20.h,
                              child: buildEmptyPlaceHolder('No Data'),
                            );
                          }
                          // ref.read(teacherOccupation.notifier).state =
                          //     data.profile?.occupation ?? '';
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.request_class_title,
                                        style: textStyleHeading),
                                    SizedBox(height: 10.w),
                                    Text(S.current.request_class_topic,
                                        style: textStyleCaption),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    TextFormField(

                                        // controller: phoneController,
                                        // focusNode: phoneFocusNode,
                                        validator: (value) {
                                          return null;
                                        },
                                        autocorrect: false,
                                        textInputAction: TextInputAction.next,
                                        decoration: inputNewGroupStyle.copyWith(
                                          hintText: S
                                              .current.request_class_topic_hint,
                                        )),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    Text(S.current.request_class_type,
                                        style: textStyleCaption),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    TextFormField(

                                        // controller: phoneController,
                                        // focusNode: phoneFocusNode,
                                        validator: (value) {
                                          return null;
                                        },
                                        autocorrect: false,
                                        textInputAction: TextInputAction.next,
                                        decoration: inputNewGroupStyle.copyWith(
                                          hintText:
                                              S.current.request_class_type_hint,
                                        )),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    Text(S.current.request_class_description,
                                        style: textStyleCaption),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    TextFormField(

                                        // controller: phoneController,
                                        // focusNode: phoneFocusNode,
                                        validator: (value) {
                                          return null;
                                        },
                                        maxLines: 10,
                                        autocorrect: false,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: S.current
                                                .request_class_description_hint,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: const BorderSide(
                                                  color:
                                                      AppColors.inputBoxBorder,
                                                  width: 1.0),
                                            ),
                                            fillColor: AppColors.inputBoxFill,
                                            filled: true,
                                            hintStyle: TextStyle(
                                              fontSize: 9.sp,
                                              fontFamily: kFontFamily,
                                              color: AppColors.inputHintText,
                                            ),
                                            border: OutlineInputBorder(
                                              gapPadding: 4.0,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            constraints: BoxConstraints(
                                                maxHeight: 20.w))),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.w),
                                  child: SizedBox(
                                    height: 15.w,
                                    width: 100.w,
                                    child: ElevatedButton(
                                        style: elevatedButtonStyle,
                                        onPressed: () {},
                                        child:
                                            Text(S.current.request_class_request
                                                // style: TextStyle(
                                                //   fontSize: 16.sp,
                                                //   fontFamily: kFontFamily,
                                                // )
                                                )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            buildEmptyPlaceHolder('error in loading data'),
                        loading: () =>
                            const CircularProgressIndicator.adaptive(),
                      );
                }),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg', color: Colors.white),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Column(
                    children: [
                      Container(
                        height: 12.5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: getImageProvider(instructor.image ?? ''),
                                fit: BoxFit.cover)),
                      ),
                      Text(
                        instructor.name.toString(),
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 4.w,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
              // _buildHeader(),
            ],
          ),
        ),
      ),
    );
  }
}
