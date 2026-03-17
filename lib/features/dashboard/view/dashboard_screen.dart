import 'package:flutter/material.dart';
import 'package:site_admin_pannel/app/app_colors.dart';

import '../widgets/dashboard_content.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: DashboardContent(),
    );
  }
}
