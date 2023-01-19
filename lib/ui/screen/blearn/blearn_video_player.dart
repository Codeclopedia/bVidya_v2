// import 'package:chewie/chewie.dart';
// import 'dart:async';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:video_player/video_player.dart';

import '/data/models/response/blearn/courses_response.dart';
import '/core/constants/colors.dart';
import '/core/helpers/video_helper.dart';
import '/controller/blearn_providers.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/lessons_response.dart';
import '../../screens.dart';
import 'components/common.dart';
import 'components/lesson_list_tile.dart';

final videoStateProvider = StateProvider.autoDispose<bool>((ref) => true);
final currentVideoIdProvider = StateProvider<int>(
  (ref) {
    return 0;
  },
);

// ignore: must_be_immutable
class BlearnVideoPlayer extends HookConsumerWidget {
  final Lesson lesson;
  final Course course;
  final int instructorId;

  BlearnVideoPlayer(
      {Key? key,
      required this.lesson,
      required this.course,
      required this.instructorId})
      : super(key: key);

  FlickManager? flickManager;
  PausableTimer? timer;
  AutoScrollController? controller;

  final scrollDirection = Axis.vertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      init();
//AutoScrollController for scroll to index feature
      controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection,
      );
//timer for calling watch time api after eevery 1 minute
      timer = PausableTimer(const Duration(minutes: 1), () async {
        await sendVideoPlayback(ref, instructorId);
      });
      setcontrollervalue(ref);

      return () {
        print('Disponse called');
        flickManager?.dispose();
        flickManager = null;
        timer?.cancel();
      };

      // return dispose();
    }, const ['KEY']);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                !ref.watch(videoStateProvider) || flickManager == null
                    ? Container(
                        width: double.infinity,
                        color: Colors.black,
                        height: 30.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              'Loading',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: kFontFamily,
                                  fontSize: 12.sp),
                            ),
                          ],
                        ),
                      )
                    : FlickVideoPlayer(flickManager: flickManager!),
                SizedBox(
                  height: 4.w,
                ),
                Consumer(builder: (context, ref, child) {
                  return ref
                      .watch(bLearnCourseDetailProvider(course.id ?? 0))
                      .when(
                          data: (data) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data?.courses?[0].name ?? '',
                                      style: TextStyle(
                                          fontFamily: kFontFamily,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  InkWell(
                                    onTap: () async {
                                      ref.watch(
                                          blearnAddorRemoveinWishlistProvider(
                                              data?.courses?[0].id ?? 0));
                                      ref.refresh(bLearnCourseDetailProvider(
                                          course.id ?? 0));
                                    },
                                    child: Container(
                                      width: 12.w,
                                      height: 12.w,
                                      decoration: BoxDecoration(
                                          color: data?.isWishlisted == true
                                              ? Colors.pink[100]
                                              : AppColors.cardWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              // offset: Offset(0, 0),
                                              // blurRadius: 1,
                                            )
                                          ]),
                                      child: data?.isWishlisted == true
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.pink[400],
                                            )
                                          : Icon(
                                              Icons.favorite_outline,
                                              size: 8.w,
                                              color: AppColors.iconGreyColor,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          error: ((error, stackTrace) =>
                              buildEmptyPlaceHolder('Error')),
                          loading: () => buildLoading);
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    '${course.numberOfLesson} Lessons | ${course.duration!} Hours',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 8.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ref
                        .watch(bLearnLessonsProvider(course.id ?? 0))
                        .when(
                            data: (data) {
                              if (data?.lessons?.isNotEmpty == true) {
                                return _buildLessons(ref, data!.lessons!);
                              } else {
                                return buildEmptyPlaceHolder('No Lessons');
                                // return _buildLessons();
                              }
                            },
                            error: (error, stackTrace) =>
                                buildEmptyPlaceHolder('text'),
                            loading: () => buildLoading);
                  },
                ),
              ],
            ),
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.adaptive.arrow_back,
                      color: AppColors.cardWhite,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildLessons(WidgetRef ref, List<Lesson> lessons) {
    final selectedIndex = ref.watch(selectedLessonIndexProvider);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
          itemCount: lessons.length,
          scrollDirection: scrollDirection,
          controller: controller,
          padding: EdgeInsets.symmetric(vertical: 3.w),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return AutoScrollTag(
              index: index,
              controller: controller!,
              key: ValueKey(key),
              child: LessonListTile(
                index: index,
                courseId: course.id ?? 0,
                instructorId: instructorId,
                onExpand: (p0) {
                  ref.read(selectedLessonIndexProvider.notifier).state = p0;
                },
                onplay: (videoUrl, videoId) {
                  showLoading(ref);
                  ref.read(videoStateProvider.notifier).state = false;

                  // await flickManager?.dispose();
                  // flickManager = null;
                  ref.read(selectedLessonIndexProvider.notifier).state = index;
                  timer?.pause();
                  flickManager?.handleChangeVideo(
                      VideoPlayerController.network(videoUrl));

                  ref.read(currentVideoIdProvider.notifier).state =
                      lesson.videoId ?? 0;
                  ref.read(videoStateProvider.notifier).state = true;
                  timer?.start();
                  hideLoading(ref);
                },
                ref: ref,
                openIndex: selectedIndex,
                lesson: lessons[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Future setcontrollervalue(WidgetRef ref) async {
    int selectedIndex = ref.read(selectedLessonIndexProvider);

    await controller?.scrollToIndex(selectedIndex,
        duration: const Duration(milliseconds: 300),
        preferPosition: AutoScrollPosition.begin);
  }

  init() {
    print('Init called');
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(lesson.videoUrl ?? ""),
    );
    flickManager?.flickVideoManager?.addListener(() {
      flickManager?.flickVideoManager?.isPlaying ?? false
          ? timer?.start()
          : timer?.pause();
    });
  }

  // dispose() {
  //   print('Disponse called');
  //   flickManager?.dispose();
  //   flickManager = null;
  // }
}

// class BlearnVideoPlayer extends HookConsumerWidget {
//   final Lesson lesson;
//   final int courseId;
//   BlearnVideoPlayer({super.key, required this.lesson, required this.courseId});

// //   @override
// //   State<BlearnVideoPlayer> createState() => _BlearnVideoPlayerState();
// // }

// // class _BlearnVideoPlayerState extends State<BlearnVideoPlayer> {
//   //controllers
//   // TargetPlatform? _platform;
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   // int? bufferDelay;

//   //videoController values

//   // @override
//   // void initState() {
//   //   super.initState();
//   // initializePlayer(); //function to initialize controllers
//   // }

//   dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//   }

//   //Value intializations
//   Future<void> initializePlayer(WidgetRef ref) async {
//     _videoPlayerController =
//         VideoPlayerController.network(lesson.videoUrl.toString());
//     // await Future.wait([
//     //   _videoPlayerController1.initialize(),
//     // ]);
//     await _videoPlayerController.initialize();
//     _createChewieController();
//     await sendVideoPlayback(lesson.id);
//     ref.read(videoStateProvider.notifier).state = true;
//     // setState(() {});
//   }

//   //chewieController
//   void _createChewieController() {
//     // final subtitles = [
//     //     Subtitle(
//     //       index: 0,
//     //       start: Duration.zero,
//     //       end: const Duration(seconds: 10),
//     //       text: 'Hello from subtitles',
//     //     ),
//     //     Subtitle(
//     //       index: 0,
//     //       start: const Duration(seconds: 10),
//     //       end: const Duration(seconds: 20),
//     //       text: 'Whats up? :)',
//     //     ),
//     //   ];
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: false,
//       looping: false,
//       progressIndicatorDelay:
//           // bufferDelay != null ? Duration(milliseconds: bufferDelay!) :
//           null,
//       additionalOptions: (context) {
//         return <OptionItem>[
//           OptionItem(
//             onTap: () {},
//             iconData: Icons.live_tv_sharp,
//             title: 'Toggle Video Src',
//           ),
//         ];
//       },
//       hideControlsTimer: const Duration(seconds: 1),
//       placeholder: Container(
//         color: Colors.white,
//       ),
//       autoInitialize: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     useEffect(() {
//       initializePlayer(ref);

//       return dispose();
//     }, const []);

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             ref.watch(videoStateProvider) ||
//                     _videoPlayerController.value.isInitialized == true
//                 ? SizedBox(
//                     height: 30.h,
//                     child: Chewie(
//                       controller: _chewieController!,
//                     ),
//                   )
//                 : SizedBox(
//                     height: 30.h,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 20),
//                         Text('Loading'),
//                       ],
//                     ),
//                   ),
//             Consumer(
//               builder: (context, ref, child) {
//                 return ref.watch(bLearnLessonsProvider(courseId)).when(
//                     data: (data) {
//                       if (data?.lessons?.isNotEmpty == true) {
//                         return _buildLessons(ref, data!.lessons!);
//                       } else {
//                         return buildEmptyPlaceHolder('No Lessons');
//                         // return _buildLessons();
//                       }
//                     },
//                     error: (error, stackTrace) => buildEmptyPlaceHolder('text'),
//                     loading: () => buildLoading);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLessons(WidgetRef ref, List<Lesson> lessons) {
//     final selectedIndex = ref.watch(selectedIndexLessonProvider);

//     return Expanded(
//       child: ListView.builder(
//         itemCount: lessons.length,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: (() async {
//               ref.read(videoStateProvider.notifier).state = false;
//               _chewieController?.pause();
//               showLoading(ref);

//               _videoPlayerController = VideoPlayerController.network(
//                   lessons[index].videoUrl.toString());
//               // await Future.wait([]);

//               await _videoPlayerController.initialize();
//               _createChewieController();
//               await sendVideoPlayback(lessons[index].id);
//               hideLoading(ref);
//               ref.read(selectedIndexLessonProvider.notifier).state = index;
//               ref.read(videoStateProvider.notifier).state = true;
//               // setState(() {
//               //
//               // });
//             }),
//             child: LessonListTile(
//               index: index,
//               openIndex: selectedIndex,
//               lesson: lessons[index],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Widget _buildLessons(WidgetRef ref, List<Lesson> lessons) {
//   //   final selectedIndex = ref.watch(selectedIndexLessonProvider);
//   //   return ListView.builder(
//   //     itemCount: lessons.length,
//   //     shrinkWrap: true,
//   //     scrollDirection: Axis.vertical,
//   //     itemBuilder: (context, index) {
//   //       return GestureDetector(
//   //         onTap: (() async {
//   // _chewieController?.pause();
//   // showLoading(ref);
//   // _videoPlayerController1 = VideoPlayerController.network(
//   //     lessons[index].videoUrl.toString());
//   // await Future.wait([
//   //   _videoPlayerController1.initialize(),
//   // ]);
//   // _createChewieController();
//   // hideLoading(ref);
//   // setState(() {
//   //   ref.read(selectedIndexLessonProvider.notifier).state = index;
//   // });
//   //         }),
//   //         child: LessonListTile(
//   //           index: index,
//   //           openIndex: selectedIndex,
//   //           lesson: lessons[index],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
// }
