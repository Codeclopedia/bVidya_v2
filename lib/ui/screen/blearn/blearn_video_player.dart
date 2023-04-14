// import 'package:chewie/chewie.dart';
// import 'dart:async';
import 'dart:ui';

import 'package:flutter_portal/flutter_portal.dart';
import 'package:secure_content/secure_content.dart';

import '/ui/base_back_screen.dart';
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
import 'components/common.dart';
import 'components/custom_orientation_controler.dart';
import 'components/lesson_list_tile.dart';

final videoStateProvider = StateProvider.autoDispose<bool>((ref) => true);

// ignore: must_be_immutable
class BlearnVideoPlayer extends HookConsumerWidget {
  final Lesson lesson;
  final Course course;
  final int instructorId;
  final bool isSubscribed;

  BlearnVideoPlayer(
      {Key? key,
      required this.lesson,
      required this.course,
      required this.instructorId,
      required this.isSubscribed})
      : super(key: key);

  FlickManager? flickManager;
  PausableTimer? timer;
  AutoScrollController? controller;

  final scrollDirection = Axis.vertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      init(ref);
      Map videodata = {
        "courseId": course.id,
        "videoId": ref.read(currentVideoIDProvider),
        "lessonId": ref.read(currentLessonIdProvider),
      };
      ref.read(bLearnsetCourseProgressProvider(videodata));
      //AutoScrollController for scroll to index feature
      controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection,
      );
      setcontrollervalue(ref);
      timer = PausableTimer(const Duration(minutes: 1), () async {
        timer?.reset();
        final res =
            isSubscribed ? await sendVideoPlayback(ref, instructorId) : null;
        if (res?.stop ?? true) {
          timer?.pause();
        }
      });

      return () {
        flickManager?.dispose();
        flickManager = null;
        timer?.cancel();
      };
    }, const ['KEY']);
    return Scaffold(
      body: Portal(
        child: SecureWidget(
            overlayWidgetBuilder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
            onScreenshotCaptured: () {},
            builder: (context, onInit, onDispose) {
              return SafeArea(
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
                            : FlickVideoPlayer(
                                flickVideoWithControls:
                                    const FlickVideoWithControls(
                                  controls: CustomOrientationControls(),
                                ),
                                flickManager: flickManager!,
                              ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Consumer(builder: (context, ref, child) {
                          return ref
                              .watch(bLearnCourseDetailProvider(course.id ?? 0))
                              .when(
                                  data: (data) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
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
                                              showLoading(ref);
                                              await ref
                                                  .read(
                                                      bLearnRepositoryProvider)
                                                  .changeinWishlist(
                                                      data?.courses?[0].id ??
                                                          0);

                                              // ref.watch(
                                              //     blearnAddorRemoveinWishlistProvider(
                                              //         data?.courses?[0].id ?? 0));
                                              ref.refresh(
                                                  bLearnCourseDetailProvider(
                                                      course.id ?? 0));
                                              hideLoading(ref);
                                            },
                                            child: Container(
                                              width: 12.w,
                                              height: 12.w,
                                              decoration: BoxDecoration(
                                                  color:
                                                      data?.isWishlisted == true
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
                                                      color: AppColors
                                                          .iconGreyColor,
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
                                        return _buildLessons(
                                            ref, data!.lessons!);
                                      } else {
                                        return buildEmptyPlaceHolder(
                                            'No Lessons');
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
                              color: AppColors.iconGreyColor,
                            ))),
                  ],
                ),
              );
            },
            isSecure: true),
      ),
    );
  }

  Widget _buildLessons(
    WidgetRef ref,
    List<Lesson> lessons,
  ) {
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
                isSubscribed: isSubscribed,
                instructorId: instructorId,
                onExpand: (p0) {
                  ref.read(selectedLessonIndexProvider.notifier).state = p0;
                },
                onplay: () {
                  // showLoading(ref);
                  ref.read(videoStateProvider.notifier).state = false;
                  Map updatedData = {
                    "courseId": course.id,
                    "videoId": ref.read(currentVideoIDProvider),
                    "lessonId": ref.read(currentLessonIdProvider)
                  };
                  ref.read(bLearnsetCourseProgressProvider(updatedData));
                  // await flickManager?.dispose();
                  // flickManager = null;

                  timer?.reset();
                  flickManager?.handleChangeVideo(VideoPlayerController.network(
                      ref.read(currentVideoUrlProvider)));

                  ref.read(videoStateProvider.notifier).state = true;

                  // hideLoading(ref);
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
    await controller?.scrollToIndex(ref.read(selectedLessonIndexProvider),
        duration: const Duration(milliseconds: 100),
        preferPosition: AutoScrollPosition.begin);
  }

  init(WidgetRef ref) {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          ref.read(currentVideoUrlProvider) ?? ""),
    );
    flickManager?.flickVideoManager?.addListener(() {
      flickManager?.flickVideoManager?.isBuffering ?? false
          ? print("blearn player isbuffering true")
          : print("blearn player isbuffering false");
      flickManager?.flickVideoManager?.errorInVideo ?? false
          ? print("blearn player iserror true")
          : print("blearn player iserror false");
      flickManager?.flickVideoManager?.isPlaying ?? false
          ? print("blearn player isplaying true")
          : print("blearn player isplaying false");
      flickManager?.flickVideoManager?.isVideoInitialized ?? false
          ? print("blearn player isvideoInitialized true")
          : print("blearn player isvideoInitialized false");
      flickManager?.flickVideoManager?.isVideoEnded ?? false
          ? print("blearn player isvideoEnded true")
          : print("blearn player isVideoEnded false");

      flickManager!.flickVideoManager!.isPlaying &&
              flickManager!.flickVideoManager!.isVideoInitialized &&
              flickManager!.flickVideoManager!.isBuffering == false &&
              flickManager!.flickVideoManager!.errorInVideo == false &&
              flickManager!.flickVideoManager!.isVideoEnded == false
          ? timer?.start()
          : timer?.pause();
      timer?.isActive == true
          ? print("blearn player timer active")
          : print("blearn player timer not active");
      timer?.isPaused ?? false
          ? print("blearn player timer paused")
          : print("blearn player timer not paused");
      print("blearn player timer ${timer?.elapsed}");
    });
  }
}
