// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../controller/bmeet_providers.dart';
import '../../../core/state.dart';
import '../../../core/ui_core.dart';
import '../../base_back_screen.dart';
import '../profile/base_settings_noscroll.dart';
// import '../../widgets.dart';

final muteSchdeuleMeetingProvider = StateProvider<bool>(
  (_) => false,
);
final videoOffSchdeuleMeetingProvider = StateProvider<bool>(
  (_) => false,
);

// final dateStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final startTimeStateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final endTimeStateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class ScheduleMeetScreen extends HookWidget {
  ScheduleMeetScreen({Key? key}) : super(key: key);

  late TextEditingController _controller;
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
      _formKey = GlobalKey<FormState>();
      _controller = TextEditingController();
      _dateController = TextEditingController();
      _startController = TextEditingController();
      _endController = TextEditingController();
      _subjectController = TextEditingController();
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

  // Widget buildScreen(BuildContext context) {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final user = ref.watch(loginRepositoryProvider).user;
  //       if (user == null) return const SizedBox.expand();
  //       return Container(
  //         decoration: const BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               AppColors.gradientTopColor,
  //               AppColors.gradientLiveBottomColor,
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Stack(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(top: 9.h),
  //                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.all(Radius.circular(4.w)),
  //                 ),
  //                 child: _buildBody(context),
  //               ),
  //               IconButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   icon: getSvgIcon('arrow_back.svg')),
  //               Container(
  //                 alignment: Alignment.topCenter,
  //                 margin: EdgeInsets.only(top: 4.h),
  //                 child: Column(
  //                   children: [
  //                     getRectFAvatar(size: 22.w, user.name, user.image),
  //                     Text(user.name, style: textStyleBlack),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
            Text(S.current.bmeet_schedule_heading, style: textStyleHeading),
            SizedBox(height: 4.h),
            Text(S.current.bmeet_caption_title, style: textStyleCaption),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _controller,
              showCursor: false,
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
              showCursor: false,
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
            TextFormField(
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
                if (_selectedDate != null) {
                  _dateController.text =
                      DateFormat('dd-MM-yyyy').format(_selectedDate!);
                }
              },
              focusNode: _dateFocus,
              decoration: inputMeetStyle.copyWith(
                  hintText: S.current.bmeet_hint_date,
                  suffixIcon: const Icon(Icons.edit_calendar)),
            ),
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
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    autofocus: false,
                    showCursor: false,
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
                        print('dt: $dt');
                        _startController.text = dt;
                      });
                    },
                    onFieldSubmitted: (value) {},
                    focusNode: _startFocus,
                    decoration: inputMeetStyle.copyWith(
                        hintText: S.current.bmeet_hint_start,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                        )),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: TextFormField(
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
                        print('dt: $dt');
                      });
                    },
                    focusNode: _endFocus,
                    onEditingComplete: () {},
                    decoration: inputMeetStyle.copyWith(
                        hintText: S.current.bmeet_hint_end,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Consumer(
              builder: (context, ref, child) {
                bool mute = ref.watch(muteSchdeuleMeetingProvider);
                return _buildSettingRow(
                    S.current.bmeet_mute_title, S.current.bmeet_mute_desc, mute,
                    (value) {
                  ref.read(muteSchdeuleMeetingProvider.notifier).state = value;
                });
              },
            ),
            SizedBox(height: 3.h),
            Consumer(
              builder: (context, ref, child) {
                final camOff = ref.watch(videoOffSchdeuleMeetingProvider);
                return _buildSettingRow(S.current.bmeet_videooff_title,
                    S.current.bmeet_videooff_desc, camOff, (value) {
                  ref.read(videoOffSchdeuleMeetingProvider.notifier).state =
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

  void _scheduleMeeting(
    BuildContext context,
    WidgetRef ref,
  ) async {
    showLoading(ref);
    final mute = ref.watch(muteSchdeuleMeetingProvider);
    final camOff = ref.watch(videoOffSchdeuleMeetingProvider);
    final result = await ref.read(bMeetRepositoryProvider).createMeeting(
        title: _controller.text,
        subject: _subjectController.text,
        date: _selectedDate!,
        startAt: _startTime!,
        endAt: _endTime!,
        noAudio: mute,
        noVideo: camOff);
    hideLoading(ref);
    if (result != null) {
      AppSnackbar.instance.message(context, 'Meeting scheduled successfully!!');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context, true);
    } else {
      AppSnackbar.instance.error(context, 'Error while scheduling meeting');
    }
  }

  void dispose() {}

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

  _pickTime(BuildContext context, Function(DateTime) onPick) {
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
}
