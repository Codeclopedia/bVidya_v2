import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/core/helpers/bchat_contact_manager.dart';

import '/core/constants.dart';
import '/core/constants/data.dart';
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
  const ContactProfileScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _loadMuteSetting(ref);
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
      ref.read(chatMuteProvider.notifier).state = true;
    } else {
      ref.read(chatMuteProvider.notifier).state = false;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 3.h),
      child: SingleChildScrollView(
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
            SizedBox(height: 3.h),
            _buildMuteSettings(),
            SizedBox(height: 3.h),
            _mediaSection(),
            SizedBox(height: 3.h),
            _buildGroups(),
            SizedBox(height: 3.h),
            Consumer(builder: (context, ref, child) {
              final future = ref.watch(blockProvider(contact.userId));

              return FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    bool blocked = snapshot.data!;
                    return _buildButton(
                        Icons.block,
                        blocked
                            ? S.current.pr_btx_unblock
                            : S.current.pr_btx_block, () async {
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
            _buildButton(Icons.thumb_down_off_alt_outlined,
                S.current.pr_btx_report, () {}),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.pr_common_groups,
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 11.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _contactRow(contacts[index]);
          },
          itemCount: 3,
        ),
      ],
    );
  }

  Widget _contactRow(ContactModel contact) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.image),
          SizedBox(width: 3.w),
          Text(
            contact.name,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: AppColors.contactNameTextColor,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, Function() onTap) {
    return TextButton(
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
    );
  }

  Widget _mediaSection() {
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
            TextButton(
              onPressed: (() {}),
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
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _rowImage(
                image:
                    'https://images.pexels.com/photos/1037992/pexels-photo-1037992.jpeg?auto=compress&cs=tinysrgb&w=400'),
            _rowImage(
                image:
                    'https://images.pexels.com/photos/2736613/pexels-photo-2736613.jpeg?auto=compress&cs=tinysrgb&w=400'),
            _rowImage(
                image:
                    'https://images.pexels.com/photos/583842/pexels-photo-583842.jpeg?auto=compress&cs=tinysrgb&w=400',
                last: true,
                counter: 4),
          ],
        )
      ],
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

  Widget _buildMuteSettings() {
    return Consumer(
      builder: (context, ref, child) {
        final mute = ref.watch(chatMuteProvider);

        // ref.watch(muteProvider(contact.userId.toString()));
        return InkWell(
          onTap: () async {
            _updateSetting(!mute);
            ref.read(chatMuteProvider.notifier).state =
                // ref.read(muteProvider(contact.userId.toString()).notifier).state =
                !mute;

            // final conv = await ChatClient.getInstance.chatManager
            //     .getConversation(currentUser.userId.toString());
//
            // conv?.
          },
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
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteList.chatScreen, (route) => route.isFirst);
                          },
                          child: _buildIcon('icon_pr_chat.svg')),
                      _buildIcon('icon_pr_vcall.svg'),
                      _buildIcon('icon_pr_acall.svg'),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteList.search);
                        },
                        child: _buildIcon('icon_pr_search.svg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
