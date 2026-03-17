import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/drawer_config.dart';
import 'app_drawer.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;

  const ResponsiveScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final items = DrawerConfig.getItems();
    final currentRoute = GoRouterState.of(context).uri.toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final isTablet =
            constraints.maxWidth >= 700 && constraints.maxWidth < 1100;
        final isDesktop = constraints.maxWidth >= 1100;

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(title: const Text("Admin Panel")),
            drawer: Drawer(
              child: AppDrawer(items: items, currentRoute: currentRoute),
            ),
            body: body,
          );
        }

        if (isTablet) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: items.indexWhere(
                    (e) => e.route == currentRoute,
                  ),
                  onDestinationSelected: (index) {
                    context.go(items[index].route);
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations:
                      items
                          .map(
                            (e) => NavigationRailDestination(
                              icon: Icon(e.icon),
                              label: Text(e.title),
                            ),
                          )
                          .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        // Desktop/Web
        return Scaffold(
          body: Row(
            children: [
              AppDrawer(items: items, currentRoute: currentRoute),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}
