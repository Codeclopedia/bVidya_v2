

import '../../../../core/constants/colors.dart';
import '../../../../core/state.dart';
import '../../../../core/ui_core.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/models.dart';

class TeacherProfileEdit extends HookWidget {
  final Profile profile;
  const TeacherProfileEdit({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: profile.name);
    final emailController = useTextEditingController(text: profile.email);
    final phoneController = useTextEditingController(text: profile.phone);
    final ageController = useTextEditingController(text: profile.age);
    final addressController = useTextEditingController(text: profile.address);
    final workedAtController =
        useTextEditingController(text: profile.occupation);
    final languageController = useTextEditingController(text: profile.language);
    final bioController = useTextEditingController(text: profile.bio);

    final nameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final phoneFocusNode = useFocusNode();
    final ageFocusNode = useFocusNode();
    final addressFocusNode = useFocusNode();
    final workedAtFocusNode = useFocusNode();
    final languageFocusNode = useFocusNode();
    final bioFocusNode = useFocusNode();
    final formKey = GlobalKey<FormState>();
    useEffect(() {
      return () {};
    }, []);

    return Scaffold(
      body: Container(
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
                margin: EdgeInsets.only(top: 9.h),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.w),
                      topLeft: Radius.circular(10.w)),
                ),
                child: Container(
                  height: double.infinity,
                  margin: EdgeInsets.only(top: 7.0.h),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          _buildTitle(),
                          SizedBox(
                            height: 2.h,
                          ),
                          // _buildCaption(S.current.prof_edit_name),
                          Text(
                            S.current.prof_edit_name,
                            style: textStyleCaption,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          TextFormField(
                              controller: nameController,
                              focusNode: nameFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty == true) {
                                  return S.current.signup_fullname_empty;
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.prof_hint_name,
                              )),
                          _buildCaption(S.current.prof_edit_email),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty == true) {
                                  return S.current.fp_email_empty;
                                } else if (!isValidEmail(value)) {
                                  return S.current.fp_email_invalid;
                                }
                                return null;
                              },
                              focusNode: emailFocusNode,
                              controller: emailController,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.prof_hint_email,
                              )),
                          _buildCaption(S.current.prof_edit_no),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              focusNode: phoneFocusNode,
                              validator: (value) {
                                return null;
                              },
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.prof_hint_no,
                              )),
                          _buildCaption(S.current.prof_edit_age),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              controller: ageController,
                              focusNode: ageFocusNode,
                              validator: (value) {
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.prof_hint_age,
                              )),
                          _buildCaption(S.current.prof_edit_address),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              validator: (value) {
                                return null;
                              },
                              controller: addressController,
                              focusNode: addressFocusNode,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.prof_hint_add,
                              )),
                          _buildCaption(S.current.tpe_worked),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              controller: workedAtController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return null;
                              },
                              focusNode: workedAtFocusNode,
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.tpe_worked_hint,
                              )),
                          _buildCaption(S.current.tpe_lang),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              controller: languageController,
                              textInputAction: TextInputAction.next,
                              focusNode: languageFocusNode,
                              validator: (value) {
                                return null;
                              },
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.tpe_lang_hint,
                              )),
                          _buildCaption(S.current.tpe_bio),
                          SizedBox(height: 0.5.h),
                          TextFormField(
                              controller: bioController,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              // textInputAction: TextInputAction.done,
                              validator: (value) {
                                return null;
                              },
                              focusNode: bioFocusNode,
                              onFieldSubmitted: (value) {},
                              decoration: inputEditProfileStyle.copyWith(
                                hintText: S.current.tpe_bio_hint,
                              )),
                          _buildButton(() {
                            if (formKey.currentState?.validate() == true) {}
                            // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            // builder: (context) => const TeacherDetail()),
                            // );
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg', color: Colors.white),
              ),
              // _buildHeader(),
              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(loginRepositoryProvider).user;
                  return Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 4.h),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: getRectFAvatar(
                              size: 22.w, user?.name ?? '', user?.image ?? ''),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: AppColors.yellowAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Icon(Icons.edit,
                                  color: AppColors.primaryColor, size: 3.w),
                            )),
                        // Text(
                        //   user?.name ?? '',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12.sp,
                        //       color: Colors.black),
                        // ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 3.h),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              SizedBox(
                width: 30.w,
                height: 14.h,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 13.h,
                        width: 28.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(2.3.h),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/screen_1.jpg',
                                  height: 12.h,
                                  width: 24.w,
                                  fit: BoxFit.fill,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 4.5.h,
                        width: 10.w,
                        padding: EdgeInsets.all(1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.h)),
                          color: Colors.yellow,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      S.current.prof_edit_title,
      style: textStyleSettingHeading,
    );
  }

  Widget _buildCaption(String value) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Text(
        value,
        style: textStyleCaption,
      ),
    );
  }

  Widget _buildButton(Function() onClick) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      height: 6.h,
      width: 100.w,
      child: ElevatedButton(
          style: elevatedButtonStyle,
          onPressed: onClick,
          child: Text(S.current.prof_save_btn
              // style: TextStyle(
              //   fontSize: 16.sp,
              //   fontFamily: kFontFamily,
              // )
              )),
    );
  }
}

// InputDecoration get inputEditProfileStyle => InputDecoration(
//       suffixIcon: const Padding(
//         padding: EdgeInsets.all(12.0),
//         child: Icon(Icons.edit, size: 20),
//       ),
//       hintStyle: const TextStyle(
//         color: Colors.grey,
//       ),
//       filled: true,
//       fillColor: Colors.grey[100],
//       enabledBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12.0)),
//         borderSide: BorderSide(color: Colors.grey, width: 1),
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         borderSide: BorderSide(color: AppColors.gradientTopColor, width: 1),
//       ),
//     );
