import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '/core/ui_core.dart';
import '/core/helpers/extensions.dart';

class ChatImageList extends StatelessWidget {
  final ChatMessageExt message;
  final int index;

  const ChatImageList({Key? key, required this.message, this.index = 0})
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
              return AutoScrollTag(
                key: ValueKey(index),
                controller: controller,
                index: index,
                child: Image(
                    image: getImageProviderChatImage(
                        msg.body as ChatImageMessageBody,
                        loadThumbFirst: false)),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 2.w),
            itemCount: message.messages.length,
          ),
        ),
      ),
    );
  }
}
