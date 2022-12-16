import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/ui_core.dart';
import '../../core/utils/date_utils.dart';

class CalendarView extends StatefulWidget {
  final Function(DateTime) onSelectedDate;
  const CalendarView({super.key, required this.onSelectedDate});

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  /// Boolean to handle calendar expansion
  bool _expanded = false;

  /// The height of an individual week row
  late double _collapsedHeightFactor;

  /// The y coordinate of the active week row
  late double _activeRowYPosition;

  /// The date var that handles the changing months on click
  final DateTime _displayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  /// The date that is shown as Month , Year between the arrows
  late DateTime _showDate;

  late DateTime _selectedDate;

  /// The list that stores the week rows of the month
  List<Widget> _calList = [];

  /// PageController to handle the changing month views on click
  PageController pageController = PageController(initialPage: 0);

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOut);

  /// Animation controller that handles the calendar expansion event and the
  /// expand_more icon rotation event
  ///
  late AnimationController _controller;

  /// Animation controller that handles the expand_more icon fading in/out event
  /// based on if the current month is being displayed
  late AnimationController _monthController;

  /// The animation for the changing height with the y coordinates in calendar expansion
  late Animation<double> _anim;

  // late Animation<double> _visiblity;

  /// Color animation for the -> and <- arrows that change the month view
  // late Animation<Color?> _arrowColor;

  /// Animation for the rotating expand_more/less icon
  late Animation<double> _iconTurns;

  /// Color animation for the ^ arrow that handles expansion of view
  // late Animation<Color?> _monthColor;

  /// Animation duration
  static const Duration _kExpand = Duration(milliseconds: 300);

  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  // Boolean to handle what to do when calendar is expanded or contracted
  ValueChanged<bool>? onExpansionChanged;

  /// Color tween for -> and <- icons
  // final ColorTween _arrowColorTween =
  //     ColorTween(begin: Colors.white, end: Colors.white10);

  /// Color tween for expand_less icon
  // final ColorTween _monthColorTween =
  //     ColorTween(begin: const Color(0xffEC520B), end: const Color(0x00EC520B));

  @override
  void initState() {
    // calendar is not expanded initially
    _expanded = false;
    _showDate = _displayDate;
    _selectedDate = _displayDate;

    // [returnRowList] called and stored in [rowListReturned] to make use of in the next occurrences
    List<Widget> rowListReturned =
        returnRowList(DateTime(_displayDate.year, _displayDate.month, 1));

    //Determine the height of one week row
    _collapsedHeightFactor = 1 / (rowListReturned.length);

    //Determine the y coordinate of the current week row with this formula
    // _activeRowYPosition = ((1 / (rowListReturned.length)) * getActiveRow()) - 1;
    _activeRowYPosition =
        ((2 / (rowListReturned.length - 1)) * getActiveRow()) - 1;

    // print('pos: $_activeRowYPosition');
    //Initialize animation controllers
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _monthController = AnimationController(duration: _kExpand, vsync: this);
    _anim = _controller.drive(_easeInTween);
    // _visiblity = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    //initial value = false
    _expanded = PageStorage.of(context)?.readState(context) ?? false;
    if (_expanded) _controller.value = 1.0;

    //calList contains the list of week Rows of the displayed month
    _calList = [
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: rowListReturned)
    ];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildMonthNameHeader(),
        _weekRow(),
        AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) => ClipRect(
            child: Align(
              alignment: Alignment(0.5, _activeRowYPosition),
              // alignment: const Alignment(0.5, 0.5),
              heightFactor: _anim.value * (1 - _collapsedHeightFactor) +
                  _collapsedHeightFactor,
              child: SizedBox(
                width: 95.w,
                height: 35.h,
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _calList,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          splashRadius: _monthController.view.value == 0.0 ? 18.0 : 0.001,
          onPressed:
              _handleTap, //_monthController.view.value == 0.0 ? _handleTap : null,
          enableFeedback: _monthController.view.value == 0.0,
          icon: RotationTransition(
            turns: _iconTurns,
            child: const Icon(
              Icons.expand_more,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNameHeader() {
    return SizedBox(
      width: 60.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: _expanded ? 1 : 0,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                enableFeedback: _expanded,
                splashRadius: _expanded ? 15.0 : 0.001,
                icon: const Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_expanded) {
                    _onPrevMonth();
                  }
                },
              ),
            ),
          ),
          // Displayed Month, Displayed Year
          Text(
            formatDate(_showDate),
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Opacity(
            opacity: _expanded ? 1 : 0,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                enableFeedback: _expanded,
                splashRadius: _expanded ? 15.0 : 0.001,
                icon: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_expanded) {
                    _onNextMonth();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onCurrentMonth() {
    final DateTime currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _calList = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: returnRowList(
          DateTime(currentDate.year, currentDate.month, 1),
        ),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   mainAxisSize: MainAxisSize.min,
      //   children: returnRowList(
      //     DateTime(currentDate.year, currentDate.month, 1),
      //   ),
      // ),
    ];
    //Decrement the showDate by 1 month
    _showDate = DateTime(currentDate.year, currentDate.month, 1);
  }

  _onSelectedDate() {
    DateTime currentDate = _selectedDate;
    final rowListReturned = returnRowList(
      DateTime(currentDate.year, currentDate.month, 1),
    );
    _collapsedHeightFactor = 1 / (rowListReturned.length);
    _activeRowYPosition =
        ((2 / (rowListReturned.length - 1)) * getActiveRow()) - 1;

    _calList = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: returnRowList(
          DateTime(currentDate.year, currentDate.month - 1, 1),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: rowListReturned,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: returnRowList(
          DateTime(currentDate.year, currentDate.month + 1, 1),
        ),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   mainAxisSize: MainAxisSize.min,
      //   children: returnRowList(
      //     DateTime(currentDate.year, currentDate.month, 1),
      //   ),
      // ),
    ];
    //Decrement the showDate by 1 month
    _showDate = DateTime(currentDate.year, currentDate.month, 1);
    pageController.jumpToPage(1);
    // pageController.previousPage(duration: _kExpand, curve: Curves.easeInOut);
  }

  _onPrevMonth() {
    DateTime curr = _showDate;
    setState(() {
      //set calList to previous month to showDate and showDate
      _calList = [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: returnRowList(
            DateTime(_showDate.year, _showDate.month - 1, 1),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: returnRowList(
            DateTime(_showDate.year, _showDate.month, 1),
          ),
        ),
      ];
      //Decrement the showDate by 1 month
      _showDate = DateTime(_showDate.year, _showDate.month - 1, 1);
    });

    //Fade in/out the expand icon if current month is not displayed month
    if (areMonthsSame(curr, DateTime.now())) {
      _monthController.forward();
      Future.delayed(const Duration(milliseconds: 1), () {
        setState(() {});
      });
    } else if (areMonthsSame(_showDate, DateTime.now())) {
      _monthController.reverse();
      Future.delayed(_kExpand, () {
        setState(() {});
      });
    }
    pageController.jumpToPage(1);
    pageController.previousPage(duration: _kExpand, curve: Curves.easeInOut);
  }

  _onNextMonth() {
    DateTime curr = _showDate;
    setState(() {
      //set calList to showDate and showDate incremented by 1 month
      _calList = [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: returnRowList(
            DateTime(_showDate.year, _showDate.month, 1),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: returnRowList(
            DateTime(_showDate.year, _showDate.month + 1, 1),
          ),
        ),
      ];
      //Increment showDate by a month
      _showDate = DateTime(_showDate.year, _showDate.month + 1, 1);
    });

    //Fade in/out the expand icon if current month is not displayed month
    if (areMonthsSame(curr, DateTime.now())) {
      _monthController.forward();
      Future.delayed(const Duration(milliseconds: 1), () {
        setState(() {});
      });
    } else if (areMonthsSame(_showDate, DateTime.now())) {
      _monthController.reverse();
      Future.delayed(_kExpand, () {
        setState(() {});
      });
    }
    pageController.jumpToPage(0);
    pageController.nextPage(duration: _kExpand, curve: Curves.easeInOut);
  }

  //Format the received date into full month and year format
  String formatDate(DateTime date) => DateFormat("MMMM yyyy").format(date);

  // Used to handle calendar expansion and icon rotation events
  void _handleTap() {
    setState(() {
      _expanded = !_expanded;

      if (_expanded) {
        _controller.forward();
      } else {
        _onSelectedDate();
        // _onCurrentMonth();
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          // setState(() {
          // Rebuild without widget.children.
          // });
        });
      }
      PageStorage.of(context)?.writeState(context, _expanded);
    });
    if (onExpansionChanged != null) onExpansionChanged!(_expanded);
  }

  //Get the current week row from the list of all the rows per current month
  int getActiveRow() {
    // int activeRow = 0;
    // print('Date ${_selectedDate.day}');
    List<List<int>> rowValueList =
        generateMonth(DateTime(_selectedDate.year, _selectedDate.month, 1));

    int numRow = rowValueList.length;
    for (int i = 0; i < numRow; i++) {
      if (!rowValueList[i].contains(_selectedDate.day)) {
        continue;
      }
      // print('Row=> ${rowValueList[i].toList()}');
      for (int j = 0; j < rowValueList[i].length; j++) {
        bool isNotOfThisMonth = (i == 0 && rowValueList[i][j] > 7) ||
            (i >= 4 && rowValueList[i][j] < 7);
        if (rowValueList[i][j] == _selectedDate.day && (!isNotOfThisMonth)) {
          return i;
        }
      }
    }
    return 0;
  }

  //checks to ensure that the dates used to generate active row dont use prev. or next. month's dates
  bool monthChecks(int rowIndex, int date) {
    print('monthChecks=> $rowIndex - $date');
    if (rowIndex <= 1 && date <= 14) {
      return true;
    } else if (rowIndex >= 4 && date > 7) {
      return true;
    } else if (rowIndex < 4 || rowIndex > 1) {
      return true;
    } else {
      return false;
    }
  }

  Widget _weekRow() {
    return Container(
      height: 95.w * 0.7 * _collapsedHeightFactor,
      padding: EdgeInsets.only(
        bottom: 4,
        left: 4.w,
        right: 4.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          calendarWeekday('M'),
          calendarWeekday('T'),
          calendarWeekday('W'),
          calendarWeekday('T'),
          calendarWeekday('F'),
          calendarWeekday('S'),
          calendarWeekday('S'),
        ],
      ),
    );
  }

  // Returns a list of Rows containing the weeks of a month
  List<Widget> returnRowList(DateTime start) {
    List<Widget> rowList = <Widget>[];
    List<List<int>> rowValueList = generateMonth(start);
    for (int i = 0; i < rowValueList.length; i++) {
      List<Widget> weekDates = [];
      for (int j = 0; j < rowValueList[i].length; j++) {
        //Grey out the previous month's and next month's values or dates
        bool isNotOfThisMonth = (i == 0 && rowValueList[i][j] > 7) ||
            (i >= 4 && rowValueList[i][j] < 7);

        bool isCurrentDate = !isNotOfThisMonth &&
            (rowValueList[i][j] == DateTime.now().day &&
                start.month == DateTime.now().month &&
                start.year == DateTime.now().year);

        bool isSelectedDate = !isNotOfThisMonth &&
            (rowValueList[i][j] == _selectedDate.day &&
                start.month == _selectedDate.month &&
                start.year == _selectedDate.year);

        // print(
        //     'Selected $isSelectedDate -  ${_selectedDate.toString()} -  $isNotOfThisMonth');
        // if (isSelectedDate) {
        //   print('Selected  ${_selectedDate.toString()}');
        // }

        weekDates.add(
          Expanded(
            child: GestureDetector(
              onTap: isNotOfThisMonth
                  ? null
                  : () {
                      setState(() {
                        _selectedDate = DateTime(
                            start.year, start.month, rowValueList[i][j]);
                        _onSelectedDate();
                        widget.onSelectedDate(_selectedDate);
                        // print('Updated  ${_selectedDate.toString()}');
                      });
                    },
              child: Container(
                height: 9.w,
                width: 9.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrentDate
                        ? AppColors.yellowAccent
                        : (isSelectedDate ? Colors.grey : Colors.transparent)),
                child: Center(
                  child: Text(
                    rowValueList[i][j].toString(),
                    style: isCurrentDate || isSelectedDate
                        ? TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                            color: isCurrentDate
                                ? AppColors.primaryColor
                                : AppColors.redBColor)
                        : TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp,
                            color:
                                isNotOfThisMonth ? Colors.grey : Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      Widget weekRow = Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 6, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: weekDates,
        ),
      );
      rowList.add(weekRow);
    }
    return rowList;
  }

  //Return a Text with Style according to input String, used for the days
  Widget calendarWeekday(String day) {
    return Text(
      day,
      style: TextStyle(
          fontFamily: kFontFamily, fontSize: 9.sp, color: Colors.white),
    );
  }

  // Utility functions to compare Dates:
  bool areDaysSame(DateTime a, DateTime b) {
    return areMonthsSame(a, b) && a.day == b.day;
  }

  bool areMonthsSame(DateTime a, DateTime b) {
    return areYearsSame(a, b) && a.month == b.month;
  }

  bool areYearsSame(DateTime a, DateTime b) {
    return a.year == b.year;
  }
}
