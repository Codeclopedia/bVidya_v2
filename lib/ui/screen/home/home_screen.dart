// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:intl/intl.dart';
import '../../../core/helpers/bchat_handler.dart';
import '../blearn/components/common.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../dialog/conversation_menu_dialog.dart';
import '../../widget/base_drawer_appbar_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(bChatSDKControllerProvider).loadChats(ref);
      // _loadConversations(ref);
      // getContacts();
      _addHandler(ref);
      return _disposeAll;
    }, const []);
    return BaseDrawerAppBarScreen(
      routeName: RouteList.home,
      topBar: _userAppBar(context),
      body: _chatListScreen(context),
    );
  }

  void _addHandler(WidgetRef ref) {
    registerForContact('home_screen_contact', ref);
    try {
      ChatClient.getInstance.chatManager.addEventHandler(
        'home_screen_chat',
        ChatEventHandler(
          onMessagesReceived: (msgs) {
            ref.read(bChatSDKControllerProvider).reloadConversation(ref);
          },
        ),
      );
    } on ChatError catch (e) {
      debugPrint('Error ${e.code} - ${e.description}');
    }
    // try {
    //   ChatClient.getInstance.presenceManager.addEventHandler(
    //     "user_presence_home_screen",
    //     ChatPresenceEventHandler(
    //       onPresenceStatusChanged: (list) {
    //         ref.read(chatConversationListProvider.notifier).updateStatus(list);
    //       },
    //     ),
    //   );
    // } catch (_) {}
  }

  void onMessagesReceived(List<ChatMessage> messages, WidgetRef ref) {
    // for (var msg in messages) {
    //  print('msg: ${msg.from}');
    // ref.read(chatMessageListProvider.notifier).addChat(msg);
    // }
    if (messages.isNotEmpty) {
      ref.read(bChatSDKControllerProvider).reloadConversation(ref);
      // _loadConversations(ref);
    }
  }

  void _disposeAll() {
    unregisterForContact('home_screen_contact');
    try {
      ChatClient.getInstance.chatManager.removeEventHandler('home_screen_chat');
    } catch (e) {
      debugPrint('Error $e');
    }
    //
    // _signOut();
  }

  // Future _signOutAsync() async {
  //   try {
  //     await ChatClient.getInstance.logout(true);
  //     print("sign out succeed");
  //   } on ChatError catch (e) {
  //     print("sign out failed, code: ${e.code}, desc: ${e.description}");
  //   }
  // }

  _chatListScreen(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowFirst(context),
          _rowSecond(context),
          SizedBox(height: 1.h),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final loading = ref.watch(loadingChatProvider);

                final conversationList =
                    ref.watch(chatConversationListProvider);

                // print('conversationList:${conversationList.length}');
                return loading && conversationList.isEmpty
                    ? buildLoading
                    : ListView.separated(
                        shrinkWrap: false,
                        itemCount: conversationList.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          );
                        },
                        itemBuilder: (context, index) {
                          final model = conversationList[index];
                          return _buildConversationItem(context, model, ref);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(
      BuildContext context, ConversationModel model, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.chatScreen,
            arguments: model);
        await Future.delayed(const Duration(seconds: 1)); //delay to reset state
        ref.read(bChatSDKControllerProvider).reloadOnlyConversation(ref, model);
      },
      onLongPress: (() {
        showDialog(
          context: context,
          useSafeArea: true,
          builder: (context) {
            return Dialog(
              // insetPadding: EdgeInsets.only(left: 6.w, top: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: ConversationMenuDialog(model: model),
            );
          },
        );
      }),
      child: _contactRow(model),
    );
  }

  Widget _contactRow(ConversationModel model) {
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
    // final online = model.isOnline?.statusDescription ?? ' Unknown';

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCicleAvatar(model.contact.name, model.contact.profileImage),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.contact.name,
                  style: TextStyle(
                    fontWeight: model.badgeCount > 0
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontSize: 12.sp,
                  ),
                ),
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
                model.lastMessage == null
                    ? ''
                    : DateFormat('h:mm a')
                        .format(DateTime.fromMillisecondsSinceEpoch(
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

  Widget _rowFirst(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBText('Chat', chat: true),
        _recentCallButton(context),
      ],
    );
  }

  Widget _rowSecond(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _newMessageButton(context),
        TextButton(
            onPressed: () async {
              Navigator.pushNamed(context, RouteList.groups);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const DashChatScreen(),
              //     ));
              // final result =
              //     await Navigator.pushNamed(context, RouteList.contactProfile);
              // if (result != null) {
              //   print('Return value $result');
              // }
            },
            child: Text(
              S.current.home_btx_groups,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }

  Widget _newMessageButton(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return InkWell(
        splashColor: AppColors.primaryColor,
        onTap: () async {
          final model =
              await Navigator.pushNamed(context, RouteList.contactList);
          if (model != null) {
            ref.read(bChatSDKControllerProvider).reloadConversation(ref);

            // ref
            //     .read(bChatSDKControllerProvider)
            //     .reloadConversation(ref,reloadContacts: true);
            // Navigator.pushNamed(context, RouteList.chatScreen,
            //     arguments: model);
          }

          // _loadConversations(ref);
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
            SizedBox(
              width: 2.w,
            ),
            Text(
              S.current.home_btx_new_message,
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
          SizedBox(
            width: 1.w,
          ),
          CircleAvatar(
            backgroundColor: AppColors.yellowAccent,
            radius: 4.2.w,
            child: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildBChatText() {
  //   return RichText(
  //       text: TextSpan(children: [
  //     TextSpan(
  //         text: 'b',
  //         style: TextStyle(
  //           fontFamily: kFontFamily,
  //           color: AppColors.redBColor,
  //           fontSize: 14.sp,
  //           fontWeight: FontWeight.bold,
  //         )),
  //     TextSpan(
  //         text: 'chat',
  //         style: TextStyle(
  //           fontFamily: kFontFamily,
  //           color: AppColors.darkChatColor,
  //           fontSize: 14.sp,
  //           fontWeight: FontWeight.bold,
  //         )),
  //   ]));
  // }

  Widget _userAppBar(BuildContext context) {
    return SizedBox(
      height: 12.h,
      child: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(loginRepositoryProvider).user;
          if (user == null) return const SizedBox.shrink();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 7.w),
              InkWell(
                onTap: () {
                  if (user.role == 'teacher' || user.role == 'admin') {
                    Navigator.pushNamed(context, RouteList.teacherProfile);
                  } else {
                    Navigator.pushNamed(context, RouteList.studentProfile);
                  }
                },
                // onTap: (() => Navigator.pushNamed(
                //     context, RouteList.contactProfile,
                //     arguments: user)),
                child: getRectFAvatar(user.name, user.image),
              ),
              SizedBox(
                width: 3.w,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.home_welcome,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.yellowAccent,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, RouteList.search);
                  if (result == true) {
                    ref.read(bChatSDKControllerProvider).loadConversations(ref);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(1.w),
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
              SizedBox(width: 5.w),
              // IconButton(
              //   onPressed: () async {
              //     // await _signOutAsync();
              //     // Navigator.pop(context);
              //     final pref = await SharedPreferences.getInstance();
              //     await pref.clear();
              //     Navigator.pushReplacementNamed(context, RouteList.login);
              //   },
              //   icon: const Icon(Icons.logout, color: Colors.white),
              // )
            ],
          );
        },
      ),
    );
  }
}
