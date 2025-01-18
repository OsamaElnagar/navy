import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/widgets/tabs/tab_with_icon.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/defaults.dart';
import '../../../../controllers/theme_controller.dart';

class ThemeTabs extends StatefulWidget {
  const ThemeTabs({super.key});

  @override
  State<ThemeTabs> createState() => _ThemeTabsState();
}

class _ThemeTabsState extends State<ThemeTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final themeMode = Get.find<ThemeController>().themeMode;
    _tabController.index = switch (themeMode) {
      ThemeMode.system => 0,
      ThemeMode.light => 1,
      ThemeMode.dark => 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppDefaults.borderRadius * 15),
            ),
            child: TabBar(
              controller: _tabController,
              dividerHeight: 0,
              onTap: (int index) {
                themeController.setThemeMode(
                  switch (index) {
                    0 => ThemeMode.system,
                    1 => ThemeMode.light,
                    2 => ThemeMode.dark,
                    _ => ThemeMode.system,
                  },
                );
              },
              splashBorderRadius:
                  BorderRadius.circular(AppDefaults.borderRadius * 5),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding * 0.5,
                vertical: AppDefaults.padding * 0.5,
              ),
              indicator: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppDefaults.borderRadius * 5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
                color: AppColors.bgSecondaryLight,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                TabWithIcon(
                  isSelected: themeController.themeMode == ThemeMode.system,
                  title: 'Auto',
                  iconSrc: 'assets/icons/auto_theme.svg',
                ),
                TabWithIcon(
                  isSelected: themeController.themeMode == ThemeMode.light,
                  title: 'Light',
                  iconSrc: 'assets/icons/sun_filled.svg',
                ),
                TabWithIcon(
                  isSelected: themeController.themeMode == ThemeMode.dark,
                  title: 'Dark',
                  iconSrc: 'assets/icons/moon_filled.svg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
