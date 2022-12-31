
import 'package:shimmer/shimmer.dart';

import '../../core/ui_core.dart';

class CustomizableShimmerTile extends StatelessWidget {
  final double height;
  final double width;
  const CustomizableShimmerTile(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: const Color.fromARGB(255, 218, 218, 218),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
