import 'package:flutter/material.dart';
import 'package:site_admin_pannel/features/dashboard/widgets/performance_section.dart';
import 'package:site_admin_pannel/features/dashboard/widgets/stats_row.dart';
import 'package:site_admin_pannel/features/dashboard/widgets/top_bar.dart';

import 'bottom_section.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            TopBar(),
            SizedBox(height: 24),
            StatsRow(),
            SizedBox(height: 24),
            PerformanceSection(),
            SizedBox(height: 24),
            BottomSection(),
          ],
        ),
      ),
    );
  }
}