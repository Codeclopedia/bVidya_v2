// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/controller/providers/bchat/groups_conversation_provider.dart';
import 'package:bvidya/core/sdk_helpers/bchat_contact_manager.dart';
import 'package:bvidya/core/sdk_helpers/bchat_group_manager.dart';

import '/controller/providers/contacts_select_notifier.dart';
import '/ui/dialog/basic_dialog.dart';
import '/ui/screen/blearn/components/common.dart';
import '/controller/bchat_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../../widgets.dart';

//Mute
final groupMuteProvider = StateProvider.autoDispose<bool>(
  ((_) => true),
);

class GroupInfoScreen extends HookConsumerWidget {
  final GroupConversationModel group;
  static final imageSize = 28.w;

  const GroupInfoScreen({super.key, required this.group});

  static final List<Contacts> contacts = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _loadMuteSetting(ref);
      return () {};
    }, []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ColouredBoxBar(
        topSize: 30.h,
        topBar: _topBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            _buildMuteSettings(),
            // SizedBox(height: 3.h),
            _mediaSection(),
            // SizedBox(height: 3.h),
            _buildGroups(),
            SizedBox(height: 4.h),
            _buildButton(Icons.delete_outline_rounded, S.current.grp_btx_clear,
                () {
              showBasicDialog(
                  context, S.current.grp_btx_clear, 'Are you sure?', 'Yes',
                  () async {
                await group.conversation?.deleteAllMessages();
              });
            }),
            // SizedBox(height: 1.h),
            _buildButton(Icons.exit_to_app, S.current.grp_btx_exit, () {
              showBasicDialog(
                  context, S.current.grp_btx_exit, 'Are you sure?', 'Yes',
                  () async {
                await ChatClient.getInstance.groupManager
                    .leaveGroup(group.groupInfo.groupId);
              });
            }),
            // SizedBox(height: 1.h),
            _buildButton(Icons.block, S.current.pr_btx_block, () {
              showBasicDialog(
                  context, S.current.pr_btx_block, 'Are you sure?', 'Yes',
                  () async {
                await ChatClient.getInstance.groupManager
                    .blockGroup(group.groupInfo.groupId);
              });
            }),
            // SizedBox(height: 1.h),
            _buildButton(
                Icons.thumb_down_off_alt_outlined, S.current.grp_btx_report,
                () {
              //     showBasicDialog(
              //     context, S.current.pr_btx_report, 'Are you sure?', 'Yes',
              //     () async {
              //   await ChatClient.getInstance.groupManager
              //       .reportGroup(group.groupInfo.groupId);
              // });
            }),
            // SizedBox(height: 1.h),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Text(
            S.current.grp_caption_participation,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 11.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          return ref.watch(groupMembersInfo(group.groupInfo.groupId)).when(
              data: (grpInfo) {
                if (grpInfo == null) {
                  return buildEmptyPlaceHolder('No Member loaded');
                }

                final data = grpInfo.members;
                final grp = grpInfo.group;
                bool hasPermission =
                    (grp.adminList ?? []).contains(grpInfo.userId) ||
                        (grp.owner ?? '') == grpInfo.userId;
                // print(
                //     'Group Owner ${grp.owner} =  ${grp.adminList}  $hasPermission ${grpInfo.userId}');
                contacts.clear();
                contacts.addAll(data.where(
                    (element) => element.userId.toString() != grpInfo.userId));
                // (grp.permissionType == ChatGroupPermissionType.Owner ||
                //     grp.permissionType == ChatGroupPermissionType.Admin);

                return ListView.builder(
                  shrinkWrap: true,
                  // separatorBuilder: (context, index) => const Divider(),
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (hasPermission) {
                      if (index == 0) {
                        return _addParticipationRow(context);
                      } else {
                        bool isAdmin = (grp.adminList ?? [])
                            .contains(data[index - 1].userId.toString());
                        return _contactRow(
                            data[index - 1], isAdmin, grpInfo.userId);
                      }
                    } else {
                      bool isAdmin = (grp.adminList ?? [])
                          .contains(data[index].userId.toString());

                      return _contactRow(data[index], isAdmin, grpInfo.userId);
                    }
                  },
                  itemCount: data.length + (hasPermission ? 1 : 0),
                );
              },
              error: (error, stackTrace) => buildEmptyPlaceHolder(''),
              loading: () => buildLoading);
        }),
      ],
    );
  }

  Widget _addParticipationRow(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.newGroupContacts);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 6.w,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
            // getCicleAvatar(contact.name, contact.image),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                S.current.grp_txt_add_participant,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontWeight: FontWeight.w600,
                  color: AppColors.contactNameTextColor,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(Contacts contact, bool isAdmin, String userId) {
    bool isOwner = contact.userId.toString() == group.groupInfo.owner;
    return InkWell(
      onLongPress: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            getCicleAvatar(contact.name, contact.profileImage, radius: 6.w),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                contact.name,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: AppColors.contactNameTextColor,
                  fontSize: 11.sp,
                ),
              ),
            ),
            if (isAdmin || isOwner)
              const Icon(
                Icons.person_outline,
                color: AppColors.primaryColor,
              ),
            if (isAdmin || isOwner)
              Text(
                isOwner ? 'Owner' : 'Admin',
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: AppColors.primaryColor,
                  fontSize: 8.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, Function() onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 6.w),
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
            Icon(icon, color: const Color(0xFFB70000)),
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
    return Consumer(builder: (context, ref, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
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
                ref.watch(groupMediaProvier(group.groupInfo.groupId)).when(
                      data: (items) {
                        return Visibility(
                          visible: items.isNotEmpty,
                          child: TextButton(
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
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
              ],
            ),
            // Consumer(
            //   builder: (context, ref, child) {
            // return
            ref.watch(groupMediaProvier(group.groupInfo.groupId)).when(
                  data: (items) {
                    if (items.isEmpty) {
                      return SizedBox(
                          height: 12.h,
                          child: buildEmptyPlaceHolder('No media shared'));
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 4.w);
                      },
                      itemCount: items.length > 3 ? 3 : items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _rowFileImage(
                            image: item.filePath,
                            counter: items.length - 3,
                            last: index == 2);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      buildEmptyPlaceHolder('Error in loading media'),
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
        ),
      );
    });
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

  Widget _rowFileImage({File? image, bool last = false, int counter = 0}) {
    return image == null
        ? SizedBox(width: imageSize)
        : SizedBox(
            height: imageSize,
            width: imageSize,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              child: Stack(
                children: [
                  Image(image: getImageProviderFile(image.absolute.path)),
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

  _updateSetting(bool mute) async {
    await BchatGroupManager.chageGroupMuteStateFor(
        group.groupInfo.groupId, mute);
  }

  _loadMuteSetting(WidgetRef ref) async {
    ChatPushRemindType remindType =
        await BchatGroupManager.fetchGroupMuteStateFor(group.groupInfo.groupId);
    if (remindType == ChatPushRemindType.NONE) {
      ref.read(groupMuteProvider.notifier).state = false;
    } else {
      ref.read(groupMuteProvider.notifier).state = true;
    }
  }

  Widget _buildMuteSettings() {
    return Consumer(
      builder: (context, ref, child) {
        final mute = ref.watch(groupMuteProvider);
        return InkWell(
          onTap: () {
            ref.read(groupMuteProvider.notifier).state = !mute;
            _updateSetting(!mute);
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
                mySwitch(mute, (value) {
                  ref.read(groupMuteProvider.notifier).state = value;
                  _updateSetting(value);
                })
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _textValue(String value) {
  //   return Text(
  //     value,
  //     style: TextStyle(
  //       fontFamily: kFontFamily,
  //       fontSize: 11.sp,
  //       color: Colors.black,
  //     ),
  //   );
  // }

  // Widget _textCaption(String caption) {
  //   return Text(
  //     caption,
  //     style: TextStyle(
  //       fontFamily: kFontFamily,
  //       fontSize: 9.sp,
  //       color: Colors.grey,
  //     ),
  //   );
  // }

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
          Positioned(
            right: 1.w,
            top: 1.h,
            child: Consumer(builder: (context, ref, child) {
              final user = ref.watch(loginRepositoryProvider).user;
              return Visibility(
                visible: group.groupInfo.owner == user?.id.toString(),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        ref.read(selectedContactProvider.notifier).clear();
                        if (contacts.isNotEmpty) {
                          ref
                              .read(selectedContactProvider.notifier)
                              .addContacts(contacts);
                          await Navigator.pushNamed(
                              context, RouteList.editGroup,
                              arguments: group.groupInfo);

                          ref.read(groupConversationProvider).update();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        await BchatGroupManager.deleteGroup(
                            group.groupInfo.groupId);
                        await ref
                            .read(groupConversationProvider)
                            .delete(group.groupInfo.groupId);
                        Navigator.popUntil(context, (route) {
                          print(
                              'Route ${route.isFirst} ${route.settings.name} - ${route.hasActiveRouteBelow}');
                          return route.isFirst;
                        });
                      },
                    ),
                  ],
                ),
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
                  getRectFAvatar(group.groupInfo.name ?? '', group.image,
                      size: 20.w),
                  SizedBox(
                    height: 0.7.h,
                  ),
                  Text(
                    group.groupInfo.name ?? '',
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
                          Navigator.pushNamed(context, RouteList.searchContact);
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
      child: getSvgIcon(icon),
    );
  }
}

//
