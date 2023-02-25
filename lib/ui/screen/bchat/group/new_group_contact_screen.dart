// import '/data/models/models.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/constants/agora_config.dart';
// import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/contact_list_provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:collection/collection.dart';

import '/controller/providers/contacts_select_notifier.dart';
// import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '../../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../widgets.dart';

class NewGroupContactsScreen extends StatelessWidget {
  final bool edit;
  const NewGroupContactsScreen({Key? key, this.edit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
        topBar: const BAppBar(title: 'Add New People'),
        body: Container(
          child: _buildList(context),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Consumer(builder: (context, ref, child) {
            final list = ref.watch(selectedContactProvider);
            return list.isEmpty
                ? const SizedBox.shrink()
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 4.w),
                      Text(
                        '${list.length} Contact Selected',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: elevatedButtonYellowStyle,
                        onPressed: () async {
                          if (edit) {
                            Navigator.pop(context, true);
                            return;
                          }
                          final added = await Navigator.pushNamed(
                              context, RouteList.createNewGroup);
                          if (added != null && added is ChatGroup) {
                            Navigator.pop(context, added);
                          }
                        },
                        child: Text(S.current.btn_create),
                      )
                    ],
                  );
          }),
          SizedBox(height: 1.h), //selectedContactProvider
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final list = ref
                    .read(contactListProvider)
                    .where((element) =>
                        element.userId != AgoraConfig.bViydaAdmitUserId)
                    .toList();
                // return ref.watch(myContactsList).when(
                //       data: (list) {
                if (list.isEmpty) {
                  return buildEmptyPlaceHolder('No Contacts');
                }
                final selectedList = ref.watch(selectedContactProvider);
                return GroupedListView(
                  elements: list,
                  groupBy: (element) => element.name[0],
                  groupSeparatorBuilder: (String groupByValue) =>
                      _groupHeader(groupByValue),
                  itemBuilder: (context, Contacts element) => _contactRow(
                      element,
                      selectedList.firstWhereOrNull(
                              (e) => e.userId == element.userId) !=
                          null,
                      ref),
                  itemComparator: (item1, item2) =>
                      item1.name.compareTo(item2.name), // optional
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                );

                // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: list.length,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     // return _contactRow(list[index]);
                //   },
                // );
                //   },
                //   error: (e, t) => buildEmptyPlaceHolder('No Contacts'),
                //   loading: () => buildLoading,
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(Contacts contact, bool selected, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (selected) {
          ref.read(selectedContactProvider.notifier).removeContact(contact);
        } else {
          ref.read(selectedContactProvider.notifier).addContact(contact);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            getCicleAvatar(contact.name, contact.profileImage),
            SizedBox(width: 3.w),
            Expanded(
                child: Text(
              contact.name,
              style: TextStyle(
                  fontFamily: kFontFamily,
                  color: selected
                      ? AppColors.primaryColor
                      : AppColors.contactNameTextColor,
                  fontSize: 11.sp),
            )),
            if (selected)
              const Icon(Icons.check_circle_outline,
                  color: AppColors.primaryColor)
          ],
        ),
      ),
    );
  }

  Widget _groupHeader(String title) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _topBar(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
  //     width: double.infinity,
  //     child: Stack(
  //       alignment: Alignment.centerLeft,
  //       children: [
  //         IconButton(
  //           onPressed: (() => Navigator.pop(context)),
  //           icon: getSvgIcon('arrow_back.svg'),
  //         ),
  //         Center(
  //           child: Text(
  //             'Add New People',
  //             style: TextStyle(
  //               fontFamily: kFontFamily,
  //               color: Colors.white,
  //               fontSize: 14.sp,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
