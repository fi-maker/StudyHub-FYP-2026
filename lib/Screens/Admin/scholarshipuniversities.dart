import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Scholarshipsadd.dart';

class Scholarshipuniversities extends StatelessWidget {
  const Scholarshipuniversities({super.key});

  @override
  Widget build(BuildContext context) {
    // Teal and Smoke White color palette
    const Color primaryTeal = Color(0xFF008080);
    const Color lightTeal = Color(0xFF20B2AA);
    const Color smokeWhite = Color(0xFFF5F5F5);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF264653);
    const Color textSecondary = Color(0xFF6B7B8A);
    const Color borderColor = Color(0xFFE0E0E0);
    const Color accentGold = Color(0xFFE6B800);

    void _viewScholarshipDetails(Map<String, dynamic> scholarshipData, String docId) {
      showDialog(
        context: context,
        builder: (context) => ScholarshipDetailDialog(
          scholarshipData: scholarshipData,
          docId: docId,
        ),
      );
    }

    Future<void> _deleteScholarship(String docId) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Delete Scholarship", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete this scholarship? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: textSecondary)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('sch-universities')
                      .doc(docId)
                      .delete();

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Scholarship deleted successfully"),
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
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pureWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              "Scholarship Universities",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: primaryTeal,
        elevation: 0,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER SECTION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: pureWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryTeal, lightTeal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Scholarship Programs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage scholarship opportunities',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScholarshipPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryTeal, lightTeal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: primaryTeal.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Add New Scholarship',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryTeal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryTeal.withOpacity(0.2)),
              ),
              child: Row(
                children: const [
                  Expanded(flex: 2, child: Text("ID", style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10, color: textPrimary))),
                  Expanded(flex: 2, child: Text("University", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                  Expanded(flex: 2, child: Text("Country", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                  Expanded(flex: 2, child: Text("Tuition", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                  Expanded(flex: 2, child: Text("Programs", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                  Expanded(flex: 2, child: Text("Subjects", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                  Expanded(flex: 2, child: Text("Action", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary))),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// FIRESTORE TABLE DATA - Now Clickable
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sch-universities')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryTeal),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: pureWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.card_giftcard_outlined, size: 50, color: textSecondary),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No scholarship programs yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Click "Add New Scholarship" to get started',
                            style: TextStyle(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return InkWell(
                        onTap: () => _viewScholarshipDetails(data, doc.id),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: borderColor.withOpacity(0.5)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(data['ID'] ?? '-', style: const TextStyle(fontSize: 11))),
                              Expanded(flex: 2, child: Text(data['name'] ?? '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                              Expanded(flex: 2, child: Text(data['Country']?.toString() ?? '-', style: const TextStyle(fontSize: 11))),
                              Expanded(flex: 2, child: Text(data['tuitionFee']?.toString() ?? '-', style: const TextStyle(fontSize: 11))),
                              Expanded(flex: 2, child: Text(data['Program']?.toString() ?? '-', style: const TextStyle(fontSize: 11))),
                              Expanded(flex: 2, child: Text(data['Course']?.toString() ?? '-', style: const TextStyle(fontSize: 11))),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  width: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      onPressed: () => _deleteScholarship(doc.id),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Scholarship Detail Dialog with View and Update Functionality
class ScholarshipDetailDialog extends StatefulWidget {
  final Map<String, dynamic> scholarshipData;
  final String docId;

  const ScholarshipDetailDialog({
    Key? key,
    required this.scholarshipData,
    required this.docId,
  }) : super(key: key);

  @override
  State<ScholarshipDetailDialog> createState() => _ScholarshipDetailDialogState();
}

class _ScholarshipDetailDialogState extends State<ScholarshipDetailDialog> {
  late Map<String, TextEditingController> controllers;
  bool isEditing = false;
  bool isLoading = false;

  final Color primaryTeal = const Color(0xFF008080);
  final Color lightTeal = const Color(0xFF20B2AA);
  final Color textPrimary = const Color(0xFF264653);
  final Color textSecondary = const Color(0xFF6B7B8A);
  final Color borderColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    controllers = {
      'universityId': TextEditingController(text: widget.scholarshipData['universityId']?.toString() ?? ''),
      'name': TextEditingController(text: widget.scholarshipData['name']?.toString() ?? ''),
      'country': TextEditingController(text: widget.scholarshipData['country']?.toString() ?? ''),
      'tuitionFee': TextEditingController(text: widget.scholarshipData['tuitionFee']?.toString() ?? ''),
      'program': TextEditingController(text: widget.scholarshipData['program']?.toString() ?? ''),
      'subject': TextEditingController(text: widget.scholarshipData['subject']?.toString() ?? ''),
    };
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _updateScholarship() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> updatedData = {};
      controllers.forEach((key, controller) {
        updatedData[key] = controller.text;
      });

      await FirebaseFirestore.instance
          .collection('sch-universities')
          .doc(widget.docId)
          .update(updatedData);

      setState(() {
        isEditing = false;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Scholarship updated successfully!'),
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
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryTeal, lightTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isEditing ? Icons.edit : Icons.card_giftcard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEditing ? 'Edit Scholarship Details' : 'Scholarship Details',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
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
                          controller.text = widget.scholarshipData[key]?.toString() ?? '';
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
            const Divider(color: Colors.white24),
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
            const Divider(color: Colors.white10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.teal)),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _updateScholarship,
                    icon: isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.save, size: 18),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryTeal),
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
          const SizedBox(height: 6),
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
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13),
          )
              : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              controllers[fieldKey]?.text ?? '-',
              style: TextStyle(
                fontSize: 13,
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy page for navigation
class UniversityPage extends StatelessWidget {
  const UniversityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add University'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('University Form Page'),
      ),
    );
  }
}