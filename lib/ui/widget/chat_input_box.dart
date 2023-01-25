// ignore_for_file: use_build_context_synchronously

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' as foundation;

import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../widgets.dart';

final emojiVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final textInputStateProvider = StateProvider.autoDispose<bool>((ref) => false);

class ChatInputBox extends ConsumerStatefulWidget {
  final Future<String?> Function(String) onSend;

  /// Current user using the chat
  // final User currentUser;
  final Function(AttachType type)? onAttach;
  final Function()? onCamera;
  final Function()? onTextChange;
  const ChatInputBox(
      {Key? key,
      required this.onSend,
      this.onAttach,
      this.onCamera,
      this.onTextChange})
      : super(key: key);

  @override
  ConsumerState<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends ConsumerState<ChatInputBox>
    with WidgetsBindingObserver {
  late TextEditingController _textController;
  late FocusNode focusNode;
  // late Config config;
  // double _keyboardHeight = 0.0;

  @override
  void initState() {
    _textController = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        ref.read(emojiVisibleProvider.notifier).state = false;
      }
      // else {
      // _clearOverlay();
      // }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final double bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final bool isKeyboardActive = bottomInset > 0.0;
    if (!isKeyboardActive) {
      // _clearOverlay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    // _clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmptyInput = ref.watch(textInputStateProvider);

    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
            child: Row(
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
                        controller: _textController,
                        onChanged: (value) {
                          // WidgetsBinding.instance
                          //     .addPostFrameCallback((_) async {
                          // if (onMention != null) {
                          //   await _checkMentions(value);
                          // }
                          // });
                          _textUpdated();
                          // ref.read(textInputStateProvider.notifier).state =
                          //     value.trim().isEmpty;
                          // if (widget.onTextChange != null) {
                          //   widget.onTextChange!();
                          // }
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
                              onTap: () {
                                bool visible = ref.read(emojiVisibleProvider);
                                if (visible) {
                                  focusNode.requestFocus();
                                } else {
                                  focusNode.unfocus();
                                }
                                ref.read(emojiVisibleProvider.notifier).state =
                                    !visible;
                              },
                              child: ref.watch(emojiVisibleProvider)
                                  ? const Icon(Icons.keyboard_alt_outlined)
                                  : getSvgIcon('icon_chat_emoji.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 1.w),
                Visibility(
                  visible: widget.onAttach != null,
                  child: IconButton(
                    onPressed: () async {
                      _showAttachDialog(context);
                    },
                    icon: getSvgIcon('icon_chat_attach.svg'),
                  ),
                ),
                if (isEmptyInput && widget.onCamera != null)
                  IconButton(
                    splashColor: Colors.grey,
                    onPressed: () {
                      widget.onCamera!();
                    },
                    icon: getSvgIcon('icon_chat_camera.svg'),
                  ),
                if (!isEmptyInput)
                  InkWell(
                    onTap: () async {
                      // ChatMessage.createTxtSendMessage(targetId: targetId, content: content)
                      final sent =
                          await widget.onSend(_textController.text.trim());
                      if (sent == null) {
                        _textController.text = '';
                        ref.read(textInputStateProvider.notifier).state = true;
                        // input = '';
                        // ref.read(inputTextProvider.notifier).state = '';
                      } else {
                        AppSnackbar.instance.error(context, sent);
                      }
                    },
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Offstage(
              offstage: !ref.watch(emojiVisibleProvider),
              child: SizedBox(
                height: 30.h,
                child: EmojiPicker(
                  onBackspacePressed: () {
                    _textUpdated();
                  },
                  onEmojiSelected: (category, emoji) {
                    _textUpdated();
                  },
                  textEditingController: _textController,
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: AppColors.primaryColor,
                    iconColor: Colors.grey,
                    iconColorSelected: AppColors.primaryColor,
                    backspaceColor: AppColors.primaryColor,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ), // Needs to be const Widget
                    loadingIndicator:
                        const SizedBox.shrink(), // Needs to be const Widget
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _textUpdated() {
    ref.read(textInputStateProvider.notifier).state =
        _textController.text.trim().isEmpty;
    if (widget.onTextChange != null) {
      widget.onTextChange!();
    }
  }

  Future<bool> handleStorage() async {
    final status = await Permission.storage.request();
    debugPrint(status.name);
    return status == PermissionStatus.granted;
  }

  _showAttachDialog(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AttachDialog();
      },
    );
    if (result != null && result is AttachType && widget.onAttach != null) {
      widget.onAttach!(result);
    }
  }

// OverlayEntry? _overlayEntry;
//   int currentMentionIndex = -1;
//   String currentTrigger = '';

//   Future<List<Widget>> Function(String trigger, String value,
//       void Function(String value) onMentionClick)? onMention;

//   final List<String> onMentionTriggers = const <String>['@'];

//   Future<void> _checkMentions(String text) async {
//     bool hasMatch = false;
//     for (final String trigger in onMentionTriggers) {
//       final RegExp regexp = RegExp(r'(?<![^\s<>])' + trigger + r'([^\s<>]+)$');
//       if (regexp.hasMatch(text)) {
//         hasMatch = true;
//         currentMentionIndex = _textController.text.indexOf(regexp);
//         currentTrigger = trigger;
//         List<Widget> children = await onMention!(
//           trigger,
//           regexp.firstMatch(text)!.group(1)!,
//           _onMentionClick,
//         );
//         _showMentionModal(children);
//       }
//     }
//     if (!hasMatch) {
//       _clearOverlay();
//     }
//   }

//   void _onMentionClick(String value) {
//     _textController.text = _textController.text.replaceRange(
//       currentMentionIndex,
//       _textController.text.length,
//       currentTrigger + value,
//     );
//     _textController.selection = TextSelection.collapsed(
//       offset: _textController.text.length,
//     );
//     _clearOverlay();
//   }

//   void _clearOverlay() {
//     if (_overlayEntry != null && _overlayEntry!.mounted) {
//       _overlayEntry?.remove();
//       _overlayEntry?.dispose();
//     }
//   }

//   void _showMentionModal(List<Widget> children) {
//     final OverlayState overlay = Overlay.of(context)!;
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Offset topLeftCornerOffset = renderBox.localToGlobal(Offset.zero);

//     double bottomPosition =
//         MediaQuery.of(context).size.height - topLeftCornerOffset.dy;
//     // if (widget.inputOptions.inputToolbarMargin != null) {
//     //   bottomPosition -= widget.inputOptions.inputToolbarMargin!.top -
//     //       widget.inputOptions.inputToolbarMargin!.bottom;
//     // }

//     _clearOverlay();

//     _overlayEntry = OverlayEntry(
//       builder: (BuildContext context) {
//         return Positioned(
//           width: renderBox.size.width,
//           bottom: bottomPosition,
//           child: Container(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height -
//                   bottomPosition -
//                   MediaQuery.of(context).padding.top -
//                   kToolbarHeight,
//             ),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(
//                     width: 0.2, color: Theme.of(context).dividerColor),
//               ),
//             ),
//             child: Material(
//               color: Theme.of(context).selectedRowColor,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: children,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     overlay.insert(_overlayEntry!);
//   }
}
