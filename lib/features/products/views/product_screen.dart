import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_admin_pannel/app/app_router.dart';
import '../../../app/app_colors.dart';
import '../models/product_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Mock IT Products Data
  final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      title: 'Enterprise ERP System',
      description: 'Full-scale cloud ERP.',
      category: 'SaaS',
      scope: 'Enterprise',
      price: 4999.00,
      status: 'Active',
      imageUrls: ['https://picsum.photos/seed/erp/200'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    ProductModel(
      id: '2',
      title: 'DevNex Admin Dashboard',
      description: 'Flutter-based admin panel.',
      category: 'Software',
      scope: 'B2B',
      price: 299.00,
      status: 'Active',
      imageUrls: ['https://picsum.photos/seed/dash/200'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    ProductModel(
      id: '3',
      title: 'Legacy Payroll API',
      description: 'Old payroll system integration.',
      category: 'Service',
      scope: 'SMB',
      price: 0.0,
      status: 'Retired',
      imageUrls: [],
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  late List<String> _categories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categories = [
      'All',
      ..._allProducts.map((p) => p.category).toSet().toList(),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    return _allProducts.where((prod) {
      final matchesSearch = prod.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCat =
          _selectedCategory == 'All' || prod.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();
  }

  void _deleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Product?'),
            content: Text(
              'Are you sure you want to permanently delete ${product.title}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () => _allProducts.removeWhere((p) => p.id == product.id),
                  );
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
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
              _buildSearchAndFilterBar(isMobile),
              SizedBox(height: isMobile ? 16 : 24),

              // Data Table
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.scaffoldBackground,
                          ),
                          dataRowMaxHeight: 70,
                          dataRowMinHeight: 60,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Product',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Category',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Scope',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows:
                              filtered
                                  .map((prod) => _buildDataRow(prod))
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- EXTRACTED WIDGETS FOR RESPONSIVENESS ---

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'IT Products',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 22 : null, // Scale down slightly on mobile
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: isMobile ? 12 : 24),
        ElevatedButton.icon(
          onPressed: () {
            context.push(AppRouter.productsCreate);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
              vertical: isMobile ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add_box, size: 20),
          label: Text(isMobile ? 'Create' : 'New Product'),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(bool isMobile) {
    Widget searchField = TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );

    Widget categoryDropdown = DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isMobile ? 12 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      items:
          _categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
      onChanged: (val) => setState(() => _selectedCategory = val!),
    );

    // Stack vertically on mobile, place side-by-side on web/desktop
    if (isMobile) {
      return Column(
        children: [searchField, const SizedBox(height: 12), categoryDropdown],
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: searchField),
        const SizedBox(width: 16),
        Expanded(flex: 1, child: categoryDropdown),
      ],
    );
  }

  DataRow _buildDataRow(ProductModel prod) {
    final isActive = prod.status == 'Active';
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(8),
                  image:
                      prod.imageUrls.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(prod.imageUrls.first),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    prod.imageUrls.isEmpty
                        ? const Icon(
                          Icons.inventory_2,
                          color: AppColors.primary,
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prod.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    prod.id ?? 'New',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(prod.category)),
        DataCell(Text(prod.scope)),
        DataCell(
          Text(
            '\$${prod.price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? AppColors.green.withValues(alpha: 0.1)
                      : AppColors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              prod.status,
              style: TextStyle(
                color: isActive ? AppColors.green : AppColors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.indigo, size: 20),
                onPressed: () {
                  context.push(AppRouter.productsCreate, extra: prod);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.red, size: 20),
                onPressed: () => _deleteProduct(prod),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
