import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navy/utils/styles.dart';
import '../../theme/app_colors.dart';
import '../../utils/defaults.dart';
import '../../utils/gaps.dart';
import '../../utils/responsive.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding,
      ),
      color: Theme.of(context).drawerTheme.surfaceTintColor,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                onPressed: () {
                  drawerKey.currentState!.openDrawer();
                },
                icon: Badge(
                  isLabelVisible: false,
                  child: SvgPicture.asset(
                    "assets/icons/menu_light.svg",
                  ),
                ),
              ),
            if (Responsive.isTablet(context)) gapW20,
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 1,
                child: TextFormField(
                  // style: Theme.of(context).textTheme.labelLarge,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDefaults.padding,
                          right: AppDefaults.padding / 2),
                      child: SvgPicture.asset("assets/icons/search_light.svg"),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: AppDefaults.outlineInputBorder,
                    focusedBorder: AppDefaults.focusedOutlineInputBorder,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // if (Responsive.isMobile(context))
                  ...[
                    PopupMenuButton(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      icon: Badge(
                        child: SvgPicture.asset(
                          "assets/icons/message_light.svg",
                        ),
                      ),
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, AppDefaults.padding),
                      itemBuilder: (context) {
                        return [
                          ...List.generate(
                            5,
                            (index) => PopupMenuItem(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression",
                                  ),
                                ),
                                title: const Text("Notification 1"),
                                subtitle: const Text(
                                  "Notification 1 description",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "1h",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.textGrey,
                                          ),
                                    ),
                                    gapW8,
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                  AppDefaults.borderRadius,
                                ),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Center(
                                child: Text(
                                  "See all notifications",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
                    gapW16,
                    PopupMenuButton(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      icon: SvgPicture.asset(
                        "assets/icons/notification_light.svg",
                      ),
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, AppDefaults.padding),
                      itemBuilder: (context) {
                        return [
                          ...List.generate(
                            5,
                            (index) => PopupMenuItem(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression",
                                  ),
                                ),
                                title: const Text("Notification 1"),
                                subtitle: const Text(
                                  "Notification 1 description",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: ubuntuLight,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "1h",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.textGrey,
                                          ),
                                    ),
                                    gapW8,
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                  AppDefaults.borderRadius,
                                ),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Center(
                                child: Text(
                                  "See all notifications",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
                    gapW16,
                  ],

                  gapW16,
                  // ConditionalWidget(
                  //   condition: !Get.find<AuthController>().isLoggedIn(),
                  //   builder: (context) => ElevatedButton(
                  //     onPressed: () => Get.toNamed('/sign-in'),
                  //     child: const Text("Sign In"),
                  //   ),
                  //   fallback: (context) => AppPopupMenu(
                  //     child: CircleAvatar(
                  //       key: GlobalKey(debugLabel: 'ProfileAvatar'),
                  //       backgroundImage: CachedNetworkImageProvider(
                  //         Get.find<UserHiveService>().getUser()!.store!.logo,
                  //       ),
                  //     ),
                  //     popUpBuilder: (context, position, size) {
                  //       return ProfileActionsPopup(
                  //         position: position,
                  //         size: size,
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
