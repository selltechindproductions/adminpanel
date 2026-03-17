import 'package:flutter/material.dart';
import 'package:site_admin_pannel/app/app_router.dart';
import 'package:site_admin_pannel/features/app_drawer/model/drawer_item.dart';

class DrawerConfig {
  static List<DrawerItem> getItems() {
    return [
      DrawerItem(
        title: "Dashboard",
        icon: Icons.dashboard,
        route: AppRouter.dashboard,
      ),
      DrawerItem(
        title: "Users",
        icon: Icons.verified_user,
        route: AppRouter.users,
      ),
      DrawerItem(
        title: "Content",
        icon: Icons.drive_file_rename_outline_sharp,
        route: AppRouter.content,
      ),
      DrawerItem(title: "Blogs", icon: Icons.newspaper, route: AppRouter.blogs),
      DrawerItem(
        title: "Products",
        icon: Icons.design_services,
        route: AppRouter.products,
      ),
      DrawerItem(
        title: "Contacts",
        icon: Icons.contact_emergency,
        route: AppRouter.contacts,
      ),
      DrawerItem(
        title: "Notifications",
        icon: Icons.notifications,
        route: AppRouter.notifications,
      ),
    ];
  }
}
