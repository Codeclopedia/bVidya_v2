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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: subCategories.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 1.w,
        ),
        itemBuilder: (context, index) {
          SubCategory item = subCategories[index];

          return subCategoriesTile(context, item);
        },
      ),
    );
  }

  Widget subCategoriesTile(BuildContext context, SubCategory item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteList.bLearnCoursesList,
            arguments: item);
      },
      child: Center(
        child: Container(
          width: 45.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              color: AppColors.chatInputBackground,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(width: 18.w),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
                child: SizedBox(
                  height: 32.5.w,
                  width: 40.w,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image(
                        image: getImageProvider(
                            item.image ?? 'assets/images/dummy_profile.png')),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text(
                    item.name ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
