import 'package:bvidya/core/helpers/group_call_helper.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import '/ui/screen/blearn/components/common.dart';
import 'package:intl/intl.dart';

import '/core/helpers/call_helper.dart';
import '/core/state.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/core/sdk_helpers/bchat_call_manager.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '../../../widgets.dart';

class GroupRecentCallScreen extends StatelessWidget {
  const GroupRecentCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
        topBar: _topBar(context),
        body: _callList(),
      ),
    );
  }

  Widget _callList() {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Text(
            'Recent',
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final callList = ref.watch(groupCallListProvider);
              if (callList.isEmpty) {
                return buildEmptyPlaceHolder('No Calls');
              }
              callList.sort(
                (a, b) => b.time.compareTo(a.time),
              );
              return ListView.separated(
                itemCount: callList.length,
                itemBuilder: (context, index) {
                  return SwipeActionCell(
                    key: ObjectKey(callList[index].msgId),
                    // onTap: () async {
                    //   makeCall(callList[index], ref, context);
                    // },
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                          backgroundRadius: 3.w,
                          widthSpace: 40.w,
                          title: S.current.menu_delete,
                          performsFirstActionWithFullSwipe: true,
                          onTap: (CompletionHandler handler) async {
                            /// await handler(true) : will delete this row
                            /// And after delete animation,setState will called to
                            /// sync your data source with your UI
                            await handler(true);
                            ref
                                .read(groupCallListProvider.notifier)
                                .delete(callList[index]);
                            // list.removeAt(index);
                            // setState(() {});
                          },
                          color: AppColors.redBColor),
                      // SwipeAction(
                      //     style: TextStyle(
                      //       fontFamily: kFontFamily,
                      //       color: Colors.white,
                      //       fontSize: 12.sp,
                      //     ),
                      //     backgroundRadius: 3.w,
                      //     widthSpace: 20.w,
                      //     title: S.current.menu_call,
                      //     onTap: (CompletionHandler handler) async {
                      //       /// false means that you just do nothing,it will close
                      //       /// action buttons by default
                      //       handler(false);
                      //       await makeCall(callList[index], ref, context);
                      //     },
                      //     color: AppColors.primaryColor),
                    ],
                    child: _contactRow(callList[index], () async {
                      final item = await makeGroupCallFromHistory(
                          callList[index], ref, context);
                      setScreen(RouteList.groupCalls);
                      if (item != null) {
                        ref
                            .read(groupCallListProvider.notifier)
                            .addMessage(item);
                      }
                      // await makeGroupCall(callList[index], ref, context);
                    }),
                  );

                  // _contactRow(callList[index]);
                },
                separatorBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(GroupCallListModel model, Function() onCall) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getCicleAvatar(model.groupName, model.groupImage),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.groupName,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(
                  DateFormat('h:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(model.time))
                      .toUpperCase(),
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onCall(),
            child: getSvgIcon(model.body.callType == CallType.audio
                ? 'icon_acall.svg'
                : 'icon_vcall.svg'),
          ),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: (() => Navigator.pop(context)),
            icon: getSvgIcon('arrow_back.svg'),
          ),
          Center(
            child: Text(
              'Calls',
              style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
