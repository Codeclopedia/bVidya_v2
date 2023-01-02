// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import '/controller/providers/contacts_select_notifier.dart';
import '../../../dialog/image_picker_dialog.dart';
import '/core/helpers/bchat_group_manager.dart';
import '../../../base_back_screen.dart';
import '../../blearn/components/common.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../widgets.dart';
// import 'new_group_contact_screen.dart';

final selectedGroupImageProvider =
    StateProvider.autoDispose<File?>((ref) => null);

class CreateNewGroupScreen extends HookWidget {
  CreateNewGroupScreen({Key? key}) : super(key: key);
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _controller = TextEditingController();
      return () {};
    }, const []);

    return Scaffold(
      body: ColouredBoxBar(
        topSize: 25.h,
        topBar: const BAppBar(title: 'New Group'),
        body: _buildList(context),
      ),
    );
  }

  // Widget _buildSearchBody(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(height: 2.h),
  //           Row(
  //             mainAxisSize: MainAxisSize.max,
  //             children: [
  //               Text(
  //                 'Add Subject',
  //                 style: TextStyle(
  //                   fontFamily: kFontFamily,
  //                   color: Colors.black,
  //                   fontSize: 10.sp,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 style: elevatedButtonYellowStyle,
  //                 onPressed: () {},
  //                 child: Text(
  //                   S.current.btn_create.toUpperCase(),
  //                 ),
  //               )
  //             ],
  //           ),
  //           SizedBox(height: 1.h),
  //           Text(
  //             'Participants',
  //             style: TextStyle(
  //               fontFamily: kFontFamily,
  //               color: Colors.black,
  //               fontSize: 10.sp,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: 3,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemBuilder: (context, index) {
  //               return _contactRow(contacts[index]);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildList(BuildContext context) {
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
                'Add Subject',
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
                    String name = _controller.text;
                    createGroup(context, name, ref);
                  },
                  child: Text(S.current.btn_create),
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
                                ? const Icon(Icons.person)
                                : _buildImage(image, () {
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
                      Text('Group Title', style: footerTextStyle),
                      SizedBox(height: 2.w),
                      Consumer(builder: (context, ref, child) {
                        return TextField(
                          controller: _controller,
                          onSubmitted: (value) {
                            createGroup(context, value, ref);
                          },
                          decoration: inputNewGroupStyle.copyWith(
                              hintText: 'Enter group name'),
                        );
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            'Participants',
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final list = ref.watch(selectedContactProvider);
                if (list.isEmpty) {
                  return buildEmptyPlaceHolder('No Contacts');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _contactRow(list[index]);
                  },
                );
                //
                // return ref.watch(myContactsList).when(
                //       data: (list) {
                //         if (list.isEmpty) {
                //           return buildEmptyPlaceHolder('No Contacts');
                //         }
                //         return ListView.builder(
                //           shrinkWrap: true,
                //           itemCount: list.length,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemBuilder: (context, index) {
                //             return _contactRow(list[index]);
                //           },
                //         );
                //       },
                //       error: (e, t) => buildEmptyPlaceHolder('No Contacts'),
                //       loading: () => buildLoading,
                //     );
              },
            ),
            // child: GroupedListView(
            //   elements: contacts,
            //   groupBy: (element) => element.name[0],
            //   // groupComparator: (item1, item2) => item1.compareTo(item2),
            //   groupSeparatorBuilder: (String groupByValue) =>
            //       _groupHeader(groupByValue),
            //   itemBuilder: (context, ContactModel element) =>
            //       _contactRow(element),
            //   itemComparator: (item1, item2) =>
            //       item1.name.compareTo(item2.name), // optional
            //   useStickyGroupSeparators: false, // optional
            //   floatingHeader: false, // optional
            //   order: GroupedListOrder.ASC, // optional
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(File image, Function() onTap) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(3.w)),
          child: Image.file(
            image,
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
      EasyLoading.showError('Group Name can\'t be emply');
      return;
    }
    if (name.length < 3) {
      EasyLoading.showError('Group Name very short');
      return;
    }
    final list = ref.read(selectedContactProvider);
    final userIds = list.map((e) => e.userId.toString()).toList();

    final file = ref.read(selectedGroupImageProvider);
    final String url;
    if (file != null) {
      url = (await ref.read(bChatProvider).uploadImage(file)) ?? '';
    } else {
      url = '';
    }
    final group =
        await BchatGroupManager.createNewGroup(name.trim(), '', userIds, url);
    hideLoading(ref);

    if (group != null) {
      // ref.read(groupl)
      Navigator.pop(context, group);
    } else {
      AppSnackbar.instance.error(context, 'Error in creating group');
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
}
