import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../models/contacts_model.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // Mock Data
  final List<ContactMessageModel> _allMessages = [
    ContactMessageModel(
      id: '1',
      name: 'Alice Johnson',
      email: 'alice.j@example.com',
      phone: '+1 555-0102',
      message:
          'Hello, I am interested in your enterprise ERP pricing. Can we schedule a demo call this week?',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    ContactMessageModel(
      id: '2',
      name: 'Bob Smith',
      email: 'bob.smith@startup.io',
      phone: '+44 7700 900077',
      message:
          'I found a bug on the checkout page of your website. Attached are the screenshots (sent via email).',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    ContactMessageModel(
      id: '3',
      name: 'Charlie Davis',
      email: 'charlie@marketing.com',
      phone: '+1 555-0198',
      message:
          'We would love to partner with DevNex for our upcoming marketing campaign.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
    ),
    // Added extra mock data to demonstrate vertical scrolling
    ContactMessageModel(
      id: '4',
      name: 'David Lee',
      email: 'd.lee@techhub.com',
      phone: '+1 555-0200',
      message: 'Are you guys available for a freelance mobile app project?',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    ContactMessageModel(
      id: '5',
      name: 'Eve Carter',
      email: 'eve.carter@mail.com',
      phone: '+1 555-0311',
      message: 'I need support with my recent purchase of the dashboard.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: false,
    ),
  ];

  // State
  String _searchQuery = '';
  String _selectedStatus = 'All';
  final List<String> _statusFilters = ['All', 'Unread', 'Read'];
  final TextEditingController _searchController = TextEditingController();

  // Scroll Controllers for explicit scrollbars
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Bulk Selection State
  final Set<String> _selectedMessageIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  // --- FILTERING LOGIC ---
  List<ContactMessageModel> get _filteredMessages {
    return _allMessages.where((msg) {
      final matchesSearch =
          msg.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          msg.email.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesStatus = true;
      if (_selectedStatus == 'Unread') matchesStatus = !msg.isRead;
      if (_selectedStatus == 'Read') matchesStatus = msg.isRead;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // --- ACTIONS ---
  void _markAsRead(ContactMessageModel msg) {
    setState(() => msg.isRead = true);
  }

  void _deleteMessage(ContactMessageModel msg) {
    setState(() {
      _allMessages.removeWhere((m) => m.id == msg.id);
      _selectedMessageIds.remove(msg.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message from ${msg.name} deleted.')),
    );
  }

  void _openViewDialog(ContactMessageModel msg) {
    _markAsRead(msg);
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Message Details'),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow('Name', msg.name),
                    _buildDetailRow('Email', msg.email),
                    _buildDetailRow('Phone', msg.phone),
                    _buildDetailRow('Date', _formatDate(msg.createdAt)),
                    const Divider(height: 32),
                    const Text(
                      'Message:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        msg.message,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openComposeEmailDialog(recipients: [msg.email]);
                },
                icon: const Icon(Icons.reply, size: 18),
                label: const Text('Reply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  /// Opens the email composer. If [recipients] is null or empty, it creates a blank email.
  void _openComposeEmailDialog({List<String>? recipients}) {
    final bool isNewEmail = recipients == null || recipients.isEmpty;

    final formKey = GlobalKey<FormState>();
    final toCtrl = TextEditingController(
      text: isNewEmail ? '' : recipients.join(', '),
    );
    final subjectCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    String dialogTitle = 'Compose Email';
    if (!isNewEmail) {
      dialogTitle =
          recipients.length > 1 ? 'Send Bulk Email' : 'Reply to Message';
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(dialogTitle),
            content: SizedBox(
              width: 600,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: toCtrl,
                        readOnly: !isNewEmail,
                        // Only read-only if replying/bulk sending
                        decoration: InputDecoration(
                          labelText: 'To',
                          hintText:
                              isNewEmail ? 'Enter recipient email(s)...' : null,
                          border: const OutlineInputBorder(),
                          filled: !isNewEmail,
                          fillColor:
                              !isNewEmail
                                  ? AppColors.scaffoldBackground
                                  : Colors.white,
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Recipient is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: subjectCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Subject is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: bodyCtrl,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: 'Message Body',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Message cannot be empty'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // TODO: Integrate backend Email Sending API here
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isNewEmail
                              ? 'Email sent successfully!'
                              : 'Email sent to ${recipients.length} recipient(s) successfully!',
                        ),
                        backgroundColor: AppColors.green,
                      ),
                    );
                    setState(() => _selectedMessageIds.clear());
                  }
                },
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Send Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  // --- UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final filtered = _filteredMessages;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 16 : 24),
              _buildSearchAndFilterBar(isMobile),
              SizedBox(height: isMobile ? 16 : 24),
              // The Expanded widget ensures the container takes all remaining vertical space,
              // which enables internal vertical scrolling if contents exceed height.
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child:
                      filtered.isEmpty
                          ? _buildEmptyState()
                          : _buildDataTable(filtered),
                ),
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
        Expanded(
          child: Text(
            'Inbox & Contacts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 22 : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedMessageIds.isNotEmpty) ...[
              ElevatedButton.icon(
                onPressed: () {
                  final emails =
                      _allMessages
                          .where((m) => _selectedMessageIds.contains(m.id))
                          .map((m) => m.email)
                          .toList();
                  _openComposeEmailDialog(recipients: emails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                icon: const Icon(Icons.forward_to_inbox, size: 20),
                label: Text(
                  isMobile
                      ? 'Bulk'
                      : 'Bulk Email (${_selectedMessageIds.length})',
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
            ],
            ElevatedButton.icon(
              onPressed: () => _openComposeEmailDialog(),
              // Null passes to compose blank email
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 12 : 16,
                ),
              ),
              icon: const Icon(Icons.edit, size: 20),
              label: Text(isMobile ? 'Compose' : 'Compose Email'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(bool isMobile) {
    Widget searchField = TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search by name or email...',
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

    Widget statusDropdown = DropdownButtonFormField<String>(
      value: _selectedStatus,
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
          _statusFilters
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
      onChanged: (val) => setState(() => _selectedStatus = val!),
    );

    if (isMobile) {
      return Column(
        children: [searchField, const SizedBox(height: 12), statusDropdown],
      );
    }
    return Row(
      children: [
        Expanded(flex: 3, child: searchField),
        const SizedBox(width: 16),
        Expanded(flex: 1, child: statusDropdown),
      ],
    );
  }

  Widget _buildDataTable(List<ContactMessageModel> filtered) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      // Adding Scrollbars for better UX on desktop
      child: Scrollbar(
        controller: _horizontalScrollController,
        child: SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Scrollbar(
            controller: _verticalScrollController,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical, // Explicit vertical scrolling
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppColors.scaffoldBackground,
                ),
                dataRowMaxHeight: 80,
                dataRowMinHeight: 60,
                showCheckboxColumn: true,
                onSelectAll: (isSelected) {
                  setState(() {
                    if (isSelected == true) {
                      _selectedMessageIds.addAll(filtered.map((e) => e.id));
                    } else {
                      _selectedMessageIds.clear();
                    }
                  });
                },
                columns: const [
                  DataColumn(
                    label: Text(
                      'Sender',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Contact Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Message',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
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
                    filtered.map((msg) {
                      final isSelected = _selectedMessageIds.contains(msg.id);
                      final isUnread = !msg.isRead;

                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedMessageIds.add(msg.id);
                            } else {
                              _selectedMessageIds.remove(msg.id);
                            }
                          });
                        },
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Text(
                                    msg.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  msg.name,
                                  style: TextStyle(
                                    fontWeight:
                                        isUnread
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  msg.email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  msg.phone,
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
                          DataCell(
                            SizedBox(
                              width: 250, // Prevents table stretching
                              child: Text(
                                msg.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.black.withValues(alpha: 0.7),
                                  fontWeight:
                                      isUnread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(_formatDate(msg.createdAt))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isUnread
                                        ? AppColors.orange.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.border.withValues(
                                          alpha: 0.5,
                                        ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isUnread ? 'New' : 'Read',
                                style: TextStyle(
                                  color:
                                      isUnread
                                          ? AppColors.orange
                                          : AppColors.black.withValues(
                                            alpha: 0.6,
                                          ),
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
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  tooltip: 'View Message',
                                  onPressed: () => _openViewDialog(msg),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.reply,
                                    color: AppColors.indigo,
                                    size: 20,
                                  ),
                                  tooltip: 'Reply',
                                  onPressed:
                                      () => _openComposeEmailDialog(
                                        recipients: [msg.email],
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    size: 20,
                                  ),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteMessage(msg),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          Text(
            'Inbox is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.black.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
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
