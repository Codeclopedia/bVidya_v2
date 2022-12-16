import '../../../../core/constants/colors.dart';
import '../../../../core/ui_core.dart';
import '../base_settings_noscroll.dart';

const colorUnSelect = Color(0xFFF5F5F5);
const colorSelect = AppColors.primaryColor;

final textStyleUnselect = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.black,
  fontSize: 10.sp,
  fontWeight: FontWeight.w500,
);

final textStyleSelect = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.white,
  fontSize: 10.sp,
  fontWeight: FontWeight.w500,
);

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => const CoursesUsersUi(),
    );
  }
}

class CoursesUsersUi extends StatefulWidget {
  const CoursesUsersUi({Key? key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<CoursesUsersUi> {
  bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return BaseNoScrollSettings(
      bodyContent: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTabs((result) {
              setState(() {
                _isSelected = result;
              });
            }),
            //_buildTeachers(),
            // _buildCourses()
          ]),
    );
  }

  Widget _buildTabs(Function(bool) onclick) {
    // print('selected :$_isSelected');
    return Container(
      margin: EdgeInsets.only(top: 3.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSelected = true;
                  _buildCourses();
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 5.5.h,
                width: 15.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w)),
                  color: _isSelected ? colorSelect : colorUnSelect,
                ),
                child: Text(
                  S.current.course_header,
                  style: _isSelected ? textStyleSelect : textStyleUnselect,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSelected = false;
                  _buildTeachers();
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 5.5.h,
                width: 15.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w)),
                  color: _isSelected ? colorUnSelect : colorSelect,
                ),
                child: Text(
                  S.current.teachers_header,
                  style: _isSelected ? textStyleUnselect : textStyleSelect,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllInstructDetail() {
    return Text(
      S.current.course_instructor_detail,
      style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTeachers() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(0.5.h),
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 7.h,
                    width: 15.1.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7.h)),
                        color: Colors.grey),
                    child: Image.asset(
                      "assets/courses/course_instr_2.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.teachers_username,
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        S.current.teachers_followers,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: kFontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildCourses() {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 10,
          padding: EdgeInsets.all(0.5.h),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Container(
                padding: EdgeInsets.all(1.h),
                height: 20.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    color: Colors.grey[300]),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          S.current.course_title,
                          style: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      height: 0.2.h,
                      width: 100.w,
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getSvgIcon('courses/course_timer.svg',
                                height: 2.h, width: 4.w),
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              child: Text(
                                S.current.course_timer,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: kFontFamily,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getSvgIcon('courses/course_play.svg',
                                height: 1.h, width: 3.w),
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              child: Text(
                                S.current.course_conti,
                                style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 10.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
