import '/core/constants.dart';
import '/core/ui_core.dart';
import '../../widgets.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColouredBoxBar(
      topBar: const BAppBar(title: 'Subjects'),
      body: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 20,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 1.w,
              childAspectRatio: 0.85),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteList.bLearnCoursesList);
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(width: 18.w),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      width: 45.w,
                      height: 45.w,
                      child: Image(
                          image: getImageProvider(
                              'assets/images/dummy_profile.png')),
                    ),
                    Text(
                      'Subject Name',
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.black,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
