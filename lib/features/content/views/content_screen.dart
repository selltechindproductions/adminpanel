import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../models/content_model.dart';
import '../widgets/content_card.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  // Mocking a few more items to show off the grid layout
  final List<ContentModel> items = [
    ContentModel(
      name: 'Banner Section',
      healthStatus: 'Healthy',
      icon: Icons.image_rounded,
      onTap: () {},
    ),
    ContentModel(
      name: 'Product Section',
      healthStatus: 'Healthy',
      icon: Icons.production_quantity_limits,
      onTap: () {},
    ),
    ContentModel(
      name: 'About Section',
      healthStatus: 'Healthy',
      icon: Icons.person,
      onTap: () {},
    ),
    ContentModel(
      name: 'Product Page',
      healthStatus: 'Healthy',
      icon: Icons.interpreter_mode_sharp,
      onTap: () {},
    ),
    ContentModel(
      name: 'Blog Page',
      healthStatus: 'Healthy',
      icon: Icons.content_copy,
      onTap: () {},
    ),
    ContentModel(
      name: 'Blog Section',
      healthStatus: 'Healthy',
      icon: Icons.image_rounded,
      onTap: () {},
    ),
    ContentModel(
      name: 'User Database',
      healthStatus: 'Healthy',
      icon: Icons.people_alt_rounded,
      onTap: () {},
    ),
    ContentModel(
      name: 'Payment Gateway',
      healthStatus: 'Maintenance',
      icon: Icons.payment_rounded,
      onTap: () {},
    ),
    ContentModel(
      name: 'Email Service',
      healthStatus: 'Error',
      icon: Icons.email_rounded,
      onTap: () {},
    ),
    ContentModel(
      name: 'Analytics Engine',
      healthStatus: 'Healthy',
      icon: Icons.analytics_rounded,
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Content Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double aspectRatio = 1.5;

          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 4;
            aspectRatio = 1.8;
          } else if (constraints.maxWidth >= 900) {
            crossAxisCount = 3;
            aspectRatio = 1.6;
          } else if (constraints.maxWidth >= 600) {
            crossAxisCount = 2;
            aspectRatio = 1.5;
          } else {
            crossAxisCount = 1;
            aspectRatio = 2.5; // Wider for mobile lists
          }

          return GridView.builder(
            addAutomaticKeepAlives: true,
            addSemanticIndexes: true,
            addRepaintBoundaries: true,
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              return RepaintBoundary(child: ContentCard(item: items[index]));
            },
          );
        },
      ),
    );
  }
}
