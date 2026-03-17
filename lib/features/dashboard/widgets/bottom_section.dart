import 'package:flutter/material.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 720;

        if (isMobile) {
          return const Column(
            children: [
              _RecentContent(),
              SizedBox(height: 20),
              _TeamActivity(),
              SizedBox(height: 20),
              _QuickActions(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _RecentContent()),
            SizedBox(width: 20),
            Expanded(child: _TeamActivity()),
            SizedBox(width: 20),
            Expanded(child: _QuickActions()),
          ],
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Panel({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _RecentContent extends StatelessWidget {
  const _RecentContent();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: "Recent Content",
      trailing: TextButton(onPressed: () {}, child: const Text("View All")),
      child: Column(
        children: const [
          _RecentItem(
            image: "assets/images/download.png",
            title: "10 Tips for Productive Remote Work",
            description:
                "Learn how to maximize your productivity while working from home...",
            views: "2.4K views",
            comments: "23 comments",
            time: "2 hours ago",
            badgeText: "Scheduled",
            badgeColor: Color(0xFFE0F2FE),
            badgeTextColor: Color(0xFF0284C7),
          ),
          Divider(height: 32),
          _RecentItem(
            image: "assets/images/download (7).jpeg",
            title: "Modern UI Design Trends 2024",
            description:
                "Explore the latest design trends shaping the future...",
            views: "0 views",
            comments: "",
            time: "5 hours ago",
            badgeText: "Draft",
            badgeColor: Color(0xFFFEF3C7),
            badgeTextColor: Color(0xFFB45309),
          ),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String views;
  final String comments;
  final String time;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  const _RecentItem({
    required this.image,
    required this.title,
    required this.description,
    required this.views,
    required this.comments,
    required this.time,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(image, width: 60, height: 60, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11,
                        color: badgeTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              Text(
                "$views • $comments • $time",
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamActivity extends StatelessWidget {
  const _TeamActivity();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: "Team Activity",
      child: Column(
        children: const [
          _ActivityItem(
            name: "Sarah Miller",
            action: "published a new post",
            time: "15 minutes ago",
          ),
          _ActivityItem(
            name: "Mike Johnson",
            action: "updated media library",
            time: "1 hour ago",
          ),
          _ActivityItem(
            name: "Emma Davis",
            action: "approved 5 comments",
            time: "2 hours ago",
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;

  const _ActivityItem({
    required this.name,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          const CircleAvatar(radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$name ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: action),
                  TextSpan(
                    text: "\n$time",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: "Quick Actions",
      child: Column(
        children: const [
          _ActionButton(
            icon: Icons.add,
            text: "Create New Post",
            color: Color(0xFFDBEAFE),
          ),
          SizedBox(height: 12),
          _ActionButton(
            icon: Icons.upload,
            text: "Upload Media",
            color: Color(0xFFD1FAE5),
          ),
          SizedBox(height: 12),
          _ActionButton(
            icon: Icons.person_add,
            text: "Add User",
            color: Color(0xFFF3E8FF),
          ),
          SizedBox(height: 12),
          _ActionButton(
            icon: Icons.analytics,
            text: "View Analytics",
            color: Color(0xFFFFEDD5),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18),
            ),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
