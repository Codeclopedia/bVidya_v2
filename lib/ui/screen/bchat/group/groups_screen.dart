import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/sdk_helpers/bchat_handler.dart';
import '/ui/screen/blearn/components/common.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/controller/providers/contacts_select_notifier.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

// import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../../widgets.dart';

// class GroupsScreen extends StatelessWidget {
//   const GroupsScreen({Key? key}) : super(key: key);

// class GroupsScreen extends ConsumerStatefulWidget {
//   const GroupsScreen({Key? key}) : super(key: key);

//   @override
//   GroupsScreenState createState() => GroupsScreenState();
// }

// class GroupsScreenState extends ConsumerState<GroupsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // "ref" can be used in all life-cycles of a StatefulWidget.
//     ref.read(groupConversationProvider.notifier).init();
//   }

class GroupsScreen extends HookConsumerWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(groupConversationProvider.notifier).reset(ref);
      registerForNewMessage('group_screens', (msgs) {
        for (var lastMessage in msgs) {
          if (lastMessage.conversationId != null &&
              lastMessage.chatType == ChatType.GroupChat) {
            ref
                .read(groupConversationProvider.notifier)
                .updateConversationMessage(
                    lastMessage, lastMessage.conversationId!,
                    update: true);
          }
        }
      });
      return () {
        unregisterForNewMessage('group_screens');
      };
    }, []);
    // final grpProvider = ref.watch(groupConversationProvider);
    return Scaffold(
      body: ColouredBoxBar(
          topBar: _buildTopBar(context, ref),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(height: 2.h),
              _buttons(context),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                child: ref.watch(groupLoadingStateProvider)
                    ? const Center(child: CircularProgressIndicator())
                    : _buildList(ref.watch(groupConversationProvider), ref),
              ))
            ],
          )),
    );
  }

  Widget _buildList(
      List<GroupConversationModel> conversationList, WidgetRef ref) {
    return conversationList.isEmpty
        ? buildEmptyPlaceHolder('No Groups')
        : ListView.separated(
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, RouteList.groupInfo,
                        arguments: conversationList[index]);
                    setScreen(RouteList.groups);
                  },
                  child: _buildConversationItem(
                      context, conversationList[index], ref),
                ),
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                ),
            itemCount: conversationList.length);
  }

  Widget _buildConversationItem(
      BuildContext context, GroupConversationModel model, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.groupChatScreen,
            arguments: model);
        setScreen(RouteList.groups);
        ref
            .read(groupConversationProvider.notifier)
            .updateConversationOnly(model.id);
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

  Widget _conversationRow(GroupConversationModel model) {
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
          getCicleAvatar(model.groupInfo.name ?? '', model.image),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.groupInfo.name ?? '',
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
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
              onTap: () async {
                await Navigator.pushNamed(context, RouteList.searchGroups);
                ref.read(groupConversationProvider.notifier).update();
              },
              child: Container(
                padding: EdgeInsets.all(0.7.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
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
    return Consumer(builder: (context, ref, child) {
      return InkWell(
        splashColor: AppColors.primaryColor,
        onTap: () async {
          ref.read(selectedContactProvider.notifier).clear();
          final result =
              await Navigator.pushNamed(context, RouteList.newGroupContacts);
          setScreen(RouteList.groups);
          if (result != null && result is ChatGroup) {
            ref.read(groupConversationProvider.notifier).addConveration(result);
          }
          ref.read(groupConversationProvider.notifier).update();
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
    });
  }

  Widget _recentCallButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.groupCalls);
        setScreen(RouteList.groups);
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
