// import '/core/constants.dart';
// import '/core/state.dart';
// import '/core/ui_core.dart';

// class BaseSettings extends StatelessWidget {
//   final Widget bodyContent;

//   const BaseSettings({Key? key, required this.bodyContent}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.gradientTopColor,
//               AppColors.gradientLiveBottomColor,
//             ],
//           ),
//         ),
//         child: SafeArea(
//             child: Stack(
//           children: [
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.only(top: 9.h),
//               padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(4.w),
//                 ),
//               ),
//               child: Container(
//                 height: double.infinity,
//                 padding: EdgeInsets.only(top: 7.h),
//                 // child: SingleChildScrollView(
//                 //   child: bodyContent,
//                 child: bodyContent,
//                 // ),
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: getSvgIcon('arrow_back.svg'),
//             ),
//             Consumer(
//               builder: (context, ref, child) {
//                 return Container(
//                   alignment: Alignment.topCenter,
//                   margin: EdgeInsets.only(top: 4.h),
//                   child: Column(
//                     children: [
//                       getRectFAvatar(
//                           size: 22.w, user?.name ?? '', user?.image ?? ''),
//                       Text(
//                         user?.name ?? '',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12.sp,
//                             color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             )
//           ],
//         )),
//       ),
//     );
//   }

//   // Widget _buildBody() {
//   //   return Column(
//   //       mainAxisSize: MainAxisSize.max,
//   //       crossAxisAlignment: CrossAxisAlignment.stretch,
//   //       mainAxisAlignment: MainAxisAlignment.start,
//   //       children: []);
//   // }
// }
