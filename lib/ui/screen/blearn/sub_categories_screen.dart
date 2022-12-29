import '/controller/blearn_providers.dart';
import '/core/constants.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '../../widgets.dart';
import 'components/common.dart';

class SubCategoriesScreen extends StatelessWidget {
  final Category category;
  const SubCategoriesScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColouredBoxBar(
      topBar: BAppBar(title: category.name ?? 'Sub Categories'),
      body: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Consumer(
          builder: (context, ref, child) {
            String id = category.id.toString();
            return ref.watch(bLearnSubCategoriesProvider(id)).when(
                data: (data) {
                  if (data?.subcategories?.isNotEmpty == true) {
                    return _buildSubCategories(context, data!.subcategories!);
                  } else {
                    return buildEmptyPlaceHolder('No Sub Categories Found!!');
                  }
                },
                error: (error, stackTrace) {
                  return buildEmptyPlaceHolder(error.toString());
                },
                loading: () => buildLoading);
          },
        ),
      ),
    );
  }

  _buildSubCategories(BuildContext context, List<SubCategory> subCategories) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: subCategories.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 1.w,
          childAspectRatio: 1),
      itemBuilder: (context, index) {
        SubCategory item = subCategories[index];

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteList.bLearnCoursesList,
                arguments: item);
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.chatInputBackground,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(width: 18.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    width: 40.w,
                    height: 40.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image(
                            image: getImageProvider(item.image ??
                                'assets/images/dummy_profile.png')),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Text(
                      item.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
