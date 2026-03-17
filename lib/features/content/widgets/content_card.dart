import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../models/content_model.dart';
import 'content_status_chip.dart';

/// Extracted widget for better performance and readability
class ContentCard extends StatelessWidget {
  final ContentModel item;

  const ContentCard({super.key, required this.item});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return AppColors.green;
      case 'maintenance':
      case 'warning':
        return AppColors.yellow;
      case 'error':
      case 'offline':
        return AppColors.red;
      default:
        return AppColors.textColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.healthStatus);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 12,
            // Using a much softer shadow for a modern look
            color: AppColors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TOP ROW: Icon and Options Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.textColor,
                      ),
                      onPressed: () {
                        // TODO: Show context menu
                      },
                    ),
                  ],
                ),

                // BOTTOM AREA: Title and Health Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    StatusChip(status: item.healthStatus, color: statusColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
