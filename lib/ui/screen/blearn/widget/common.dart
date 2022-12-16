import '../../../../core/ui_core.dart';

Widget get buildLoading => const Center(
      child: CircularProgressIndicator(),
    );

Widget buildEmptyPlaceHolder(String text) => Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: kFontFamily,
          color: Colors.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
