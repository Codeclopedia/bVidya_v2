import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

import '../../widget/coloured_box_bar.dart';
import '/core/ui_core.dart';

class PdFViewerScreen extends StatelessWidget {
  final PDFDocument document;
  const PdFViewerScreen({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColouredBoxBar(
      topSize: 25.h,
      topBar: SizedBox(
          height: 8.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: getSvgIcon('arrow_back.svg'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PDF Document',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: kFontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: IconButton(
                  icon: getSvgIcon('ic_set_share.svg', color: Colors.white),
                  onPressed: () {
                    // Navigator.pop(context);
                    // shareUserMeetContent(title, id, type)
                  },
                ),
              )
            ],
          )),
      body: Center(child: PDFViewer(document: document)),
    )
        // body: Center(child: PDFViewer(document: document)),
        );
  }
}
