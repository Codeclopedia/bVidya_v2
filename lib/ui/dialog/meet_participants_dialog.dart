import 'package:agora_rtm/agora_rtm.dart';

import '/controller/bmeet_providers.dart';
import '/controller/providers/bmeet_provider.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';

class MeetParticipantsDialog extends StatelessWidget {
  final bool isHost;
  const MeetParticipantsDialog({Key? key, required this.isHost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(bMeetCallChangeProvider);
      return Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        padding: EdgeInsets.only(top: 1.h, bottom: 3.h, left: 4.w, right: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.w),
            topRight: Radius.circular(3.w),
          ),
          color: Colors.black,
        ),
        child: Column(children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg'),
              ),
              Text(
                S.current.grp_caption_participation,
                style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 40.h,
            child: SingleChildScrollView(
              // constraints: BoxConstraints(minHeight: 40.h),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                itemCount: provider.memberList.length,
                itemBuilder: (context, index) {
                  return _buildMember(
                      context, provider, provider.memberList[index]);
                },
              ),
            ),
          ),
        ]),
      );
    });
  }

  Widget _buildMember(
      BuildContext context, BMeetProvider provider, AgoraRtmMember member) {
    final split = member.userId.split(':');
    String name = split[1];
    String id = split[0];
    final ConnectedUserInfo? info = provider.userList[id];
    bool isMe = provider.localUid?.toString() == id;
    bool isVideo = info?.enabledVideo ?? true;
    bool isMute = info?.muteAudio ?? false;
    return Container(
      height: 10.h,
      padding: EdgeInsets.all(2.w),
      child: Row(
        children: [
          getCicleAvatar(info?.name ?? name, ''),
          SizedBox(width: 3.w),
          Text(
            isMe ? S.current.bmeet_user_you : name,
            style: TextStyle(
              fontFamily: kFontFamily,
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Visibility(
            visible: isHost,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    provider.sendPeerMessage(
                        member.userId, isMute ? 'mic_on' : 'mic_off');
                  },
                  child: getSvgIcon(
                      isMute ? 'vc_mic_off.svg' : 'vc_mic_off.svg',
                      width: 6.w),
                ),
                SizedBox(width: 3.w),
                InkWell(
                  onTap: () {
                    provider.sendPeerMessage(
                        id, isVideo ? 'videocam_off' : 'videocam_on');
                  },
                  child: getSvgIcon(
                      isVideo ? 'vc_video_off.svg' : 'vc_video_on.svg',
                      width: 6.w),
                ),
                SizedBox(width: 3.w),
                InkWell(
                  onTap: isMe
                      ? null
                      : () {
                          provider.sendPeerMessage(member.userId, 'remove');
                        },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                        color: isMe ? Colors.grey : AppColors.redBColor,
                        borderRadius: BorderRadius.all(Radius.circular(1.5.w))),
                    // style: elevatedButtonEndStyle,
                    // onPressed: () {
                    //   provider.sendPeerMessage(id, 'remove');
                    // },
                    child: Text(
                      S.current.btn_remove,
                      style: TextStyle(fontSize: 8.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
