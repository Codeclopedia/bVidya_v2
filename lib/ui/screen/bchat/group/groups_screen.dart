import 'package:dotted_border/dotted_border.dart';

import '../../../../core/constants.dart';
import '../../../../core/ui_core.dart';
import '../../../widgets.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
          topBar: _buildTopBar(context),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(height: 2.h),
              _buttons(context),
            ],
          )),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h, top: 2.h, right: 4.w),
        child: Row(
          children: [
            IconButton(
              onPressed: (() => Navigator.pop(context)),
              icon: getSvgIcon('arrow_back.svg'),
            ),
            const Expanded(child: UserTopBar()),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(0.7.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2.w)),
                  color: AppColors.yellowAccent,
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 3.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _newGroupButton(context),
          _recentCallButton(context),
        ],
      ),
    );
  }

  Widget _newGroupButton(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primaryColor,
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.contactList);
      },
      child: Row(
        children: [
          DottedBorder(
            // radius: Radius.circular(3.5.w),
            borderType: BorderType.Circle,
            dashPattern: const [10, 4],
            strokeWidth: 3.0,
            color: AppColors.newMessageBorderColor,
            child: SizedBox(
              width: 7.w,
              height: 7.w,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            S.current.home_btx_new_group,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 10.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentCallButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteList.recentCalls);
      },
      child: Row(
        children: [
          Text(
            S.current.home_btx_recent_calls,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 10.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 1.w),
          CircleAvatar(
            backgroundColor: AppColors.yellowAccent,
            radius: 4.2.w,
            child: const Icon(Icons.call, color: Colors.white),
          )
        ],
      ),
    );
  }
}
