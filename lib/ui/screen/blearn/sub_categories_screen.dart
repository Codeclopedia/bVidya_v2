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
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 4.w,
          childAspectRatio: 0.295.w,
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
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: AppColors.inputHintText.withOpacity(0.07),
                    blurRadius: 1.w,
                    spreadRadius: 1.w, //New
                    offset: Offset(0, 1.w))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(2.w)),
                child: SizedBox(
                  height: 32.5.w,
                  width: 40.w,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image(
                        image: getImageProvider(
                            item.image ?? 'assets/images/dummy_profile.png',
                            maxHeight: (60.w * devicePixelRatio).round(),
                            maxWidth: (60.w * devicePixelRatio).round())),
                  ),
                ),
              ),
              SizedBox(
                height: 1.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text(
                    item.name ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 1,
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
