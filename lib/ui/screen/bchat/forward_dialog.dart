import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:grouped_list/grouped_list.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/ui/screen/blearn/components/common.dart';
import '/core/ui_core.dart';

Future showForwardList(
    BuildContext context, ChatMessage message) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ForwardContactListDialog(message: message),
      );
    },
  );
}

class ForwardContactListDialog extends StatelessWidget {
  final ChatMessage message;

  const ForwardContactListDialog({Key? key, required this.message})
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
                        return ref.watch(forwardListProvider).when(
                            data: (data) {
                              if (data.isNotEmpty) {
                                return GroupedListView(
                                  elements: data,
                                  groupBy: (element) => element.chatType.name,
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        groupByValue,
                                        style: TextStyle(
                                          fontFamily: kFontFamily,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Expanded(
                                        child: Container(
                                          height: 0.5,
                                          width: double.infinity,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (context, element) {
                                    return _buildRow(element);
                                  },
                                  itemComparator: (item1, item2) => item1.name
                                      .compareTo(item2.name), // optional
                                  useStickyGroupSeparators: false, // optional
                                  floatingHeader: false, // optional
                                  order: GroupedListOrder.ASC, // optional
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

  Widget _buildRow(ForwardModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
            onTap: () {
              _sendMessage(model);
            },
            child: CircleAvatar(
              radius: 6.w,
              backgroundColor: AppColors.yellowAccent,
              child: getSvgIcon(
                'icon_chat_forward.svg',
                width: 5.w,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius:
          //           BorderRadius.circular(3.w),
          //     ),
          //     foregroundColor:
          //         AppColors.primaryColor,
          //     backgroundColor:
          //         AppColors.yellowAccent,
          //   ),
          //   onPressed: () {},
          //   child: getSvgIcon(
          //     'icon_chat_forward.svg',
          //     width: 5.w,
          //     color: AppColors.primaryColor,
          //   ),
          //   // child: Text('Send'),
          // )
        ],
      ),
    );
  }

  _sendMessage(ForwardModel model) async {
    try {
      ChatMessage msg = ChatMessage.createSendMessage(
          body: message.body, to: model.id, chatType: model.chatType);
      final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
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
