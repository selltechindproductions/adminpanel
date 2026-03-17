import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../../app/app_colors.dart';
import '../models/product_model.dart';

class CreateEditProductScreen extends StatefulWidget {
  final ProductModel? editingProduct;

  const CreateEditProductScreen({super.key, this.editingProduct});

  @override
  State<CreateEditProductScreen> createState() =>
      _CreateEditProductScreenState();
}

class _CreateEditProductScreenState extends State<CreateEditProductScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late ProductModel _currentProduct;
  late TabController _tabController;

  final quill.QuillController _quillController = quill.QuillController.basic();

  // Dynamic List Input Controllers
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _techStackController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  final List<PlatformFile> _pickedMedia = [];

  final List<String> _categories = [
    'Software',
    'Hardware',
    'SaaS',
    'Service',
    'API',
  ];
  final List<String> _scopes = ['Enterprise', 'SMB', 'B2B', 'B2C', 'Internal'];
  final List<String> _statuses = ['Draft', 'Active', 'Retired'];

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.editingProduct ?? ProductModel.newProduct();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quillController.dispose();
    _featureController.dispose();
    _techStackController.dispose();
    _tagController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() => _pickedMedia.addAll(result.files));
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Extract Quill Data: final delta = _quillController.document.toDelta().toJson();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingProduct != null;
    // Breakpoint to determine if the layout should be stacked (mobile/tablet) or row (desktop)
    final isMobile = MediaQuery.of(context).size.width < 900;
    // Smaller breakpoint for tighter paddings
    final isSmallMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit IT Product' : 'Create IT Product'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 16 : 24,
              vertical: 8,
            ),
            child: ElevatedButton.icon(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.save, size: 20),
              label: Text(isSmallMobile ? 'Save' : 'Save Product'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(isSmallMobile ? 16.0 : 24.0),
            child:
                isMobile
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT COLUMN: Stacked on top for Mobile
                        _buildLeftColumn(isSmallMobile),
                        const SizedBox(height: 24),
                        // RIGHT COLUMN: Stacked on bottom for Mobile
                        _buildRightColumn(isSmallMobile),
                      ],
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT COLUMN: Side by side for Web
                        Expanded(
                          flex: 5,
                          child: _buildLeftColumn(isSmallMobile),
                        ),
                        const SizedBox(width: 24),
                        // RIGHT COLUMN: Side by side for Web
                        Expanded(
                          flex: 2,
                          child: _buildRightColumn(isSmallMobile),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(bool isSmallMobile) {
    return _buildContentCard(
      title: 'Core Details',
      child: Column(
        children: [
          TextFormField(
            initialValue: _currentProduct.title,
            decoration: const InputDecoration(
              labelText: 'Product Title',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _currentProduct.title = val,
            validator: (val) => val!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              // Make scrollable on mobile to prevent overflow
              isScrollable: isSmallMobile,
              tabAlignment:
                  isSmallMobile ? TabAlignment.start : TabAlignment.fill,
              tabs: const [
                Tab(text: 'Description', icon: Icon(Icons.description)),
                Tab(text: 'Features & Tech', icon: Icon(Icons.featured_video)),
                Tab(text: 'SEO Setup', icon: Icon(Icons.search)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuillEditor(),
                _buildFeaturesAndTech(),
                _buildSEO(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(bool isSmallMobile) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isSmallMobile ? 16 : 24),
      // Removed the nested SingleChildScrollView here because the parent is already a SingleChildScrollView.
      // This prevents physics conflicts and layout errors on mobile.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            'Status',
            _statuses,
            _currentProduct.status,
            (val) => _currentProduct.status = val!,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Category',
            _categories,
            _currentProduct.category.isEmpty ? null : _currentProduct.category,
            (val) => _currentProduct.category = val!,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Target Scope',
            _scopes,
            _currentProduct.scope.isEmpty ? null : _currentProduct.scope,
            (val) => _currentProduct.scope = val!,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _currentProduct.price.toString(),
            decoration: const InputDecoration(
              labelText: 'Base Price (USD)',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onSaved:
                (val) =>
                    _currentProduct.price = double.tryParse(val ?? '0') ?? 0.0,
          ),
          const SizedBox(height: 32),
          const Text(
            'Product Imagery',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildImageGallery(),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items:
          items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Required' : null,
    );
  }

  // --- EDITOR & TABS ---
  Widget _buildQuillEditor() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          quill.QuillSimpleToolbar(
            controller: _quillController,
            config: const quill.QuillSimpleToolbarConfig(
              // Allow toolbar to wrap smoothly on narrow devices
              multiRowsDisplay: true,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: quill.QuillEditor.basic(
                controller: _quillController,
                config: const quill.QuillEditorConfig(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesAndTech() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipInputSection(
            'Key Features',
            _currentProduct.features,
            _featureController,
          ),
          const SizedBox(height: 24),
          _buildChipInputSection(
            'Tech Stack & Integrations',
            _currentProduct.techStack,
            _techStackController,
          ),
          const SizedBox(height: 24),
          _buildChipInputSection(
            'Search Tags',
            _currentProduct.tags,
            _tagController,
          ),
        ],
      ),
    );
  }

  Widget _buildSEO() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            initialValue: _currentProduct.slug,
            decoration: const InputDecoration(
              labelText: 'URL Slug',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _currentProduct.slug = val,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _currentProduct.metaTitle,
            decoration: const InputDecoration(
              labelText: 'Meta Title',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _currentProduct.metaTitle = val,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _currentProduct.metaDescription,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Meta Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _currentProduct.metaDescription = val,
          ),
          const SizedBox(height: 16),
          _buildChipInputSection(
            'SEO Keywords',
            _currentProduct.keywords,
            _keywordController,
          ),
        ],
      ),
    );
  }

  // --- REUSABLE CHIP INPUT (For Tags, Features, Tech Stack) ---
  Widget _buildChipInputSection(
    String label,
    List<String> listRef,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              listRef
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      deleteIconColor: AppColors.red,
                      onDeleted: () => setState(() => listRef.remove(item)),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Add new...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    listRef.add(controller.text.trim());
                    controller.clear();
                  });
                }
              },
            ),
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              setState(() {
                listRef.add(val.trim());
                controller.clear();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _pickMedia,
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Images'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._currentProduct.imageUrls.map(
              (url) => _buildMediaBox(
                isNetwork: true,
                url: url,
                onRemove:
                    () => setState(() => _currentProduct.imageUrls.remove(url)),
              ),
            ),
            ..._pickedMedia.map(
              (file) => _buildMediaBox(
                isNetwork: false,
                local: file,
                onRemove: () => setState(() => _pickedMedia.remove(file)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaBox({
    required bool isNetwork,
    required VoidCallback onRemove,
    String? url,
    PlatformFile? local,
  }) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image:
                  isNetwork
                      ? NetworkImage(url!) as ImageProvider
                      : MemoryImage(local!.bytes!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
