import 'package:flutter/material.dart';

import '../model/dashboard_item.dart';
import 'dashboard_stat_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Total Users',
        value: '2,000',
        icon: Icons.people,
        growthText: '+12% from last month',
        growthPercent: 12,
      ),
      DashboardItem(
        title: 'Total Posts',
        value: '1,245',
        icon: Icons.article,
        growthText: '+8% from last month',
        growthPercent: 8,
      ),
      DashboardItem(
        title: 'Active Subscriptions',
        value: '865',
        icon: Icons.subscriptions,
        growthText: '+5% from last month',
        growthPercent: 5,
      ),
      DashboardItem(
        title: 'Revenue',
        value: '\$12,430',
        icon: Icons.attach_money,
        growthText: '-3% from last month',
        growthPercent: -3,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;

        if (constraints.maxWidth > 1400) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 1000) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          addAutomaticKeepAlives: true,
          itemCount: items.length,
          shrinkWrap: true,                 // 🔥 IMPORTANT
          physics: const NeverScrollableScrollPhysics(), // 🔥 IMPORTANT
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return DashboardStatCard(
              title: item.title,
              value: item.value,
              growthText: item.growthText,
              growthPercent: item.growthPercent,
              icon: item.icon,
            );
          },
        );
      },
    );
  }
}