// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:navy/components/text_hover.dart';
// import 'package:navy/controllers/localization_controller.dart';
// import 'package:navy/core/helpers/route_helper.dart';
// import 'package:navy/features/splash/controller/splash_controller.dart';
// import 'package:navy/features/web_landing/controller/web_landing_controller.dart';
// import 'package:navy/features/web_landing/model/web_landing_model.dart';
// import 'package:navy/models/config_model.dart';
// import 'package:navy/utils/app_constants.dart';
// import 'package:navy/utils/dimensions.dart';
// import 'package:navy/utils/images.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import '../features/web_landing/repository/web_landing_repo.dart';
// import '../utils/styles.dart';

// class FooterView extends StatefulWidget {
//   const FooterView({super.key});

//   @override
//   State<FooterView> createState() => _FooterViewState();
// }

// class _FooterViewState extends State<FooterView> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(
//         () => WebLandingController(WebLandingRepo(apiClient: Get.find())));
//     ConfigModel? config = Get.find<SplashController>().configModel;
//     List<SocialMedia>? socialMediaList = config.content?.socialMedia;
//     Color color = Theme.of(context).primaryColorLight;
//     return GetBuilder<SplashController>(builder: (splashController) {
//       return Container(
//         color: Theme.of(context).primaryColorDark,
//         width: double.maxFinite,
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 width: Dimensions.webMaxWidth,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 4,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                                 height: Dimensions.paddingSizeLarge * 2),
//                             Image.asset(
//                               Images.appbarLogo,
//                               width: 180,
//                             ),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   Images.footerAddress,
//                                   width: 18,
//                                 ),
//                                 const SizedBox(
//                                     width: Dimensions.paddingSizeSmall),
//                                 Text(
//                                   Get.find<SplashController>()
//                                           .configModel
//                                           .content!
//                                           .businessAddress ??
//                                       "",
//                                   style: ubuntuRegular.copyWith(
//                                     color: color,
//                                     fontSize: Dimensions.fontSizeExtraSmall,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('follow_us_on'.tr,
//                                     style: ubuntuRegular.copyWith(
//                                         color: color,
//                                         fontSize:
//                                             Dimensions.fontSizeExtraSmall)),
//                                 SizedBox(
//                                   height: 50,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     shrinkWrap: true,
//                                     itemBuilder: (BuildContext context, index) {
//                                       String? icon = Images.facebookIcon;
//                                       if (socialMediaList![index].media ==
//                                           'facebook') {
//                                         icon = Images.facebookIcon;
//                                       } else if (socialMediaList[index].media ==
//                                           'linkedin') {
//                                         icon = Images.linkedinIcon;
//                                       } else if (socialMediaList[index].media ==
//                                           'youtube') {
//                                         icon = Images.youtubeIcon;
//                                       } else if (socialMediaList[index].media ==
//                                           'twitter') {
//                                         icon = Images.twitterIcon;
//                                       } else if (socialMediaList[index].media ==
//                                           'instagram') {
//                                         icon = Images.instagramIcon;
//                                       } else if (socialMediaList[index].media ==
//                                           'pinterest') {
//                                         icon = Images.pinterestIcon;
//                                       }

//                                       return 1 > 0
//                                           ? InkWell(
//                                               onTap: () {
//                                                 _launchURL(
//                                                     '${socialMediaList[index].link}');
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     right: 15.0),
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.all(6),
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                           shape:
//                                                               BoxShape.circle,
//                                                           color: Colors.white),
//                                                   child: Center(
//                                                     child: Image.asset(
//                                                       icon!,
//                                                       height: 15,
//                                                       width: 15,
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : const SizedBox();
//                                     },
//                                     itemCount: socialMediaList != null
//                                         ? socialMediaList.length
//                                         : 0,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 )
//                               ],
//                             )
//                           ],
//                         )),
//                     const SizedBox(
//                       width: Dimensions.paddingSizeLarge,
//                     ),
//                     if (config.content!.appUrlAndroid != null ||
//                         config.content!.appUrlIos != null)
//                       Expanded(
//                         flex: 4,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                                 height: Dimensions.paddingSizeLarge * 2),
//                             Text('download_our_app'.tr,
//                                 style: ubuntuRegular.copyWith(
//                                     color: color,
//                                     fontSize: Dimensions.fontSizeLarge)),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                             Text('download_our_app_from_google_play_store'.tr,
//                                 style: ubuntuRegular.copyWith(
//                                     color: color,
//                                     fontSize: Dimensions.fontSizeExtraSmall)),
//                             const SizedBox(height: Dimensions.paddingSizeLarge),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 if (config.content!.appUrlAndroid != null)
//                                   InkWell(
//                                       onTap: () {
//                                         _launchURL(Get.find<SplashController>()
//                                             .configModel
//                                             .content!
//                                             .appUrlAndroid!);
//                                       },
//                                       child: Image.asset(Images.playStoreIcon,
//                                           height: 40, fit: BoxFit.contain)),
//                                 const SizedBox(
//                                   width: Dimensions.paddingSizeSmall,
//                                 ),
//                                 /*
//                                 if (config.content!.appUrlIos != null)
//                                   InkWell(
//                                       onTap: () {
//                                         _launchURL(Get.find<SplashController>()
//                                             .configModel
//                                             .content!
//                                             .appUrlIos!);
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             child: Image.asset(
//                                                 Images.huawieStoreIcon,
//                                                 height: 40,
//                                                 fit: BoxFit.contain)),
//                                       )),
//                                  */
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                               height: Dimensions.paddingSizeLarge * 2),
//                           Text('useful_link'.tr,
//                               style: ubuntuRegular.copyWith(
//                                   color: color,
//                                   fontSize: Dimensions.fontSizeLarge)),
//                           const SizedBox(
//                             height: 5.0,
//                           ),
//                           Container(
//                             height: 1,
//                             width: 60,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//                           FooterButton(
//                               title: 'privacy_policy'.tr,
//                               route:
//                                   RouteHelper.getHtmlRoute('privacy-policy')),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//                           FooterButton(
//                               title: 'terms_and_conditions'.tr,
//                               route: RouteHelper.getHtmlRoute(
//                                   'terms-and-condition')),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//                           FooterButton(
//                               title: 'about_us'.tr,
//                               route: RouteHelper.getHtmlRoute('about_us')),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//                           // FooterButton(
//                           //     title: 'contact_us'.tr,
//                           //     route: RouteHelper.getSupportRoute()),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                         flex: 2,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                                 height: Dimensions.paddingSizeLarge * 2),
//                             Text('quick_links'.tr,
//                                 style: ubuntuRegular.copyWith(
//                                     color: Colors.white,
//                                     fontSize: Dimensions.fontSizeLarge)),
//                             const SizedBox(
//                               height: 5.0,
//                             ),
//                             Container(
//                               height: 1,
//                               width: 60,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             const SizedBox(height: Dimensions.paddingSizeLarge),
//                             // FooterButton(
//                             //     title: 'current_offers'.tr,
//                             //     route: RouteHelper.getOffersRoute('')),
//                             // const SizedBox(height: Dimensions.paddingSizeSmall),
//                             // FooterButton(
//                             //     title: 'popular_services'.tr,
//                             //     route: RouteHelper.allServiceScreenRoute(
//                             //         "popular_services")),
//                             // const SizedBox(height: Dimensions.paddingSizeSmall),
//                             // FooterButton(
//                             //     title: 'categories'.tr,
//                             //     route: RouteHelper.getCategoryRoute(
//                             //         'fromPage', '123')),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                             if (config.content?.providerSelfRegistration == 1)
//                               FooterButton(
//                                 title: 'become_a_provider'.tr,
//                                 url: true,
//                                 route:
//                                     '${AppConstants.baseUrl}/provider/auth/sign-up',
//                               ),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeDefault),
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                       width: double.maxFinite,
//                       color: const Color(0xff253036),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: Dimensions.paddingSizeDefault),
//                         child: Center(
//                             child: Text(
//                           Get.find<SplashController>()
//                                   .configModel
//                                   .content!
//                                   .footerText ??
//                               "",
//                           style: ubuntuRegular.copyWith(
//                               color: Colors.white,
//                               fontSize: Dimensions.fontSizeSmall),
//                         )),
//                       )),
//                   Positioned(
//                     top: -32,
//                     left: Get.find<LocalizationController>().isLtr
//                         ? (MediaQuery.of(context).size.width -
//                                 Dimensions.webMaxWidth) /
//                             2
//                         : 0,
//                     right: !Get.find<LocalizationController>().isLtr
//                         ? 0
//                         : (MediaQuery.of(context).size.width -
//                                 Dimensions.webMaxWidth) /
//                             2,
//                     child: Center(
//                       child: SizedBox(
//                         width: Dimensions.webMaxWidth,
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                     Dimensions.radiusSmall),
//                                 color: Colors.grey.withOpacity(0.2),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: Dimensions.paddingSizeDefault,
//                                 vertical: Dimensions.paddingSizeSmall,
//                               ),
//                               child: Row(
//                                 children: [
//                                   ContactUsWidget(
//                                     title: "email_us".tr,
//                                     subtitle: Get.find<SplashController>()
//                                             .configModel
//                                             .content!
//                                             .businessEmail ??
//                                         "",
//                                   ),
//                                   const SizedBox(
//                                     width: Dimensions.paddingSizeExtraLarge,
//                                   ),
//                                   ContactUsWidget(
//                                     title: "call_us".tr,
//                                     subtitle: Get.find<SplashController>()
//                                             .configModel
//                                             .content!
//                                             .businessPhone ??
//                                         "",
//                                   ),
//                                   const SizedBox(
//                                     width: Dimensions.paddingSizeSmall,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Expanded(child: SizedBox())
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

// _launchURL(String url) async {
//   if (await canLaunchUrl(Uri.parse(url))) {
//     await launchUrl(Uri.parse(url));
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// class ContactUsWidget extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const ContactUsWidget(
//       {super.key, required this.title, required this.subtitle});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: ubuntuMedium.copyWith(
//             fontSize: Dimensions.fontSizeSmall,
//             color: Theme.of(context).cardColor.withOpacity(0.8),
//           ),
//         ),
//         const SizedBox(
//           height: Dimensions.paddingSizeSmall,
//         ),
//         Text(
//           subtitle,
//           style: ubuntuRegular.copyWith(
//             fontSize: Dimensions.fontSizeExtraSmall,
//             color: Theme.of(context).cardColor.withOpacity(0.6),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FooterButton extends StatelessWidget {
//   final String title;
//   final String route;
//   final bool url;

//   const FooterButton(
//       {super.key, required this.title, required this.route, this.url = false});

//   @override
//   Widget build(BuildContext context) {
//     return TextHover(builder: (hovered) {
//       return InkWell(
//         hoverColor: Colors.transparent,
//         onTap: route.isNotEmpty
//             ? () async {
//                 if (url) {
//                   if (await canLaunchUrlString(route)) {
//                     launchUrlString(route,
//                         mode: LaunchMode.externalApplication);
//                   }
//                 } else {
//                   Get.toNamed(route);
//                 }
//               }
//             : null,
//         child: Text(title,
//             style: hovered
//                 ? ubuntuRegular.copyWith(
//                     color: Theme.of(context).colorScheme.error,
//                     fontSize: Dimensions.fontSizeExtraSmall)
//                 : ubuntuRegular.copyWith(
//                     color: Colors.white,
//                     fontSize: Dimensions.fontSizeExtraSmall)),
//       );
//     });
//   }
// }
