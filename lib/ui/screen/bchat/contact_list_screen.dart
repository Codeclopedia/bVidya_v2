// ignore_for_file: use_build_context_synchronously

// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:grouped_list/grouped_list.dart';

import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/utils/request_utils.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/contact_list_provider.dart';

import '/core/utils/chat_utils.dart';
import '/ui/dialog/contact_menu_dialog.dart';

import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/data/models/models.dart';
import '../blearn/components/common.dart';
import '/core/constants/colors.dart';
// import '/core/constants/data.dart';
import '/core/ui_core.dart';
import '../../widgets.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
        topBar: const BAppBar(title: 'Start New Conversation'),
        body: Consumer(
          builder: (context, ref, child) {
            final data = ref
                .watch(contactListProvider)
                .where((element) => element.status == ContactStatus.friend)
                .toList();
            if (data.isNotEmpty) {
              return _buildList(context, ref, data);
            } else {
              return buildEmptyPlaceHolder('No Contacts');
            }
            // return ref.watch(myContactsList).when(
            //     data: (data) {
            //       if (data.isNotEmpty) {
            //         return _buildList(context, ref, data);
            //       } else {
            //         return buildEmptyPlaceHolder('No Contacts');
            //       }
            //     },
            //     error: (error, t) => buildEmptyPlaceHolder('No Contacts'),
            //     loading: () => buildLoading);
          },
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Contacts> contacts) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Text(
            'My Contacts',
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: GroupedListView(
              elements: contacts,
              groupBy: (element) => element.name[0],
              // groupComparator: (item1, item2) => item1.compareTo(item2),
              groupSeparatorBuilder: (String groupByValue) =>
                  _groupHeader(groupByValue),
              itemBuilder: (context, element) {
                return InkWell(
                    onLongPress: () async {
                      final value = await showContactMenu(context, element);
                      if (value == 1) {
                        Navigator.popAndPushNamed(
                          context,
                          RouteList.contactInfo,
                          arguments: {
                            'contact': element,
                            'is_contact': true,
                          },
                        );
                      } else if (value == 2) {
                        // await deleteContact(element.userId, ref);
                        await BChatContactManager.sendRequestResponse(
                            ref,
                            element.userId.toString(),
                            element.apnToken != null,
                            element.apnToken ?? element.fcmToken,
                            ContactAction.deleteContact);
                        ref
                            .read(contactListProvider.notifier)
                            .removeContact(element.userId);
                        ref
                            .read(chatConversationProvider.notifier)
                            .removeConversation(element.userId.toString());
                        // ref
                        //     .read(chatConversationProvider)
                        //     .removedContact(element.userId);
                      }
                    },
                    onTap: (() async {
                      openChatScreen(context, element, ref);
                    }),
                    child: _contactRow(element));
              },

              itemComparator: (item1, item2) =>
                  item1.name.compareTo(item2.name), // optional
              useStickyGroupSeparators: false, // optional
              floatingHeader: false, // optional
              order: GroupedListOrder.ASC, // optional
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(Contacts contact) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.profileImage,
              cacheWidth: (100.w * devicePixelRatio).round(),
              cacheHeight: (100.w * devicePixelRatio).round()),
          SizedBox(
            width: 3.w,
          ),
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
