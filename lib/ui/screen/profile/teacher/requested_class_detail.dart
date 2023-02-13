import '/core/state.dart';
import '/data/models/response/bmeet/class_request_response.dart';

import '/core/constants/colors.dart';
import '/core/ui_core.dart';

class RequestedClassDetailScreen extends StatelessWidget {
  final PersonalClass requestedClass;
  const RequestedClassDetailScreen({super.key, required this.requestedClass});

  @override
  Widget build(BuildContext context) {
    // print(requestedClass.toJson());
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.gradientTopColor,
                AppColors.gradientLiveBottomColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 9.h),
                    padding: EdgeInsets.only(top: 12.5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          topLeft: Radius.circular(10.w)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.class_requested_title,
                                style: textStyleHeading,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),
                              Text(
                                requestedClass.studentName ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8.w,
                                    fontWeight: FontWeight.bold),
                              ),
                              ListView(
                                shrinkWrap: true,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  customTile(
                                      title: S.current.request_class_topic,
                                      data: requestedClass.topic ?? ""),
                                  customTile(
                                      title: S.current.request_class_type,
                                      data: requestedClass.type ?? ""),
                                  customTile(
                                      title:
                                          S.current.request_class_description,
                                      data: requestedClass.description ?? ""),
                                  Text(requestedClass.preferred_date_time ?? "")
                                  // customTile(
                                  //     title: S.current.preferredDate,
                                  //     data: DateFormat.yMEd().format(
                                  //         requestedClass.preferred_date_time ??
                                  //             DateTime.now())),
                                  // customTile(
                                  //     title: S.current.preferredTime,
                                  //     data: DateFormat.yMEd().format(
                                  //         requestedClass.preferred_date_time ??
                                  //             DateTime.now()))
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: elevatedButtonSecondaryStyle,
                                    child: const Text("Accept"),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Reject"),
                                    style: elevatedButtonEndStyle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: getSvgIcon('arrow_back.svg', color: Colors.white),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Container(
                      height: 12.5.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: getImageProvider(
                                  requestedClass.studentImage ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  ),
                )
                // _buildHeader(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget customTile({required String title, required String data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.w,
        ),
        Text(
          title,
          style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 5.w,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 2.w,
        ),
        Text(
          data,
          style: TextStyle(
              color: Colors.grey, fontSize: 4.w, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
