// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/helpers/call_helper.dart';
import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';
import '../../dialog/add_contact_dialog.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/controller/bchat_providers.dart';
import '/core/constants/agora_config.dart';
import '/ui/dialog/basic_dialog.dart';
import '/ui/screens.dart';
import '/core/utils/chat_utils.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import '/ui/screen/blearn/components/common.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';

import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widgets.dart';

final imageSize = 28.w;

// //Mute
// final muteProvider = StateProvider.autoDispose.family<bool, String>(
//   ((ref, id) {
//     final result = ref
//         .read(muteUserProvider(id))
//         .whenData((value) => value == ChatPushRemindType.NONE);
//     print('State = $result');
//     return result.value ?? false;
//   }),
// );

// //Mute
final chatMuteProvider = StateProvider.autoDispose<bool>(
  ((ref) {
    return false;
  }),
);

final blockProvider = StateProvider.autoDispose.family<Future<bool>, int>(
  ((ref, id) {
    return BChatContactManager.isUserBlocked(id.toString());
  }),
);

//Mute
// final muteUserProvider =
//     FutureProvider.autoDispose.family<ChatPushRemindType, String>(
//   ((ref, id) async {
//     try {
//       final result = await ChatClient.getInstance.pushManager
//           .fetchConversationSilentMode(
//               conversationId: id, type: ChatConversationType.Chat);
//       return result.remindType ?? ChatPushRemindType.ALL;
//     } on ChatError catch (e) {
//       print('Error: ${e.code}- ${e.description} ');
//     }
//     return ChatPushRemindType.ALL;
//   }),
// );

class ContactProfileScreen extends HookConsumerWidget {
  final Contacts contact;
  final bool fromChat;
  final bool isInContact;
  const ContactProfileScreen(
      {super.key,
      required this.contact,
      this.fromChat = true,
      this.isInContact = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (isInContact) {
        _loadMuteSetting(ref);
      }

      return () {};
    }, const []);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ColouredBoxBar(
        topSize: 30.h,
        topBar: _topBar(context),
        body: _buildBody(context),
      ),
    );
  }

  _updateSetting(bool mute) async {
    await BChatContactManager.chageChatMuteStateFor(
        contact.userId.toString(), mute);
  }

  _loadMuteSetting(WidgetRef ref) async {
    ChatPushRemindType remindType =
        await BChatContactManager.fetchChatMuteStateFor(
            contact.userId.toString());
    if (remindType == ChatPushRemindType.NONE) {
      ref.read(chatMuteProvider.notifier).state = false;
    } else {
      ref.read(chatMuteProvider.notifier).state = true;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isInContact) ...inContact(),
            if (!isInContact) ...notInContact(),
          ],
        ),
      ),
    );
  }

  List<Widget> notInContact() {
    return [
      _buildUserInfo(),
      SizedBox(height: 1.h),
      _buildGroups(),
      SizedBox(height: 3.h),
    ];
  }

  List<Widget> inContact() {
    return [
      _buildUserInfo(),
      _buildMuteSettings(),
      _mediaSection(),
      _buildGroups(),
      SizedBox(height: 3.h),
      Consumer(builder: (context, ref, child) {
        final future = ref.watch(blockProvider(contact.userId));

        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              bool blocked = snapshot.data!;
              return _buildButton(Icons.block,
                  blocked ? S.current.pr_btx_unblock : S.current.pr_btx_block,
                  () async {
                if (blocked) {
                  await BChatContactManager.unBlockUser(
                      contact.userId.toString());
                } else {
                  await BChatContactManager.blockUser(
                      contact.userId.toString());
                }
                ref.refresh(blockProvider(contact.userId));
                // ref.read(blockProvider(contact.userId).notifier).state =
                //     BChatContactManager.isUserBlocked(
                //         contact.userId.toString());
              });
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }),
      SizedBox(height: 1.h),
      _buildButton(
          Icons.thumb_down_off_alt_outlined, S.current.pr_btx_report, () {}),
      SizedBox(height: 4.h),
    ];
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          _textCaption(S.current.pr_name),
          SizedBox(height: 0.4.h),
          _textValue(contact.name),
          SizedBox(height: 2.h),
          _textCaption(S.current.pr_email),
          SizedBox(height: 0.4.h),
          _textValue(contact.email ?? ''),
          SizedBox(height: 2.h),
          _textCaption(S.current.pr_phone),
          SizedBox(height: 0.4.h),
          _textValue(contact.phone ?? ''),
        ],
      ),
    );
  }

  Widget _buildGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Text(
            S.current.pr_common_groups,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 11.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          return ref
              .watch(commonGroupsProvider(contact.userId.toString()))
              .when(
                data: ((data) {
                  if (data.isEmpty) {
                    return SizedBox(
                        height: 12.h,
                        child: buildEmptyPlaceHolder('No Common group'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async {
                            final model = await ref
                                .read(groupConversationProvider.notifier)
                                .getGroupConversation(data[index].groupId);
                            if (model != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteList.groupChatScreenDirect,
                                  (route) => route.isFirst,
                                  arguments: model);
                            } else {
                              print('Model is null');
                            }
                          },
                          child: _contactRow(data[index]));
                    },
                    itemCount: data.length,
                  );
                }),
                error: (error, stackTrace) => buildEmptyPlaceHolder('text'),
                loading: () => buildLoading,
              );
        }),
      ],
    );
  }

  Widget _contactRow(ChatGroup contact) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          getCicleAvatar(
              contact.name ?? '', BchatGroupManager.getGroupImage(contact)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              contact.name ?? '',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.contactNameTextColor,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, Function() onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          backgroundColor: const Color(0xFFF5F5F5),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, color: const Color(0xFFB70000), size: 5.w),
            SizedBox(width: 4.w),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFFB70000),
                fontSize: 12.sp,
                fontFamily: kFontFamily,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mediaSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Consumer(builder: (context, ref, child) {
        final medias = ref.watch(chatImageFiles(contact.userId.toString()));

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.pr_media_shared,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 11.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Visibility(
                  visible: medias.valueOrNull?.isNotEmpty == true,
                  child: TextButton(
                    onPressed: (() {
                      final data = medias.valueOrNull;
                      if (data == null) return;
                      final list = data
                          .map((e) => getImageProviderChatImage(e.body,
                              loadThumbFirst: false))
                          .toList();
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider(list);
                      showImageViewerPager(context, multiImageProvider,
                          onPageChanged: (page) {
                        print("page changed to $page");
                      }, onViewerDismissed: (page) {
                        print("dismissed while on page $page");
                      });
                    }),
                    child: Text(
                      S.current.pr_btx_all,
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 8.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            medias.when(
              data: (data) {
                if (data.isEmpty) {
                  return buildEmptyPlaceHolder('No Media');
                }
                return SizedBox(
                  height: imageSize,
                  child: ListView.separated(
                    itemCount: data.length > 3 ? 3 : data.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          final list = data
                              .map((e) => getImageProviderChatImage(e.body,
                                  loadThumbFirst: false))
                              .toList();
                          MultiImageProvider multiImageProvider =
                              MultiImageProvider(list, initialIndex: index);
                          // final body = data[index].body;
                          showImageViewerPager(context, multiImageProvider,
                              onPageChanged: (page) {
                            print("page changed to $page");
                          }, onViewerDismissed: (page) {
                            print("dismissed while on page $page");
                          });
                          // showImageViewer(
                          //     context,
                          //     getImageProviderChatImage(data[index].body,
                          //         loadThumbFirst: false),
                          //     onViewerDismissed: () {
                          //   // print("dismissed");
                          // });
                        },
                        child: _rowChatImageBody(data[index],
                            counter: data.length - 3, last: index == 2),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  buildEmptyPlaceHolder('Error in loadin No Media'),
              loading: () => buildLoading,
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _rowImage(
            //         image:
            //             'https://images.pexels.com/photos/1037992/pexels-photo-1037992.jpeg?auto=compress&cs=tinysrgb&w=400'),
            //     _rowImage(
            //         image:
            //             'https://images.pexels.com/photos/2736613/pexels-photo-2736613.jpeg?auto=compress&cs=tinysrgb&w=400'),
            //     _rowImage(
            //         image:
            //             'https://images.pexels.com/photos/583842/pexels-photo-583842.jpeg?auto=compress&cs=tinysrgb&w=400',
            //         last: true,
            //         counter: 4),
            //   ],
            // )
          ],
        );
      }),
    );
  }

  Widget _rowImage({String? image, bool last = false, int counter = 0}) {
    return image == null
        ? SizedBox(width: imageSize)
        : SizedBox(
            height: imageSize,
            width: imageSize,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              child: Stack(
                children: [
                  image.startsWith('http')
                      ? Image(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                        )
                      : Image(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                        ),
                  if (last && counter > 0)
                    Container(
                      color: Colors.black38,
                      child: Center(
                        child: Text(
                          '$counter+',
                          style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  Widget _rowChatImageBody(ChatMediaFile file,
      {bool last = false, int counter = 0}) {
    return SizedBox(
      // height: imageSize + 2.w,
      width: imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4.w)),
        child: Stack(
          children: [
            Image(
              image: getImageProviderChatImage(file.body),
              fit: BoxFit.cover,
              height: imageSize,
              width: imageSize,
            ),
            if (last && counter > 0)
              Container(
                color: Colors.black38,
                child: Center(
                  child: Text(
                    '$counter+',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuteSettings() {
    return Consumer(
      builder: (context, ref, child) {
        final mute = ref.watch(chatMuteProvider);
        // ref.watch(muteProvider(contact.userId.toString()));
        return InkWell(
          onTap: () async {
            _updateSetting(!mute);
            ref.read(chatMuteProvider.notifier).state = !mute;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.pr_mute_notification,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 11.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                mySwitch(mute, (value) async {
                  // ref.read(muteProvider(contact.userId.toString()).notifier)
                  _updateSetting(value);
                  ref.read(chatMuteProvider.notifier).state = value;
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 11.sp,
        color: Colors.black,
      ),
    );
  }

  Widget _textCaption(String caption) {
    return Text(
      caption,
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 9.sp,
        color: Colors.grey,
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return SizedBox(
      width: 100.w,
      // padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Stack(
        children: [
          Positioned(
            left: 1.w,
            top: 1.h,
            child: IconButton(
              icon: getSvgIcon('arrow_back.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          if (isInContact)
            Positioned(
              right: 1.w,
              top: 1.h,
              child: Consumer(builder: (context, ref, child) {
                return IconButton(
                  // padding: EdgeInsets.all(1.w),
                  icon: getSvgIcon('icon_delete_conv.svg',
                      color: Colors.white, width: 5.w),
                  onPressed: () async {
                    await showBasicDialog(
                        context, 'Delete Contact', 'Are you sure?', 'Yes',
                        () async {
                      await BChatContactManager.deleteContact(
                          contact.userId.toString());
                      await deleteContact(contact.userId, ref);
                      // await ref
                      //     .read(chatConversationProvider)
                      //     .removedContact(contact.userId);
                      Navigator.pushNamedAndRemoveUntil(
                          context, RouteList.home, (route) => route.isFirst);
                    }, negativeButton: 'No');
                  },
                );
              }),
            ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  getRectFAvatar(contact.name, contact.profileImage,
                      size: 20.w),
                  SizedBox(
                    height: 0.7.h,
                  ),
                  Text(
                    contact.name,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Consumer(builder: (context, ref, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (fromChat) {
                              Navigator.pop(context);
                            } else {
                              if (isInContact) {
                                openChatScreen(context, contact, ref);
                              } else {
                                if (AgoraConfig.autoAcceptContact) {
                                  _addContactSendRequest(ref, context, contact);
                                } else {
                                  AppSnackbar.instance
                                      .message(context, 'Send request to chat');
                                }
                              }
                            }
                          },
                          child: isInContact
                              ? _buildIcon('icon_pr_chat.svg')
                              : CircleAvatar(
                                  radius: 6.w,
                                  backgroundColor: AppColors.yellowAccent,
                                  child: Icon(
                                    Icons.person_add_alt_outlined,
                                    color: AppColors.primaryColor,
                                    size: 5.w,
                                  ),
                                ),
                        ),
                        InkWell(
                            onTap: () => makeVideoCall(contact, ref, context),
                            child: _buildIcon('icon_pr_vcall.svg')),
                        InkWell(
                            onTap: () => makeAudioCall(contact, ref, context),
                            child: _buildIcon('icon_pr_acall.svg')),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteList.searchContact);
                          },
                          child: _buildIcon('icon_pr_search.svg'),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addContactSendRequest(
      WidgetRef ref, BuildContext context, Contacts item) async {
    final input = await showAddContactDialog(context, item.userId, item.name);
    if (input == null) {
      return;
    }

    showLoading(ref);
    final result = await BChatContactManager.sendRequestToAddContact(
        item.userId.toString());

    if (result == null) {
      AppSnackbar.instance
          .message(context, 'Request sent to ${item.name} successfully');
      final contacts = await ref
              .read(bChatProvider)
              .getContactsByIds(item.userId.toString()) ??
          [];
      if (contacts.isNotEmpty) {
        openChatScreen(context,
            Contacts.fromContact(contacts[0], ContactStatus.sentInvite), ref,
            sendInviateMessage: true, message: input);
      }
    } else {
      hideLoading(ref);
      AppSnackbar.instance.error(context, result);
    }
  }

  Widget _buildIcon(String icon) {
    return CircleAvatar(
      radius: 6.w,
      backgroundColor: AppColors.yellowAccent,
      child: getSvgIcon(icon, width: 5.w),
    );
  }
}

//
