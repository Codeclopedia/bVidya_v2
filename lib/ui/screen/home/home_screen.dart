// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dotted_border/dotted_border.dart';

import '/core/utils/notification_controller.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/core/utils.dart';
import '/controller/providers/user_auth_provider.dart';
import '/core/utils/date_utils.dart';

import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/helpers/call_helper.dart';
import '/data/models/call_message_body.dart';
import '/controller/bchat_providers.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/core/sdk_helpers/bchat_handler.dart';
import '../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '/ui/dialog/conversation_menu_dialog.dart';
import '/ui/widget/base_drawer_appbar_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool direct;
  const HomeScreen({Key? key, this.direct = false}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    // ref.read(groupConversationProvider.notifier).init();
    handleInit();

    _addHandler(ref);
  }

  handleInit() async {
    //initialized
    if (widget.direct || !BChatSDKController.instance.isInitialized) {
      final user = await getMeAsUser();
      if (user == null) {
        ref.read(userAuthChangeProvider.notifier).logout();
        return;
      }
      //
      await BChatSDKController.instance.initChatSDK(user);
      if (!ref.read(chatConversationProvider.notifier).initialized) {
        print('setting up again');
        await ref
            .read(chatConversationProvider.notifier)
            .setup(ref.read(bChatProvider), user, update: true);
        await ref.read(groupConversationProvider.notifier).setup();
        await ref.read(callListProvider.notifier).setup();
      } else {
        ref
            .read(chatConversationProvider.notifier)
            .reset(ref.read(bChatProvider));
      }
    } else {
      print('reseting chat only');
      ref
          .read(chatConversationProvider.notifier)
          .reset(ref.read(bChatProvider));
    }

    if (await NotificationController.isAllowedPermission()) {
      return;
    }
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      NotificationController.displayNotificationRationale();
    }
  }

  @override
  void dispose() {
    _disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDrawerAppBarScreen(
      currentIndex: DrawerMenu.bChat,
      routeName: RouteList.home,
      topBar: _userAppBar(context),
      body: _chatListScreen(context),
    );
  }

  void _addHandler(WidgetRef ref) {
    registerForContact('home_screen_contact', ref);
    registerForNewMessage('home_screen_chat', (msgs) {
      for (var lastMessage in msgs) {
        // print(
        //     'message ${lastMessage.conversationId} - ${lastMessage.chatType}');
        if (lastMessage.conversationId != null) {
          if (lastMessage.chatType == ChatType.Chat) {
            ref
                .read(chatConversationProvider.notifier)
                .updateConversationMessage(lastMessage, update: true);
          } else if (lastMessage.chatType == ChatType.GroupChat) {
            ref
                .read(groupConversationProvider.notifier)
                .updateConversationMessage(
                    lastMessage, lastMessage.conversationId!,
                    update: false);
          }
        }
      }
    });
  }

  void _disposeAll() {
    unregisterForContact('home_screen_contact');
    unregisterForNewMessage('home_screen_chat');
  }

  Widget _chatListScreen(BuildContext context) {
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
                final provider = ref.watch(chatConversationProvider);
                final loading = provider.isLoading;

                // ref.watch(chatConversationProvider
                //     .select((value) => value.isLoading));

                final conversationList = provider.chatConversationList;

                // ref.watch(chatConversationProvider
                //     .select((value) => value.chatConversationList));
                conversationList.sort((a, b) => (b.lastMessage?.serverTime ?? 0)
                    .compareTo((a.lastMessage?.serverTime ?? 1)));

                // print('conversationList:${conversationList.length}');
                return loading && conversationList.isEmpty
                    ? buildLoading
                    : conversationList.isEmpty
                        ? buildEmptyPlaceHolder('No Converasations')
                        : ListView.separated(
                            shrinkWrap: false,
                            itemCount: conversationList.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                  height: 1, color: Colors.grey.shade300);
                            },
                            itemBuilder: (context, index) {
                              final model = conversationList[index];
                              return _buildConversationItem(
                                  context, model, ref);
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
        setScreen(RouteList.home);
        try {
          ref.read(chatConversationProvider).updateConversationOnly(model.id);
        } catch (_) {}
      },
      onLongPress: (() async {
        final result = await showConversationOptions(context, model);
        if (result == null) {
          return;
        }
        if (result == 1) {
          ref.read(chatConversationProvider).updateConversationOnly(model.id);
        } else if (result == 2) {
          ref.read(chatConversationProvider).deleteConversationOnly(model.id);
          ref.read(callListProvider.notifier).setup();
        }
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
      } else if (model.lastMessage!.body.type == MessageType.CUSTOM) {
        try {
          ChatCustomMessageBody body =
              model.lastMessage!.body as ChatCustomMessageBody;
          final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
          textMessage = (callBody.callType == CallType.video)
              ? 'Video Call'
              : 'Audio call';
        } catch (e) {
          textMessage = 'Call';
        }
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
                model.lastMessage == null
                    ? ''
                    : formatConverastionTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            model.lastMessage!.serverTime)),

                //  DateFormat('h:mm a')
                //     .format(DateTime.fromMillisecondsSinceEpoch(
                //         model.lastMessage!.serverTime))
                //     .toUpperCase(),
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
        Consumer(builder: (context, ref, child) {
          return TextButton(
              onPressed: () async {
                // try {
                //   ref.refresh(groupConversationProvider);
                // } catch (e) {
                //   print('error :$e');
                // }
                await Navigator.pushNamed(context, RouteList.groups);
                setScreen(RouteList.home);
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
              ));
        }),
      ],
    );
  }

  Widget _newMessageButton(BuildContext context) {
    // return Consumer(builder: (context, ref, child) {
    return InkWell(
      splashColor: AppColors.primaryColor,
      onTap: () async {
        final model = await Navigator.pushNamed(context, RouteList.contactList);
        setScreen(RouteList.home);
        if (model != null) {
          ref.read(chatConversationProvider).updateUi();
          // ref.read(bChatSDKControllerProvider).reloadConversation(ref);
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
    // });
  }

  Widget _recentCallButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await ref.read(callListProvider.notifier).setup();
        await Navigator.pushNamed(context, RouteList.recentCalls);
        setScreen(RouteList.home);
        ref.read(chatConversationProvider).updateUnread();
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
            child: Icon(
              Icons.call,
              size: 4.w,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _userAppBar(BuildContext context) {
    return SizedBox(
      height: 12.h,
      child: UserConsumer(
        builder: (context, user, ref) {
          // if (user == null) return const SizedBox.shrink();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 7.w),
              InkWell(
                onTap: () async {
                  if (user.role == 'teacher' || user.role == 'admin') {
                    await Navigator.pushNamed(
                        context, RouteList.teacherProfile);
                  } else {
                    await Navigator.pushNamed(
                        context, RouteList.studentProfile);
                  }
                  setScreen(RouteList.home);
                  ref.read(chatConversationProvider).updateUnread();
                },
                // onTap: (() => Navigator.pushNamed(
                //     context, RouteList.contactProfile,
                //     arguments: user)),
                child: getRectFAvatar(user.name, user.image),
              ),
              SizedBox(width: 3.w),
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
                  // final result =
                  await Navigator.pushNamed(context, RouteList.searchContact);
                  // if (result == true) {
                  setScreen(RouteList.home);
                  await ref.read(chatConversationProvider).updateUnread();
                  // ref.read(bChatSDKControllerProvider).loadConversations(ref);
                  // }
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
