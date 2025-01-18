import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:navy/core/helpers/conditional_widget.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/utils/styles.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/widgets/theme_tabs.dart';
import '../../../utils/defaults.dart';
import '../../../utils/gaps.dart';
import '../../../utils/responsive.dart';
import 'menu_tile.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: Responsive.isMobile(context) ? double.infinity : null,
      // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: const Radius.circular(20),
        topRight: Responsive.isMobile(context)
            ? const Radius.circular(20)
            : const Radius.circular(0),
      )),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.h,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              SvgPicture.asset('assets/icons/close_filled.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                        ),
                        child: Text(
                          Get.find<UserHiveService>().getUser()!.user.name,
                          style: ubuntuBold.copyWith(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding,
                        vertical: AppDefaults.padding * 1.2,
                      ),
                      child: SvgPicture.asset('assets/icons/logo.svg'),
                    ),
                    if (!Responsive.isMobile(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                        ),
                        child: Text(
                          Get.find<UserHiveService>().getUser()!.user.name,
                          style: ubuntuBold.copyWith(fontSize: 24),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Divider(),
            gapH16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    //Home
                    MenuTile(
                      isActive: selectedIndex == 0,
                      title: "Home",
                      activeIconSrc: "assets/icons/home_filled.svg",
                      inactiveIconSrc: "assets/icons/home_light.svg",
                      onPressed: () {
                        onChanged.call(0);
                      },
                    ),
                    // Products
                    ExpansionTile(
                      initiallyExpanded: selectedIndex == 1 ||
                          selectedIndex == 2 ||
                          selectedIndex == 3,
                      leading: SvgPicture.asset(selectedIndex == 1 ||
                              selectedIndex == 2 ||
                              selectedIndex == 3
                          ? "assets/icons/diamond_filled.svg"
                          : "assets/icons/diamond_light.svg"),
                      title: Text(
                        "Products",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isActive: selectedIndex == 1,
                          isSubmenu: true,
                          title: "Dashboard",
                          onPressed: () {
                            onChanged.call(1);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 2,
                          isSubmenu: true,
                          title: "Draft",
                          count: 16,
                          onPressed: () {
                            onChanged.call(2);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 3,
                          isSubmenu: true,
                          title: "Add Product",
                          onPressed: () {
                            onChanged.call(3);
                          },
                        ),
                      ],
                    ),
                    // New Categories Expansion Tile
                    ExpansionTile(
                      initiallyExpanded: selectedIndex == 12 ||
                          selectedIndex == 13 ||
                          selectedIndex == 14,
                      leading: SvgPicture.asset(selectedIndex == 12 ||
                              selectedIndex == 13 ||
                              selectedIndex == 14
                          ? "assets/icons/category_filled.svg"
                          : "assets/icons/category_light.svg"),
                      title: Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isActive: selectedIndex == 12,
                          isSubmenu: true,
                          title: "Overview",
                          onPressed: () {
                            onChanged.call(12);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 13,
                          isSubmenu: true,
                          title: "My Categories",
                          onPressed: () {
                            onChanged.call(13);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 14,
                          isSubmenu: true,
                          title: "Subscribe to New Categories",
                          onPressed: () {
                            onChanged.call(14);
                          },
                        ),
                      ],
                    ),
                    // Customers
                    ExpansionTile(
                      initiallyExpanded:
                          selectedIndex == 4 || selectedIndex == 5,
                      leading: SvgPicture.asset(
                        selectedIndex == 4 || selectedIndex == 5
                            ? "assets/icons/profile_circled_filled.svg"
                            : "assets/icons/profile_circled_light.svg",
                      ),
                      title: Text(
                        "Customers",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isActive: selectedIndex == 4,
                          isSubmenu: true,
                          title: "Overview",
                          onPressed: () {
                            onChanged.call(4);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 5,
                          isSubmenu: true,
                          title: "Customer list",
                          count: 16,
                          onPressed: () {
                            onChanged.call(5);
                          },
                        ),
                      ],
                    ),
                    // Shop
                    MenuTile(
                      isActive: selectedIndex == 6,
                      title: "Shop",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {
                        onChanged.call(6);
                      },
                    ),
                    // Income
                    ExpansionTile(
                      initiallyExpanded: selectedIndex == 7 ||
                          selectedIndex == 8 ||
                          selectedIndex == 9 ||
                          selectedIndex == 10,
                      leading: SvgPicture.asset(
                        selectedIndex == 7 ||
                                selectedIndex == 8 ||
                                selectedIndex == 9 ||
                                selectedIndex == 10
                            ? "assets/icons/pie_chart_filled.svg"
                            : "assets/icons/pie_chart_light.svg",
                      ),
                      title: Text(
                        "Income",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isActive: selectedIndex == 7,
                          isSubmenu: true,
                          title: "Earning",
                          onPressed: () {
                            onChanged.call(7);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 8,
                          isSubmenu: true,
                          title: "Refunds",
                          onPressed: () {
                            onChanged.call(8);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 9,
                          isSubmenu: true,
                          title: "Payouts",
                          onPressed: () {
                            onChanged.call(9);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 10,
                          isSubmenu: true,
                          title: "Statements",
                          onPressed: () {
                            onChanged.call(10);
                          },
                        ),
                      ],
                    ),
                    MenuTile(
                      isActive: selectedIndex == 11,
                      title: "Promote",
                      activeIconSrc: "assets/icons/promotion_filled.svg",
                      inactiveIconSrc: "assets/icons/promotion_light.svg",
                      onPressed: () {
                        onChanged.call(11);
                      },
                    ),
                    // Profile
                    ExpansionTile(
                      initiallyExpanded: selectedIndex == 15 ||
                          selectedIndex == 16 ||
                          selectedIndex == 17,
                      leading: SvgPicture.asset(selectedIndex == 15 ||
                              selectedIndex == 16 ||
                              selectedIndex == 17
                          ? "assets/icons/person_filled.svg"
                          : "assets/icons/person_light.svg"),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isActive: selectedIndex == 15,
                          isSubmenu: true,
                          title: "My Profile",
                          onPressed: () {
                            onChanged.call(15);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 16,
                          isSubmenu: true,
                          title: "Security",
                          onPressed: () {
                            onChanged.call(16);
                          },
                        ),
                        MenuTile(
                          isActive: selectedIndex == 17,
                          isSubmenu: true,
                          title: "Account Settings",
                          onPressed: () {
                            onChanged.call(17);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ConditionalWidget(
                  condition: Get.find<AuthController>().isLoggedIn(),
                  builder: (context) {
                    //var userResponse = Get.find<UserHiveService>().getUser()!;
                    return Column(
                      children: [
                        if (Responsive.isMobile(context))
                          // CustomerInfo(
                          //   name: userResponse.user.name,
                          //   designation: userResponse.store!.name,
                          //   imageSrc: userResponse.store!.logo,
                          // ),
                          gapH8,
                        const Divider(),
                      ],
                    );
                  },
                  fallback: (context) => const SizedBox.shrink(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  gapH8,
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/help_light.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textLight,
                          BlendMode.srcIn,
                        ),
                      ),
                      gapW8,
                      Text(
                        'Help & getting started',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Chip(
                        backgroundColor: AppColors.secondaryLavender,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 0.5),
                        label: Text(
                          "8",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  gapH20,
                  const ThemeTabs(),
                  gapH8,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
