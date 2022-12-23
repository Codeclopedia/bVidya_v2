import '/core/constants.dart';
import '/core/constants/data.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../widget/coloured_box_bar.dart';

class SearchScreen extends HookWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   return (){};
    // },const []);

    return Scaffold(
      body: ColouredBoxBar(
        topSize: 25.h,
        topBar: _buildTopBar(context),
        body: _buildSearchBody(context),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final controller = useTextEditingController(text: '');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
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
                    onChanged: (value) {
                      ref.read(inputTextProvider.notifier).state = value.trim();
                    },
                    decoration: searchInputDirectionStyle.copyWith(
                      suffixIcon: inputText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.text = '';
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.black))
                          : null,
                      hintText: 'Search Person or Group',
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
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
              'People',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _contactRow(contacts[index]);
              },
            ),
            SizedBox(height: 3.h),
            Text(
              'Group Chat',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _contactRow(contacts[index]);
              },
            ),
            // GroupedListView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
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
          ],
        ),
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
