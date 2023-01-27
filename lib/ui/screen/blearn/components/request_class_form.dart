import 'package:bvidya/controller/bmeet_providers.dart';
import 'package:bvidya/ui/screens.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../dialog/ok_dialog.dart';
import '/data/models/response/blearn/instructors_response.dart';

import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import 'common.dart';

class RequestClassForm extends HookWidget {
  final Instructor instructor;
  RequestClassForm({super.key, required this.instructor});

  final topicController = TextEditingController();
  final classTypeController = TextEditingController();
  final descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  final currentClassTypeProvider = StateProvider<int?>(
    (ref) {
      return null;
    },
  );

  DateTime? _selectedDate;
  DateTime? _startTime;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        return () {
          topicController.dispose();
          classTypeController.dispose();
          descriptionController.dispose();
          _dateController.dispose();
          _timeController.dispose();
        };
      },
    );
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
                child: Consumer(builder: (consumercontext, ref, child) {
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
                            child: ListView(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          controller: topicController,
                                          // focusNode: phoneFocusNode,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty == true) {
                                              return S.current
                                                  .t_request_class_empty_topic;
                                            }
                                            if (value.length < 5) {
                                              return S.current
                                                  .t_request_class_topic_invalid;
                                            }
                                            return null;
                                          },
                                          autocorrect: false,
                                          textInputAction: TextInputAction.next,
                                          decoration:
                                              inputNewGroupStyle.copyWith(
                                            hintText: S.current
                                                .request_class_topic_hint,
                                          )),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(S.current.request_class_type,
                                          style: textStyleCaption),
                                      SizedBox(
                                        height: 2.w,
                                      ),
                                      DropdownButtonFormField2(
                                        decoration: inputNewGroupStyle.copyWith(
                                          hintText: S.current
                                              .t_request_class_type_hint,
                                        ),
                                        isExpanded: true,
                                        // hint: const Text(
                                        //   "Select Class type",
                                        //   style: TextStyle(fontSize: 14),
                                        // ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 10.w,

                                        dropdownDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 0,
                                            child: Text("Group"),
                                          ),
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text("Personal"),
                                          )
                                        ],
                                        validator: (value) {
                                          if (value == null) {
                                            return S.current
                                                .t_request_class_empty_type;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          switch (value) {
                                            case 0:
                                              classTypeController.text =
                                                  "Group";
                                              ref
                                                  .watch(
                                                      currentClassTypeProvider
                                                          .notifier)
                                                  .state = 0;
                                              break;
                                            case 1:
                                              classTypeController.text =
                                                  "Personal";
                                              ref
                                                  .watch(
                                                      currentClassTypeProvider
                                                          .notifier)
                                                  .state = 1;
                                              break;
                                          }
                                        },
                                      ),
                                      // TextFormField(
                                      //   controller: classTypeController,
                                      //   autofocus: false,
                                      //   readOnly: true,
                                      //   showCursor: false,
                                      //   keyboardType: TextInputType.none,
                                      //   validator: (value) {
                                      //     if (value == null ||
                                      //         value.isEmpty == true ||
                                      //         _startTime == null) {
                                      //       return S.current.bmeet_empty_start;
                                      //     }
                                      //     if (_startTime
                                      //             ?.isBefore(DateTime.now()) ==
                                      //         true) {
                                      //       return S
                                      //           .current.bmeet_invalid_start;
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onTap: () {
                                      //     final returndata =
                                      //         _pickType(context, ref);

                                      //   },
                                      //   onFieldSubmitted: (value) {},
                                      //   // focusNode: _startFocus,
                                      //   decoration: inputMeetStyle.copyWith(
                                      //       hintText:
                                      //           S.current.bmeet_hint_start,
                                      //       suffixIcon: const Icon(
                                      //         Icons.keyboard_arrow_down,
                                      //       )),
                                      // ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(S.current.request_class_description,
                                          style: textStyleCaption),
                                      SizedBox(
                                        height: 2.w,
                                      ),
                                      TextFormField(
                                          controller: descriptionController,
                                          // focusNode: phoneFocusNode,
                                          validator: (value) {
                                            if (value?.isEmpty ?? false) {
                                              return S.current
                                                  .t_request_class_empty_description;
                                            }
                                            if (value!.length < 5) {
                                              return S.current
                                                  .t_request_class_description_invalid;
                                            }
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
                                                    color: AppColors
                                                        .inputBoxBorder,
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
                                                  maxHeight: 30.w))),
                                      SizedBox(height: 3.h),
                                      Text(S.current.bmeet_caption_date,
                                          style: textStyleCaption),
                                      SizedBox(height: 3.h),
                                      Consumer(builder: (context, ref, child) {
                                        return TextFormField(
                                          controller: _dateController,
                                          autofocus: false,
                                          showCursor: false,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty == true ||
                                                _selectedDate == null) {
                                              return S.current.bmeet_empty_date;
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            _selectedDate =
                                                await _pickDate(context);
                                            ref
                                                    .read(selectedDateProvider
                                                        .notifier)
                                                    .state =
                                                _selectedDate ?? DateTime.now();
                                            if (_selectedDate != null) {
                                              _dateController.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(_selectedDate!);
                                            }
                                          },
                                          // focusNode: _dateFocus,
                                          decoration: inputMeetStyle.copyWith(
                                              hintText:
                                                  S.current.bmeet_hint_date,
                                              suffixIcon: const Icon(
                                                  Icons.edit_calendar)),
                                        );
                                      }),
                                      SizedBox(height: 3.h),
                                      Text(S.current.bmeet_caption_starttime,
                                          style: textStyleCaption),
                                      SizedBox(height: 3.h),
                                      TextFormField(
                                        controller: _timeController,
                                        autofocus: false,
                                        readOnly: true,
                                        showCursor: false,
                                        keyboardType: TextInputType.none,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty == true ||
                                              _startTime == null) {
                                            return S.current.bmeet_empty_start;
                                          }
                                          if (_startTime
                                                  ?.isBefore(DateTime.now()) ==
                                              true) {
                                            return S
                                                .current.bmeet_invalid_start;
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          _pickTime(context, (time) {
                                            print(time);
                                            _startTime = time;
                                            final dt =
                                                DateFormat.jm().format(time);
                                            print('dt: $dt');
                                            _timeController.text = dt;
                                          }, ref);
                                        },
                                        onFieldSubmitted: (value) {},
                                        // focusNode: _startFocus,
                                        decoration: inputMeetStyle.copyWith(
                                            hintText:
                                                S.current.bmeet_hint_start,
                                            suffixIcon: const Icon(
                                              Icons.keyboard_arrow_down,
                                            )),
                                      ),
                                      SizedBox(height: 6.h),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.w),
                                  child: SizedBox(
                                    height: 15.w,
                                    width: 100.w,
                                    child: ElevatedButton(
                                        style: elevatedButtonStyle,
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            showLoading(ref);
                                            final response = await ref
                                                .read(bMeetRepositoryProvider)
                                                .requestPersonalClass(
                                                    topic: topicController.text,
                                                    classType:
                                                        classTypeController
                                                            .text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    date: _selectedDate ??
                                                        DateTime.now(),
                                                    time: _timeController.text,
                                                    instructorid:
                                                        instructor.id ?? 0);
                                            response == "error"
                                                ? showTopSnackBar(
                                                    Overlay.of(context)!,
                                                    CustomSnackBar.error(
                                                        message:
                                                            S.current.error),
                                                  )
                                                : showTopSnackBar(
                                                    Overlay.of(context)!,
                                                    CustomSnackBar.success(
                                                        message: response),
                                                  );
                                            hideLoading(ref);
                                            Navigator.pop(context);
                                          }
                                        },
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

  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day));
  }

  _pickType(BuildContext context, WidgetRef ref) async {
    return DropdownButton(
      value: ref.watch(currentClassTypeProvider),
      items: const [
        DropdownMenuItem(
          value: 0,
          child: Text("Group"),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text("Personal"),
        )
      ],
      onChanged: (value) {
        switch (value) {
          case 0:
            classTypeController.text = "Group";
            ref.watch(currentClassTypeProvider.notifier).state = 0;
            break;
          case 1:
            classTypeController.text = "Personal";
            ref.watch(currentClassTypeProvider.notifier).state = 1;
            break;
        }
      },
    );
  }

  _pickTime(
      BuildContext context, Function(DateTime) onPick, WidgetRef ref) async {
    TimeOfDay pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
          builder: (context, child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child ?? Container(),
            );
          },
        ) ??
        TimeOfDay.now();

    if (pickedTime != null) {
      onPick(DateTime(
          ref.watch(selectedDateProvider).year,
          ref.watch(selectedDateProvider).month,
          ref.watch(selectedDateProvider).day,
          pickedTime.hour,
          pickedTime.minute));
      //output 10:51 PM
      // DateTime parsedTime =
      //     DateFormat.jm().parse(pickedTime.format(context).toString());
      // //converting to DateTime so that we can further format on different pattern.
      // print(parsedTime); //output 1970-01-01 22:53:00.000
      // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      // print(formattedTime); //output 14:59:00
      // //DateFormat() is from intl package, you can format the time on any pattern you need.
    } else {
      print("Time is not selected");
    }

    // showCupertinoModalPopup(
    //     context: context,
    //     builder: (_) => Container(
    //           height: 40.h,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(4.w),
    //                   topLeft: Radius.circular(4.w)),
    //               color: Colors.white),
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: 40.h,
    //                 child: CupertinoDatePicker(
    //                     mode: CupertinoDatePickerMode.time,
    //                     initialDateTime: DateTime.now(),
    //                     onDateTimeChanged: (val) {
    //                       onPick(val);
    //                     }),
    //               ),
    //             ],
    //           ),
    //         ));
  }
}
