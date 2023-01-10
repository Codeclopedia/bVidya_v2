// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:bvidya/core/utils/chat_utils.dart';

import '../../dialog/contact_menu_dialog.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';

import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '../../base_back_screen.dart';
import '../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../widget/coloured_box_bar.dart';

class SearchScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   registerForContact('search_screen', null);
    //   return () {
    //     unregisterForContact('search_screen');
    //   };
    // }, const []);

    return BaseWilPopupScreen(
      onBack: () async => true,
      child: Scaffold(
        body: ColouredBoxBar(
          topSize: 25.h,
          topBar: _buildTopBar(context),
          body: _buildSearchBody(context),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final controller = TextEditingController(text: '');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: getSvgIcon('arrow_back.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Center(
              child: SizedBox(
                width: 85.w,
                child: Consumer(
                  builder: (context, ref, child) {
                    final inputText = ref.watch(inputTextProvider);
                    return TextFormField(
                      controller: controller,
                      decoration: searchInputDirectionStyle.copyWith(
                        suffixIcon: inputText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.text = '';
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black))
                            : null,
                        hintText: 'Search Person',
                      ),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: kFontFamily,
                        color: AppColors.inputText,
                      ),
                      onChanged: (value) {
                        ref.read(inputTextProvider.notifier).state =
                            value.trim();
                      },
                      onFieldSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          ref.read(searchQueryProvider.notifier).state =
                              value.trim();
                        } else {
                          ref.read(searchQueryProvider.notifier).state = '';
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              S.current.search_contact_ppl,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final result = ref.watch(searchChatContact);
              final contacts = ref.watch(
                  chatConversationProvider.select((value) => value.contacts));
              final contactIds = contacts.map((e) => e.userId).toList();
              return result.when(
                  data: ((data) {
                    if (data.isEmpty) {
                      return buildEmptyPlaceHolder('No User found');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        bool alreadyAdded = contactIds.contains(item.userId!);
                        return InkWell(
                            onLongPress: () async {
                              final value = await showSearchMenu(
                                  context, item, alreadyAdded);
                              if (value == 0) {
                                final result = await BChatContactManager
                                    .sendRequestToAddContact(
                                        item.userId.toString());
                                if (result == null) {
                                  AppSnackbar.instance.message(context,
                                      'Request sent to ${item.name} successfully');
                                } else {
                                  AppSnackbar.instance.error(context, result);
                                }
                              } else if (value == 1) {
                                final Contacts contact =
                                    contacts.firstWhereOrNull(
                                            (e) => e.userId == item.userId!) ??
                                        Contacts(
                                            userId: item.userId!,
                                            name: item.name!,
                                            email: item.email,
                                            phone: item.phone,
                                            profileImage: item.image!);
                                Navigator.popAndPushNamed(
                                  context,
                                  RouteList.contactInfo,
                                  arguments: {
                                    'contact': contact,
                                    'is_contact': alreadyAdded
                                  },
                                );
                              } else if (value == 2) {
                                ref
                                    .read(chatConversationProvider)
                                    .removedContact(item.userId!);
                              } else {}
                            },
                            onTap: () async {
                              if (alreadyAdded) {
                                final Contacts element = contacts.firstWhere(
                                    (e) => e.userId == item.userId!);
                                try {
                                  openChatScreen(context, element, ref);
                                  // final conv = await ChatClient
                                  //     .getInstance.chatManager
                                  //     .getConversation(
                                  //         element.userId.toString(),
                                  //         type: ChatConversationType.Chat);

                                  // if (conv != null) {
                                  //   ConversationModel model = ConversationModel(
                                  //     id: element.userId.toString(),
                                  //     badgeCount: await conv.unreadCount(),
                                  //     contact: element,
                                  //     conversation: conv,
                                  //     lastMessage: await conv.latestMessage(),
                                  //   );
                                  //   ref
                                  //       .read(chatConversationProvider.notifier)
                                  //       .addOrUpdateConversation(model);

                                  //   Navigator.pushReplacementNamed(
                                  //       context, RouteList.chatScreen,
                                  //       arguments: model);
                                  // }
                                } catch (e) {
                                  debugPrint(
                                      'Error in starting new chat of ${item.name}');
                                }
                              } else {
                                // final userResult = data[index];
                                // final result = await ref
                                //     .read(bChatProvider)
                                //     .addContact(userResult);
                                final result = await BChatContactManager
                                    .sendRequestToAddContact(
                                        item.userId.toString());

                                if (result == null) {
                                  // AppSnackbar.instance.message(context,
                                  //     '${data[index].name} added as your contact successfully');
                                  // ref.read(chatConversationProvider).addContact(
                                  //     userResult.userId!.toString());
                                  AppSnackbar.instance.message(context,
                                      'Request sent to ${item.name} successfully');
                                  // Navigator.pop(context, true);
                                } else {
                                  AppSnackbar.instance.error(context, result);
                                }
                              }
                            },
                            child: _contactRow(data[index], alreadyAdded, ref));
                      },
                    );
                  }),
                  error: (e, t) => buildEmptyPlaceHolder('No User found'),
                  loading: () => buildLoading);
            }),
            // SizedBox(height: 3.h),
            // Text(
            //   'Group Chat',
            //   style: TextStyle(
            //     fontFamily: kFontFamily,
            //     color: Colors.black,
            //     fontSize: 10.sp,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // ListView.builder(
            //   itemCount: 3,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return _contactRow(contacts[index]);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(SearchContactResult contact, bool added, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name ?? '', contact.image ?? ''),
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
}
