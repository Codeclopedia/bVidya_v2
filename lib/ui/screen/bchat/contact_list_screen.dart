import 'package:grouped_list/grouped_list.dart';

import '/core/constants/colors.dart';
import '/core/constants/data.dart';
import '/core/ui_core.dart';
import '../../widgets.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColouredBoxBar(
        topBar: const BAppBar(title: 'Add New People'),
        body: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Text(
            'My Contact',
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
              itemBuilder: (context, ContactModel element) =>
                  _contactRow(element),
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

  Widget _contactRow(ContactModel contact) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.image),
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
              'Add New People',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
