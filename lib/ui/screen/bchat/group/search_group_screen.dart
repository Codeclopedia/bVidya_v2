// ignore_for_file: use_build_context_synchronously

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/controller/providers/bchat/groups_conversation_provider.dart';
import '/core/sdk_helpers/bchat_group_manager.dart';
import '/controller/bchat_providers.dart';
import '/data/models/models.dart';
import '../../../base_back_screen.dart';
import '../../blearn/components/common.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '../../../widget/coloured_box_bar.dart';

class GroupSearchScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();

  GroupSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    final controller = TextEditingController(text: '');

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
                      decoration: searchInputDirectionStyle.copyWith(
                        suffixIcon: inputText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.text = '';
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black))
                            : null,
                        hintText: 'Search Group',
                      ),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: kFontFamily,
                        color: AppColors.inputText,
                      ),
                      onChanged: (value) {
                        ref.read(inputTextProvider.notifier).state =
                            value.trim();
                      },
                      onFieldSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          ref.read(searchQueryGroupProvider.notifier).state =
                              value.trim();
                        } else {
                          ref.read(searchQueryGroupProvider.notifier).state =
                              '';
                        }
                      },
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
              S.current.search_contact_ppl,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final result = ref.watch(searchGroupProvider);
              final groups = ref.watch(groupConversationProvider);
              final contactIds = groups.map((e) => e.id).toList();
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
                        final item = data[index];
                        bool alreadyAdded = contactIds.contains(item.groupId);
                        return InkWell(
                            onTap: () async {
                              if (alreadyAdded) {
                                final GroupConversationModel element = groups
                                    .firstWhere((e) => e.id == item.groupId);
                                Navigator.pushReplacementNamed(
                                    context, RouteList.groupChatScreen,
                                    arguments: element);
                              } else {
                                final userResult = data[index];
                                final result =
                                    await BchatGroupManager.addPublicGroup(
                                        userResult.groupId);

                                if (result == null) {
                                  AppSnackbar.instance.message(context,
                                      'Added to group ${userResult.name} successfully');
                                  // Navigator.pop(context, true);
                                } else {
                                  AppSnackbar.instance.error(context, result);
                                }
                              }
                            },
                            child: _contactRow(data[index], alreadyAdded, ref));
                      },
                    );
                  }),
                  error: (e, t) => buildEmptyPlaceHolder('No User found'),
                  loading: () => buildLoading);
            }),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(ChatGroup group, bool added, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          getCicleAvatar(
              group.name ?? '', BchatGroupManager.getGroupImage(group)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              group.name ?? '',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.contactNameTextColor,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
