import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../model/drawer_item.dart';

class AnimatedDrawerTile extends StatefulWidget {
  final DrawerItem item;
  final bool isSelected;
  final bool isRail;
  final bool isLogout;
  final VoidCallback onTap;

  const AnimatedDrawerTile({super.key,
    required this.item,
    required this.isSelected,
    required this.isRail,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  State<AnimatedDrawerTile> createState() => _AnimatedDrawerTileState();
}

class _AnimatedDrawerTileState extends State<AnimatedDrawerTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isLogout
        ? Colors.red
        : widget.isSelected
        ? AppColors.primary
        : AppColors.black;

    final bgColor = widget.isSelected
        ? AppColors.primary.withValues(alpha: .12)
        : _isHovering
        ? AppColors.primary.withValues(alpha: .08)
        : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            /// Left active indicator
            if (widget.isSelected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isRail ? 0 : 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: widget.isRail
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      widget.item.icon,
                      color: baseColor,
                      size: 22,
                    ),

                    if (!widget.isRail) ...[
                      const SizedBox(width: 14),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: baseColor,
                            fontSize: 14,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          child: Text(widget.item.title),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}