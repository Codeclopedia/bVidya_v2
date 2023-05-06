import '/core/ui_core.dart';
import 'package:lottie/lottie.dart';

class WishListIcon extends StatefulWidget {
  final bool isWishlisted;
  final Function() ontap;
  const WishListIcon(
      {super.key, required this.isWishlisted, required this.ontap});

  @override
  State<WishListIcon> createState() => _WishListIconState();
}

class _WishListIconState extends State<WishListIcon>
    with TickerProviderStateMixin {
  late AnimationController _favoriteController;

  @override
  void initState() {
    super.initState();
    _favoriteController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.isWishlisted) {
      _favoriteController.reset();
      _favoriteController.animateTo(0.6);
    }
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      splashRadius: 30.w,
      iconSize: 15.w,
      onPressed: () async {
        if (_favoriteController.status == AnimationStatus.dismissed) {
          _favoriteController.reset();
          _favoriteController.animateTo(0.6);
        } else {
          _favoriteController.reverse();
        }
        await widget.ontap();
      },
      icon: Lottie.network(
        "https://assets2.lottiefiles.com/packages/lf20_6z3m9mpw.json",
        controller: _favoriteController,
      ),
    );
  }
}
