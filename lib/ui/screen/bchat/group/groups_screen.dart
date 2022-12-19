import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

import '../../../../controller/bchat_providers.dart';
import '../../../../core/constants.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../../data/models/models.dart';
import '../../../widgets.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
          topBar: _buildTopBar(context),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(height: 2.h),
              _buttons(context),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                child: Consumer(
                  builder: (context, ref, child) {
                    final conversationList =
                        ref.watch(groupChatConversationListProvider);
                    print('group conversation List:${conversationList.length}');

                    return ListView.separated(
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteList.groupInfo,
                                    arguments: GroupModel('Office Group', ''));
                              },
                              child: _buildConversationItem(
                                  context, conversationList[index], ref),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                            ),
                        itemCount: conversationList.length);
                  },
                ),
              ))
            ],
          )),
    );
  }

  Widget _buildConversationItem(
      BuildContext context, GroupModel model, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.groupChatScreen,
            arguments: model);
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); //delay to reset state
        // ref.invalidate(chatConversationListProvider);
        ref.read(bChatRepositoryProvider).loadConversations();
      },
      // onLongPress: (() {
      //   showDialog(
      //     context: context,
      //     useSafeArea: true,
      //     builder: (context) {
      //       // return Dialog(
      //       //   // insetPadding: EdgeInsets.only(left: 6.w, top: 2.h),
      //       //   shape: RoundedRectangleBorder(
      //       //     borderRadius: BorderRadius.circular(3.w),
      //       //   ),
      //       //   // child: ConversationMenuDialog(model: model),
      //       // );
      //     },
      //   );
      // }),
      child: _conversationRow(model),
    );
  }

  Widget _conversationRow(GroupModel model) {
    final colorTimeBadge = model.badgeCount > 0
        ? AppColors.contactBadgeUnreadTextColor
        : AppColors.contactBadgeReadTextColor;
    String textMessage = '';
    if (model.lastMessage != null) {
      textMessage =
          model.lastMessage!.body.type.name.toLowerCase(); //!=MessageType.TXT
      if (model.lastMessage!.body.type == MessageType.TXT) {
        final body = model.lastMessage!.body as ChatTextMessageBody;
        textMessage = body.content;
      }
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getCicleAvatar(model.name, model.image),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: model.badgeCount > 0
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontSize: 12.sp,
                  ),
                ),
                // if (textMessage.isNotEmpty)
                Text(
                  textMessage,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontWeight: model.badgeCount > 0
                        ? FontWeight.w500
                        : FontWeight.w200,
                    color: model.badgeCount > 0 ? AppColors.black : Colors.grey,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                DateFormat('h:mm a')
                    .format(model.lastMessage == null
                        ? DateTime.now()
                        : DateTime.fromMillisecondsSinceEpoch(
                            model.lastMessage!.serverTime))
                    .toUpperCase(),
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: colorTimeBadge,
                  fontSize: 9.sp,
                ),
              ),
              SizedBox(height: 1.h),
              model.badgeCount > 0
                  ? CircleAvatar(
                      radius: 3.w,
                      backgroundColor: AppColors.contactBadgeUnreadTextColor,
                      child: Text(
                        model.badgeCount.toString(),
                        style: TextStyle(
                          fontFamily: kFontFamily,
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h, top: 2.h, right: 4.w),
        child: Row(
          children: [
            IconButton(
              onPressed: (() => Navigator.pop(context)),
              icon: getSvgIcon('arrow_back.svg'),
            ),
            const Expanded(child: UserTopBar()),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(0.7.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2.w)),
                  color: AppColors.yellowAccent,
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 3.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _newGroupButton(context),
          _recentCallButton(context),
        ],
      ),
    );
  }

  Widget _newGroupButton(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primaryColor,
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.newGroupContacts);
      },
      child: Row(
        children: [
          DottedBorder(
            // radius: Radius.circular(3.5.w),
            borderType: BorderType.Circle,
            dashPattern: const [10, 4],
            strokeWidth: 3.0,
            color: AppColors.newMessageBorderColor,
            child: SizedBox(
              width: 7.w,
              height: 7.w,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            S.current.home_btx_new_group,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 10.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentCallButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteList.recentCalls);
      },
      child: Row(
        children: [
          Text(
            S.current.home_btx_recent_calls,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 10.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 1.w),
          CircleAvatar(
            backgroundColor: AppColors.yellowAccent,
            radius: 4.2.w,
            child: const Icon(Icons.call, color: Colors.white),
          )
        ],
      ),
    );
  }
}
