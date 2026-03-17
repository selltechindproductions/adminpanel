import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../models/user_model.dart';

class CreateEditUserScreen extends StatefulWidget {
  final UserModel? editingUser; // If null, we are creating a new user

  const CreateEditUserScreen({super.key, this.editingUser});

  @override
  State<CreateEditUserScreen> createState() => _CreateEditUserScreenState();
}

class _CreateEditUserScreenState extends State<CreateEditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  // State Variables
  String _selectedRole = 'User';
  bool _isVerified = false;
  bool _obscurePassword = true;

  // Image State
  PlatformFile? _pickedProfilePic;
  String _existingProfilePicUrl = '';

  final List<String> _roles = ['Admin', 'Editor', 'User'];

  @override
  void initState() {
    super.initState();
    if (widget.editingUser != null) {
      final user = widget.editingUser!;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _professionController.text = user.profession;
      _selectedRole = _roles.contains(user.role) ? user.role : 'User';
      _isVerified = user.isVerified;
      _existingProfilePicUrl = user.profilePic;
      // Note: We deliberately leave _passwordController empty when editing
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  // --- WEB-SAFE IMAGE PICKER ---
  Future<void> _pickProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // CRITICAL FOR FLUTTER WEB
      );

      if (result != null) {
        setState(() {
          _pickedProfilePic = result.files.first;
        });
      }
    } catch (e) {
      debugPrint("Error picking profile image: $e");
    }
  }

  // --- SAVE LOGIC ---
  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.editingUser != null;

      // TODO: Handle Image Upload to Storage Bucket here if _pickedProfilePic != null
      // TODO: Create or Update UserModel in Database

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'User updated successfully!' : 'New user created!',
          ),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editingUser != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Create New User'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.border),
              ),
              child: const Text('Cancel'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Create User',
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
                  // Desktop Layout: Two Columns
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildMainInfoCard(isEditing)),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildSettingsSidebar(isEditing),
                      ),
                    ],
                  );
                } else {
                  // Mobile Layout: Stacked
                  return Column(
                    children: [
                      _buildMainInfoCard(isEditing),
                      const SizedBox(height: 24),
                      _buildSettingsSidebar(isEditing),
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

  // --- MAIN INFO SECTION (Left Column) ---
  Widget _buildMainInfoCard(bool isEditing) {
    return _buildContentCard(
      title: 'Basic Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Avatar Picker
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.border,
                  backgroundImage: _getAvatarImage(),
                  child:
                      (_pickedProfilePic == null &&
                              _existingProfilePicUrl.isEmpty)
                          ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.textColor,
                          )
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Name Field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator:
                (val) =>
                    (val == null || val.trim().isEmpty)
                        ? 'Name is required'
                        : null,
          ),
          const SizedBox(height: 24),

          // Email Field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Profession Field
          TextFormField(
            controller: _professionController,
            decoration: const InputDecoration(
              labelText: 'Profession',
              hintText: 'e.g., Software Engineer',
            ),
          ),
          const SizedBox(height: 24),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText:
                  isEditing
                      ? 'New Password (Leave blank to keep current)'
                      : 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
                onPressed:
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (val) {
              if (!isEditing && (val == null || val.isEmpty)) {
                return 'Password is required for new users';
              }
              if (val != null && val.isNotEmpty && val.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // --- SETTINGS SECTION (Right Column) ---
  Widget _buildSettingsSidebar(bool isEditing) {
    return Column(
      children: [
        _buildContentCard(
          title: 'Account Settings',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Role Dropdown
              const Text(
                'User Role',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.scaffoldBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items:
                    _roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 24),

              // Verification Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified Account',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _isVerified
                            ? 'User has a verified badge'
                            : 'User is not verified',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isVerified,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _isVerified = val),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Read-only Metadata for Existing Users
        if (isEditing) ...[
          const SizedBox(height: 24),
          _buildContentCard(
            title: 'System Metadata',
            child: Column(
              children: [
                _buildMetadataRow('User ID', widget.editingUser!.id),
                const Divider(color: AppColors.border),
                _buildMetadataRow(
                  'Created',
                  _formatDate(widget.editingUser!.createdAt),
                ),
                const Divider(color: AppColors.border),
                _buildMetadataRow(
                  'Last Updated',
                  _formatDate(widget.editingUser!.updatedAt),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // --- HELPERS ---
  ImageProvider? _getAvatarImage() {
    if (_pickedProfilePic != null && _pickedProfilePic!.bytes != null) {
      return MemoryImage(_pickedProfilePic!.bytes!); // Web-safe local preview
    } else if (_existingProfilePicUrl.isNotEmpty) {
      return NetworkImage(_existingProfilePicUrl); // Existing network image
    }
    return null;
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

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.black.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

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
}
