/// Extended model for production editing and SEO optimization.
class BlogModel {
  final String? id;
  String title;
  String content;
  String category;
  List<String> imageUrls; // Supports multiple images
  String status; // e.g., 'Draft', 'Published'
  String authorId;
  DateTime createdAt;
  DateTime updatedAt;

  // --- Professional SEO Settings ---
  String slug; // The URL-friendly version of the title
  String metaTitle; // For search engine title (defaults to Blog Title)
  String metaDescription; // The short summary shown in search results
  List<String> keywords; // Specific focus keywords or tags for indexing

  BlogModel({
    this.id,
    this.title = '',
    this.content = '',
    this.category = 'Select Category',
    this.imageUrls = const [],
    this.status = 'Draft',
    this.authorId = '', // e.g., current admin ID
    required this.createdAt,
    required this.updatedAt,
    this.slug = '',
    this.metaTitle = '',
    this.metaDescription = '',
    this.keywords = const [],
  });

  // Factory constructor for a new blank blog
  // Factory constructor for a new blank blog
  factory BlogModel.newBlog() {
    return BlogModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'Draft',
      title: '',
      content: '',
      category: '',
      // Blank category so the dropdown shows the "Category" label cleanly
      slug: '',
      metaTitle: '',
      metaDescription: '',
      authorId: '',
      imageUrls: [],
      // Mutable list!
      keywords: [], // Mutable list!
    );
  }
}
