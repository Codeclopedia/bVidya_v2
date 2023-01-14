import 'package:bvidya/core/utils/date_utils.dart';
import 'package:intl/intl.dart';

import '../blearn/components/common.dart';
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
              final callList = ref.watch(callListProvider);
              if (callList.isEmpty) {
                return buildEmptyPlaceHolder('No Calls');
              }
              callList.sort(
                (a, b) => b.time.compareTo(a.time),
              );
              return ListView.separated(
                itemCount: callList.length,
                itemBuilder: (context, index) {
                  return _contactRow(callList[index]);
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

  Widget _contactRow(CallListModel model) {
    final date = DateTime.fromMillisecondsSinceEpoch(model.time);
    String time = formatDateCall(date);
    // if (!DateUtils.isSameDay(date, DateTime.now())) {
    //   time = DateFormat('EE, d MMM, yyyy').format(date);
    // }
    // time += DateFormat('h:mm a')
    //     .format(DateTime.fromMillisecondsSinceEpoch(model.time))
    //     .toUpperCase();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getCicleAvatar(model.name, ''),
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
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          getSvgIcon(model.body.callType == CallType.audio
              ? 'icon_acall.svg'
              : 'icon_vcall.svg'),
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
