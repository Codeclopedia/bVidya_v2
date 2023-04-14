// ignore_for_file: use_build_context_synchronously

import '/core/utils/common.dart';

import '/controller/profile_providers.dart';
import '../../../dialog/image_picker_dialog.dart';
import '../../../screens.dart';
import '/core/constants/colors.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/core/utils.dart';
import '/data/models/models.dart';

final isBioEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final isoccupationEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final islanguageEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);

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
    final occupationController =
        useTextEditingController(text: profile.occupation);
    final languageController = useTextEditingController(text: profile.language);
    final bioController = useTextEditingController(text: profile.bio);

    final nameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final phoneFocusNode = useFocusNode();
    final ageFocusNode = useFocusNode();
    final addressFocusNode = useFocusNode();
    final occupationFocusNode = useFocusNode();
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
                child: Consumer(builder: (context, ref, child) {
                  return Container(
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
                                readOnly:
                                    ref.watch(isNameEditing) ? false : true,
                                showCursor:
                                    ref.watch(isNameEditing) ? true : false,
                                validator: (value) {
                                  if (value == null || value.isEmpty == true) {
                                    return S.current.signup_fullname_empty;
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.prof_hint_name,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(isNameEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.prof_edit_email),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                readOnly:
                                    ref.watch(isEmailEditing) ? false : true,
                                showCursor:
                                    ref.watch(isEmailEditing) ? true : false,
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
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(isEmailEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.prof_edit_no),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                readOnly: ref.watch(isPhoneNumberEditing)
                                    ? false
                                    : true,
                                showCursor: ref.watch(isPhoneNumberEditing)
                                    ? true
                                    : false,
                                focusNode: phoneFocusNode,
                                validator: (value) {
                                  return null;
                                },
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.prof_hint_no,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(
                                                  isPhoneNumberEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.prof_edit_age),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                controller: ageController,
                                focusNode: ageFocusNode,
                                readOnly:
                                    ref.watch(isAgeEditing) ? false : true,
                                showCursor:
                                    ref.watch(isAgeEditing) ? true : false,
                                validator: (value) {
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.prof_hint_age,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(isAgeEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.prof_edit_address),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                validator: (value) {
                                  return null;
                                },
                                controller: addressController,
                                readOnly:
                                    ref.watch(isAddressEditing) ? false : true,
                                showCursor:
                                    ref.watch(isAddressEditing) ? true : false,
                                focusNode: addressFocusNode,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.prof_hint_add,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(isAddressEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.tpe_occupation),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                controller: occupationController,
                                textInputAction: TextInputAction.next,
                                readOnly: ref.watch(isoccupationEditing)
                                    ? false
                                    : true,
                                showCursor: ref.watch(isoccupationEditing)
                                    ? true
                                    : false,
                                validator: (value) {
                                  return null;
                                },
                                focusNode: occupationFocusNode,
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.tpe_worked_hint,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(
                                                  isoccupationEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.tpe_lang),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                controller: languageController,
                                textInputAction: TextInputAction.next,
                                readOnly:
                                    ref.watch(islanguageEditing) ? false : true,
                                showCursor:
                                    ref.watch(islanguageEditing) ? true : false,
                                focusNode: languageFocusNode,
                                validator: (value) {
                                  return null;
                                },
                                decoration: inputEditProfileStyle.copyWith(
                                    hintText: S.current.tpe_lang_hint,
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(islanguageEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            _buildCaption(S.current.tpe_bio),
                            SizedBox(height: 0.5.h),
                            TextFormField(
                                controller: bioController,
                                keyboardType: TextInputType.multiline,
                                readOnly:
                                    ref.watch(isBioEditing) ? false : true,
                                showCursor:
                                    ref.watch(isBioEditing) ? true : false,
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
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                              .read(isBioEditing.notifier)
                                              .state = true;
                                        },
                                        child: const Icon(Icons.edit_sharp)))),
                            ref.watch(isNameEditing) ||
                                    ref.watch(isEmailEditing) ||
                                    ref.watch(isAddressEditing) ||
                                    ref.watch(isPhoneNumberEditing) ||
                                    ref.watch(isAgeEditing) ||
                                    ref.watch(isBioEditing) ||
                                    ref.watch(isoccupationEditing) ||
                                    ref.watch(islanguageEditing)
                                ? Consumer(builder: (context, ref, child) {
                                    return _buildButton(() async {
                                      if (formKey.currentState?.validate() ==
                                          true) {
                                        showLoading(ref);

                                        final result = await ref
                                            .read(profileRepositoryProvider)
                                            .updateProfile(
                                                nameController.text.trim(),
                                                emailController.text.trim(),
                                                phoneController.text.trim(),
                                                addressController.text.trim(),
                                                ageController.text.trim(),
                                                bioController.text.trim(),
                                                languageController.text.trim(),
                                                occupationController.text
                                                    .trim(),
                                                "",
                                                "",
                                                "India");
                                        if (result == null) {
                                          AppSnackbar.instance.error(context,
                                              'Error in updating details');
                                        } else {
                                          await updateProfileData(ref, result);
                                          Navigator.pop(context, true);
                                        }
                                        // ref.read(
                                        //     updateProfileProvider(userdata));
                                        // print("click working");
                                        hideLoading(ref);
                                      }
                                      // Navigator.push(
                                      // context,
                                      // MaterialPageRoute(
                                      // builder: (context) => const TeacherDetail()),
                                      // );
                                    });
                                  })
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: getSvgIcon('arrow_back.svg', color: Colors.white),
              ),
              // _buildHeader(),
              UserConsumer(
                builder: (context, user, ref) {
                  return Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 4.h),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: getRectFAvatar(
                              size: 22.w,
                              user.name,
                              user.image,
                              cacheHeight: (50.w * devicePixelRatio).round(),
                              cacheWidth: (50.w * devicePixelRatio).round()),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                final pickedFile =
                                    await showImageFilePicker(context);
                                if (pickedFile != null) {
                                  final result = await ref
                                      .read(profileRepositoryProvider)
                                      .updateProfileImage(pickedFile);
                                  if (result != null) {
                                    updateUserImage(ref, result);
                                    // updateUser(ref, user);
                                    AppSnackbar.instance.message(context,
                                        'Profile image updated successfully');
                                  } else {
                                    AppSnackbar.instance.error(
                                        context, 'Error in updating image');
                                  }
                                }
                              },
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
                              ),
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

  // Widget _buildHeader() {
  //   return Container(
  //     alignment: Alignment.topCenter,
  //     margin: EdgeInsets.only(top: 3.h),
  //     child: Column(
  //       children: [
  //         Stack(
  //           children: <Widget>[
  //             SizedBox(
  //               width: 30.w,
  //               height: 14.h,
  //               child: Stack(
  //                 children: <Widget>[
  //                   Positioned(
  //                     left: 0,
  //                     right: 0,
  //                     child: Container(
  //                       height: 13.h,
  //                       width: 28.w,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0),
  //                         borderRadius: BorderRadius.all(
  //                           Radius.circular(2.3.h),
  //                         ),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         mainAxisSize: MainAxisSize.max,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           ClipRRect(
  //                               borderRadius: BorderRadius.circular(20),
  //                               child: Image.asset(
  //                                 'assets/screen_1.jpg',
  //                                 height: 12.h,
  //                                 width: 24.w,
  //                                 fit: BoxFit.fill,
  //                               )),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     right: 0,
  //                     bottom: 0,
  //                     child: Container(
  //                       height: 4.5.h,
  //                       width: 10.w,
  //                       padding: EdgeInsets.all(1.h),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(3.h)),
  //                         color: Colors.yellow,
  //                         border: Border.all(
  //                           color: Colors.white,
  //                           width: 2,
  //                         ),
  //                       ),
  //                       child: const Icon(Icons.edit),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTitle() {
    return Text(
      S.current.profile_detail,
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
