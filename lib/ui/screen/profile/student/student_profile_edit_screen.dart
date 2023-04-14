// ignore_for_file: use_build_context_synchronously

// import 'dart:io';

import '/core/constants/colors.dart';
import '../../../dialog/image_picker_dialog.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';
import '/core/state.dart';
import '/controller/profile_providers.dart';
import '/core/utils/common.dart';
import '/ui/screens.dart';

// final updateProfilePictureProvider =
//     FutureProvider.autoDispose.family<dynamic, File?>(
//   (ref, image) async =>
//       ref.watch(loginRepositoryProvider).updateProfileImage(image),
// );

final isNameEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final isEmailEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final isPhoneNumberEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final isAgeEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final isAddressEditing = StateProvider.autoDispose<bool>(
  (ref) => false,
);

class StudentProfileEditScreen extends HookWidget {
  final Profile profile;

  const StudentProfileEditScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: profile.name);
    final emailController = useTextEditingController(text: profile.email);
    final phoneController = useTextEditingController(text: profile.phone);
    final ageController = useTextEditingController(text: profile.age);
    final addressController = useTextEditingController(text: profile.address);

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
                  padding: EdgeInsets.only(top: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.w),
                        topLeft: Radius.circular(10.w)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            "${S.current.profile_title} Detail", //didn't added throught l10n
                            style: textStyleHeading,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Name", //didn't added throught l10n
                            style: inputBoxCaptionStyle(context),
                          ),
                          TextFormField(
                            controller: nameController,
                            readOnly: !ref.watch(isNameEditing),
                            showCursor: !ref.watch(isNameEditing),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: inputDirectionStyle.copyWith(
                                hintText: profile.name,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      ref.read(isNameEditing.notifier).state =
                                          true;
                                    },
                                    child: const Icon(Icons.edit_sharp))),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Email Address", //didn't added throught l10n
                            style: inputBoxCaptionStyle(context),
                          ),
                          TextFormField(
                            controller: emailController,
                            readOnly: ref.watch(isEmailEditing) ? false : true,
                            showCursor:
                                ref.watch(isEmailEditing) ? true : false,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: inputDirectionStyle.copyWith(
                                hintText: S.current.login_email_hint,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      ref.read(isEmailEditing.notifier).state =
                                          true;
                                    },
                                    child: const Icon(Icons.edit_sharp))),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Phone Number", //didn't added throught l10n
                            style: inputBoxCaptionStyle(context),
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            readOnly:
                                ref.watch(isPhoneNumberEditing) ? false : true,
                            showCursor:
                                ref.watch(isPhoneNumberEditing) ? true : false,
                            textInputAction: TextInputAction.next,
                            decoration: inputDirectionStyle.copyWith(
                                hintText: S.current.signup_mobile_hint,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      ref
                                          .read(isPhoneNumberEditing.notifier)
                                          .state = true;
                                    },
                                    child: const Icon(Icons.edit_sharp))),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Age", //didn't added throught l10n
                            style: inputBoxCaptionStyle(context),
                          ),
                          TextFormField(
                            controller: ageController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: ref.watch(isAgeEditing) ? false : true,
                            showCursor: ref.watch(isAgeEditing) ? true : false,
                            textInputAction: TextInputAction.next,
                            decoration: inputDirectionStyle.copyWith(
                                hintText: S.current.prof_hint_age,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      ref.read(isAgeEditing.notifier).state =
                                          true;
                                    },
                                    child: const Icon(Icons.edit_sharp))),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Address", //didn't added throught l10n
                            style: inputBoxCaptionStyle(context),
                          ),
                          TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly:
                                ref.watch(isAddressEditing) ? false : true,
                            showCursor:
                                ref.watch(isAddressEditing) ? true : false,
                            textInputAction: TextInputAction.next,
                            decoration: inputDirectionStyle.copyWith(
                                hintText: S.current.prof_edit_address,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      ref
                                          .read(isAddressEditing.notifier)
                                          .state = true;
                                    },
                                    child: const Icon(Icons.edit_sharp))),
                          ),
                          SizedBox(height: 4.h),
                          ref.watch(isNameEditing) ||
                                  ref.watch(isEmailEditing) ||
                                  ref.watch(isAddressEditing) ||
                                  ref.watch(isPhoneNumberEditing) ||
                                  ref.watch(isAgeEditing)
                              ? Consumer(
                                  builder: (context, ref, child) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: elevatedButtonTextStyle,
                                        onPressed: () async {
                                          showLoading(ref);
                                          // Map userdata = {
                                          //   "name": nameController.text,
                                          //   "email": emailController.text,
                                          //   "address": addressController.text,
                                          //   "phone": phoneController.text,
                                          //   "age": ageController.text,
                                          // };
                                          final result = await ref
                                              .read(profileRepositoryProvider)
                                              .updateProfile(
                                                  nameController.text.trim(),
                                                  emailController.text.trim(),
                                                  phoneController.text.trim(),
                                                  addressController.text.trim(),
                                                  ageController.text.trim(),
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                  "");
                                          if (result == null) {
                                            AppSnackbar.instance.error(context,
                                                'Error in updating details');
                                          } else {
                                            await updateProfileData(
                                                ref, result);
                                            Navigator.pop(context, true);
                                          }
                                          // ref.read(
                                          //     updateProfileProvider(userdata));
                                          // print("click working");
                                          hideLoading(ref);
                                        },
                                        child: Text(
                                          "Save",
                                          style: elevationTextButtonTextStyle,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                        ],
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 12.5.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: getImageProvider(
                                          profile.image ?? '',
                                          maxHeight:
                                              (50.w * devicePixelRatio).round(),
                                          maxWidth: (50.w * devicePixelRatio)
                                              .round()),
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                              bottom: 0.h,
                              right: 0.w,
                              child: Visibility(
                                visible: true,
                                child: InkWell(
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
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.yellowAccent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(Icons.edit_outlined, size: 4.w),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        Text(
                          profile.name.toString(),
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 4.w,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
}
