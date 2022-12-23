import 'package:intl/intl.dart';

import '/core/constants.dart';
import '/core/constants/data.dart';
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
            child: ListView.separated(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(CallModel model) {
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
                  DateFormat('h:mm a').format(model.time).toUpperCase(),
                  style: TextStyle(
                    fontFamily: kFontFamily,
                    color: AppColors.contactNameTextColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          getSvgIcon(
              model.callType == 'audio' ? 'icon_acall.svg' : 'icon_vcall.svg'),
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
