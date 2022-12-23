import '/core/ui_core.dart';

import '../widgets.dart';
import 'base_drawer_page.dart';

class BaseDrawerAppBarScreen extends StatelessWidget {
  //
  final Widget topBar;
  final Widget body;
  final String routeName;

  const BaseDrawerAppBarScreen(
      {super.key,
      required this.topBar,
      required this.body,
      required this.routeName});

  @override
  Widget build(BuildContext context) {
    return BaseDrawerPage(
      screenName: routeName,
      body: ColouredBoxBar(
        topBar: topBar,
        // home: true,
        body: Stack(
          children: [
            body,
          ],
        ),
      ),
    );
  }
}
