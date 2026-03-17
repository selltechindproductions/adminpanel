import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_admin_pannel/app/app_router.dart';

import '../../../app/app_colors.dart';
import '../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Mock Data
  final List<UserModel> _allUsers = [
    UserModel(
      id: '1',
      name: 'Pratham Soni',
      email: 'pratham@devnex.com',
      password: 'hashed_password',
      profilePic: 'https://i.pravatar.cc/150?img=11',
      profession: 'Flutter Developer',
      role: 'Admin',
      isVerified: true,
      createdAt: DateTime(2023, 5, 12),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: '2',
      name: 'Meghna Srivatsav',
      email: 'meghna@model.com',
      password: 'hashed_password',
      profilePic: 'https://i.pravatar.cc/150?img=5',
      profession: 'AI Influencer',
      role: 'Editor',
      isVerified: true,
      createdAt: DateTime(2024, 1, 20),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: '3',
      name: 'John Doe',
      email: 'john.doe@example.com',
      password: 'hashed_password',
      profilePic: '',
      profession: 'Designer',
      role: 'User',
      isVerified: false,
      createdAt: DateTime(2024, 3, 10),
      updatedAt: DateTime.now(),
    ),
  ];

  String _searchQuery = '';
  String _selectedRole = 'All';
  final List<String> _roles = ['All', 'Admin', 'Editor', 'User'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter Logic
  List<UserModel> get _filteredUsers {
    return _allUsers.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRole == 'All' || user.role == _selectedRole;
      return matchesSearch && matchesRole;
    }).toList();
  }

  // --- ACTIONS ---
  void _deleteUser(UserModel user) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete User?'),
            content: Text(
              'Are you sure you want to delete ${user.name}? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _allUsers.removeWhere((u) => u.id == user.id);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${user.name} deleted successfully.'),
                    ),
                  );
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
    final filteredList = _filteredUsers;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchAndFilterBar(),
              const SizedBox(height: 24),
              Expanded(
                child:
                    filteredList.isEmpty
                        ? _buildEmptyState()
                        : _buildUsersTable(filteredList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Users Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.push(AppRouter.usersEdit);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.person_add),
          label: const Text('Add New User'),
        ),
      ],
    );
  }

  // --- SEARCH & FILTER ---
  Widget _buildSearchAndFilterBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        Widget searchField = TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search by name or email...',
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
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

        Widget roleDropdown = Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              icon: const Icon(Icons.filter_list, color: AppColors.primary),
              items:
                  _roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
          ),
        );

        if (isMobile) {
          return Column(
            children: [searchField, const SizedBox(height: 12), roleDropdown],
          );
        }
        return Row(
          children: [
            Expanded(flex: 3, child: searchField),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: roleDropdown),
          ],
        );
      },
    );
  }

  // --- DATA TABLE ---
  Widget _buildUsersTable(List<UserModel> users) {
    return Container(
      width: double.infinity,
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
              dividerThickness: 1,
              dataRowMaxHeight: 70,
              dataRowMinHeight: 60,
              columns: const [
                DataColumn(
                  label: Text(
                    'User',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Profession',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Role',
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
                    'Joined',
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
              rows: users.map((user) => _buildDataRow(user)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(UserModel user) {
    return DataRow(
      cells: [
        // 1. User Info (Avatar + Name + Email)
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage:
                    user.profilePic.isNotEmpty
                        ? NetworkImage(user.profilePic)
                        : null,
                child:
                    user.profilePic.isEmpty
                        ? Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    user.email,
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

        // 2. Profession
        DataCell(
          Text(user.profession, style: const TextStyle(color: AppColors.black)),
        ),

        // 3. Role Chip
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  user.role == 'Admin'
                      ? AppColors.purple.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    user.role == 'Admin' ? AppColors.purple : AppColors.primary,
              ),
            ),
          ),
        ),

        // 4. Status (Verified / Unverified)
        DataCell(
          Row(
            children: [
              Icon(
                user.isVerified ? Icons.check_circle : Icons.pending,
                size: 16,
                color: user.isVerified ? AppColors.green : AppColors.orange,
              ),
              const SizedBox(width: 6),
              Text(
                user.isVerified ? 'Verified' : 'Unverified',
                style: TextStyle(
                  color: user.isVerified ? AppColors.green : AppColors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // 5. Date Joined
        DataCell(
          Text(
            '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
            style: TextStyle(color: AppColors.black.withValues(alpha: 0.7)),
          ),
        ),

        // 6. Actions (View, Edit, Delete)
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: 'View Profile',
                onPressed: () {
                  // TODO: Route to view profile
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.indigo,
                  size: 20,
                ),
                tooltip: 'Edit User',
                onPressed: () {
                  context.push(AppRouter.usersEdit, extra: user);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 20,
                ),
                tooltip: 'Delete User',
                onPressed: () => _deleteUser(user),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or role filter.',
            style: TextStyle(color: AppColors.black.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}
