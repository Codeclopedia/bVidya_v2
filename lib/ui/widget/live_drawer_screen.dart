import '/core/ui_core.dart';
import 'base_drawer_page.dart';

class LiveDrawerScreen extends StatelessWidget {
  final Widget overlayBody;
  final Widget? baseBody;
  final int currentIndex;
  const LiveDrawerScreen(
      {Key? key,
      required this.overlayBody,
      required this.currentIndex,
      this.baseBody,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDrawerPage(
      currentIndex: currentIndex,
      body: Stack(children: [
        if (baseBody != null) baseBody!,
        overlayBody,
      ]),
    );
  }
}
