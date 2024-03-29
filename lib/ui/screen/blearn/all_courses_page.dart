import '/ui/widgets.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/courses_response.dart';
import '/data/models/response/blearn/instructors_response.dart';
import '/ui/screen/blearn/components/instructor_row.dart';
import '/controller/blearn_providers.dart';
import '/core/constants/colors.dart';
import '/core/constants/route_list.dart';
import '/core/state.dart';
import '../../screens.dart';
// import '../../widget/coloured_box_bar.dart';
import '../../widget/sliding_tab.dart';
import 'components/common.dart';
import 'components/course_row.dart';

final selectedSearchTabCourseDetailProvider = StateProvider<int>((ref) => 0);

class AllCoursesPage extends StatelessWidget {
  const AllCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWilPopupScreen(
      onBack: () async => true,
      child: Scaffold(
        body: ColouredBoxBar(
          topSize: 25.h,
          topBar: _buildTopBar(context),
          body: _buildSearchBody(context),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final controller = TextEditingController(text: '');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: getSvgIcon('arrow_back.svg'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Center(
            child: SizedBox(
              width: 85.w,
              child: Consumer(
                builder: (context, ref, child) {
                  final inputText = ref.watch(inputTextProvider);
                  return TextFormField(
                    controller: controller,
                    decoration: searchInputDirectionStyle.copyWith(
                      suffixIcon: inputText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.text = "";
                                ref.read(inputTextProvider.notifier).state = "";
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.black))
                          : null,
                      hintText: 'Search Courses',
                    ),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: kFontFamily,
                      color: AppColors.inputText,
                    ),
                    onChanged: (value) {
                      ref.read(inputTextProvider.notifier).state = value;
                    },
                    onFieldSubmitted: (value) {
                      // if (value.trim().isNotEmpty) {
                      //   ref.read(searchQueryGroupProvider.notifier).state =
                      //       value.trim();
                      // } else {
                      //   ref.read(searchQueryGroupProvider.notifier).state = '';
                      // }
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildSearchBody(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            SizedBox(height: 2.h),
            SlidingTab(
              label1: 'Courses',
              label2: 'Instructors',
              selectedIndex: ref.watch(selectedSearchTabCourseDetailProvider),
              callback: (index) {
                ref.read(selectedSearchTabCourseDetailProvider.notifier).state =
                    index;
              },
            ),
            SizedBox(height: 2.h),
            ref.watch(selectedSearchTabCourseDetailProvider) == 0
                ? _buildCourseView()
                : _buildInstructorView(),
          ],
        );
      },
    );
  }

  Widget _buildCourseView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 5.w,
          right: 5.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Consumer(builder: (context, ref, child) {
                return ref
                    .watch(bLearnSearchCoursesProvider(
                        ref.watch(inputTextProvider)))
                    .when(
                        data: ((data) {
                          if (data == null) {
                            return buildEmptyPlaceHolder('No Course found');
                          }

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            shrinkWrap: true,
                            itemCount: data.courses?.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () async {
                                      Navigator.pushNamed(
                                          context, RouteList.bLearnCourseDetail,
                                          arguments: data.courses?[index]);
                                    },
                                    child: CourseRowItem(
                                      course: data.courses?[index] ?? Course(),
                                    )),
                              );
                            },
                          );
                        }),
                        error: (e, t) => buildEmptyPlaceHolder('No User found'),
                        loading: () => GridView.builder(
                              shrinkWrap: true,
                              itemCount: 20,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 0.2.w,
                                      mainAxisSpacing: 0.1.w),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: CustomizableShimmerTile(
                                      height: 50.w, width: 40.w),
                                );
                              },
                            ));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructorView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Consumer(builder: (context, ref, child) {
                // if (ref.watch(inputTextProvider) == '' ||
                //     ref.watch(inputTextProvider).isEmpty) {
                //   return Center(
                //       child: Column(
                //     children: [
                //       SizedBox(height: 50.w),
                //       getSvgIcon('professor.svg', width: 15.w),
                //       SizedBox(height: 1.w),
                //       Text(
                //         S.current.blearn_search_instructor,
                //         textAlign: TextAlign.center,
                //         style: textStyleBlack.copyWith(
                //             fontSize: 6.sp, color: AppColors.inputHintText),
                //       )
                //     ],
                //   ));
                // }
                return ref
                    .watch(bLearnSearchCoursesProvider(
                        ref.watch(inputTextProvider)))
                    .when(
                        data: ((data) {
                          if (data?.instructors?.isEmpty ?? false) {
                            return buildEmptyPlaceHolder('No Instructor found');
                          }

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                            ),
                            shrinkWrap: true,
                            itemCount: data?.instructors?.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(2.w),
                                child: InkWell(
                                    onTap: () async {
                                      Navigator.pushNamed(context,
                                          RouteList.bLearnteacherProfileDetail,
                                          arguments:
                                              data?.instructors?[index] ??
                                                  Instructor());
                                    },
                                    child: InstructorRowItem(
                                        instructor: data?.instructors?[index] ??
                                            Instructor())),
                              );
                            },
                          );
                        }),
                        error: (e, t) => buildEmptyPlaceHolder('No User found'),
                        loading: () => GridView.builder(
                              shrinkWrap: true,
                              itemCount: 20,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 0.1.w,
                                      mainAxisSpacing: 0.1.w),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(2.w),
                                  child: CustomizableShimmerTile(
                                      height: 30.w, width: 40.w),
                                );
                              },
                            ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
