import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:grouped_list/grouped_list.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/ui/screen/blearn/components/common.dart';
import '/core/ui_core.dart';

final forwardedProvider =
    StateProvider.family.autoDispose<bool, String>((ref, id) => false);

Future showForwardList(
    BuildContext context, ChatMessage message, String exceptId) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ForwardContactListDialog(message: message, exceptId: exceptId),
      );
    },
  );
}

class ForwardContactListDialog extends StatelessWidget {
  final ChatMessage message;
  final String exceptId;

  const ForwardContactListDialog(
      {Key? key, required this.message, required this.exceptId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.001),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.remove,
                    color: Colors.grey[600],
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ref.watch(forwardListProvider(exceptId)).when(
                            data: (data) {
                              if (data.isNotEmpty) {
                                return GroupedListView<ForwardModel, ChatType>(
                                  controller: controller,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  elements: data,
                                  sort: false,
                                  groupBy: (element) => element.chatType,
                                  groupSeparatorBuilder: (ChatType type) =>
                                      _header(type),

                                  indexedItemBuilder:
                                      (context, element, index) {
                                    return _buildRow(
                                        element,
                                        ref.watch(
                                            forwardedProvider(element.id)), () {
                                      _sendMessage(element);
                                      ref
                                          .read(forwardedProvider(element.id)
                                              .notifier)
                                          .state = true;
                                    }, last: index == data.length - 1);
                                  },
                                  // itemComparator: (item1, item2) => item1.name
                                  //     .compareTo(item2.name), // optional
                                  useStickyGroupSeparators: false, // optional
                                  floatingHeader: false, // optional
                                  // order: GroupedListOrder.ASC, // optional
                                  // ),
                                );

                                // return ListView.separated(
                                //   separatorBuilder: (context, index) =>
                                //       const Divider(
                                //     height: 1,
                                //     color: Color(0xFFDBDBDB),
                                //   ),
                                //   controller: controller,
                                //   itemCount: data.length,
                                //   itemBuilder: (_, index) {
                                //     final model = data[index];
                                //     return _buildRow(model);
                                //   },
                                // );

                                // _buildList(context, ref, data);
                              } else {
                                return buildEmptyPlaceHolder('No Contacts');
                              }
                            },
                            error: (error, t) =>
                                buildEmptyPlaceHolder('No Contacts'),
                            loading: () => buildLoading);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(ChatType type) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          type == ChatType.Chat
              ? S.current.search_contact_ppl
              : S.current.home_btx_groups,
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Divider(
            height: 1,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(ForwardModel model, bool sent, Function() onSend,
      {bool last = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Row(
            children: [
              getCicleAvatar(radius: 5.w, model.name, model.image),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.black,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              InkWell(
                onTap: sent
                    ? null
                    : () {
                        onSend();
                      },
                child: CircleAvatar(
                  radius: 6.w,
                  backgroundColor: sent ? Colors.grey : AppColors.yellowAccent,
                  child: getSvgIcon(
                    'icon_chat_forward.svg',
                    width: 5.w,
                    color: sent ? Colors.black : AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(
            height: 1,
            color: Color(0xFFDBDBDB),
          )
      ],
    );
  }

  _sendMessage(ForwardModel model) async {
    try {
      ChatMessage msg = ChatMessage.createSendMessage(
          body: message.body, to: model.id, chatType: model.chatType);
      final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
      print('Forwarding msg: $msg');
      return chat;
    } on ChatError catch (e) {
      debugPrint('error in sening chat: $e');
    } catch (e) {
      debugPrint('other error in deleting chat: $e');
    }
  }

  // _sendGroupMessage(ChatGroup group) async {
  //   try {
  //     ChatMessage msg = ChatMessage.createSendMessage(
  //       body: message.body,
  //       to: group.groupId,
  //       chatType: ChatType.GroupChat,
  //     );
  //     final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
  //     return chat;
  //   } on ChatError catch (e) {
  //     debugPrint('error in sening chat: $e');
  //   } catch (e) {
  //     debugPrint('other error in deleting chat: $e');
  //   }
  // }
}
