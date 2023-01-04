// import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '/core/helpers/video_helper.dart';
import '/controller/blearn_providers.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/blearn/lessons_response.dart';
import '../../screens.dart';
import 'components/common.dart';
import 'components/lesson_list_tile.dart';

final videoStateProvider = StateProvider<bool>((ref) => false);

class BlearnVideoPlayer extends HookConsumerWidget {
  final Lesson lesson;
  final int courseId;

  BlearnVideoPlayer({Key? key, required this.lesson, required this.courseId})
      : super(key: key);

  FlickManager? flickManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      init(ref);

      return () {
        print('Disponse called');
        flickManager?.dispose();
        flickManager = null;
      };

      // return dispose();
    }, const ['KEY']);
    return Scaffold(
      body: SafeArea(
        child: Column(
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
            Consumer(
              builder: (context, ref, child) {
                return ref.watch(bLearnLessonsProvider(courseId)).when(
                    data: (data) {
                      if (data?.lessons?.isNotEmpty == true) {
                        return _buildLessons(ref, data!.lessons!);
                      } else {
                        return buildEmptyPlaceHolder('No Lessons');
                        // return _buildLessons();
                      }
                    },
                    error: (error, stackTrace) => buildEmptyPlaceHolder('text'),
                    loading: () => buildLoading);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessons(WidgetRef ref, List<Lesson> lessons) {
    final selectedIndex = ref.watch(selectedIndexLessonProvider);

    return Expanded(
      child: ListView.builder(
        itemCount: lessons.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              ref.read(videoStateProvider.notifier).state = false;
              await flickManager?.dispose();
              flickManager = null;
              ref.read(selectedIndexLessonProvider.notifier).state = index;
              flickManager = FlickManager(
                videoPlayerController:
                    VideoPlayerController.network(lessons[index].videoUrl),
              );
              // _chewieController?.pause();
              // showLoading(ref);
              // _videoPlayerController = VideoPlayerController.network(
              //     lessons[index].videoUrl.toString());
              // // await Future.wait([]);

              // await _videoPlayerController.initialize();
              // _createChewieController();
              await sendVideoPlayback(lessons[index].id);
              // hideLoading(ref);

              ref.read(videoStateProvider.notifier).state = true;
            },
            child: LessonListTile(
              index: index,
              openIndex: selectedIndex,
              lesson: lessons[index],
            ),
          );
        },
      ),
    );
  }

  init(WidgetRef ref) {
    print('Init called');
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(lesson.videoUrl),
    );
  }

  dispose() {
    print('Disponse called');
    flickManager?.dispose();
    flickManager = null;
  }
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
