import '/core/constants.dart';
import '/core/constants/data.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../../widgets.dart';

//Mute
final groupMuteProvider = StateProvider.autoDispose<bool>(
  ((_) => true),
);

class GroupInfoScreen extends StatelessWidget {
  final GroupConversationModel currentGroup;
  final int contactId;

  static final imageSize = 28.w;
  const GroupInfoScreen({Key? key, required GroupConversationModel group, int? userId})
      : currentGroup = group,
        contactId = userId ?? 1,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ColouredBoxBar(
        topSize: 30.h,
        topBar: _topBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 3.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            _buildMuteSettings(),
            SizedBox(height: 3.h),
            _mediaSection(),
            SizedBox(height: 3.h),
            _buildGroups(),
            SizedBox(height: 5.h),
            _buildButton(
                Icons.delete_outline_rounded, S.current.grp_btx_clear, () {}),
            SizedBox(height: 1.h),
            _buildButton(Icons.exit_to_app, S.current.grp_btx_exit, () {}),
            SizedBox(height: 1.h),
            _buildButton(Icons.block, S.current.pr_btx_block, () {}),
            SizedBox(height: 1.h),
            _buildButton(Icons.thumb_down_off_alt_outlined,
                S.current.pr_btx_report, () {}),
            SizedBox(height: 1.h),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.grp_caption_participation,
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 11.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _addParticipationRow(context);
            } else {
              return _contactRow(contacts[index - 1]);
            }
          },
          itemCount: 3 + 1,
        ),
      ],
    );
  }

  Widget _addParticipationRow(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, RouteList.newGroupContacts);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 6.w,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
            // getCicleAvatar(contact.name, contact.image),
            SizedBox(width: 3.w),
            Text(
              S.current.grp_txt_add_participant,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontWeight: FontWeight.w600,
                color: AppColors.contactNameTextColor,
                fontSize: 11.sp,
              ),
            ),
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
          getCicleAvatar(contact.name, contact.image, radius: 6.w),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              contact.name,
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.contactNameTextColor,
                fontSize: 11.sp,
              ),
            ),
          ),
          if (contact.name.contains('Anil'))
            const Icon(
              Icons.person_outline,
              color: AppColors.primaryColor,
            ),
          if (contact.name.contains('Anil'))
            Text(
              'Admin',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: AppColors.primaryColor,
                fontSize: 8.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, Function() onTap) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: const Color(0xFFB70000)),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFFB70000),
              fontSize: 12.sp,
              fontFamily: kFontFamily,
            ),
          )
        ],
      ),
    );
  }

  Widget _mediaSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.pr_media_shared,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 11.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: (() {}),
              child: Text(
                S.current.pr_btx_all,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 8.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _rowImage(
                image:
                    'https://images.pexels.com/photos/1037992/pexels-photo-1037992.jpeg?auto=compress&cs=tinysrgb&w=400'),
            _rowImage(
                image:
                    'https://images.pexels.com/photos/2736613/pexels-photo-2736613.jpeg?auto=compress&cs=tinysrgb&w=400'),
            _rowImage(
                image:
                    'https://images.pexels.com/photos/583842/pexels-photo-583842.jpeg?auto=compress&cs=tinysrgb&w=400',
                last: true,
                counter: 4),
          ],
        )
      ],
    );
  }

  Widget _rowImage({String? image, bool last = false, int counter = 0}) {
    return image == null
        ? SizedBox(width: imageSize)
        : SizedBox(
            height: imageSize,
            width: imageSize,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              child: Stack(
                children: [
                  image.startsWith('http')
                      ? Image(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                        )
                      : Image(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                        ),
                  if (last && counter > 0)
                    Container(
                      color: Colors.black38,
                      child: Center(
                        child: Text(
                          '$counter+',
                          style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  Widget _buildMuteSettings() {
    return Consumer(
      builder: (context, ref, child) {
        final mute = ref.watch(groupMuteProvider);
        return InkWell(
          onTap: () {
            ref.read(groupMuteProvider.notifier).state = !mute;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.pr_mute_notification,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 11.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              mySwitch(mute, (value) {
                ref.read(groupMuteProvider.notifier).state = value;
              })
            ],
          ),
        );
      },
    );
  }

  // Widget _textValue(String value) {
  //   return Text(
  //     value,
  //     style: TextStyle(
  //       fontFamily: kFontFamily,
  //       fontSize: 11.sp,
  //       color: Colors.black,
  //     ),
  //   );
  // }

  // Widget _textCaption(String caption) {
  //   return Text(
  //     caption,
  //     style: TextStyle(
  //       fontFamily: kFontFamily,
  //       fontSize: 9.sp,
  //       color: Colors.grey,
  //     ),
  //   );
  // }

  Widget _topBar(BuildContext context) {
    return SizedBox(
      width: 100.w,
      // padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Stack(
        children: [
          Positioned(
            left: 1.w,
            top: 1.h,
            child: IconButton(
              icon: getSvgIcon('arrow_back.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  getRectFAvatar(currentGroup.groupInfo.name??'', currentGroup.image,
                      size: 20.w),
                  SizedBox(
                    height: 0.7.h,
                  ),
                  Text(
                    currentGroup.groupInfo.name??'',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteList.chatScreen, (route) => route.isFirst);
                          },
                          child: _buildIcon('icon_pr_chat.svg')),
                      _buildIcon('icon_pr_vcall.svg'),
                      _buildIcon('icon_pr_acall.svg'),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteList.search);
                        },
                        child: _buildIcon('icon_pr_search.svg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String icon) {
    return CircleAvatar(
      radius: 6.w,
      backgroundColor: AppColors.yellowAccent,
      child: getSvgIcon(icon),
    );
  }
}

//
