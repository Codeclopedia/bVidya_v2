// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';
// import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:uuid/uuid.dart';

import '/core/utils/callkit_utils.dart';
import '../blearn/components/common.dart';
import '/controller/bchat_providers.dart';
import '/core/constants/agora_config.dart';
import '/core/utils/chat_utils.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/core/utils.dart';
import '/controller/providers/user_auth_provider.dart';
import '/core/utils/date_utils.dart';

import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/helpers/call_helper.dart';
import '/data/models/call_message_body.dart';

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
        ref.read(userLoginStateProvider.notifier).logout();
        return;
      }
      //
      await BChatSDKController.instance.initChatSDK(user);
      await loadChats(ref, updateStatus: true);

      await ref.read(groupConversationProvider.notifier).setup();
      // await ref.read(callListProvider.notifier).setup();
    } else {
      print('reseting chat only');
      try {
        await loadChats(ref, updateStatus: true);
      } catch (e) {
        print('Error =>$e');
      }
      appLoaded = true;
      // ref
      //     .read(chatConversationProvider.notifier)
      //     .reset(ref.read(bChatProvider));
    }

    // if (await NotificationController.isAllowedPermission()) {
    //   return;
    // }
    // print('object')
    // final uid = const Uuid().v5(Uuid.NAMESPACE_OID, 'mGf3ee4gcOlj2hsnyhcH');
    // print('UUID=> $uid   : ${Uuid.isValidUUID(fromString: uid)}');
    await ref.read(chatConversationProvider.notifier).registerPresence(ref);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      _firebaseNotification();
      // NotificationController.displayNotificationRationale();
    }
  }

  _firebaseNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings pre = await messaging.getNotificationSettings();
    if (pre.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } else {
      // print('User granted permission: ${pre.authorizationStatus}');
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
    // registerForContact('home_screen_contact', ref);
    // registerForNewMessage('home_screen_chat', (msgs) {
    //   for (var lastMessage in msgs) {
    //     // print(
    //     //     'message ${lastMessage.conversationId} - ${lastMessage.chatType}');
    //     if (lastMessage.conversationId != null) {
    //       if (lastMessage.chatType == ChatType.Chat) {
    //         onNewChatMessage(lastMessage, ref);
    //         // ref
    //         //     .read(chatConversationProvider.notifier)
    //         //     .updateConversationMessage(lastMessage, update: true);
    //       } else if (lastMessage.chatType == ChatType.GroupChat) {
    //         ref
    //             .read(groupConversationProvider.notifier)
    //             .updateConversationMessage(
    //                 lastMessage, lastMessage.conversationId!,
    //                 update: false);
    //       }
    //     }
    //   }
    // });
  }

  void _disposeAll() {
    // ref.read(chatConversationProvider.notifier).unRegisterPresence();
    // unregisterForContact('home_screen_contact');
    try {
      ChatClient.getInstance.presenceManager
          .removeEventHandler("user_presence_home_screen");
    } on ChatError catch (e) {
      print('error in unsubscribe presence: $e');
    }

    // unregisterForNewMessage('home_screen_chat');
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
                final conversationList = ref.watch(chatConversationProvider);
                final loading = ref.watch(conversationLoadingStateProvider);

                // ref.watch(chatConversationProvider
                //     .select((value) => value.isLoading));

                // final conversationList = provider.chatConversationList;

                // ref.watch(chatConversationProvider
                //     .select((value) => value.chatConversationList));
                // conversationList.sort((a, b) => (b.lastMessage?.serverTime ?? 0)
                //     .compareTo((a.lastMessage?.serverTime ?? 1)));
                if (conversationList.length > 1) {
                  conversationList.sort(
                    (a, b) {
                      if (b.id == AgoraConfig.bViydaAdmitUserId.toString()) {
                        return 1;
                      }
                      if (a.id == AgoraConfig.bViydaAdmitUserId.toString()) {
                        return -1;
                      }
                      // int value = (b.lastMessage?.serverTime ?? 0)
                      //     .compareTo((a.lastMessage?.serverTime ?? 1));
                      if ((b.contact.ispinned ?? false) &&
                          !(a.contact.ispinned ?? false)) {
                        return 1;
                      }
                      if ((a.contact.ispinned ?? false) &&
                          !(b.contact.ispinned ?? false)) {
                        return -1;
                      }
                      return (b.lastMessage?.serverTime ?? 0)
                          .compareTo((a.lastMessage?.serverTime ?? 1));
                    },
                  );
                }

                // print('conversationList:${conversationList.length}');
                return loading && conversationList.isEmpty
                    ? buildLoading
                    : conversationList.isEmpty
                        ? buildEmptyPlaceHolder('No Converasations')
                        : ListView.separated(
                            shrinkWrap: false,
                            physics: const BouncingScrollPhysics(),
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

        // try {
        ref
            .read(chatConversationProvider.notifier)
            .updateConversation(model.id);
        // } catch (_) {}
      },
      onLongPress: (() async {
        final result = await showConversationOptions(context, model);
        if (result == null) {
          return;
        }
        if (result == 1) {
          ref
              .read(chatConversationProvider.notifier)
              .updateConversation(model.id);
          // ref.read(chatConversationProvider).updateConversationOnly(model.id);
        } else if (result == 2) {
          ref
              .read(chatConversationProvider.notifier)
              .removeConversation(model.id);
          // ref.read(chatConversationProvider).deleteConversationOnly(model.id);
          ref.read(callListProvider.notifier).setup();
        }
        //result == 4 ||
        // if (result == 3) {
        //   ref
        //       .read(chatConversationProvider.notifier)
        //       .updateConversation(model.id);
        // }
      }),
      child: _contactRow(model),
    );
  }

  Widget _contactRow(ConversationModel model) {
    final colorTimeBadge = model.badgeCount > 0
        ? AppColors.contactBadgeUnreadTextColor
        : AppColors.contactBadgeReadTextColor;
    String textMessage = '';
    // bool isCall = false;
    Widget? desc;
    if (model.lastMessage != null) {
      textMessage =
          model.lastMessage!.body.type.name.toLowerCase(); //!=MessageType.TXT
      if (model.lastMessage!.body.type == MessageType.TXT) {
        final body = model.lastMessage!.body as ChatTextMessageBody;
        textMessage = body.content;
      } else if (model.lastMessage!.body.type == MessageType.CUSTOM) {
        try {
          // print('Call Message ID:${model.lastMessage!.msgId}');

          ChatCustomMessageBody body =
              model.lastMessage!.body as ChatCustomMessageBody;

          final callBody = CallMessegeBody.fromJson(jsonDecode(body.event));
          bool isMissed =
              model.id == model.lastMessage?.from && callBody.isMissedType();
          textMessage = (isMissed ? ' Missed' : '') +
              ((callBody.callType == CallType.video)
                  ? ' Video Call'
                  : ' Audio call');
          desc = Row(
            children: [
              Icon(isMissed ? Icons.call_missed : Icons.call,
                  color: isMissed ? AppColors.redBColor : Colors.black),
              Text(
                textMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontWeight:
                      model.badgeCount > 0 ? FontWeight.w500 : FontWeight.w200,
                  color: isMissed
                      ? AppColors.redBColor
                      : model.badgeCount > 0
                          ? AppColors.black
                          : Colors.grey,
                  fontSize: 9.sp,
                ),
              )
            ],
          );
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
          // getCicleAvatar(model.contact.name, model.contact.profileImage),
          getOnlineStatusCircle(model),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    SizedBox(
                      width: 1.w,
                    ),
                    if (model.id == AgoraConfig.bViydaAdmitUserId.toString())
                      getPngImage('check.png', width: 4.5.w),
                    if (model.contact.role == "instructor" ||
                        model.contact.role == "Teacher")
                      getSvgIcon('Badge.svg', width: 3.w),
                  ],
                ),
                // Text(
                //   model.contact.name,
                //   style: TextStyle(
                //     fontWeight: model.badgeCount > 0
                //         ? FontWeight.w700
                //         : FontWeight.w500,
                //     fontFamily: kFontFamily,
                //     color: AppColors.contactNameTextColor,
                //     fontSize: 12.sp,
                //   ),
                // ),
                desc ??
                    Text(
                      textMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        fontWeight: model.badgeCount > 0
                            ? FontWeight.w500
                            : FontWeight.w200,
                        color: model.badgeCount > 0
                            ? AppColors.black
                            : Colors.grey,
                        fontSize: 9.sp,
                      ),
                    ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (model.contact.ispinned ?? false)
                    getSvgIcon('Pin.svg', width: 4.w),
                  if (model.contact.ispinned ?? false) SizedBox(width: 1.w),
                  if (model.mute) getSvgIcon('icon_mute_conv.svg', width: 4.w),
                  if (model.mute) SizedBox(width: 1.w),
                  model.badgeCount > 0
                      ? CircleAvatar(
                          radius: 3.w,
                          backgroundColor:
                              AppColors.contactBadgeUnreadTextColor,
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
            ],
          ),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }

  Widget getOnlineStatusCircle(ConversationModel model) => Stack(
        children: [
          getCicleAvatar(model.contact.name, model.contact.profileImage),
          if (isOnline(model.isOnline))
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 2.25.w,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 1.75.w,
                ),
              ),
            ),
        ],
      );

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
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                ),
                onPressed: () async {
                  await Navigator.pushNamed(context, RouteList.groups);
                  setScreen(RouteList.home);
                },
                child: Text(
                  S.current.home_btx_groups,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.primaryColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ref.watch(groupUnreadCountProvider).when(
                    data: (count) {
                      return count > 0
                          ? CircleAvatar(
                              backgroundColor: AppColors.redBColor,
                              radius: 2.5.w,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 7.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                    error: (error, stackTrace) => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  ),
            ],
          );
        }),
      ],
    );
  }

  Widget _newMessageButton(BuildContext context) {
    // return Consumer(builder: (context, ref, child) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        alignment: Alignment.center,
      ),
      onPressed: () async {
        // final model =
        await Navigator.pushNamed(context, RouteList.contactList);
        setScreen(RouteList.home);
        // if (model != null) {}
        // _loadConversations(ref);
      },
      child: Text(
        S.current.home_btx_new_message,
        style: TextStyle(
          fontFamily: kFontFamily,
          color: AppColors.primaryColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // });
  }

  Widget _newMessageButton2(BuildContext context) {
    // return Consumer(builder: (context, ref, child) {
    return InkWell(
      splashColor: AppColors.primaryColor,
      onTap: () async {
        final model = await Navigator.pushNamed(context, RouteList.contactList);
        setScreen(RouteList.home);
        if (model != null) {
          // ref.read(chatConversationProvider).updateUi();
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
        ref.read(chatConversationProvider.notifier).updateUnread();
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
                  if (user.role == 'teacher' ||
                      user.role == 'instructor' ||
                      user.role == 'admin') {
                    await Navigator.pushNamed(
                        context, RouteList.teacherProfile);
                  } else {
                    await Navigator.pushNamed(
                        context, RouteList.studentProfile);
                  }
                  setScreen(RouteList.home);
                  ref.read(chatConversationProvider.notifier).updateUnread();
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
                  await Navigator.pushNamed(
                      context, RouteList.friendRequestScreen);
                  setScreen(RouteList.home);
                },
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.w)),
                    color: AppColors.yellowAccent,
                  ),
                  child: const Icon(
                    Icons.person_add_alt,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              InkWell(
                onTap: () async {
                  // final result =
                  await Navigator.pushNamed(context, RouteList.searchContact);
                  // if (result == true) {
                  setScreen(RouteList.home);
                  await ref
                      .read(chatConversationProvider.notifier)
                      .updateUnread();
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
            ],
          );
        },
      ),
    );
  }
}
