import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_admin_pannel/features/app_drawer/model/drawer_item.dart';
import '../../../app/app_colors.dart';
import '../widget/animated_drawer_tile.dart';

class AppDrawer extends StatelessWidget {
  final List<DrawerItem> items;
  final String currentRoute;
  final bool isRail;

  const AppDrawer({
    super.key,
    required this.items,
    required this.currentRoute,
    this.isRail = false,
  });

  @override
  Widget build(BuildContext context) {
    const userName = "User";

    return Container(
      width: isRail ? 80 : 270,
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isRail) _buildHeader(userName),

          const SizedBox(height: 8),

          /// 🔹 Menu Items
          Expanded(
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              addSemanticIndexes: true,
              addRepaintBoundaries: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = currentRoute == item.route;
                return RepaintBoundary(
                  child: AnimatedDrawerTile(
                    item: item,
                    isSelected: isSelected,
                    isRail: isRail,
                    onTap: () => context.go(item.route),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          /// 🔹 Logout Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: AnimatedDrawerTile(
              item: DrawerItem(
                title: "Logout",
                icon: Icons.logout,
                route: '',
              ),
              isSelected: false,
              isRail: isRail,
              isLogout: true,
              onTap: () {
                // Handle logout
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Welcome,\n$userName",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}