import '../../core/ui_core.dart';

class HeadingAppBar extends StatelessWidget {
  //
  final String title, description;

  final double titleFontSize, paddingTop, descriptionFontSize;

  const HeadingAppBar({
    Key? key,
    required this.title,
    required this.description,
    required this.paddingTop,
    required this.titleFontSize,
    required this.descriptionFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: paddingTop),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: kFontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: titleFontSize),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: kFontFamily,
                    fontWeight: FontWeight.w200,
                    fontSize: descriptionFontSize),
              ),
            ),
          ],
        ));
  }
}
