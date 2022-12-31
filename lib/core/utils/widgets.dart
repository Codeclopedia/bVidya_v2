import 'dart:io';

import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../constants.dart';
import '../ui_core.dart';

// Widget buildBText(String text) {
//   return RichText(
//       text: TextSpan(children: [
//     TextSpan(
//         text: 'b',
//         style: TextStyle(
//           fontFamily: kFontFamily,
//           color: AppColors.redBColor,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.bold,
//         )),
//     TextSpan(
//         text: text,
//         style: TextStyle(
//           fontFamily: kFontFamily,
//           color: AppColors.darkChatColor,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.bold,
//         )),
//   ]));
// }

Widget buildBText(String text, {bool chat = false}) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: 'b',
        style: TextStyle(
          fontFamily: kFontFamily,
          color: AppColors.redBColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        )),
    TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: kFontFamily,
          color: chat ? AppColors.darkChatColor : Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        )),
  ]));
}

Widget buildRatingBar(double rating) => RatingBar.builder(
      itemSize: 3.5.w,
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ignoreGestures: true,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color(0xFFF49C32),
      ),
      onRatingUpdate: (rating) {
        // print(rating);
      },
    );

ImageProvider getImageProvider(String url) {
  if (url.startsWith('http')) {
    return CachedNetworkImageProvider(url);
  } else if (url.startsWith('assets')) {
    return AssetImage(url);
  } else {
    // print('$url');
    return CachedNetworkImageProvider('$baseImageApi$url');
    // return FileImage(
    //   File(url),
    // );
  }
}

ImageProvider getImageProviderFile(String url) {
  if (url.startsWith('http')) {
    return CachedNetworkImageProvider(url);
  } else if (url.startsWith('assets')) {
    return AssetImage(url);
  } else {
    return FileImage(
      File(url),
    );
  }
}

SvgPicture getSvgIcon(String name,
        {double? width = 24.0, Color? color, double height = 24.0}) =>
    SvgPicture.asset(
      'assets/icons/svgs/$name',
      width: width,
      color: color,
      fit: BoxFit.fitWidth,
    );

Image getPngIcon(String name,
        {double? width = 24.0, Color? color, double height = 24.0}) =>
    Image.asset(
      'assets/icons/png/$name',
      width: width,
      color: color,
      fit: BoxFit.fitWidth,
    );

Widget getRectFAvatar(String name, String image, {double? size}) => Avatar(
      shape: AvatarShape.rectangle(
        size ?? 14.w,
        size ?? 14.w,
        BorderRadius.all(Radius.circular(3.w)),
      ),
      name: name,
      placeholderColors: avatarPlaceHolderColors,
      textStyle: TextStyle(
        fontFamily: kFontFamily,
        color: AppColors.contactNameTextColor,
        fontSize: 14.sp,
      ),
      sources: [
        // if (image.startsWith('http'))?
        if (image.isNotEmpty && !image.startsWith("asset"))
          GenericSource(
            getImageProvider(
                image.startsWith('http') ? image : '$baseImageApi$image'),
          ),
        // NetworkSource(Hi
        //   image.startsWith('http') ? image : '$baseImageApi$image',
        // ),
        if (image.isNotEmpty && image.startsWith("asset"))
          GenericSource(
            AssetImage(image),
          ),
      ],
    );

Widget getCicleAvatar(String name, String image, {double? radius}) => Avatar(
      shape: AvatarShape.circle(radius ?? 7.w),
      backgroundColor: const Color(0xFFF5F5F5),
      name: name,
      textStyle: TextStyle(
        fontFamily: kFontFamily,
        color: AppColors.contactNameTextColor,
        fontSize: 14.sp,
      ),
      sources: [
        if (image.isNotEmpty && !image.startsWith("asset"))
          GenericSource(
            getImageProvider(
                image.startsWith('http') ? image : '$baseImageApi$image'),
          ),

        // if (image.isNotEmpty && !image.startsWith("asset"))
        //   NetworkSource(
        //     image.startsWith('http') ? image : '$baseImageApi$image',
        //   ),
        if (image.isNotEmpty && image.startsWith("asset"))
          GenericSource(
            AssetImage(image),
          ),

        if (image.isEmpty)
          GenericSource(
            const AssetImage('assets/images/dummy_profile.png'),
          ),
      ],
      placeholderColors: avatarPlaceHolderColors,
    );

Widget mySwitch(bool value, Function(bool) onChanged) => FlutterSwitch(
      onToggle: (v) {
        onChanged(v);
      },
      value: value,
      activeColor: AppColors.primaryColor,
      inactiveColor: const Color(0xFFCCCCCC),
      toggleSize: 5.w,
      width: 14.w,
      height: 6.7.w,
    );

Widget getTwoRowSettingItem(
    String title, String desc, String icon, Function() onClick) {
  return InkWell(
    onTap: onClick,
    child: Container(
      margin: EdgeInsets.only(top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 6.w),
              CircleAvatar(
                backgroundColor: AppColors.cardWhite,
                radius: 6.w,
                child:
                    getSvgIcon(icon, width: 5.w, color: AppColors.primaryColor),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textStyleSettingTitle,
                    ),
                    Text(
                      desc,
                      style: textStyleSettingDesc,
                    ),
                  ],
                ),
              ),
              getSvgIcon(
                'arrow_right.svg',
                width: 2.w,
                color: Colors.black,
              ),
              SizedBox(width: 6.w),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 2.h),
            height: 0.5,
            color: Colors.grey[200],
          )
        ],
      ),
    ),
  );
}

Widget getTwoRowSwitchSettingItem(
  String title,
  String desc,
  String icon,
  bool checked,
  Function(bool) onChanged,
) {
  return InkWell(
    onTap: onChanged(!checked),
    child: Container(
      margin: EdgeInsets.only(top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 6.w),
              CircleAvatar(
                backgroundColor: AppColors.cardWhite,
                radius: 6.w,
                child:
                    getSvgIcon(icon, width: 5.w, color: AppColors.primaryColor),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textStyleSettingTitle,
                    ),
                    Text(
                      desc,
                      style: textStyleSettingDesc,
                    ),
                  ],
                ),
              ),
              mySwitch(checked, (value) => {onChanged(value)}),
              SizedBox(width: 6.w),
              // getSvgIcon(
              //   'arrow_right.svg',
              //   width: 2.w,
              //   color: Colors.black,
              // )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 2.h),
            height: 0.5,
            color: Colors.grey[200],
          )
        ],
      ),
    ),
  );
}
