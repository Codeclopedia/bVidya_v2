import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:wakelock/wakelock.dart';
import '/core/state.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '/core/ui_core.dart';

class ChatVideoPlayerScreen extends HookWidget {
  final ChatVideoMessageBody body;
  ChatVideoPlayerScreen({Key? key, required this.body}) : super(key: key);

  FlickManager? flickManager;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      flickManager = FlickManager(
        videoPlayerController: body.localPath.isEmpty
            ? VideoPlayerController.network(body.remotePath!)
            : VideoPlayerController.file(File(body.localPath)),
      );
      Wakelock.enable();
      return () {
        // print('Disponse called');
        Wakelock.disable();
        flickManager?.dispose();
        flickManager = null;
      };
    }, const []);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: flickManager == null
              ? Container(
                  width: double.infinity,
                  color: Colors.black,
                  height: 30.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        'Loading',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: kFontFamily,
                            fontSize: 12.sp),
                      ),
                    ],
                  ),
                )
              : FlickVideoPlayer(flickManager: flickManager!),
        ),
      ),
    );
  }
}
