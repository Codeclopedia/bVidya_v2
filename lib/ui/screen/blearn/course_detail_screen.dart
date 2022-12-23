import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widgets.dart';
import 'components/common.dart';
import 'components/lesson_list_row.dart';

// int _selectedIndex = -1;

final selectedTabCourseDetailProvider = StateProvider<int>((ref) => 0);
final selectedIndexLessonProvider = StateProvider<int>((ref) => 0);

class CourseDetailScreen extends ConsumerWidget {
  final Course courses;
  const CourseDetailScreen({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(selectedTabCourseDetailProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _topImage(context),
            _subjectDetail(),
            _buildTab(ref, selectedIndex),
            // _toggleItems(),
            selectedIndex == 0 ? _buildDescView() : _builCurriculumView()
          ],
        ),
      ),
    );
  }

  Widget _builCurriculumView() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8 Lessons | 8 Hours',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 8.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return ref
                    .watch(bLearnLessonsProvider(courses.id.toString()))
                    .when(
                        data: (data) {
                          if (data != null) {
                            return _buildLessons(ref);
                          } else {
                            return buildEmptyPlaceHolder('text');
                            // return _buildLessons();
                          }
                        },
                        error: (error, stackTrace) =>
                            buildEmptyPlaceHolder('text'),
                        loading: () => buildLoading);
              },
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildLessons(WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexLessonProvider);
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return LessonListRow(
          index: index + 1,
          openIndex: selectedIndex,
          onExpand: (selected) {
            ref.read(selectedIndexLessonProvider.notifier).state = selected;
          },
        );
      },
    );
  }

  Widget _buildDescView() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem(
                          'Duration:', ' ${courses.duration}', Icons.history),
                      Container(
                        height: 0.5,
                        color: const Color(0xFFDBDBDB),
                      ),
                      _buildDetailItem('Lectures:',
                          ' ${courses.numberOfLesson}', Icons.description),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem(
                          'Level:', ' ${courses.level}', Icons.sort),
                      Container(
                        height: 0.5,
                        color: const Color(0xFFDBDBDB),
                      ),
                      _buildDetailItem(
                          '', 'Full lifetime Access ', Icons.hourglass_bottom),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Description',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 1.h),
            _getText(),
            SizedBox(height: 1.h),
            const TwoColorText(
              first: 'Related',
              second: 'Courses',
            ),
          ],
        ),
      ),
    ));
  }

  Widget _getText() {
    return Text(courses.description);
  }

  Widget _buildGridView() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 20,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 1.w,
            childAspectRatio: 0.85),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteList.bLearnCoursesList);
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(width: 18.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    width: 45.w,
                    height: 45.w,
                    child: Image(
                        image: getImageProvider(
                            'assets/images/dummy_profile.png')),
                  ),
                  Text(
                    'Subject Name',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.black,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(WidgetRef ref, int selectedIndex) {
    // return Consumer(
    //   builder: (context, ref, child) {
    //     int selectedIndex = ref.watch(selectedTabCourseDetailProvider);
    return Center(
      child: SlideTab(
          initialIndex: selectedIndex,
          containerWidth: 80.w,
          onSelect: (index) {
            ref.read(selectedTabCourseDetailProvider.notifier).state = index;
          },
          containerHeight: 6.h,
          sliderColor: AppColors.primaryColor,
          containerBorderRadius: 2.5.w,
          sliderBorderRadius: 2.6.w,
          containerColor: AppColors.cardWhite,
          activeTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            fontFamily: kFontFamily,
          ),
          inactiveTextStyle: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w400,
            fontFamily: kFontFamily,
            color: Colors.black,
          ),
          texts: const [
            'Description',
            'Curriculum',
          ]),
    );
    //   },
    // );
  }

  // Widget _toggleItems() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 6.w),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Expanded(
  //             child: InkWell(
  //           onTap: (() {
  //             setState(() {
  //               _selectedDesc = true;
  //             });
  //           }),
  //           child: Container(
  //             padding: EdgeInsets.all(3.w),
  //             decoration: BoxDecoration(
  //               color: _selectedDesc
  //                   ? AppColors.primaryColor
  //                   : AppColors.cardWhite,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(3.w),
  //                 bottomLeft: Radius.circular(3.w),
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 'Description',
  //                 style: _selectedDesc ? textStyleSelect : textStyleUnselect,
  //               ),
  //             ),
  //           ),
  //         )),
  //         Expanded(
  //           child: InkWell(
  //             onTap: (() {
  //               setState(() {
  //                 _selectedDesc = false;
  //               });
  //             }),
  //             child: Container(
  //               padding: EdgeInsets.all(3.w),
  //               decoration: BoxDecoration(
  //                 color: !_selectedDesc ? colorSelect : colorUnSelect,
  //                 borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(3.w),
  //                   bottomRight: Radius.circular(3.w),
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   'Curriculum',
  //                   style: !_selectedDesc ? textStyleSelect : textStyleUnselect,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
      // color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: title,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 8.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
            ),
          ),
          Icon(icon, color: AppColors.primaryColor)
          // getSvgIcon(icon, width: 23.0, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _subjectDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  courses.name,
                  style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        // offset: Offset(0, 0),
                        // blurRadius: 1,
                      )
                    ]),
                child: Icon(
                  Icons.favorite_outline,
                  size: 8.w,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIntructor(),
              const Spacer(),
              _buildMeta('Launguage', courses.language, 'icon_language.svg'),
              const Spacer(),
              _buildMeta('Category', courses.categoryId.toString(),
                  'icon_category.svg'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIntructor() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCicleAvatar(courses.instructorName, courses.instructorImage,
            radius: 4.w),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 6.sp,
                color: Colors.black,
              ),
            ),
            Text(
              courses.instructorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMeta(String title, String value, String icon) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getSvgIcon(icon),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 6.sp,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 7.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _topImage(BuildContext context) {
    // final providerFallback = getImageProvider('assets/images/banner_image.png');
    return Stack(
      children: [
        SizedBox(
          width: 95.w,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
              child: Image(
                image: getImageProvider(courses.image),
                fit: BoxFit.fitWidth,
              )),
        ),
        Positioned(
          top: 1.h,
          left: 3.w,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: getSvgIcon('arrow_back.svg'),
          ),
        )
      ],
    );
  }
}
