// ignore_for_file: use_build_context_synchronously

import 'package:shimmer/shimmer.dart';

import '/core/constants/agora_config.dart';
import '/core/utils.dart';
import '/core/utils/request_utils.dart';
import '/data/services/fcm_api_service.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/contact_list_provider.dart';
import '/ui/dialog/add_contact_dialog.dart';
import 'package:collection/collection.dart';
import '/core/utils/chat_utils.dart';

import '../../dialog/contact_menu_dialog.dart';
// import '/controller/providers/bchat/chat_conversation_provider.dart';
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
        // resizeToAvoidBottomInset: false,
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
                                  ref.read(searchQueryProvider.notifier).state =
                                      '';
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
                        ref.read(searchQueryProvider.notifier).state =
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
            SizedBox(height: 3.h),
            Text(
              S.current.search_contact_ppl,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black,
                fontSize: 17.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final result = ref.watch(searchChatContact);
              // final result = ref.watch(inputTextProvider) == ''
              //     ? null
              //     : ref.watch(searchChatContactProvider(
              //         ref.watch(inputTextProvider).trim()));
              final contacts = ref
                  .watch(contactListProvider)
                  .where((element) => element.status == ContactStatus.friend);
              final contactIds = contacts.map((e) => e.userId).toList();
              if (ref.watch(searchQueryProvider) == "") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.w),
                    Center(
                      child: Text(
                        "Search any user through name, email address, phone number.",
                        textAlign: TextAlign.center,
                        style: textStyleBlack.copyWith(
                            color: Colors.grey,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                );
              }
              return result.when(
                  data: ((data) {
                    if (data.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50.w),
                          Center(
                            child: Text(
                              "No User Found.",
                              style: textStyleBlack.copyWith(
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      );
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
                                _addContactSendRequest(ref, context, item);
                              } else if (value == 1) {
                                final Contacts contact =
                                    contacts.firstWhereOrNull(
                                            (e) => e.userId == item.userId!) ??
                                        Contacts(
                                            userId: item.userId!,
                                            name: item.name!,
                                            email: item.email,
                                            status: alreadyAdded
                                                ? ContactStatus.friend
                                                : ContactStatus.none,
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
                                final Contacts element = contacts.firstWhere(
                                    (e) => e.userId == item.userId!);
                                try {
                                  await BChatContactManager.sendRequestResponse(
                                      ref,
                                      element.userId.toString(),
                                      element.fcmToken!,
                                      ContactAction.deleteContact);
                                  ref
                                      .read(contactListProvider.notifier)
                                      .removeContact(element.userId);
                                  ref
                                      .read(chatConversationProvider.notifier)
                                      .removeConversation(
                                          element.userId.toString());
                                } catch (e) {
                                  debugPrint(
                                      'Error in starting new chat of ${item.name}');
                                }
                                // await deleteContact(item.userId!, ref);
                                // ref
                                //     .read(chatConversationProvider)
                                //     .removedContact(item.userId!);
                              } else {}
                            },
                            onTap: () async {
                              if (alreadyAdded) {
                                final Contacts element = contacts.firstWhere(
                                    (e) => e.userId == item.userId!);
                                try {
                                  openChatScreen(context, element, ref);
                                } catch (e) {
                                  debugPrint(
                                      'Error in starting new chat of ${item.name}');
                                }
                              } else {
                                _addContactSendRequest(ref, context, item);
                                // final userResult = data[index];
                                // final result = await ref
                                //     .read(bChatProvider)
                                //     .addContact(userResult);
                                // showLoading(ref);
                                // final result = await BChatContactManager
                                //     .sendRequestToAddContact(
                                //         item.userId.toString());

                                // if (result == null) {
                                //   AppSnackbar.instance.message(context,
                                //       'Request sent to ${item.name} successfully');
                                //   final contacts = await ref
                                //           .read(bChatProvider)
                                //           .getContactsByIds(
                                //               item.userId.toString()) ??
                                //       [];
                                //   if (contacts.isNotEmpty) {
                                //     openChatScreen(context, contacts[0], ref,
                                //         sendInviateMessage: true);
                                //   }

                                //   // AppSnackbar.instance.message(context,
                                //   //     '${data[index].name} added as your contact successfully');
                                //   // ref.read(chatConversationProvider).addContact(
                                //   //     userResult.userId!.toString());

                                //   // Navigator.pop(context, true);
                                // } else {
                                //   hideLoading(ref);
                                //   AppSnackbar.instance.error(context, result);
                                // }
                              }
                            },
                            child: _contactRow(data[index], alreadyAdded, ref));
                      },
                    );
                  }),
                  error: (e, t) => buildEmptyPlaceHolder('No User found'),
                  loading: () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 1.w),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.4),
                                highlightColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.4),
                                  radius: 7.w,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.white,
                                child: Container(
                                  height: 15.w,
                                  width: 60.w,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
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

  _addContactSendRequest(
      WidgetRef ref, BuildContext context, SearchContactResult item) async {
    final input = await showAddContactDialog(context, item.userId!, item.name!);
    if (input == null) {
      return;
    }

    showLoading(ref);
    final result = await BChatContactManager.sendRequestToAddContact(
        item.userId.toString(), input);

    if (result == null) {
      AppSnackbar.instance
          .message(context, 'Request sent to ${item.name} successfully');
      final contacts = await ref
              .read(bChatProvider)
              .getContactsByIds(item.userId.toString()) ??
          [];
      if (contacts.isNotEmpty && AgoraConfig.autoAcceptContact) {
        openChatScreen(context,
            Contacts.fromContact(contacts[0], ContactStatus.sentInvite), ref,
            sendInviateMessage: true, message: input);
      } else {
        hideLoading(ref);
        ref.read(contactListProvider.notifier).addNewContact(
            Contacts.fromContact(contacts[0], ContactStatus.sentInvite));
        User? me = await getMeAsUser();
        if (me != null) {
          await FCMApiService.instance.pushContactAlert(
            contacts[0].fcmToken!,
            me.id.toString(),
            item.userId.toString(),
            '${me.name} sent you request',
            input,
            ContactAction.sendRequestContact,
          );
        }
      }
    } else {
      hideLoading(ref);
      AppSnackbar.instance.error(context, result);
    }
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
