import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import 'package:grouped_list/grouped_list.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/ui/screen/blearn/components/common.dart';
import '/core/ui_core.dart';

final forwardedBMeetProvider =
    StateProvider.family.autoDispose<bool, String>((ref, id) => false);

Future showBmeetForwardList(
    BuildContext context, String content, String exceptId) async {
  final User? user = await getMeAsUser();
  if (user == null) return;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ForwardContactListBmeetDialog(
            content: content, exceptId: exceptId, user: user),
      );
    },
  );
}

class ForwardContactListBmeetDialog extends StatelessWidget {
  final String content;
  final String exceptId;

  final User user;
  const ForwardContactListBmeetDialog(
      {Key? key,
      required this.content,
      required this.exceptId,
      required this.user})
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
                                            forwardedBMeetProvider(element.id)),
                                        () async {
                                      bool sent =
                                          (await _sendMessage(element)) != null;
                                      // for (var message in messages) {
                                      //   final msg = await _sendMessage(
                                      //       element, message);
                                      //   if (msg != null) {
                                      //     sent = true;
                                      //   } else {
                                      //     break;
                                      //   }
                                      // }
                                      // final sent = await _sendMessage(element);
                                      if (sent) {
                                        ref
                                            .read(forwardedBMeetProvider(
                                                    element.id)
                                                .notifier)
                                            .state = true;
                                      }
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
              getCicleAvatar(
                  radius: 5.w,
                  model.name,
                  model.image,
                  cacheWidth: (75.w * devicePixelRatio).round(),
                  cacheHeight: (75.w * devicePixelRatio).round()),
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

  Future<ChatMessage?> _sendMessage(ForwardModel model) async {
    try {
      ChatMessage msg = ChatMessage.createTxtSendMessage(
          content: content, targetId: model.id, chatType: model.chatType);

      if (model.chatType == ChatType.GroupChat) {
        msg.attributes = {
          "em_apns_ext": {
            'type': 'group_chat',
            "em_push_title": "${user.name} sent you a message in ${model.name}",
            "em_push_content": content,
          },
        };

        // final gName = message.attributes?['from_name'] ?? 'Group';
        // if (msg.body.type == MessageType.TXT) {

        // } else {
        //   msg.attributes = {
        //     "em_apns_ext": {
        //       'type': 'group_chat',
        //       "em_push_title": "${user.name} sent you a message in $gName",
        //       "em_push_content": 'A New ${msg.body.type.name}',
        //       // 'name': user.name,
        //       // 'image': model.image,
        //       // 'group_name': model.name,
        //       // 'content_type': msg.body.type.name,
        //     },
        //   };
        // }
        msg.attributes?.addAll({'from_name': user.name});
        msg.attributes?.addAll({'from_image': user.image});
      } else if (model.chatType == ChatType.Chat) {
        msg.attributes = {
          "em_apns_ext": {
            'type': 'chat',
            "em_push_title": "${user.name} sent you a message",
            "em_push_content": content,
            // 'name': user.name,
            // 'content': ((message.body as ChatTextMessageBody).content),
            // 'image': user.image,
            // 'content_type': msg.body.type.name,
          },
        };
      }

      msg.attributes?.addAll({"em_force_notification": true});
      final chat = await ChatClient.getInstance.chatManager.sendMessage(msg);
      // print('Forwarded msg:${message.msgId}=> ${chat.msgId}');
      return chat;
    } on ChatError catch (e) {
      debugPrint('error in sening chat: $e');
    } catch (e) {
      debugPrint('other error in deleting chat: $e');
    }
    return null;
  }
}
