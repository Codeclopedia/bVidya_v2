// ignore_for_file: use_build_context_synchronously

import '../../../../core/constants.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../widgets.dart';

class ChatInputBox extends StatefulWidget {
  final Future<String?> Function(String) onSend;

  /// Current user using the chat
  // final User currentUser;
  final Function(AttachType type) onAttach;
  const ChatInputBox({
    Key? key,
    required this.onSend,
    required this.onAttach,
  }) : super(key: key);

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox>
    with WidgetsBindingObserver {
  late TextEditingController textController;
  OverlayEntry? _overlayEntry;
  int currentMentionIndex = -1;
  String currentTrigger = '';
  late FocusNode focusNode;

  @override
  void initState() {
    textController = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _clearOverlay();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final double bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final bool isKeyboardActive = bottomInset > 0.0;
    if (!isKeyboardActive) {
      _clearOverlay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
        //
        child: Consumer(
          builder: (context, ref, child) {
            String input = ref.watch(inputTextProvider);
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3.w),
                        ),
                        color: AppColors.chatInputBackground),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        focusNode: focusNode,
                        controller: textController,
                        onChanged: (value) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            if (onMention != null) {
                              await _checkMentions(value);
                            }
                          });
                          ref.read(inputTextProvider.notifier).state =
                              value.trim();
                        },
                        maxLines: 6,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: chatInputDirectionStyle.copyWith(
                          hintText: S.current.chat_input_hint,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: InkWell(
                              // padding: EdgeInsets.all(0),
                              onTap: () {},
                              child: getSvgIcon('icon_chat_emoji.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                IconButton(
                  onPressed: () {
                    _showAttachDialog(context);
                  },
                  icon: getSvgIcon('icon_chat_attach.svg'),
                ),
                if (input.isEmpty)
                  IconButton(
                    splashColor: Colors.grey,
                    onPressed: () {},
                    icon: getSvgIcon('icon_chat_camera.svg'),
                  ),
                if (input.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      // ChatMessage.createTxtSendMessage(targetId: targetId, content: content)
                      final sent = await widget.onSend(input);
                      if (sent == null) {
                        textController.text = '';
                        input = '';
                        ref.read(inputTextProvider.notifier).state = '';
                      } else {
                        AppSnackbar.instance.error(context, sent);
                      }
                    },
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  _showAttachDialog(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AttachDialog();
      },
    );
    if (result != null && result is AttachType) {
      widget.onAttach(result);
    }
  }

  Future<List<Widget>> Function(String trigger, String value,
      void Function(String value) onMentionClick)? onMention;

  final List<String> onMentionTriggers = const <String>['@'];
  Future<void> _checkMentions(String text) async {
    bool hasMatch = false;
    for (final String trigger in onMentionTriggers) {
      final RegExp regexp = RegExp(r'(?<![^\s<>])' + trigger + r'([^\s<>]+)$');
      if (regexp.hasMatch(text)) {
        hasMatch = true;
        currentMentionIndex = textController.text.indexOf(regexp);
        currentTrigger = trigger;
        List<Widget> children = await onMention!(
          trigger,
          regexp.firstMatch(text)!.group(1)!,
          _onMentionClick,
        );
        _showMentionModal(children);
      }
    }
    if (!hasMatch) {
      _clearOverlay();
    }
  }

  void _onMentionClick(String value) {
    textController.text = textController.text.replaceRange(
      currentMentionIndex,
      textController.text.length,
      currentTrigger + value,
    );
    textController.selection = TextSelection.collapsed(
      offset: textController.text.length,
    );
    _clearOverlay();
  }

  void _clearOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    }
  }

  void _showMentionModal(List<Widget> children) {
    final OverlayState overlay = Overlay.of(context)!;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset topLeftCornerOffset = renderBox.localToGlobal(Offset.zero);

    double bottomPosition =
        MediaQuery.of(context).size.height - topLeftCornerOffset.dy;
    // if (widget.inputOptions.inputToolbarMargin != null) {
    //   bottomPosition -= widget.inputOptions.inputToolbarMargin!.top -
    //       widget.inputOptions.inputToolbarMargin!.bottom;
    // }

    _clearOverlay();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          width: renderBox.size.width,
          bottom: bottomPosition,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  bottomPosition -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 0.2, color: Theme.of(context).dividerColor),
              ),
            ),
            child: Material(
              color: Theme.of(context).selectedRowColor,
              child: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }
}
