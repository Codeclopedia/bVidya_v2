import '/core/ui_core.dart';

class SlideTab extends StatefulWidget {
  final List<String> texts;

  final void Function(int index) onSelect;

  ///Container height
  final double containerHeight;

  ///Container width
  final double containerWidth;

  final double containerBorderRadius;

  final double sliderBorderRadius;

  ///Container fill color
  final Color containerColor;
  final Color sliderColor;

  ///Indents between the container and the sliders (the same on all sides)
  final double indents;

  ///Defining the direction of the slider swipe
  final Axis direction;

  ///A shadow cast by a box
  // final List<BoxShadow> containerBoxShadow;

  ///Ability to tap on the current slider and change its index to the opposite (available only for 2 children)
  final bool isAllContainerTap;

  ///Initial index of the slider, which is rendering for the first time
  final int initialIndex;

  final TextStyle activeTextStyle;
  final TextStyle inactiveTextStyle;

  ///A class for creating sliders
  const SlideTab({
    Key? key,
    required this.texts,
    required this.containerHeight,
    required this.containerWidth,
    required this.onSelect,
    required this.activeTextStyle,
    required this.inactiveTextStyle,
    required this.sliderColor,

    // this.slidersBorder = const Border(),
    this.indents = 0,
    // this.slidersColors = const [AppColors.primaryColor],
    // this.slidersGradients = const [],
    this.containerColor = Colors.white,
    this.containerBorderRadius = 20,
    this.sliderBorderRadius = 20,
    this.direction = Axis.horizontal,
    // this.containerBoxShadow = const [],
    this.isAllContainerTap = false,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _SlideTabState createState() => _SlideTabState();
}

class _SlideTabState extends State<SlideTab>
    with SingleTickerProviderStateMixin {
  // late final double sliderBorderRadius;
  late final double slidersHeight;
  late final double slidersWidth;
  late final double containerBorderWight;
  late final bool verticalBadSize;
  late final bool horizontalBadSize;
  late final EdgeInsets padding;
  late final EdgeInsets sliderPadding;
  late int index;
  int lastIndex = -1;

  late final AnimationController _controller;
  // late Animation _colorTween;

  // late Animation _selectedColorTween;
  //  = AnimationController(
  //   duration: const Duration(milliseconds: 250),
  //   vsync: this,
  // );
  late Animation<Offset> offsetAnimation;

  // = Tween<Offset>(
  //   begin: Offset(widget.initialIndex.toDouble(), 0.0),
  //   end: widget.direction == Axis.horizontal
  //       ? const Offset(1.0, 0.0)
  //       : const Offset(0.0, 1.0),
  // ).animate(
  //   CurvedAnimation(
  //     parent: _controller,
  //     curve: Curves.linear,
  //   ),
  // );

  @override
  void initState() {
    verticalBadSize = widget.direction == Axis.vertical &&
        widget.containerHeight < widget.containerWidth * widget.texts.length;

    horizontalBadSize = widget.direction == Axis.horizontal &&
        widget.containerHeight * widget.texts.length > widget.containerWidth;

    double containerBorderHeight = 2.w;
    // widget.containerBorder.top.width + widget.containerBorder.bottom.width;

    double containerBorderWidth = 2.w;
    // widget.containerBorder.left.width + widget.containerBorder.right.width;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    // _colorTween =
    //     ColorTween(begin: Colors.white, end: Colors.black).animate(_controller);

    // _selectedColorTween =
    //     ColorTween(begin: Colors.white, end: Colors.black).animate(_controller);
    offsetAnimation = Tween<Offset>(
      begin: Offset(widget.initialIndex.toDouble(), 0.0),
      end: widget.direction == Axis.horizontal
          ? const Offset(1.0, 0.0)
          : const Offset(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // sliderBorderRadius =
    //     (widget.containerHeight - widget.indents - containerBorderWight) *
    //         (widget.containerBorderRadius / widget.containerHeight);
    // sliderBorderRadius = widget.containerBorderRadius;
    if (widget.direction == Axis.horizontal) {
      slidersHeight =
          widget.containerHeight - widget.indents * 2 - containerBorderHeight;
      padding = EdgeInsets.symmetric(horizontal: widget.indents);
      sliderPadding = EdgeInsets.symmetric(horizontal: widget.indents + 2.w);
      slidersWidth =
          (widget.containerWidth - widget.indents * 2 - containerBorderWidth) /
              widget.texts.length;
    } else {
      slidersWidth =
          widget.containerWidth - widget.indents * 2 - containerBorderWidth;
      padding = EdgeInsets.symmetric(vertical: widget.indents);
      sliderPadding = EdgeInsets.symmetric(vertical: widget.indents + 2.w);
      slidersHeight = (widget.containerHeight -
              widget.indents * 2 -
              containerBorderHeight) /
          widget.texts.length;
    }
    index = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lastIndex == -1) _checkForExceptions();
    return Container(
      height: widget.texts.isEmpty ? 0 : widget.containerHeight,
      width: widget.texts.isEmpty ? 0 : widget.containerWidth,
      decoration: BoxDecoration(
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(widget.containerBorderRadius),
        // border: widget.containerBorder,
        // boxShadow: widget.containerBoxShadow,
      ),
      child: Stack(
        alignment: widget.direction == Axis.horizontal
            ? Alignment.centerLeft
            : Alignment.topCenter,
        children: [
          Padding(
            padding: sliderPadding,
            child: SlideTransition(
              position: offsetAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: slidersHeight,
                width: slidersWidth,
                decoration: BoxDecoration(
                  borderRadius: _makingBorder(index),
                  color: widget.sliderColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: Flex(
              direction: widget.direction,
              children: List.generate(
                widget.texts.length,
                (slidersIndex) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _slidersOnTap(
                      widget.isAllContainerTap && widget.texts.length == 2
                          ? 1 - index
                          : slidersIndex,
                    );
                  },
                  onHorizontalDragEnd: widget.direction == Axis.horizontal
                      ? (details) {
                          _slidersOnSwipe(details);
                        }
                      : null,
                  onVerticalDragEnd: widget.direction == Axis.vertical
                      ? (details) {
                          _slidersOnSwipe(details);
                        }
                      : null,
                  child: SizedBox(
                    height: slidersHeight,
                    width: slidersWidth,
                    child: Center(
                      child: Text(widget.texts[slidersIndex],
                          style: slidersIndex == index
                              ? widget.activeTextStyle
                              : widget.inactiveTextStyle),
                      // child: AnimatedBuilder(
                      //     animation: index == slidersIndex
                      //         ? _selectedColorTween
                      //         : _colorTween,
                      //     builder: (context, child) {
                      //       return Text(
                      //         widget.texts[slidersIndex],
                      //         style: TextStyle(
                      //           fontSize: 9.sp,
                      //           fontWeight: FontWeight.w600,
                      //           fontFamily: kFontFamily,
                      //           color: index == slidersIndex
                      //               ? _selectedColorTween.value
                      //               : _colorTween.value,
                      //         ),
                      //         // style: slidersIndex == index
                      //         //     ? widget.activeTextStyle
                      //         //     : widget.inactiveTextStyle
                      //       );
                      //     }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius _makingBorder(int index) {
    return BorderRadius.only(
      bottomLeft: index == 0 && verticalBadSize ||
              index == widget.texts.length - 1 && horizontalBadSize
          ? Radius.zero
          : Radius.circular(widget.sliderBorderRadius),
      bottomRight: index == 0 && (verticalBadSize || horizontalBadSize)
          ? Radius.zero
          : Radius.circular(widget.sliderBorderRadius),
      topLeft: index == widget.texts.length - 1 && verticalBadSize ||
              index == widget.texts.length - 1 && horizontalBadSize
          ? Radius.zero
          : Radius.circular(widget.sliderBorderRadius),
      topRight: index == widget.texts.length - 1 && verticalBadSize ||
              index == 0 && horizontalBadSize
          ? Radius.zero
          : Radius.circular(widget.sliderBorderRadius),
    );
  }

  void _slidersOnTap(int slidersIndex) {
    lastIndex = index;
    setState(() {
      index = slidersIndex;
      widget.onSelect(index);
    });

    if (widget.texts.length == 2) {
      slidersIndex == 1 ? _controller.forward() : _controller.reverse();
    } else {
      // if (widget.direction == Axis.horizontal) {
      //   offsetAnimation = Tween<Offset>(
      //     begin: Offset(lastIndex.toDouble(), 0.0),
      //     end: Offset(slidersIndex.toDouble(), 0.0),
      //   ).animate(
      //     CurvedAnimation(
      //       parent: _controller,
      //       curve: Curves.linear,
      //     ),
      //   );
      // } else {
      //   offsetAnimation = Tween<Offset>(
      //     begin: Offset(0.0, lastIndex.toDouble()),
      //     end: Offset(0.0, slidersIndex.toDouble()),
      //   ).animate(
      //     CurvedAnimation(
      //       parent: _controller,
      //       curve: Curves.linear,
      //     ),
      //   );
      // }
      // _controller.reset();
      // _controller.forward();
    }
  }

  void _slidersOnSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0 && index != widget.texts.length - 1) {
      _slidersOnTap(index + 1);
    }
    if (details.primaryVelocity! < 0 && index != 0) {
      _slidersOnTap(index - 1);
    }
  }

  void _checkForExceptions() {
    if (widget.isAllContainerTap && widget.texts.length != 2) {
      debugPrint(
          '\x1B[31mThe "isAllContainerTap" parameter can be "true" only when "children" length is 2\nRemove "isAllContainerTap" or make 2 "children"\x1B[0m');
      throw 'The "isAllContainerTap" parameter can be "true" only when "children" length is 2\nRemove "isAllContainerTap" or make 2 "children"';
    }

    double shortSide = widget.containerHeight > widget.containerWidth
        ? widget.containerWidth
        : widget.containerHeight;
    double longSide = widget.containerHeight > widget.containerWidth
        ? widget.containerHeight
        : widget.containerWidth;
    if (shortSide * widget.texts.length * 0.5 > longSide &&
        widget.containerBorderRadius * 2 > shortSide &&
        widget.texts.length != 2) {
      debugPrint(
          '\x1B[31mAll widgets from the list of "children" do not fit into the given container size.\nTry applying other container sizes\x1B[0m');
      throw 'All widgets from the list of "children" do not fit into the given container size.\nTry applying other container sizes';
    }
    lastIndex = 0;
  }
}
