// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:navy/features/authentication/controller/auth_controller.dart';
// import '../../../features/pages/dashboard/widgets/profile_actions_popup.dart';
// import '../../../theme/app_colors.dart';
// import '../../../utils/defaults.dart';
// import '../../../utils/gaps.dart';
// import '../avatar/customer_rounded_avatar.dart';
// import '../popup/app_popup_menu.dart';

// class CustomerInfo extends GetView<AuthController> {
//   const CustomerInfo({
//     super.key,
//     this.showCancel = false,
//     required this.name,
//     required this.designation,
//     required this.imageSrc,
//     this.onCancelPressed,
//   });

//   final bool showCancel;
//   final String name, designation, imageSrc;

//   final Function()? onCancelPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: 'customer_info',
//       child: Container(
//         padding: const EdgeInsets.all(AppDefaults.padding * 0.75),
//         margin: const EdgeInsets.all(AppDefaults.padding * 0.75),
//         decoration: BoxDecoration(
//           // color: AppColors.bgLight,
//           borderRadius: BorderRadius.circular(
//             AppDefaults.borderRadius * 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 0.5,
//               blurRadius: 2,
//               offset: const Offset(0, 1),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             CustomerRoundedAvatar(
//               height: 48,
//               width: 48,
//               imageSrc: imageSrc,
//               radius: AppDefaults.borderRadius * 10,
//             ),
//             gapW8,
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: Theme.of(context).textTheme.titleMedium,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     designation,
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ],
//               ),
//             ),
//             gapW16,
//             showCancel
//                 ? IconButton(
//                     onPressed: onCancelPressed,
//                     icon: const Icon(
//                       Icons.close,
//                       color: AppColors.textLight,
//                     ),
//                   )
//                 : AppPopupMenu(
//                     child: Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       key: GlobalKey(debugLabel: 'ArrowDown'),
//                       color: AppColors.textLight,
//                     ),
//                     popUpBuilder: (context, position, size) {
//                       return ProfileActionsPopup(
//                         position: position,
//                         size: size,
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
