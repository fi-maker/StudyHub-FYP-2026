import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyhub_032_031/FeedBack/feedback.dart';
import 'package:studyhub_032_031/Screens/Student/scholarship_applications.dart';
import "package:studyhub_032_031/Screens/Student/stu-application.dart";
import 'package:studyhub_032_031/Screens/Student/stuapplications.dart';
import 'package:studyhub_032_031/Screens/Student/stuschapp.dart';
import 'package:studyhub_032_031/Screens/Student/your_Applications.dart';
import 'package:studyhub_032_031/Services/utilis.dart';
import '../../Chatbot/Chatbotmain.dart';
import '../../FeedBack/SentimentAnalysis.dart';
import '../../payment/transaction.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String profilePicUrl = "";
  String username = "";
  Uint8List? _image;

  final User? user = FirebaseAuth.instance.currentUser;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = user!.uid;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        username = doc["username"] ?? "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Teal and Smoke White color palette
    const Color primaryTeal = Color(0xFF008080);
    const Color lightTeal = Color(0xFF20B2AA);
    const Color smokeWhite = Color(0xFFF5F5F5);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color darkTeal = Color(0xFF004D4D);
    const Color textLight = Color(0xFF666666);
    const Color borderColor = Color(0xFFE0E0E0);
    const Color accentGold = Color(0xFFE6B800);
    const Color accentGreen = Color(0xFF4CAF50);
    const Color accentOrange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: smokeWhite,

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        backgroundColor: primaryTeal,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.chat,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- HEADER ----------------
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryTeal, lightTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$username",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              /// ---------------- PROFILE IMAGE SECTION ----------------
              Transform.translate(
                offset: const Offset(0, -20),
                child: Center(
                  child: GestureDetector(
                    onTap: selectImage,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: pureWhite,
                            backgroundImage: _image != null
                                ? MemoryImage(_image!)
                                : profilePicUrl.isNotEmpty
                                ? NetworkImage(profilePicUrl)
                                : null,
                            child: profilePicUrl.isEmpty && _image == null
                                ? Icon(
                              Icons.person,
                              size: 55,
                              color: textLight,
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryTeal,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: pureWhite,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------- DASHBOARD SECTION ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Dashboard Stats Row
                    Row(
                      children: [
                        // Total Applications Card
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user_dashboard')
                                .doc(uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              int totalApplications = 0;
                              if (snapshot.hasData && snapshot.data!.exists) {
                                final data = snapshot.data!.data() as Map<String, dynamic>;
                                totalApplications = data['totalApplications'] ?? 0;
                              }
                              return _buildStatCard(
                                title: "Application",
                                count: totalApplications,
                                color: primaryTeal,
                                icon: Icons.assignment,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF008080), Color(0xFF20B2AA)],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Accepted Applications Card
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('acceptedapplications')
                                .doc('stats sch')
                                .snapshots(),
                            builder: (context, snapshot) {
                              int acceptedCount = 0;
                              if (snapshot.hasData && snapshot.data!.exists) {
                                final data = snapshot.data!.data() as Map<String, dynamic>;
                                acceptedCount = data['totalApplications'] ?? 0;
                              }
                              return _buildStatCard(
                                title: "Accepted",
                                count: acceptedCount,
                                color: accentGreen,
                                icon: Icons.check_circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Scholarships Card
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('admin_dashboard')
                                .doc(uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              int scholarshipsCount = 0;
                              if (snapshot.hasData && snapshot.data!.exists) {
                                final data = snapshot.data!.data() as Map<String, dynamic>;
                                scholarshipsCount = data['totalApplications'] ?? 0;
                              }
                              return _buildStatCard(
                                title: "Scholarship",
                                count: scholarshipsCount,
                                color: accentOrange,
                                icon: Icons.school,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    /// ---------------- QUICK ACTIONS SECTION ----------------
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Actions Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildActionCard(
                          title: "New Application",
                          subtitle: "Submit a new\nstudy application",
                          icon: Icons.add_circle_outline,
                          color: primaryTeal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CompleteStudentRegistrationForm(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          title: "New Scholarship",
                          subtitle: "Apply for\nscholarship",
                          icon: Icons.school_outlined,
                          color: lightTeal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CompleteStudentRegistrationFormScholarship(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          title: "Current Application",
                          subtitle: "View current application",
                          icon: Icons.settings_applications_sharp,
                          color: accentOrange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ApplicationHistory(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          title: "Feedback",
                          subtitle: "Share your\nfeedback",
                          icon: Icons.feedback_outlined,
                          color: accentGreen,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedbackPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    /// ---------------- APPLICATIONS SECTION ----------------
                    const Text(
                      "Your Applications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Student Applications Card
                    _buildApplicationCard(
                      title: "Student Applications",
                      subtitle: "View and track all your submitted student applications",
                      icon: Icons.assignment_turned_in,
                      color: primaryTeal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplicationHistory01(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Scholarship Applications Card
                    _buildApplicationCard(
                      title: "Scholarship Applications",
                      subtitle: "Manage your scholarship submissions and track status",
                      icon: Icons.school,
                      color: accentGold,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplicationHistory02(),
                          ),
                        );
                      },
                    ),



                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- STAT CARD WIDGET ----------------
  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ---------------- ACTION CARD WIDGET ----------------
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),

            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkTeal,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9,
                color: textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- APPLICATION CARD WIDGET ----------------
  Widget _buildApplicationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkTeal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Constants
const Color primaryTeal = Color(0xFF008080);
const Color lightTeal = Color(0xFF20B2AA);
const Color darkTeal = Color(0xFF004D4D);
const Color textLight = Color(0xFF666666);