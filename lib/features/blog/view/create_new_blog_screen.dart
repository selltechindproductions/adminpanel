import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- NEW DEPENDENCIES ---
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../app/app_colors.dart';
import '../models/blog_model.dart';

class CreateNewBlogScreen extends StatefulWidget {
  final BlogModel? editingBlog;

  const CreateNewBlogScreen({super.key, this.editingBlog});

  @override
  State<CreateNewBlogScreen> createState() => _CreateNewBlogScreenState();
}

class _CreateNewBlogScreenState extends State<CreateNewBlogScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late BlogModel _currentBlog;
  late TabController _tabController;

  // Rich Text Editor Controller
  final quill.QuillController _quillController = quill.QuillController.basic();

  // SEO Controllers
  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _metaDescController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();

  // Local Media State for Web Uploads
  final List<PlatformFile> _pickedMedia = [];

  final List<String> _categories = [
    'Technology',
    'Design',
    'Lifestyle',
    'Business',
    'Update',
  ];
  final List<String> _statuses = ['Draft', 'Published', 'Archived'];

  @override
  void initState() {
    super.initState();
    _currentBlog = widget.editingBlog ?? BlogModel.newBlog();

    _slugController.text = _currentBlog.slug;
    _metaDescController.text = _currentBlog.metaDescription;

    // TODO: If editing an existing blog, load _currentBlog.content (HTML) into _quillController here

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _slugController.dispose();
    _metaDescController.dispose();
    _keywordsController.dispose();
    _tabController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _generateSlug(String title) {
    if (widget.editingBlog == null) {
      setState(() {
        _currentBlog.slug = title.toLowerCase().trim().replaceAll(
          RegExp(r'[^a-z0-9]+'),
          '-',
        );
        _slugController.text = _currentBlog.slug;
      });
    }
  }

  // --- NATIVE WEB FILE PICKER ---
  Future<void> _pickMediaFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.media, // Allows images and videos
        withData: true, // CRITICAL FOR FLUTTER WEB
      );

      if (result != null) {
        setState(() {
          _pickedMedia.addAll(result.files);
        });
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  void _handlePublish() {
    if (_formKey.currentState!.validate()) {
      // 1. Extract content from Quill
      final deltaJson = _quillController.document.toDelta().toJson();

      // NOTE: To convert this to raw HTML for your backend, you would typically
      // use the 'vsc_quill_delta_to_html' package right here:
      // final htmlContent = QuillDeltaToHtmlConverter(deltaJson).convert();

      // 2. Upload _pickedMedia files to your storage bucket (Firebase/Supabase)
      // 3. Add resulting URLs to _currentBlog.imageUrls
      // 4. Send _currentBlog to database

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing blog for publish...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEditing = widget.editingBlog != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Blog' : 'Create New Blog'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                // TODO: Draft Saving Logic
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.border),
              ),
              child: const Text('Save as Draft'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: ElevatedButton(
              onPressed: _handlePublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                isEditing ? 'Update Blog' : 'Publish Blog',
                style: const TextStyle(color: AppColors.backgroundColor),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildMainContentArea()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildSidebar(theme)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildMainContentArea(),
                      const SizedBox(height: 24),
                      _buildSidebar(theme),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContentArea() {
    return Column(
      children: [
        _buildContentCard(
          title: 'Blog Content',
          child: Column(
            children: [
              TextFormField(
                initialValue: _currentBlog.title,
                decoration: const InputDecoration(
                  labelText: 'Blog Title',
                  hintText: 'Optimal for indexing: 50-60 chars',
                ),
                maxLength: 70,
                onChanged: (val) {
                  _currentBlog.title = val;
                  _generateSlug(val);
                },
                validator:
                    (val) =>
                        (val == null || val.trim().isEmpty)
                            ? 'Title is required'
                            : null,
              ),
              const SizedBox(height: 24),

              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.black.withValues(alpha: .6),
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'Rich Content Editor'),
                    Tab(text: 'SEO Configuration'),
                  ],
                ),
              ),

              SizedBox(
                height: 500, // Taller for the editor
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildQuillEditor(), _buildSEOConfig()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- PROFESSIONAL RICH TEXT EDITOR ---
  Widget _buildQuillEditor() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Toolbar (FIXED FOR v11 API)
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.all(8),
              child: quill.QuillSimpleToolbar(
                controller: _quillController,
                config: const quill.QuillSimpleToolbarConfig(),
              ),
            ),
            // Editor Area (FIXED FOR v11 API)
            Expanded(
              child: Container(
                color: AppColors.backgroundColor,
                padding: const EdgeInsets.all(16),
                child: quill.QuillEditor.basic(
                  controller: _quillController,
                  config: const quill.QuillEditorConfig(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSEOConfig() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _slugController,
            decoration: const InputDecoration(
              labelText: 'URL Slug',
              prefixText: '/blog/',
              helperText: 'Unique and descriptive URL path.',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9-]')),
            ],
            onChanged: (val) => _currentBlog.slug = val,
          ),
          const SizedBox(height: 16),
          _buildSEOMetaFields(),
          const SizedBox(height: 16),
          _buildKeywordTagging(),
        ],
      ),
    );
  }

  Widget _buildSEOMetaFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          TextField(
            controller: _metaDescController,
            maxLines: 3,
            maxLength: 160,
            decoration: InputDecoration(
              labelText: 'Meta Description',
              hintText: 'Summarize content within 150-160 characters.',
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterText:
                  '${_metaDescController.text.length} / 160 characters (Optimal)',
            ),
            onChanged: (val) {
              setState(() {
                _currentBlog.metaDescription = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
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

  Widget _buildKeywordTagging() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Focus Keywords (Optional)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              _currentBlog.keywords
                  .map(
                    (kw) => Chip(
                      label: Text(kw),
                      backgroundColor: AppColors.primary.withValues(alpha: .1),
                      labelStyle: const TextStyle(color: AppColors.primary),
                      deleteIconColor: AppColors.primary,
                      onDeleted: () {
                        setState(() {
                          _currentBlog.keywords.remove(kw);
                        });
                      },
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _keywordsController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Flutter, AdminPanel, SEO',
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {
                if (_keywordsController.text.trim().isNotEmpty) {
                  setState(() {
                    _currentBlog.keywords.add(_keywordsController.text.trim());
                    _keywordsController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_box),
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidebar(ThemeData theme) {
    final String? safeCategory =
        _categories.contains(_currentBlog.category)
            ? _currentBlog.category
            : null;

    final String safeStatus =
        _statuses.contains(_currentBlog.status)
            ? _currentBlog.status
            : _statuses.first;

    return Column(
      children: [
        _buildImageUploadSection(),
        const SizedBox(height: 24),
        _buildContentCard(
          title: 'Publishing Settings',
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: safeCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged:
                    (val) => setState(() => _currentBlog.category = val ?? ''),
                validator:
                    (val) =>
                        (val == null || val.isEmpty)
                            ? 'Category is required'
                            : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: safeStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items:
                    _statuses.map((s) {
                      final bool isDraft = s.toLowerCase() == 'draft';
                      return DropdownMenuItem(
                        value: s,
                        child: Text(
                          s,
                          style: TextStyle(
                            color: isDraft ? AppColors.orange : AppColors.green,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged:
                    (val) => setState(
                      () => _currentBlog.status = val ?? _statuses.first,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- MULTI-MEDIA PICKER (IMAGES & VIDEOS) ---
  Widget _buildImageUploadSection() {
    return _buildContentCard(
      title: 'Media Assets (Images & Videos)',
      child: Column(
        children: [
          _pickedMedia.isEmpty && _currentBlog.imageUrls.isEmpty
              ? _buildEmptyImagePlaceholder()
              : SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // 1. Show already uploaded images (if editing)
                    ..._currentBlog.imageUrls.map((url) {
                      return _buildMediaItem(
                        isNetwork: true,
                        url: url,
                        onRemove:
                            () => setState(
                              () => _currentBlog.imageUrls.remove(url),
                            ),
                      );
                    }),
                    // 2. Show newly picked local files (Web bytes)
                    ..._pickedMedia.map((file) {
                      return _buildMediaItem(
                        isNetwork: false,
                        localFile: file,
                        onRemove:
                            () => setState(() => _pickedMedia.remove(file)),
                      );
                    }),
                  ],
                ),
              ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickMediaFiles,
            icon: const Icon(Icons.perm_media_outlined),
            label: const Text('Browse Files'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to display either a network image, a local memory image, or a video placeholder
  Widget _buildMediaItem({
    required bool isNetwork,
    required VoidCallback onRemove,
    String? url,
    PlatformFile? localFile,
  }) {
    final bool isVideo =
        localFile?.extension?.toLowerCase() == 'mp4' ||
        localFile?.extension?.toLowerCase() == 'mov';

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              color: AppColors.scaffoldBackground,
            ),
            clipBehavior: Clip.hardEdge,
            child:
                isVideo
                    ? const Center(
                      child: Icon(
                        Icons.videocam,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    )
                    : Image(
                      image:
                          isNetwork
                              ? NetworkImage(url!) as ImageProvider
                              : MemoryImage(localFile!.bytes!),
                      // WEBSAFE: Using bytes instead of path
                      fit: BoxFit.cover,
                    ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyImagePlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, style: BorderStyle.none),
      ),
      child: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: AppColors.black.withValues(alpha: .3),
        ),
      ),
    );
  }
}
