// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '/controller/blive_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../base_back_screen.dart';
import '../../dialog/image_picker_dialog.dart';
import '../../dialog/ok_dialog.dart';
import '../profile/base_settings_noscroll.dart';

// final dateStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final startTimeStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedImageFileStateProvider =
    StateProvider.autoDispose<File?>((ref) => null);

class ScheduleBLiveScreen extends HookWidget {
  ScheduleBLiveScreen({Key? key}) : super(key: key);

  late GlobalKey<FormState> _formKey;

  late TextEditingController _controller;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late TextEditingController _startController;

  late FocusNode _titleFocus;
  late FocusNode _descFocus;
  late FocusNode _dateFocus;
  late FocusNode _startFocus;
  // late FocusNode _endFocus;

  DateTime? _selectedDate;
  DateTime? _time;
  // DateTime? _endTime;
  // File? _image;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _formKey = GlobalKey<FormState>();
      _controller = TextEditingController();
      _dateController = TextEditingController();
      _startController = TextEditingController();
      _subjectController = TextEditingController();
      _titleFocus = FocusNode();
      _dateFocus = FocusNode();
      _startFocus = FocusNode();
      _descFocus = FocusNode();
      return dispose;
    }, []);
    return BaseWilPopupScreen(
      onBack: () async {
        return true;
      },
      child: Scaffold(
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Text(S.current.blive_schedule_heading, style: textStyleHeading),
            SizedBox(height: 4.h),
            Text(S.current.blive_caption_title, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _controller,
              showCursor: false,
              focusNode: _titleFocus,
              onTap: () {},
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return S.current.blive_empty_title;
                }
                if (value.length < 5) {
                  return S.current.blive_invalid_title;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _formKey.currentState?.save();
              },
              decoration:
                  inputMeetStyle.copyWith(hintText: S.current.blive_hint_title),
            ),
            SizedBox(height: 3.h),
            // Text(S.current.blive_caption_date, style: textStyleCaption),
            // SizedBox(height: 0.5.h),
            // TextFormField(
            //   controller: _dateController,
            //   autofocus: false,
            //   showCursor: false,
            //   validator: (value) {
            //     if (value == null ||
            //         value.isEmpty == true ||
            //         _selectedDate == null) {
            //       return S.current.blive_empty_date;
            //     }
            //     return null;
            //   },
            //   onTap: () async {
            //     _dateFocus.unfocus();
            //     _selectedDate = await _pickDate(context);
            //     if (_selectedDate != null) {
            //       _dateController.text =
            //           DateFormat('dd-MM-yyyy').format(_selectedDate!);
            //     }
            //   },
            //   focusNode: _dateFocus,
            //   decoration: inputMeetStyle.copyWith(
            //       hintText: S.current.blive_hint_date,
            //       suffixIcon: const Icon(Icons.edit_calendar)),
            // ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(S.current.blive_caption_date,
                        style: textStyleCaption)),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: Text(S.current.blive_caption_starttime,
                      style: textStyleCaption),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _dateController,
                    autofocus: false,
                    showCursor: false,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty == true ||
                          _selectedDate == null) {
                        return S.current.blive_empty_date;
                      }
                      return null;
                    },
                    onTap: () async {
                      _dateFocus.unfocus();

                      _selectedDate = await _pickDate(context);
                      if (_selectedDate != null) {
                        _dateController.text =
                            DateFormat('dd-MM-yyyy').format(_selectedDate!);
                      }
                    },
                    focusNode: _dateFocus,
                    decoration: inputMeetStyle.copyWith(
                        hintText: S.current.blive_hint_date,
                        suffixIcon: const Icon(Icons.edit_calendar)),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _startController,
                    autofocus: false,
                    showCursor: false,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty == true ||
                          _time == null) {
                        return S.current.blive_empty_time;
                      }
                      if (_time?.isBefore(DateTime.now()) == true) {
                        return S.current.blive_invalid_time;
                      }
                      return null;
                    },
                    onTap: () {
                      _showTimePicker(context, (time) {
                        _time = time;
                        final dt = DateFormat.jm().format(time);
                        // print('dt: $dt');
                        _startController.text = dt;
                      });
                    },
                    onFieldSubmitted: (value) {},
                    focusNode: _startFocus,
                    decoration: inputMeetStyle.copyWith(
                        hintText: S.current.blive_hint_time,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                        )),
                  ),
                ),
                SizedBox(width: 3.w),
                // Expanded(
                //   child: TextFormField(
                //     controller: _endController,
                //     autofocus: false,
                //     showCursor: false,
                //     validator: (value) {
                //       if (value == null ||
                //           value.isEmpty == true ||
                //           _endTime == null ||
                //           _time == null) {
                //         return S.current.blive_empty_end;
                //       }
                //       if (_endTime?.isBefore(_time!) == true) {
                //         return S.current.blive_invalid_end;
                //       }
                //       return null;
                //     },
                //     onTap: () {
                //       _pickTime(context, (time) {
                //         final dt = DateFormat.jm().format(time);
                //         _endTime = time;
                //         _endController.text = dt;
                //         print('dt: $dt');
                //       });
                //     },
                //     focusNode: _endFocus,
                //     onEditingComplete: () {},
                //     decoration: inputMeetStyle.copyWith(
                //         hintText: S.current.blive_hint_end,
                //         suffixIcon: const Icon(
                //           Icons.keyboard_arrow_down,
                //         )),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(S.current.blive_caption_desc, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _subjectController,
              showCursor: false,
              focusNode: _descFocus,
              keyboardType: TextInputType.multiline,
              onTap: () {},
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return S.current.blive_empty_desc;
                }
                if (value.length < 5) {
                  return S.current.blive_invalid_desc;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _formKey.currentState?.save();
              },
              minLines: 3,
              maxLines: 5,
              decoration:
                  inputMeetStyle.copyWith(hintText: S.current.blive_hint_desc),
            ),
            SizedBox(height: 3.h),
            Text(S.current.blive_caption_image, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            Container(
              height: 15.h,
              decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.all(Radius.circular(3.w))),
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    File? image = ref.watch(selectedImageFileStateProvider);
                    return InkWell(
                      onTap: () async {
                        final pickedFile = await showImageFilePicker(context);
                        if (pickedFile != null) {
                          ref
                              .read(selectedImageFileStateProvider.notifier)
                              .state = pickedFile;
                        }
                      },
                      child: image != null
                          ? _buildImage(image, () {
                              ref
                                  .read(selectedImageFileStateProvider.notifier)
                                  .state = null;
                            })
                          : const Icon(Icons.camera_alt,
                              color: AppColors.iconGreyColor),
                    );
                  },
                ),
              ),
            ),
            // SizedBox(height: 6.h),
            // Consumer(
            //   builder: (context, ref, child) {
            //     bool mute = ref.watch(muteSchdeuleLiveProvider);
            //     return _buildSettingRow(
            //         S.current.blive_mute_title, S.current.blive_mute_desc, mute,
            //         (value) {
            //       ref.read(muteSchdeuleLiveProvider.notifier).state = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 3.h),
            // Consumer(
            //   builder: (context, ref, child) {
            //     final camOff = ref.watch(videoOffSchdeuleLiveProvider);
            //     return _buildSettingRow(S.current.blive_videooff_title,
            //         S.current.blive_videooff_desc, camOff, (value) {
            //       ref.read(videoOffSchdeuleLiveProvider.notifier).state = value;
            //     });
            //   },
            // ),
            SizedBox(height: 7.h),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  style: elevatedButtonTextStyle,
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      if (_selectedDate != null && _time != null) {
                        _scheduleBroadcast(context, ref);
                      }
                    }
                  },
                  child: Text(S.current.bmeet_btn_schedule),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(File image, Function() onTap) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(3.w)),
          child: Image.file(
            image,
            width: 88.w,
            height: 15.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(
                onPressed: () {
                  onTap();
                },
                icon: const Icon(Icons.close, color: Colors.red)))
      ],
    );
  }

  void _scheduleBroadcast(BuildContext context, WidgetRef ref) async {
    showLoading(ref);
    final file = ref.read(selectedImageFileStateProvider.notifier).state;
    if (file == null) {
      AppSnackbar.instance.message(context, 'Pick an image first');
      return;
    }
    final result = await ref.read(bLiveRepositoryProvider).createClass(
          title: _controller.text,
          desc: _subjectController.text,
          date: _selectedDate!,
          time: _time!,
          image: file,
        );
    hideLoading(ref);
    if (result != null) {
      // AppSnackbar.instance
      //     .message(context, 'Broadcast scheduled successfully!!');
      // await Future.delayed(const Duration(seconds: 2));
      // Navigator.pop(context, true);
      showOkDialog(
        context,
        S.current.dg_title_live_scheduled,
        S.current.dg_message_live_scheduled,
        type: true,
        positiveButton: S.current.btn_continue,
        positiveAction: () {
          Navigator.pop(context, true);
        },
      );
    } else {
      AppSnackbar.instance.error(context, 'Error while scheduling broadcast');
    }
  }

  // Widget _buildSettingRow(
  //     String title, String desc, bool value, Function(bool) onTapSetting) {
  //   return InkWell(
  //     onTap: () {
  //       onTapSetting(!value);
  //     },
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(title, style: textStyleTitle),
  //               SizedBox(height: 0.4.h),
  //               Text(desc, style: textStyleDesc),
  //             ],
  //           ),
  //         ),
  //         mySwitch(value, onTapSetting),
  //       ],
  //     ),
  //   );
  // }

  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day));
  }

  _showTimePicker(BuildContext context, Function(DateTime) onPick) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.w),
                      topLeft: Radius.circular(4.w)),
                  color: Colors.white),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          onPick(val);
                        }),
                  ),
                ],
              ),
            ));
  }

  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    _startController.dispose();
    _subjectController.dispose();
    _titleFocus.dispose();
    _dateFocus.dispose();
    _startFocus.dispose();
    _descFocus.dispose();
  }
}
