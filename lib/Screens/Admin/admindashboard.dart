import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyhub_032_031/Screens/Admin/schadminapp.dart';
import 'package:studyhub_032_031/Screens/Admin/scholarshipuniversities.dart' hide UniversityPage;

import '../../Consultant/admin_requests_page.dart';
import '../../FeedBack/comments.dart';
import 'Universityadd.dart';
import 'admin_application_list.dart';
import 'adminlogin.dart';
import 'adminseetransaction.dart';

class AdminDashboard77 extends StatefulWidget {
  const AdminDashboard77({super.key});

  @override
  State<AdminDashboard77> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard77> {
  // Teal and White color palette
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color accentGold = Color(0xFFE6B800);

  // Status Colors
  static const Color statusAccepted = Color(0xFF28A745);
  static const Color statusRejected = Color(0xFFDC3545);

  int _selectedIndex = 0;
  bool _isLoggingOut = false;
  bool _isSidebarExpanded = true;
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() {
          username = doc["username"] ?? "Admin";
          email = user.email ?? "";
        });
      } else {
        setState(() {
          username = "Admin";
          email = user.email ?? "";
        });
      }
    }
  }

  Future<void> _deleteUniversity(String docId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete University", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this university? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('universities')
                    .doc(docId)
                    .delete();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("University deleted successfully"),
                    backgroundColor: primaryTeal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error deleting: $e"),
                    backgroundColor: statusRejected,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: statusRejected, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLoginPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: statusRejected,
          ),
        );
      }
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  void _viewUniversityDetails(Map<String, dynamic> universityData, String docId) {
    showDialog(
      context: context,
      builder: (context) => UniversityDetailDialog(
        universityData: universityData,
        docId: docId,
        onUpdate: () {
          // Refresh the table after update
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: isMobile
          ? AppBar(
        backgroundColor: pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isSidebarExpanded ? Icons.close : Icons.menu,
            color: primaryTeal,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _isSidebarExpanded = !_isSidebarExpanded;
            });
          },
        ),
        title: const Text(
          'StudyHub Admin',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      )
          : null,
      body: Row(
        children: [
          // Sidebar - Always visible on web, toggle on mobile
          if (!isMobile || _isSidebarExpanded)
            Container(
              width: isMobile ? screenWidth * 0.7 : 220,
              child: _buildSidebar(isMobile),
            ),

          // Main Content
          Expanded(
            child: _buildMainContent(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isMobile) {
    return Container(
      color: pureWhite,
      child: Column(
        children: [
          // Sidebar Header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'StudyHub',
                      style: TextStyle(
                        color: primaryTeal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User Profile Card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: smokeWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryTeal,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 10,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isSelected: _selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        if (isMobile) _isSidebarExpanded = false;
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.description,
                    label: 'Applications',
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminApplicationList(
                            applicationNumber: 0,
                            applicationData: {},
                          ),
                        ),
                      );
                      if (isMobile) setState(() => _isSidebarExpanded = false);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.school,
                    label: 'Scholarships App',
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminApplicationList03(
                            applicationNumber: 0,
                            applicationData: {},
                          ),
                        ),
                      );
                      if (isMobile) setState(() => _isSidebarExpanded = false);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.feedback,
                    label: 'Users Feedbacks',
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplicationHistory03(),
                        ),
                      );
                      if (isMobile) setState(() => _isSidebarExpanded = false);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.handshake,
                    label: 'Consultancy',
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminRequestsPage(),
                        ),
                      );
                      if (isMobile) setState(() => _isSidebarExpanded = false);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.payment,
                    label: 'Transactions',
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionList(),
                        ),
                      );
                      if (isMobile) setState(() => _isSidebarExpanded = false);
                    },
                  ),

                  const Spacer(),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: _isLoggingOut ? null : _handleLogout,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: statusRejected.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: statusRejected.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (_isLoggingOut)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    statusRejected,
                                  ),
                                ),
                              )
                            else
                              const Icon(
                                Icons.logout,
                                color: statusRejected,
                                size: 18,
                              ),
                            const SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: statusRejected,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryTeal.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? primaryTeal : textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? primaryTeal : textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: primaryTeal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome back, $username',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            childAspectRatio: isMobile ? 1.1 : 1.3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildDashboardBox(
                title: "Applications",
                stream: FirebaseFirestore.instance
                    .collection('broadmindedness')
                    .doc('stats sch')
                    .snapshots(),
                color: primaryTeal,
                icon: Icons.folder,
              ),
              _buildDashboardBox(
                title: "Accepted",
                stream: FirebaseFirestore.instance
                    .collection('acceptedapplications')
                    .doc('stats sch')
                    .snapshots(),
                color: statusAccepted,
                icon: Icons.check_circle,
              ),
              _buildDashboardBox(
                title: "Rejected",
                stream: FirebaseFirestore.instance
                    .collection('rejectedapplications')
                    .doc('stats sch')
                    .snapshots(),
                color: statusRejected,
                icon: Icons.cancel,
              ),
              _buildDashboardBox(
                title: "Scholarships",
                stream: FirebaseFirestore.instance
                    .collection('admindashboardww')
                    .doc('stats sch')
                    .snapshots(),
                color: accentGold,
                icon: Icons.school,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Universities Section
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primaryTeal,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Universities & Scholarships',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons
                if (isMobile)
                  Column(
                    children: [
                      _buildActionButton(
                        icon: Icons.add,
                        label: 'New University',
                        color: primaryTeal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UniversityPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        icon: Icons.add,
                        label: 'Scholarships',
                        color: lightTeal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Scholarshipuniversities(),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.add,
                          label: 'Add New University',
                          color: primaryTeal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UniversityPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.add,
                          label: 'Add Scholarship',
                          color: lightTeal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Scholarshipuniversities(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Universities Table
          Container(
            decoration: BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.table_chart,
                          color: primaryTeal,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Universities List',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Table
                  _buildUniversitiesTable(),
                ],
              ),
            ),
          ),

          if (isMobile) const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDashboardBox({
    required String title,
    required Stream<DocumentSnapshot> stream,
    required Color color,
    required IconData icon,
  }) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        int count = 0;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          count = data['totalApplications'] ?? 0;
        }

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversitiesTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('universities')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: primaryTeal),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.school_outlined, size: 40, color: textSecondary),
                const SizedBox(height: 8),
                Text('No universities yet',
                  style: TextStyle(color: textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryTeal.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: primaryTeal.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    _buildTableHeader('ID', width: 130),
                    _buildTableHeader('University', width: 150),
                    _buildTableHeader('Country', width: 80),
                    _buildTableHeader('Tuition(\$)', width: 80),
                    _buildTableHeader('Program', width: 100),
                    _buildTableHeader('Subjects', width: 100),
                    _buildTableHeader('Action', width: 70),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Table Rows - Now Clickable
              ...snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                String getValue(String key) {
                  return data[key]?.toString() ?? '-';
                }

                return InkWell(
                  onTap: () => _viewUniversityDetails(data, doc.id),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: borderColor.withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTableCell(getValue('ID'), width: 130),
                        _buildTableCell(getValue('name'), width: 150, isBold: true),
                        _buildTableCell(getValue('Country'), width: 80),
                        _buildTableCell(getValue('tuitionFee'), width: 80),
                        _buildTableCell(getValue('Program'), width: 100),
                        _buildTableCell(getValue('Course'), width: 100),
                        // Action Cell with Delete Button
                        SizedBox(
                          width: 70,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: statusRejected, size: 18),
                              onPressed: () => _deleteUniversity(doc.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(String text, {required double width}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: textPrimary,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {required double width, bool isBold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textPrimary,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

// University Detail Dialog with View and Update Functionality
class UniversityDetailDialog extends StatefulWidget {
  final Map<String, dynamic> universityData;
  final String docId;
  final VoidCallback onUpdate;

  const UniversityDetailDialog({
    Key? key,
    required this.universityData,
    required this.docId,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<UniversityDetailDialog> createState() => _UniversityDetailDialogState();
}

class _UniversityDetailDialogState extends State<UniversityDetailDialog> {
  late Map<String, TextEditingController> controllers;
  bool isEditing = false;
  bool isLoading = false;

  final Color primaryTeal = const Color(0xFF008080);
  final Color textPrimary = const Color(0xFF264653);
  final Color textSecondary = const Color(0xFF6B7B8A);
  final Color borderColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    controllers = {
      'universityId': TextEditingController(text: widget.universityData['ID']?.toString() ?? ''),
      'name': TextEditingController(text: widget.universityData['name']?.toString() ?? ''),
      'country': TextEditingController(text: widget.universityData['Country']?.toString() ?? ''),
      'city': TextEditingController(text: widget.universityData['city']?.toString() ?? ''),
      'tuitionFee': TextEditingController(text: widget.universityData['tuitionFee']?.toString() ?? ''),
      'program': TextEditingController(text: widget.universityData['Program']?.toString() ?? ''),
      'subject': TextEditingController(text: widget.universityData['Course']?.toString() ?? ''),
      'duration': TextEditingController(text: widget.universityData['duration']?.toString() ?? ''),
      'deadline': TextEditingController(text: widget.universityData['deadline']?.toString() ?? ''),
      'website': TextEditingController(text: widget.universityData['website']?.toString() ?? ''),
      'description': TextEditingController(text: widget.universityData['description']?.toString() ?? ''),
    };
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _updateUniversity() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> updatedData = {};
      controllers.forEach((key, controller) {
        updatedData[key] = controller.text;
      });

      await FirebaseFirestore.instance
          .collection('universities')
          .doc(widget.docId)
          .update(updatedData);

      setState(() {
        isEditing = false;
        isLoading = false;
      });

      widget.onUpdate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('University updated successfully!'),
          backgroundColor: primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.school,
                  color: primaryTeal,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isEditing ? 'Edit University Details' : 'University Details',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.close : Icons.edit,
                    color: primaryTeal,
                  ),
                  onPressed: () {
                    if (isEditing) {
                      // Reset controllers
                      setState(() {
                        isEditing = false;
                        controllers.forEach((key, controller) {
                          controller.text = widget.universityData[key]?.toString() ?? '';
                        });
                      });
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(color: Color(0xFFE0E0E0)),
            const SizedBox(height: 10),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(

                child: Column(
                  children: [
                    _buildDetailField('University ID', 'universityId', Icons.numbers),
                    _buildDetailField('University Name', 'name', Icons.business),
                    _buildDetailField('Country', 'country', Icons.flag),
                    _buildDetailField('Tuition Fee (\$)', 'tuitionFee', Icons.attach_money),
                    _buildDetailField('Program', 'program', Icons.school),
                    _buildDetailField('Subject', 'subject', Icons.book),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE0E0E0)),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _updateUniversity,
                    icon: isLoading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryTeal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String fieldKey, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          isEditing
              ? TextFormField(
            controller: controllers[fieldKey],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryTeal, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: maxLines,
          )
              : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              controllers[fieldKey]?.text ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}