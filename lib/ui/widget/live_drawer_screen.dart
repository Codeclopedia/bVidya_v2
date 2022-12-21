import '../../core/ui_core.dart';
import 'base_drawer_page.dart';

class LiveDrawerScreen extends StatelessWidget {
  final Widget overlayBody;
  final Widget? baseBody;
  final String screenName;
  const LiveDrawerScreen(
      {Key? key,
      required this.overlayBody,
      this.baseBody,
      required this.screenName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerPage(
      screenName: screenName,
      body: Stack(children: [
        if (baseBody != null) baseBody!,
        overlayBody,
      ]),
    );
  }
}
