import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:avatars/avatars.dart';
import '/app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lottie/lottie.dart';

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

final devicePixelRatio =
    MediaQuery.of(navigatorKey.currentContext!).devicePixelRatio;

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

ImageProvider getImageProvider(String url,
    {int maxWidth = 100, int maxHeight = 100}) {
  if (url.startsWith('http')) {
    return CachedNetworkImageProvider(url,
        maxHeight: maxHeight, maxWidth: maxWidth);
  } else if (url.startsWith('assets')) {
    return AssetImage(url);
  } else {
    // print('$url');
    return CachedNetworkImageProvider('$baseImageApi$url',
        maxHeight: maxHeight, maxWidth: maxWidth);
    // return FileImage(
    //   File(url),
    // );
  }
}

ImageProvider getImageProviderFile(String url,
    {int maxHeight = 100, int maxWidth = 100}) {
  if (url.startsWith('http')) {
    return CachedNetworkImageProvider(url,
        maxHeight: maxHeight, maxWidth: maxWidth);
  } else if (url.startsWith('assets')) {
    return AssetImage(url);
  } else {
    return FileImage(File(url));
  }
}

ImageProvider getImageProviderChatImage(ChatImageMessageBody body,
    {bool loadThumbFirst = true, int maxHeight = 100, int maxWidth = 100}) {
  // print('thumbnailLocalPath:${body.thumbnailLocalPath}');
  // print('localPath:${body.localPath}');
  // print('thumbnailRemotePath:${body.thumbnailRemotePath}');
  // print('remotePath:${body.remotePath}');
  if (body.thumbnailLocalPath?.isNotEmpty == true && loadThumbFirst) {
    File f = File(body.thumbnailLocalPath!);
    if (f.existsSync()) {
      return FileImage(f);
    }
  }
  if (body.localPath.isNotEmpty) {
    File f = File(body.localPath);
    if (f.existsSync()) {
      return FileImage(f);
    }
  }
  if (body.thumbnailRemotePath?.isNotEmpty == true && loadThumbFirst) {
    return CachedNetworkImageProvider(body.thumbnailRemotePath!,
        maxHeight: maxHeight, maxWidth: maxWidth);
  }
  if (body.remotePath?.isNotEmpty == true) {
    return CachedNetworkImageProvider(body.remotePath!,
        maxHeight: maxHeight, maxWidth: maxWidth);
  }
  // return CachedNetworkImageProvider(body.remotePath!);

  return CachedNetworkImageProvider(
      'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg',
      maxHeight: maxHeight,
      maxWidth: maxWidth);
}

ImageProvider getImageProviderChatVideo(ChatVideoMessageBody body,
    {int maxHeight = 663, int maxWidth = 633}) {
  if (body.thumbnailLocalPath?.isNotEmpty == true) {
    return FileImage(
      File(body.thumbnailLocalPath!),
    );
  }
  // if (body.localPath.isNotEmpty) {
  //   return FileImage(
  //     File(body.localPath),
  //   );
  // }
  if (body.thumbnailRemotePath?.isNotEmpty == true) {
    return CachedNetworkImageProvider(body.thumbnailRemotePath!,
        maxHeight: maxHeight, maxWidth: maxWidth);
  }
  return CachedNetworkImageProvider(
      'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg',
      maxHeight: maxHeight,
      maxWidth: maxWidth);
  // final lo
  // if (url.startsWith('http')) {
  //   return CachedNetworkImageProvider(url);
  // } else if (url.startsWith('assets')) {
  //   return AssetImage(url);
  // } else {
  //   return FileImage(
  //     File(url),
  //   );
  // }
}

SvgPicture getSvgIcon(String name,
        {double? width = 24.0,
        Color? color,
        double height = 24.0,
        BoxFit fit = BoxFit.fitWidth}) =>
    SvgPicture.asset(
      'assets/icons/svgs/$name',
      width: width,
      color: color,
      fit: fit,
    );

Image getPngIcon(String name,
        {double? width = 24.0,
        Color? color,
        double height = 24.0,
        int cacheWidth = 57,
        int cacheHeight = 57}) =>
    Image.asset(
      'assets/icons/png/$name',
      width: width,
      color: color,
      cacheHeight: (cacheHeight * devicePixelRatio).round(),
      cacheWidth: (cacheWidth * devicePixelRatio).round(),
      fit: BoxFit.fitWidth,
    );

Image getPngImage(String name,
        {double? width = 24.0,
        Color? color,
        double height = 24.0,
        BoxFit fit = BoxFit.fitWidth,
        int cacheWidth = 100,
        int cacheHeight = 100}) =>
    Image.asset(
      'assets/images/$name',
      width: width,
      color: color,
      fit: fit,
      cacheHeight: (cacheHeight * devicePixelRatio).round(),
      cacheWidth: (cacheWidth * devicePixelRatio).round(),
    );

Widget getLottieIcon(
  String name, {
  double? width = 24.0,
  Color? color,
  double height = 24.0,
  BoxFit fit = BoxFit.fitWidth,
}) =>
    LottieBuilder.asset(
      'assets/icons/lottie/$name',
      width: width,
      fit: fit,
    );

Widget getRectFAvatar(String name, String image,
        {double? size, int cacheWidth = 57, int cacheHeight = 57}) =>
    Avatar(
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
                image.startsWith('http') ? image : '$baseImageApi$image',
                maxHeight: cacheHeight,
                maxWidth: cacheWidth),
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

Widget getCicleAvatar(String name, String image,
        {double? radius, int cacheWidth = 57, int cacheHeight = 57}) =>
    Avatar(
      shape: AvatarShape.circle(radius ?? 7.w),
      backgroundColor: const Color(0xFFF5F5F5),
      name: name,
      textStyle: TextStyle(
        fontFamily: kFontFamily,
        color: AppColors.contactNameTextColor,
        fontSize: 14.sp,
      ),
      sources: [
        if (image.isNotEmpty &&
            !image.startsWith("asset") &&
            !image.contains("users/default.png"))
          GenericSource(
            getImageProvider(
                image.startsWith('http') ? image : '$baseImageApi$image',
                maxHeight: cacheHeight,
                maxWidth: cacheWidth),
          ),

        // if (image.isNotEmpty && !image.startsWith("asset"))
        //   NetworkSource(
        //     image.startsWith('http') ? image : '$baseImageApi$image',
        //   ),
        if (image.isNotEmpty && image.startsWith("asset"))
          GenericSource(
            AssetImage(image),
          ),

        // if (image.isEmpty)
        //   GenericSource(
        //     const AssetImage('assets/images/dummy_profile.png'),
        //   ),
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
