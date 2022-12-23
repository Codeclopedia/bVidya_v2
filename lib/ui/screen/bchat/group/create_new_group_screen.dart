import '/core/constants.dart';
import '/core/constants/data.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../widgets.dart';

class CreateNewGroupScreen extends HookWidget {
  const CreateNewGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   return (){};
    // },const []);

    return Scaffold(
      body: ColouredBoxBar(
        topSize: 25.h,
        topBar: const BAppBar(title: 'New Group'),
        body: _buildList(context),
      ),
    );
  }

  // Widget _buildSearchBody(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(height: 2.h),
  //           Row(
  //             mainAxisSize: MainAxisSize.max,
  //             children: [
  //               Text(
  //                 'Add Subject',
  //                 style: TextStyle(
  //                   fontFamily: kFontFamily,
  //                   color: Colors.black,
  //                   fontSize: 10.sp,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 style: elevatedButtonYellowStyle,
  //                 onPressed: () {},
  //                 child: Text(
  //                   S.current.btn_create.toUpperCase(),
  //                 ),
  //               )
  //             ],
  //           ),
  //           SizedBox(height: 1.h),
  //           Text(
  //             'Participants',
  //             style: TextStyle(
  //               fontFamily: kFontFamily,
  //               color: Colors.black,
  //               fontSize: 10.sp,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: 3,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemBuilder: (context, index) {
  //               return _contactRow(contacts[index]);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Subject',
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: elevatedButtonYellowStyle,
                onPressed: () {},
                child: Text(S.current.btn_create),
              )
            ],
          ),
          SizedBox(
            height: 12.h,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 2.w),
                SizedBox(
                  width: 9.h,
                  height: 9.h,
                  child: Stack(children: [
                    Container(
                      width: 8.h,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.person),
                    ),
                    Positioned(
                      bottom: 1.h,
                      right: 1.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: AppColors.yellowAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: Icon(Icons.add, size: 4.w),
                      ),
                    ),
                  ]),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group Title', style: footerTextStyle),
                      SizedBox(height: 2.w),
                      TextField(
                        decoration: inputNewGroupStyle.copyWith(
                            hintText: 'Enter group name'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            'Participants',
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.black,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _contactRow(contacts[index]);
              },
            ),
            // child: GroupedListView(
            //   elements: contacts,
            //   groupBy: (element) => element.name[0],
            //   // groupComparator: (item1, item2) => item1.compareTo(item2),
            //   groupSeparatorBuilder: (String groupByValue) =>
            //       _groupHeader(groupByValue),
            //   itemBuilder: (context, ContactModel element) =>
            //       _contactRow(element),
            //   itemComparator: (item1, item2) =>
            //       item1.name.compareTo(item2.name), // optional
            //   useStickyGroupSeparators: false, // optional
            //   floatingHeader: false, // optional
            //   order: GroupedListOrder.ASC, // optional
            // ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(ContactModel contact) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name, contact.image),
          SizedBox(width: 3.w),
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
}
