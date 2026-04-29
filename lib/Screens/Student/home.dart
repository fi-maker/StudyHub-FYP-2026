import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyhub_032_031/Screens/Student/change_password.dart';
import 'package:studyhub_032_031/Screens/Student/tab1home.dart';
import 'package:studyhub_032_031/Screens/Student/tab2explore.dart';
import 'package:studyhub_032_031/Screens/Student/tab3scholarship.dart';

import '../../Consultant/request_consultant_page.dart';
import '../../FeedBack/SentimentAnalysis.dart';
import '../../FeedBack/feedback.dart';
import '../../Services/reccomendation system.dart';
import '../../Services/reccomendation_system_scholarships.dart';
import '4tabconsultant.dart';
import 'Universityrating.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // StudyHub color scheme
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color darkTeal = Color(0xFF004D4D);
  static const Color accentGold = Color(0xFFE6B800);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A2B3C);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE2E8F0);

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeTab(),
      const RequestConsultantPage(),
      const UniversitiesP(),
      const UniversitiesS(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,

      // ---------- APP BAR ----------
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: primaryTeal,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryTeal, lightTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryTeal.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "assets/launchericon.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "StudyHub",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Your Education Partner",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == "change_password") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage(),
                  ),
                );
              } else if (value == "logout") {
                _showLogoutDialog(context);
              } else if (value == "feedback") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FeedbackPage(),
                  ),
                );
              }
              else if (value == "rating") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RateUniversityPage(),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryTeal.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline,
                color: primaryTeal,
                size: 22,
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "feedback",
                enabled: true,
                child: Row(
                  children: [
                    Icon(Icons.feedback_outlined, size: 20, color: primaryTeal),
                    SizedBox(width: 12),
                    Text(
                      "Your Feedback",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "rating",
                enabled: true,
                child: Row(
                  children: [
                    Icon(Icons.star_border_outlined, size: 20, color: primaryTeal),
                    SizedBox(width: 12),
                    Text(
                      "Rate Universities",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "change_password",
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 20, color: primaryTeal),
                    SizedBox(width: 12),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // ---------- BODY ----------
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      // ---------- BOTTOM NAVIGATION BAR ----------
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
            _buildNavItem(Icons.person_outline, Icons.person, "Consultant", 1),
            _buildNavItem(Icons.explore_outlined, Icons.explore, "Explore", 2),
            _buildNavItem(Icons.school_outlined, Icons.school, "Scholarships", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => currentIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryTeal.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? primaryTeal : textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primaryTeal : textSecondary,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: primaryTeal,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: pureWhite,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryTeal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: primaryTeal,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textSecondary,
                        side: BorderSide(color: borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await FirebaseAuth.instance.signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}