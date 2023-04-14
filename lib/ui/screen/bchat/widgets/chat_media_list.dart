import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/state.dart';
import 'package:bvidya/core/utils/save_locally.dart';
import 'package:bvidya/ui/screens.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '/core/constants.dart';
import '/core/ui_core.dart';
import '/core/helpers/extensions.dart';

class ChatMediaList extends StatelessWidget {
  final ChatMessageExt message;
  final int index;

  const ChatMediaList({Key? key, required this.message, this.index = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AutoScrollController(
      //add this for advanced viewport boundary. e.g. SafeArea
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      //choose vertical/horizontal
      axis: Axis.vertical,
    );
    controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView.separated(
            controller: controller,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final msg = message.messages[index];
              return Consumer(builder: (context, ref, child) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: msg.body.type == MessageType.VIDEO
                      ? Center(
                          child: SizedBox(
                            width: 200.w,
                            height: 100.w,
                            child: Stack(
                              children: [
                                Image(
                                  image: getImageProviderChatVideo(
                                    msg.body as ChatVideoMessageBody,
                                  ),
                                  fit: BoxFit.cover,
                                  height: 100.w,
                                  width: 200.w,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, RouteList.bViewVideo,
                                            arguments: msg.body
                                                as ChatVideoMessageBody);
                                      },
                                      icon: Icon(
                                        Icons.play_circle_rounded,
                                        color: Colors.white,
                                        size: 10.w,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                      onPressed: () async {
                                        showLoading(ref);
                                        final body =
                                            msg.body as ChatVideoMessageBody;
                                        await saveFile(
                                            ref,
                                            body.displayName ?? "",
                                            body.remotePath ?? "",
                                            message.msg.body.type);
                                        hideLoading(ref);
                                      },
                                      icon: Icon(
                                        Icons.downloading,
                                        color: Colors.white,
                                        size: 8.w,
                                        shadows: <Shadow>[
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1.w)
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            final body = msg.body as ChatImageMessageBody;
                            showImageViewer(
                                context,
                                ondownloadPressed: () {
                                  saveFile(ref, body.displayName ?? "",
                                      body.remotePath ?? "", body.type);
                                },
                                getImageProviderChatImage(body,
                                    loadThumbFirst: false),
                                onViewerDismissed: () {
                                  // print("dismissed");
                                });
                          },
                          child: Image(
                              image: getImageProviderChatImage(
                                  msg.body as ChatImageMessageBody,
                                  loadThumbFirst: false)),
                        ),
                );
              });
            },
            separatorBuilder: (context, index) => SizedBox(height: 2.w),
            itemCount: message.messages.length,
          ),
        ),
      ),
    );
  }
}
