class ProductModel {
  final String? id;
  String title;
  String description; // Natively stores Quill Delta or HTML
  String category; // e.g., Software, Hardware, SaaS, Service
  String scope; // e.g., Enterprise, SMB, B2C, B2B
  double price; // Base price or starting price
  String status; // 'Active', 'Draft', 'Retired'

  // Arrays for detailed IT specs
  List<String> imageUrls;
  List<String> features;
  List<String> techStack; // e.g., React, Node.js, AWS, Flutter
  List<String> tags; // General search tags

  // SEO Configurations
  String slug;
  String metaTitle;
  String metaDescription;
  List<String> keywords;

  DateTime createdAt;
  DateTime updatedAt;

  ProductModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.scope,
    this.price = 0.0,
    required this.status,
    this.imageUrls = const [],
    this.features = const [],
    this.techStack = const [],
    this.tags = const [],
    this.slug = '',
    this.metaTitle = '',
    this.metaDescription = '',
    this.keywords = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory for a safe, blank new product
  factory ProductModel.newProduct() {
    return ProductModel(
      title: '',
      description: '',
      category: '',
      scope: '',
      status: 'Draft',
      imageUrls: [],
      features: [],
      techStack: [],
      tags: [],
      keywords: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
