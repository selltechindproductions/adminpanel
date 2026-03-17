import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_admin_pannel/app/app_router.dart';

import '../../../app/app_colors.dart';
import '../models/blog_model.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  // Mock Data Updated for the new BlogModel
  final List<BlogModel> _allBlogs = [
    BlogModel(
      id: '1',
      title: 'Getting Started with Flutter Web',
      category: 'Technology',
      authorId: 'Jane Doe',
      createdAt: DateTime(2023, 10, 12),
      updatedAt: DateTime(2023, 10, 12),
      status: 'Published',
      imageUrls: ['https://picsum.photos/seed/flutter/400/200'],
      slug: 'getting-started-flutter-web',
    ),
    BlogModel(
      id: '2',
      title: 'Top 10 UI/UX Trends in 2024',
      category: 'Design',
      authorId: 'John Smith',
      createdAt: DateTime(2023, 10, 15),
      updatedAt: DateTime(2023, 10, 16),
      status: 'Published',
      imageUrls: ['https://picsum.photos/seed/design/400/200'],
      slug: 'top-10-ui-ux-trends-2024',
    ),
    BlogModel(
      id: '3',
      title: 'Mastering State Management',
      category: 'Technology',
      authorId: 'Alice Johnson',
      createdAt: DateTime(2023, 10, 18),
      updatedAt: DateTime(2023, 10, 18),
      status: 'Draft',
      imageUrls: [],
      slug: 'mastering-state-management',
    ),
    BlogModel(
      id: '4',
      title: 'Healthy Eating for Busy Developers',
      category: 'Lifestyle',
      authorId: 'Mark Lee',
      createdAt: DateTime(2023, 10, 20),
      updatedAt: DateTime(2023, 10, 20),
      status: 'Published',
      imageUrls: ['https://picsum.photos/seed/health/400/200'],
      slug: 'healthy-eating-busy-developers',
    ),
    BlogModel(
      id: '5',
      title: 'How to Market Your App',
      category: 'Business',
      authorId: 'Sarah Connor',
      createdAt: DateTime(2023, 10, 22),
      updatedAt: DateTime(2023, 10, 22),
      status: 'Published',
      imageUrls: ['https://picsum.photos/seed/market/400/200'],
      slug: 'how-to-market-your-app',
    ),
  ];

  late List<String> _categories;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categories = ['All', ..._allBlogs.map((b) => b.category).toSet().toList()];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BlogModel> get _filteredBlogs {
    return _allBlogs.where((blog) {
      final matchesSearch = blog.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'All' || blog.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredBlogs;
    // Determine if the screen is mobile-sized to optimize padding and layout
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          // Dynamically adjust padding for mobile vs web
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 16 : 24),
              _SearchAndFilterBar(
                searchController: _searchController,
                onSearchChanged:
                    (value) => setState(() => _searchQuery = value),
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategoryChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
              ),
              SizedBox(height: isMobile ? 16 : 24),
              Expanded(
                child:
                    filteredList.isEmpty
                        ? _buildEmptyState()
                        : _buildResponsiveGrid(filteredList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Wrapped in Expanded to prevent text overflow on narrow mobile screens
        Expanded(
          child: Text(
            'Blogs Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontSize: isMobile ? 22 : null, // Slightly scale down on mobile
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: isMobile ? 12 : 24),
        ElevatedButton.icon(
          onPressed: () {
            context.push(AppRouter.createBlog);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.backgroundColor,
            // Smaller padding on mobile
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
              vertical: isMobile ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, size: 20),
          // Shorten the label on mobile to save space
          label: Text(isMobile ? 'Create' : 'Create New Blog'),
        ),
      ],
    );
  }

  Widget _buildResponsiveGrid(List<BlogModel> blogs) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double aspectRatio;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
          aspectRatio = 0.85;
        } else if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
          aspectRatio = 0.8;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
          aspectRatio = 0.9;
        } else {
          crossAxisCount = 1;
          // Adjust aspect ratio specifically for mobile to prevent card stretching
          aspectRatio = constraints.maxWidth < 400 ? 1.05 : 1.2;
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: blogs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16, // Slightly tighter spacing
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            return _BlogCard(blog: blogs[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),
          Text(
            'No blogs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or category filter.',
            style: TextStyle(color: AppColors.black.withValues(alpha: 0.4)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------
// EXTRACTED WIDGETS
// ------------------------------------------------------------------------

class _SearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const _SearchAndFilterBar({
    required this.searchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        // Mobile layout naturally stacks via Column
        if (isMobile) {
          return Column(
            children: [
              _buildSearchField(isMobile),
              const SizedBox(height: 12),
              _buildCategoryDropdown(isMobile),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: _buildSearchField(isMobile)),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildCategoryDropdown(isMobile)),
          ],
        );
      },
    );
  }

  Widget _buildSearchField(bool isMobile) {
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search blogs by title...',
        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.backgroundColor,
        // Slightly smaller padding on mobile
        contentPadding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      // Set to match height of the textfield accurately on mobile
      height: isMobile ? 48 : null,
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primary,
            ),
            items:
                categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
            onChanged: onCategoryChanged,
          ),
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogModel blog;

  const _BlogCard({required this.blog});

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDraft = blog.status.toLowerCase() == 'draft';
    final hasImage = blog.imageUrls.isNotEmpty;
    final displayDate = _formatDate(blog.createdAt);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 12,
            color: AppColors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(AppRouter.createBlog, extra: blog);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    blog.imageUrls.first,
                    height: isMobile ? 140 : 120,
                    // Slightly taller image on mobile to balance aspect ratio
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: isMobile ? 140 : 120,
                          color: AppColors.border,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              blog.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDraft
                                      ? AppColors.orange.withValues(alpha: 0.1)
                                      : AppColors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              blog.status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDraft
                                        ? AppColors.orange
                                        : AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: Text(
                          blog.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            height: 1.3,
                            // Slightly reduce title size on mobile
                            fontSize: isMobile ? 18 : null,
                          ),
                          maxLines: hasImage ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Divider(
                        color: AppColors.border,
                        height: isMobile ? 16 : 24,
                      ),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              blog.authorId.isNotEmpty
                                  ? blog.authorId[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.authorId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  displayDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.black.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
