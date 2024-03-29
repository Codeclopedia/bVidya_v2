import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import '../blearn/components/common.dart';
import '/core/utils/date_utils.dart';
import '/core/helpers/call_helper.dart';
import '/core/state.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/core/sdk_helpers/bchat_call_manager.dart';
import '/core/constants.dart';
import '/core/ui_core.dart';
import '../../widgets.dart';

class RecentCallScreen extends StatelessWidget {
  const RecentCallScreen({Key? key}) : super(key: key);

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
      padding: EdgeInsets.only(
        left: 6.w,
        right: 6.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Text(
            S.current.recent_call_title,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final callList = ref.watch(callListProvider);
              if (callList.isEmpty) {
                return buildEmptyPlaceHolder(S.current.recent_call_no_calls);
              }
              callList.sort(
                (a, b) => b.time.compareTo(a.time),
              );
              return ListView.separated(
                itemCount: callList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SwipeActionCell(
                    key: ObjectKey(callList[index].msgId),
                    backgroundColor: Colors.white,
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
                                .read(callListProvider.notifier)
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
                      final item =
                          await makeCall(callList[index], ref, context);
                      if (item != null) {
                        ref.read(callListProvider.notifier).addMessage(item);
                      }
                      setScreen(RouteList.recentCalls);
                    }),
                  );
                },
                separatorBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(width: 18.w),
                      const Expanded(
                        child: Divider(
                          height: 1,
                          color: AppColors.dividerCall,
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

  Widget _contactRow(CallListModel model, Function() onCall) {
    final date = DateTime.fromMillisecondsSinceEpoch(model.time);
    String time = formatDateCall(date);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getCicleAvatar(model.name, model.image,
              cacheWidth: (75.w * devicePixelRatio).round(),
              cacheHeight: (75.w * devicePixelRatio).round()),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    model.outgoing
                        ? Icon(
                            Icons.call_made,
                            color: Colors.green,
                            size: 5.w,
                          )
                        : model.body.isMissedType()
                            ? Icon(
                                Icons.call_missed,
                                color: Colors.red,
                                size: 5.w,
                              )
                            : Icon(
                                Icons.call_received,
                                color: Colors.black,
                                size: 5.w,
                              ),
                    SizedBox(width: 0.5.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        color: AppColors.contactNameTextColor,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider()
          Container(
            color: const Color(0x33707070),
            height: 12.w,
            width: 1,
          ),
          SizedBox(
            width: 5.w,
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
