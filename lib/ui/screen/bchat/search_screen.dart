// ignore_for_file: use_build_context_synchronously

import 'package:bvidya/core/helpers/bchat_contact_manager.dart';

import '../../../controller/bchat_providers.dart';
import '../../../data/models/models.dart';
import '../../base_back_screen.dart';
import '../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../widget/coloured_box_bar.dart';

class SearchScreen extends HookWidget {
  final _key = GlobalKey<FormState>();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   return (){};
    // },const []);

    return BaseWilPopupScreen(
      onBack: () async => true,
      child: Scaffold(
        body: ColouredBoxBar(
          topSize: 25.h,
          topBar: _buildTopBar(context),
          body: _buildSearchBody(context),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final controller = useTextEditingController(text: '');

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
                      onChanged: (value) {
                        ref.read(inputTextProvider.notifier).state =
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
                      decoration: searchInputDirectionStyle.copyWith(
                        suffixIcon: inputText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.text = '';
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black))
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
            Consumer(builder: (context, ref, child) {
              final result = ref.watch(searchChatContact);
              return result.when(
                  data: ((data) {
                    if (data.isEmpty) {
                      return buildEmptyPlaceHolder('No User found');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              // final result = await ref
                              //     .read(bChatProvider)
                              //     .addContact(data[index]);
                              final result = await BChatContactManager.sendRequestToAddContact(
                                  data[index].userId.toString());

                              if (result == null) {
                                AppSnackbar.instance.message(context,
                                    '${data[index].name} added successfully into Contacts');
                                // Navigator.pop(context, true);
                              } else {
                                AppSnackbar.instance
                                    .error(context, 'Error: $result');
                              }
                            },
                            child: _contactRow(data[index], ref));
                      },
                    );
                  }),
                  error: (e, t) => buildEmptyPlaceHolder('No User found'),
                  loading: () => buildLoading);
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

  Widget _contactRow(SearchContactResult contact, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(contact.name ?? '', contact.image ?? ''),
          SizedBox(width: 3.w),
          Text(
            contact.name ?? '',
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
