import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/core/ui_core.dart';

class FullScreenImageScreen extends StatelessWidget {
  final ChatImageMessageBody body;
  const FullScreenImageScreen({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(body.displayName ?? 'Image'),
      ),
      body: SafeArea(
        child: Center(
          child: Image(
            image: getImageProviderChatImage(body),
          ),
        ),
      ),
    );
  }
}
