import 'package:flutter/material.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String growthText;
  final double growthPercent;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.growthText,
    required this.growthPercent,
    required this.icon,
    this.iconColor = const Color(0xFF2563EB),
    this.iconBackgroundColor = const Color(0xFFE0E7FF),
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = growthPercent >= 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        /// 🔥 Responsive Scaling Logic
        final horizontalPadding = width * 0.06;
        final verticalPadding = width * 0.06;

        final titleFontSize =
        (width * 0.07).clamp(11, 14).toDouble();

        final valueFontSize =
        (width * 0.16).clamp(18, 32).toDouble();

        final growthFontSize =
        (width * 0.075).clamp(11, 14).toDouble();

        final iconSize =
        (width * 0.12).clamp(18, 26).toDouble();

        final iconContainerSize =
        (width * 0.22).clamp(36, 48).toDouble();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: growthFontSize,
                          color: isPositive
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            growthText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: growthFontSize,
                              fontWeight: FontWeight.w500,
                              color: isPositive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: width * 0.04),

              /// RIGHT ICON
              Container(
                height: iconContainerSize,
                width: iconContainerSize,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}