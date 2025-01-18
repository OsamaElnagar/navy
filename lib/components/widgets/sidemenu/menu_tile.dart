import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_colors.dart';
import '../../../utils/defaults.dart';

class MenuTile extends StatefulWidget {
  const MenuTile({
    super.key,
    required this.title,
    this.activeIconSrc,
    this.inactiveIconSrc,
    required this.onPressed,
    this.isActive = false,
    this.isSubmenu = false,
    this.isSpecial = false,
    this.count,
    this.countBg = AppColors.secondaryMintGreen,
  });

  final String title;
  final String? inactiveIconSrc, activeIconSrc;
  final VoidCallback onPressed;
  final bool isActive, isSubmenu, isSpecial;
  final int? count;
  final Color countBg;

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.isSubmenu ? AppDefaults.padding * 2 : 0,
          right: widget.isSubmenu ? AppDefaults.padding : 0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isActive
              ? Theme.of(context).primaryColor
              : isHover
                  ? Theme.of(context).secondaryHeaderColor
                  : null,
          borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          boxShadow: [
            if (widget.isActive)
              BoxShadow(
                color: AppColors.textGrey.withOpacity(0.3),
                spreadRadius: 0.5,
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          onTap: widget.onPressed,
          onHover: (value) {
            setState(() {
              isHover = value;
            });
          },
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
            ),
            leading: widget.activeIconSrc != null
                ? SvgPicture.asset(
                    (widget.isActive || widget.inactiveIconSrc == null)
                        ? widget.activeIconSrc!
                        : widget.inactiveIconSrc!,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        widget.isSpecial
                            ? AppColors.secondary
                            : isHover || widget.isActive
                                ? Theme.of(context).iconTheme.color!
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!,
                        BlendMode.srcIn),
                  )
                : null,
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.isSpecial
                    ? AppColors.secondary
                    : isHover || widget.isActive
                        ? AppColors.titleLight
                        : AppColors.textLight,
              ),
            ),
            trailing: widget.count != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding / 2,
                        vertical: AppDefaults.padding / 4),
                    decoration: BoxDecoration(
                      color: widget.countBg,
                      borderRadius:
                          BorderRadius.circular(AppDefaults.borderRadius / 2),
                    ),
                    child: Text(
                      widget.count.toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
