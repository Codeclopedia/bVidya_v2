// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/ui/screens.dart';
import '/controller/providers/contacts_select_notifier.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/helpers/bchat_group_manager.dart';
import '../../blearn/components/common.dart';
import '../../../dialog/image_picker_dialog.dart';
import '../../../widgets.dart';
// import 'new_group_contact_screen.dart';

final selectedGroupImageProvider =
    StateProvider.autoDispose<File?>((ref) => null);

// ignore: must_be_immutable
class CreateNewGroupScreen extends HookWidget {
  ChatGroup? group;
  CreateNewGroupScreen({Key? key, this.group}) : super(key: key);
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _controller = TextEditingController(text: group?.name ?? '');
      return () {
        _controller?.dispose();
      };
    }, const []);

    return Scaffold(
      body: ColouredBoxBar(
        topSize: 25.h,
        topBar: BAppBar(
            title: group != null
                ? S.current.groups_create_edit_title
                : S.current.groups_create_title),
        body: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    String imageUrl =
        group != null ? BchatGroupManager.getGroupImage(group!) : '';
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.groups_create_subject,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer(builder: (context, ref, child) {
                return ElevatedButton(
                  style: elevatedButtonYellowStyle,
                  onPressed: () async {
                    String name = _controller!.text;
                    createGroup(context, name, ref);
                  },
                  child: Text(group != null
                      ? S.current.btn_update
                      : S.current.btn_create),
                );
              })
            ],
          ),
          SizedBox(
            height: 12.h,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 2.w),
                SizedBox(
                  width: 9.h,
                  height: 9.h,
                  child: Consumer(
                    builder: (context, ref, child) {
                      File? image = ref.watch(selectedGroupImageProvider);
                      return Stack(
                        children: [
                          Container(
                            width: 8.h,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: image == null
                                ? (imageUrl.isNotEmpty
                                    ? _buildImage(imageUrl, () {
                                        ref
                                            .read(selectedGroupImageProvider
                                                .notifier)
                                            .state = null;
                                      })
                                    : const Icon(Icons.person))
                                : _buildImage(image.absolute.path, () {
                                    ref
                                        .read(
                                            selectedGroupImageProvider.notifier)
                                        .state = null;
                                  }),
                          ),
                          Positioned(
                            bottom: 1.h,
                            right: 1.w,
                            child: InkWell(
                              onTap: () async {
                                final pickedFile =
                                    await showImageFilePicker(context);
                                if (pickedFile != null) {
                                  ref
                                      .read(selectedGroupImageProvider.notifier)
                                      .state = pickedFile;
                                }
                              },
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: AppColors.yellowAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(Icons.add, size: 4.w),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.current.groups_create_caption,
                          style: footerTextStyle),
                      SizedBox(height: 2.w),
                      Consumer(builder: (context, ref, child) {
                        return TextField(
                          controller: _controller,
                          onSubmitted: (value) {
                            createGroup(context, value, ref);
                          },
                          decoration: inputNewGroupStyle.copyWith(
                              hintText: S.current.groups_create_hint_name),
                        );
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            S.current.grp_caption_participation,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (group == null) _buildParticipants(),
          if (group != null) ..._editBuildParticipants(context)
          // Row(
          //   children: [
          //     Text(
          //       S.current.grp_caption_participation,
          //       style: TextStyle(
          //         fontFamily: kFontFamily,
          //         color: Colors.black,
          //         fontSize: 10.sp,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildParticipants() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final list = ref.watch(selectedContactProvider);
          if (list.isEmpty) {
            return buildEmptyPlaceHolder(S.current.group_empty_no_contacts);
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _contactRow(list[index]);
            },
          );
        },
      ),
    );
  }

  List<Widget> _editBuildParticipants(BuildContext context) {
    return [
      SizedBox(height: 1.h),
      _addParticipationRow(context),
      Expanded(
        child: Consumer(
          builder: (context, ref, child) {
            final list = ref.watch(selectedContactProvider);
            // final updateList = [];
            // updateList.addAll(list);
            // updateList.addAll(GroupInfoScreen.contacts);
            if (list.isEmpty) {
              return buildEmptyPlaceHolder(S.current.group_empty_no_contacts);
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _contactRemoveRow(list[index], ref);
              },
            );
          },
        ),
      )
    ];
  }

  Widget _addParticipationRow(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(
            context,
            group != null
                ? RouteList.editGroupContacts
                : RouteList.newGroupContacts);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 7.w,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
            // getCicleAvatar(contact.name, contact.image),
            SizedBox(width: 3.w),
            Text(
              S.current.grp_txt_add_participant,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontWeight: FontWeight.w600,
                color: AppColors.contactNameTextColor,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String image, Function() onTap) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 4.h,
          // borderRadius: BorderRadius.all(Radius.circular(3.w)),
          child: Image(
            image: getImageProviderFile(image),
            width: 8.h,
            height: 8.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              onTap();
            },
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ),
      ],
    );
  }

  createGroup(BuildContext context, String name, WidgetRef ref) async {
    showLoading(ref);
    if (name.trim().isEmpty) {
      EasyLoading.showError(S.current.group_error_empty);
      return;
    }
    if (name.trim().length < 3) {
      EasyLoading.showError(S.current.group_error_invalid);
      return;
    }

    final file = ref.read(selectedGroupImageProvider);
    final String url;
    if (file != null) {
      url = (await ref.read(bChatProvider).uploadImage(file)) ?? '';
    } else {
      url = '';
    }
    final ChatGroup? groupCreated;
    if (group != null) {
      final list = ref.read(selectedContactProvider);
      final userIds = list.map((e) => e.userId.toString()).toList();
      final removedContact = GroupInfoScreen.contacts
          .where((e) => !userIds.contains(e.userId.toString()))
          .toList();

      final removedUserIds =
          removedContact.map((e) => e.userId.toString()).toList();

      groupCreated = await BchatGroupManager.editGroup(
          group!.groupId, name.trim(), '', userIds, removedUserIds, url);
    } else {
      final list = ref.read(selectedContactProvider);
      final userIds = list.map((e) => e.userId.toString()).toList();
      groupCreated =
          await BchatGroupManager.createNewGroup(name.trim(), '', userIds, url);
    }

    hideLoading(ref);
    if (groupCreated != null) {
      // print('group : ${groupCreated.toJson()}');
      Navigator.pop(context, groupCreated);
    } else {
      AppSnackbar.instance.error(context, S.current.group_error_creating);
      // EasyLoading.showError('Error in creating group');
    }
  }

  // Widget _contactRow(ContactModel contact) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 1.h),
  //     child: Row(
  //       children: [
  //         getCicleAvatar(contact.name, contact.image),
  //         SizedBox(width: 3.w),
  //         Text(
  //           contact.name,
  //           style: TextStyle(
  //             fontFamily: kFontFamily,
  //             color: AppColors.contactNameTextColor,
  //             fontSize: 11.sp,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _contactRow(Contacts contact) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.profileImage),
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
        ],
      ),
    );
  }

  Widget _contactRemoveRow(Contacts contact, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.profileImage),
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
          if (GroupInfoScreen.contacts.contains(contact))
            ElevatedButton(
              style: elevatedButtonEndStyle
              // .copyWith(
              //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              //         const EdgeInsets.all(0)))
              ,
              onPressed: () {
                ref
                    .read(selectedContactProvider.notifier)
                    .removeContact(contact);
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.white,
                  fontSize: 8.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
