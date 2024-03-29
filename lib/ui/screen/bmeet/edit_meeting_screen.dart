// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:intl/intl.dart';

import '/data/models/models.dart';
import '/controller/bmeet_providers.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../base_back_screen.dart';
import '../../dialog/ok_dialog.dart';
import '../profile/base_settings_noscroll.dart';
// import '../../widgets.dart';

final muteSchdeuleEditMeetingProvider = StateProvider<bool>(
  (_) => false,
);
final videoOffSchdeuleEditMeetingProvider = StateProvider<bool>(
  (_) => false,
);

// final dateStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final startTimeStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final endTimeStateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class EditMeetScreen extends HookWidget {
  final ScheduledMeeting meeting;
  EditMeetScreen({Key? key, required this.meeting}) : super(key: key);

  late TextEditingController _titlecontroller;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  late FocusNode _titleFocus;
  late FocusNode _subjectFocus;
  late FocusNode _dateFocus;
  late FocusNode _startFocus;
  late FocusNode _endFocus;

  DateTime? _selectedDate;
  DateTime? _startTime;
  DateTime? _endTime;

  late GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final startDate =
          DateFormat('yyyy-MM-dd hh:mm:ss').parse(meeting.startsAt);
      final endDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(meeting.endsAt);
      _formKey = GlobalKey<FormState>();
      _titlecontroller = TextEditingController(text: meeting.name);
      _dateController = TextEditingController(
          text: DateFormat('dd-MM-yyyy').format(startDate));
      _startController =
          TextEditingController(text: DateFormat.jm().format(startDate));

      _endController =
          TextEditingController(text: DateFormat.jm().format(endDate));

      _subjectController = TextEditingController(text: meeting.description);
      _titleFocus = FocusNode();
      _dateFocus = FocusNode();
      _startFocus = FocusNode();
      _endFocus = FocusNode();
      _subjectFocus = FocusNode();
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
            Text(S.current.bmeet_edit_heading, style: textStyleHeading),
            SizedBox(height: 4.h),
            Text(S.current.bmeet_caption_title, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _titlecontroller,
              showCursor: true,
              focusNode: _titleFocus,
              onTap: () {},
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return S.current.bmeet_empty_title;
                }
                if (value.length < 5) {
                  return S.current.bmeet_invalid_title;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _formKey.currentState?.save();
              },
              decoration: inputMeetStyle.copyWith(
                hintText: S.current.bmeet_hint_title,
              ),
            ),
            SizedBox(height: 3.h),
            Text(S.current.bmeet_caption_subject, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _subjectController,
              showCursor: true,
              focusNode: _subjectFocus,
              onTap: () {},
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return S.current.bmeet_empty_subject;
                }
                if (value.length < 5) {
                  return S.current.bmeet_invalid_subject;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _formKey.currentState?.save();
              },
              decoration: inputMeetStyle.copyWith(
                hintText: S.current.bmeet_hint_subject,
              ),
            ),
            SizedBox(height: 3.h),
            Text(S.current.bmeet_caption_date, style: textStyleCaption),
            SizedBox(height: 0.5.h),
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
                  _dateFocus.unfocus();

                  _selectedDate = await _pickDate(context);
                  ref.read(selectedDateProvider.notifier).state =
                      _selectedDate ?? DateTime.now();
                  if (_selectedDate != null) {
                    _dateController.text =
                        DateFormat('dd-MM-yyyy').format(_selectedDate!);
                  }
                },
                focusNode: _dateFocus,
                decoration: inputMeetStyle.copyWith(
                    hintText: S.current.bmeet_hint_date,
                    suffixIcon: const Icon(Icons.edit_calendar)),
              );
            }),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                    child: Text(S.current.bmeet_caption_starttime,
                        style: textStyleCaption)),
                SizedBox(width: 3.w),
                Expanded(
                    child: Text(S.current.bmeet_caption_endtime,
                        style: textStyleCaption)),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    return TextFormField(
                      controller: _startController,
                      autofocus: false,
                      showCursor: false,
                      keyboardType: TextInputType.none,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty == true ||
                            _startTime == null) {
                          return S.current.bmeet_empty_start;
                        }
                        if (_startTime?.isBefore(DateTime.now()) == true) {
                          return S.current.bmeet_invalid_start;
                        }
                        return null;
                      },
                      onTap: () {
                        _pickTime(context, (time) {
                          _startTime = time;
                          final dt = DateFormat.jm().format(time);
                          // print('dt: $dt');
                          _startController.text = dt;
                        }, ref);
                      },
                      onFieldSubmitted: (value) {},
                      focusNode: _startFocus,
                      decoration: inputMeetStyle.copyWith(
                          hintText: S.current.bmeet_hint_start,
                          isDense: true,
                          errorStyle: const TextStyle(height: 0),
                          errorMaxLines: 3,
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                          )),
                    );
                  }),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    return TextFormField(
                      controller: _endController,
                      autofocus: false,
                      showCursor: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty == true ||
                            _endTime == null ||
                            _startTime == null) {
                          return S.current.bmeet_empty_end;
                        }
                        if (_endTime?.isBefore(_startTime!) == true) {
                          return S.current.bmeet_invalid_end;
                        }
                        return null;
                      },
                      onTap: () {
                        _pickTime(context, (time) {
                          final dt = DateFormat.jm().format(time);
                          _endTime = time;
                          _endController.text = dt;
                          // print('dt: $dt');
                        }, ref);
                      },
                      focusNode: _endFocus,
                      onEditingComplete: () {},
                      decoration: inputMeetStyle.copyWith(
                          hintText: S.current.bmeet_hint_end,
                          errorMaxLines: 2,
                          isDense: true,
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                          )),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Consumer(
              builder: (context, ref, child) {
                bool mute = ref.watch(muteSchdeuleEditMeetingProvider);
                return _buildSettingRow(
                    S.current.bmeet_mute_title, S.current.bmeet_mute_desc, mute,
                    (value) {
                  ref.read(muteSchdeuleEditMeetingProvider.notifier).state =
                      value;
                });
              },
            ),
            SizedBox(height: 3.h),
            Consumer(
              builder: (context, ref, child) {
                final camOff = ref.watch(videoOffSchdeuleEditMeetingProvider);
                return _buildSettingRow(S.current.bmeet_videooff_title,
                    S.current.bmeet_videooff_desc, camOff, (value) {
                  ref.read(videoOffSchdeuleEditMeetingProvider.notifier).state =
                      value;
                });
              },
            ),
            SizedBox(height: 7.h),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  style: elevatedButtonTextStyle,
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      if (_selectedDate != null &&
                          _startTime != null &&
                          _endTime != null) {
                        _scheduleMeeting(context, ref);
                      }
                    }
                  },
                  child: Text(S.current.btn_update),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _scheduleMeeting(BuildContext context, WidgetRef ref) async {
    showLoading(ref);
    final mute = ref.watch(muteSchdeuleEditMeetingProvider);
    final camOff = ref.watch(videoOffSchdeuleEditMeetingProvider);
    final date =
        DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
    final startTime = DateFormat('H:mm').format(_startTime ?? DateTime.now());
    final endTime = DateFormat('H:mm').format(_endTime ?? DateTime.now());

    Map data = {
      'id': meeting.id,
      'name': _titlecontroller.text,
      'description': _subjectController.text,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'repeatable': '0',
      'disable_video': mute,
      'disable_audio': camOff,
    };
    final result =
        await ref.read(bMeetRepositoryProvider).updateMeeting(data: data);
    hideLoading(ref);
    if (result != null) {
      // AppSnackbar.instance.message(context, 'Meeting scheduled successfully!!');
      // await Future.delayed(const Duration(seconds: 2));
      // Navigator.pop(context, true);
      showOkDialog(
        context,
        S.current.dg_title_meeting_scheduled,
        S.current.dg_message_meeting_scheduled,
        type: true,
        positiveButton: S.current.btn_continue,
        positiveAction: () {
          Navigator.pop(context, true);
        },
      );
    } else {
      AppSnackbar.instance.error(context, 'Error while scheduling meeting');
    }
  }

  void dispose() {
    _titlecontroller.dispose();
    _dateController.dispose();
    _endController.dispose();
    _startController.dispose();
    _subjectController.dispose();

    _titleFocus.dispose();
    _subjectFocus.dispose();
    _dateFocus.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
  }

  Widget _buildSettingRow(
      String title, String desc, bool value, Function(bool) onTapSetting) {
    return InkWell(
      onTap: () {
        onTapSetting(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyleTitle),
                SizedBox(height: 0.4.h),
                Text(desc, style: textStyleDesc),
              ],
            ),
          ),
          mySwitch(value, onTapSetting),
        ],
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

  _pickTime(
      BuildContext context, Function(DateTime) onPick, WidgetRef ref) async {
    // TimeOfDay pickedTime = await showTimePicker(
    //       initialTime: TimeOfDay.now(),
    //       context: context, //context of current state
    //     ) ??
    //     TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context, //context of current state
          builder: (context, child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child ?? Container(),
            );
          },
        ) ??
        TimeOfDay.now();
    // final now = DateTime.now();

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
