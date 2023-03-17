import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/constants/colors.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '/controller/bchat_providers.dart';
// import '/core/constants/colors.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/ui/widgets.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

// import '../../widget/shimmer_tile.dart';
import '../blearn/components/common.dart';
// import 'widgets/chat_image_body.dart';

final selectedMediaIndexProvider = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);

class ChatMediaGalleryScreen extends StatelessWidget {
  final Contacts contact;
  // final String title;
  const ChatMediaGalleryScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColouredBoxBar(
      topBar: BAppBar(
        title: '${contact.name}\'s Media Files',
        // title: S.current.title_ViewAll,
      ),
      body: Consumer(builder: (context, ref, child) {
        return ref.watch(chatImageFiles(contact.userId.toString())).when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                      child: buildEmptyPlaceHolder('No media shared.'));
                }
                return Column(
                  children: [
                    SizedBox(
                      height: 3.w,
                    ),
                    CustomSlidingSegmentedControl<int>(
                      initialValue: 1,
                      fixedWidth: 22.5.w,
                      children: {
                        1: Text(
                          'Images',
                          style: textStyleBlack.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.w500),
                        ),
                        2: Text(
                          'Videos',
                          style: textStyleBlack.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.w500),
                        ),
                        3: Text(
                          'Audios',
                          style: textStyleBlack.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.w500),
                        ),
                        4: Text(
                          'Docs',
                          style: textStyleBlack.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.w500),
                        ),
                      },
                      decoration: BoxDecoration(
                        color: CupertinoColors.lightBackgroundGray,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: Offset(
                              0.0,
                              0.8.w,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInToLinear,
                      onValueChanged: (v) {
                        ref.read(selectedMediaIndexProvider.notifier).state =
                            v - 1;
                      },
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    mediabody(ref.watch(selectedMediaIndexProvider), data)
                    // customizedTabbarWidget(ref)
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 7.w),
                    //   child: GridView.builder(
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2,
                    //         mainAxisSpacing: 3.w,
                    //         crossAxisSpacing: 2.w,
                    //         childAspectRatio: 0.8),
                    //     shrinkWrap: true,
                    //     itemCount: data.length,
                    //     cacheExtent: 100.w,
                    //     padding: EdgeInsets.symmetric(vertical: 5.w),
                    //     itemBuilder: (context, index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           final list = data
                    //               .map((e) => getImageProviderChatImage(e.body,
                    //                   loadThumbFirst: false))
                    //               .toList();
                    //           MultiImageProvider multiImageProvider =
                    //               MultiImageProvider(list, initialIndex: index);
                    //           showImageViewerPager(context, multiImageProvider,
                    //               onPageChanged: (page) {},
                    //               onViewerDismissed: (page) {});
                    //         },
                    //         child: chatImageBody(
                    //           data[index],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  buildEmptyPlaceHolder(S.current.error),
              loading: () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return CustomizableShimmerTile(height: 40.w, width: 40.w);
                },
              ),
            );
      }),
    ));
  }

  Widget mediabody(int selectedTabIndex, List<ChatMediaFile> data) {
    late Widget widget;
    switch (selectedTabIndex) {
      case 0:
        List<ChatMediaFile> images = [];
        for (var element in data) {
          if (element.type == MessageType.IMAGE) {
            images.add(element);
          }
        }
        if (images.isEmpty) {
          widget = Center(
            child: buildEmptyPlaceHolder('No Image shared'),
          );
        } else {
          widget = Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.w,
                    ),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 10,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: InkWell(
                                onTap: () {
                                  final list = images
                                      .map((e) => getImageProviderChatImage(
                                          e.body as ChatImageMessageBody,
                                          loadThumbFirst: false))
                                      .toList();
                                  MultiImageProvider multiImageProvider =
                                      MultiImageProvider(list,
                                          initialIndex: index);
                                  // final body = data[index].body;
                                  showImageViewerPager(
                                      context, multiImageProvider,
                                      onPageChanged: (page) {
                                    print("page changed to $page");
                                  }, onViewerDismissed: (page) {
                                    print("dismissed while on page $page");
                                  });
                                },
                                child: chatImageBody(images[index])),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          );
        }

        break;
      case 1:
        List<ChatMediaFile> videos = [];
        for (var element in data) {
          if (element.type == MessageType.VIDEO) {
            videos.add(element);
          }
        }
        if (videos.isEmpty) {
          widget = Center(
            child: buildEmptyPlaceHolder('No Video shared'),
          );
        } else {
          widget = Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: videos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.w,
                    ),
                    itemBuilder: (context, index) {
                      final body = videos[index].body as ChatVideoMessageBody;
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 10,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: _videoOnly(body),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          );
        }
        break;
      case 2:
        List<ChatMediaFile> audios = [];
        for (var element in data) {
          if (element.type == MessageType.VOICE) {
            audios.add(element);
          }
        }
        if (audios.isEmpty) {
          widget = Center(
            child: buildEmptyPlaceHolder('No Audio shared'),
          );
        } else {
          widget = Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: audios.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.w,
                    ),
                    itemBuilder: (context, index) {
                      final body = audios[index].body as ChatVoiceMessageBody;
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 10,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Column(
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.w),
                                      color: AppColors.primaryColor),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.w, horizontal: 3.w),
                                  child: getSvgIcon('Icon metro-file-audio.svg',
                                      fit: BoxFit.contain,
                                      width: 15.w,
                                      color: AppColors.cardBackground),
                                ),
                                SizedBox(height: 1.w),
                                Expanded(
                                  child: Text(
                                    body.displayName ?? "",
                                    style:
                                        textStyleBlack.copyWith(fontSize: 4.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          );
        }
        break;
      case 3:
        List<ChatMediaFile> documents = [];
        for (var element in data) {
          if (element.type == MessageType.FILE) {
            documents.add(element);
          }
        }
        if (documents.isEmpty) {
          widget = Center(
            child: buildEmptyPlaceHolder('No Documents shared'),
          );
        } else {
          widget = Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.w,
                    ),
                    itemBuilder: (context, index) {
                      final body = documents[index].body as ChatFileMessageBody;
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 10,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Column(
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.w),
                                      color: AppColors.primaryColor),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.w, horizontal: 3.w),
                                  child: getSvgIcon('icon_file_doc.svg',
                                      fit: BoxFit.contain,
                                      width: 10.w,
                                      color: AppColors.cardBackground),
                                ),
                                SizedBox(height: 1.w),
                                Expanded(
                                  child: Text(
                                    body.displayName ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        textStyleBlack.copyWith(fontSize: 6.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          );
        }
        break;
    }
    return widget;
  }

  Widget _videoOnly(ChatVideoMessageBody body) {
    // final bool isOwnMessage = message.from == currentUser.id;
    return Container(
      constraints: BoxConstraints(
        minWidth: 30.w,
        maxWidth: 60.w,
        minHeight: 5.h,
        maxHeight: 30.h,
      ),
      margin: EdgeInsets.only(left: 2.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            child: Image(
              image: getImageProviderChatVideo(body),
            ),
          ),
          // Positioned(
          //   right: 2.w,
          //   bottom: 1.h,
          //   child: _buildTime(message.msg),
          // ),
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
            ),
          ),
          // if (progress > 0)
          //   Positioned(
          //     bottom: 0,
          //     right: 0,
          //     left: 0,
          //     top: 0,
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         value: progress.toDouble(),
          //         backgroundColor: Colors.transparent,
          //         color: AppColors.primaryColor,
          //       ),
          //     ),
          //   )
          // // Center(child: CircularProgressIndicator(value: progress.toDouble()))
        ],
      ),
    );
  }

  Widget customizedTabbarWidget(WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              ref.read(selectedMediaIndexProvider.notifier).state = 0;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
              decoration: BoxDecoration(
                  color: ref.watch(selectedMediaIndexProvider) == 0
                      ? Colors.transparent
                      : AppColors.primaryColor,
                  boxShadow: ref.watch(selectedMediaIndexProvider) == 0
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1.w,
                          ),
                        ],
                  border: Border.all(
                    color: ref.watch(selectedMediaIndexProvider) == 0
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(2.w)),
              child: Text(
                "IMAGES",
                style: textStyleBlack.copyWith(
                  color: ref.watch(selectedMediaIndexProvider) == 0
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(selectedMediaIndexProvider.notifier).state = 1;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
              decoration: BoxDecoration(
                  color: ref.watch(selectedMediaIndexProvider) == 1
                      ? Colors.transparent
                      : AppColors.primaryColor,
                  boxShadow: ref.watch(selectedMediaIndexProvider) == 1
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1.w,
                          ),
                        ],
                  border: Border.all(
                    color: ref.watch(selectedMediaIndexProvider) == 1
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(2.w)),
              child: Text(
                "Videos",
                style: textStyleBlack.copyWith(
                  color: ref.watch(selectedMediaIndexProvider) == 1
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(selectedMediaIndexProvider.notifier).state = 2;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
              decoration: BoxDecoration(
                  color: ref.watch(selectedMediaIndexProvider) == 2
                      ? Colors.transparent
                      : AppColors.primaryColor,
                  boxShadow: ref.watch(selectedMediaIndexProvider) == 2
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1.w,
                          ),
                        ],
                  border: Border.all(
                    color: ref.watch(selectedMediaIndexProvider) == 2
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(2.w)),
              child: Text(
                "Audios",
                style: textStyleBlack.copyWith(
                  color: ref.watch(selectedMediaIndexProvider) == 2
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(selectedMediaIndexProvider.notifier).state = 3;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
              decoration: BoxDecoration(
                  color: ref.watch(selectedMediaIndexProvider) == 3
                      ? Colors.transparent
                      : AppColors.primaryColor,
                  boxShadow: ref.watch(selectedMediaIndexProvider) == 3
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1.w,
                          ),
                        ],
                  border: Border.all(
                    color: ref.watch(selectedMediaIndexProvider) == 3
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(2.w)),
              child: Text(
                "Docs",
                style: textStyleBlack.copyWith(
                  color: ref.watch(selectedMediaIndexProvider) == 3
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatImageBody(
    ChatMediaFile file,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4.w)),
      child: Image(
        image: getImageProviderChatImage(file.body as ChatImageMessageBody),
        fit: BoxFit.cover,
      ),
    );
  }
}
