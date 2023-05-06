import 'package:shared_preferences/shared_preferences.dart';

import '/controller/providers/bchat/contact_list_provider.dart';
import '/core/constants/colors.dart';
import '/ui/widget/sliding_tab.dart';

import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils/request_utils.dart';
import '/data/models/models.dart';
import '../../base_back_screen.dart';
import '../../widgets.dart';
// import '../blearn/components/common.dart';

final requestTabIndexProvider = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);

class FriendRequestsScreen extends HookConsumerWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColouredBoxBar(
      topBar: _topBar(context, ref),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.w),
            Text(
              S.current.requests,
              style: textStyleCaption.copyWith(fontSize: 16.5.sp),
            ),
            SizedBox(height: 3.w),
            Center(
              child: SlidingTab(
                label1: S.current.request_sent,
                label2: S.current.request_recv,
                selectedIndex: ref.watch(requestTabIndexProvider),
                callback: (p0) {
                  ref.read(requestTabIndexProvider.notifier).state = p0;
                },
              ),
            ),
            SizedBox(height: 4.w),
            ref.watch(requestTabIndexProvider) == 0
                ? requestSent()
                : requestReceived()
          ],
        ),
      ),
    );
  }

  seenRequest() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('newRequestNotification', false);
  }

  Widget requestSent() {
    return Consumer(
      builder: (context, ref, child) {
        final data = ref
            .watch(contactListProvider)
            .where((element) => element.status == ContactStatus.sentInvite)
            .toList();
        if (data.isEmpty) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: 30.w),
                Icon(Icons.supervised_user_circle_rounded,
                    color: AppColors.inputHintText, size: 10.w),
                SizedBox(height: 2.w),
                Text(
                  S.current.no_request,
                  style:
                      textStyleBlack.copyWith(color: AppColors.inputHintText),
                )
              ],
            ),
          );
        }
        print("image of contact is : ${data[0].profileImage}");

        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final user = data[index];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        getCicleAvatar(user.name, user.profileImage,
                            cacheWidth: (75.w * devicePixelRatio).round(),
                            cacheHeight: (75.w * devicePixelRatio).round()),
                        SizedBox(width: 2.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style:
                                  textStyleHeading.copyWith(fontSize: 12.5.sp),
                            ),
                            SizedBox(height: 0.5.w),
                            Text(
                              user.role?.toUpperCase() ?? "",
                              style: textStyleHeading.copyWith(
                                  fontSize: 6.sp,
                                  color: AppColors.inputHintText),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(color: Color.fromARGB(153, 74, 73, 73)),
              ],
            );
          },
        );
      },
    );
  }

  Widget requestReceived() {
    seenRequest();
    return Consumer(
      builder: (context, ref, child) {
        final data = ref
            .watch(contactListProvider)
            .where((element) => element.status == ContactStatus.invited)
            .toList();
        if (data.isEmpty) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: 30.w),
                Icon(Icons.supervised_user_circle_rounded,
                    color: AppColors.inputHintText, size: 10.w),
                SizedBox(height: 2.w),
                Text(
                  S.current.no_request,
                  style:
                      textStyleBlack.copyWith(color: AppColors.inputHintText),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final user = data[index];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        getCicleAvatar(user.name, user.profileImage,
                            cacheWidth: (75.w * devicePixelRatio).round(),
                            cacheHeight: (75.w * devicePixelRatio).round()),
                        SizedBox(width: 2.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style:
                                  textStyleHeading.copyWith(fontSize: 12.5.sp),
                            ),
                            SizedBox(height: 0.5.w),
                            Text(
                              user.role?.toUpperCase() ?? "",
                              style: textStyleHeading.copyWith(
                                  fontSize: 6.sp,
                                  color: AppColors.inputHintText),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            showLoading(ref);

                            await BChatContactManager.sendRequestResponse(
                                ref,
                                user.userId.toString(),
                                user.apnToken != null,
                                user.apnToken ?? user.fcmToken,
                                ContactAction.declineRequest);

                            ref
                                .read(contactListProvider.notifier)
                                .removeContact(user.userId);
                            ref
                                .read(chatConversationProvider.notifier)
                                .removeConversation(user.userId.toString());
                            hideLoading(ref);
                            // snackBar?.remove();
                            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 7.w,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        InkWell(
                          onTap: () async {
                            showLoading(ref);
                            await BChatContactManager.sendRequestResponse(
                                ref,
                                user.userId.toString(),
                                user.apnToken != null,
                                user.apnToken ?? user.fcmToken,
                                ContactAction.acceptRequest);
                            final contacts = await ref
                                .read(contactListProvider.notifier)
                                .addContact(user.userId, ContactStatus.friend);
                            if (contacts != null) {
                              await ref
                                  .read(chatConversationProvider.notifier)
                                  .addConversationByContact(contacts);
                            }
                            hideLoading(ref);
                            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Icon(
                            Icons.check_circle_outline_sharp,
                            color: Colors.green,
                            size: 7.w,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const Divider(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _topBar(BuildContext context, WidgetRef ref) {
    // final value = ref.watch(onlineStatusProvier);

    return UserConsumer(builder: (context, user, ref) {
      return Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: getSvgIcon('arrow_back.svg', width: 6.w),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w, top: 1.h, bottom: 1.h),
                  child: Row(
                    children: [
                      getRectFAvatar(
                        user.name,
                        user.image,
                        cacheHeight: (40.w * devicePixelRatio).round(),
                        cacheWidth: (40.w * devicePixelRatio).round(),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: kFontFamily,
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
