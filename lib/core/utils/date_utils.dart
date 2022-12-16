import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:intl/intl.dart';

import '../ui_core.dart';

/// Check if a date separator needs to be shown
bool shouldShowDateSeparator(
    ChatMessage? previousMessage, ChatMessage message) {
  if (previousMessage == null) {
    return true;
  }

  final DateTime previousDate =
      DateTime.fromMillisecondsSinceEpoch(previousMessage.serverTime);
  final DateTime messageDate =
      DateTime.fromMillisecondsSinceEpoch(message.serverTime);
  return previousDate.difference(messageDate).inDays.abs() > 0;
}

String formatDateSeparator(DateTime date) {
  final DateTime today = DateTime.now();
  // print('Date: ${date.day}');
  if (date.year != today.year) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  } else if (date.month != today.month ||
      _getWeekOfYear(date) != _getWeekOfYear(today)) {
    return DateFormat('dd MMM HH:mm').format(date);
  } else if (date.day != today.day) {
    return DateFormat('E HH:mm').format(date);
  }
  return DateFormat('HH:mm').format(date);
}

int _getWeekOfYear(DateTime date) {
  final int dayOfYear = int.parse(DateFormat('D').format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

String parseMeetingTime(String time) {
  return DateFormat.jm().format(DateTime.parse(time));
}

bool isSameDate(String time, DateTime d1) {
  DateTime d2 = DateTime.parse(time);
  return DateUtils.isSameDay(d1, d2);
}

///Generate a month given the start date of month as a list of list of integers
/// e.g. [[30, 1, 2, 3, 4, 5, 6], [7, 8, 9, 10, 11, 12, 13],..]. Weeks start
/// from Monday.
List<List<int>> generateMonth(DateTime firstOfMonth) {
  List<List<int>> rowValueList = [];

  //Adding the first week
  DateTime endWeek = firstOfMonth.add(Duration(days: 7 - firstOfMonth.weekday));
  DateTime startWeek = endWeek.subtract(const Duration(days: 6));
  List<int> first = [];
  for (DateTime j = startWeek;
      j.compareTo(endWeek) <= 0;
      j = j.add(const Duration(days: 1))) {
    first.add(j.day);
  }
  rowValueList.add(first);

  //Moving the counters
  int i = endWeek.day + 1;
  endWeek = endWeek.add(const Duration(days: 7));

  //Looping to add the other weeks inside the month
  while (endWeek.month == firstOfMonth.month) {
    List<int> temp = [];
    for (int j = i; j <= endWeek.day; j++) {
      temp.add(j);
    }
    rowValueList.add(temp);
    i = 1 + endWeek.day;
    endWeek = endWeek.add(const Duration(days: 7));
  }

  //Adding the last week
  if (endWeek.day < 7) {
    List<int> last = [];
    startWeek = endWeek.subtract(const Duration(days: 6));
    for (DateTime j = startWeek;
        j.compareTo(endWeek) <= 0;
        j = j.add(const Duration(days: 1))) {
      last.add(j.day);
    }
    rowValueList.add(last);
  }
  //print(rowValueList);
  return rowValueList;
}
