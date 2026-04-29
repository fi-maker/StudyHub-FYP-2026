import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController(); // ADDED: Username controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final academiclevelController = TextEditingController();
  final prefredcountryController = TextEditingController();
  final subjectController = TextEditingController();
  final budgetController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  // StudyHub color scheme
  static const Color studyHubBlue = Colors.teal;
  static const Color studyHubLightBlue = Colors.teal;
  static const Color studyHubTeal = Color(0xFF2BA9A3);
  static const Color studyHubAccent = Color(0xFFF5A623);

  static const Color backgroundColor = Colors.white;
  static const Color cardBackground = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF1A2B3C);
  static const Color textSecondary = Color(0xFF5A6B7C);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ---------------------- HEADER SECTION ----------------------
                      Container(
                        height: constraints.maxHeight * 0.32,
                        constraints: const BoxConstraints(
                          minHeight: 220,
                          maxHeight: 280,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              studyHubBlue,
                              studyHubLightBlue,
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Decorative elements
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: studyHubTeal.withOpacity(0.2),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 70,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: studyHubAccent.withOpacity(0.15),
                                ),
                              ),
                            ),

                            // Back button and header content
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                                    iconSize: 28,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: studyHubBlue.withOpacity(0.3),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(18),
                                              child: Image.asset(
                                                "assets/launchericon.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          const Text(
                                            "Create Account",
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Join StudyHub community",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 48), // For symmetry
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ---------------------- REGISTER FORM CARD ----------------------
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: studyHubBlue.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Username Field - ADDED
                              _buildInputField(
                                controller: usernameController,
                                label: "Username",
                                hintText: "Enter your username",
                                icon: Icons.person_outline,
                                isPassword: false,
                              ),

                              const SizedBox(height: 20),

                              // Email Field
                              _buildInputField(
                                controller: emailController,
                                label: "Email Address",
                                hintText: "StudyHub@gmail.com",
                                icon: Icons.email_outlined,
                                isPassword: false,
                              ),

                              const SizedBox(height: 20),
                              // prefrences

                              // academic level
                              _buildInputField(
                                controller: academiclevelController,
                                label: "Academic level you prefer?",
                                hintText: "BS, MS ,PHD, MBBS etc.",
                                icon: Icons.school_rounded,
                                isPassword: false,
                              ),

                              const SizedBox(height: 20),

                              // country
                              _buildInputField(
                                controller: prefredcountryController,
                                label: "Which country you prefer?",
                                hintText: "USA, Germeny, China, Canada, Japan etc.",
                                icon: Icons.south_america,
                                isPassword: false,
                              ),

                              const SizedBox(height: 20),

                              // subject
                              _buildInputField(
                                controller: subjectController,
                                label: "Subject of interest",
                                hintText: "Computer Sciences etc.",
                                icon: Icons.interests,
                                isPassword: false,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Available Programs:'),
                                    _buildRequirement("Computer Sciences", studyHubAccent),
                                    _buildRequirement("Medicines", studyHubAccent),
                                    _buildRequirement("Engineering", studyHubAccent),
                                    _buildRequirement("Bussiness", studyHubAccent),
                                    _buildRequirement("Natural Sciences", studyHubAccent),
                                  ],
                                ),
                              ),


                              const SizedBox(height: 20),
                              // budget
                              _buildInputField(
                                controller: budgetController,
                                label: "Your Budget",
                                hintText: "30,000 dollar to 4,5000 etc.",
                                icon: Icons.money,
                                isPassword: false,
                              ),
                              const SizedBox(height: 10),

                              // Password Field
                              _buildInputField(
                                controller: passwordController,
                                label: "Password",
                                hintText: "Create a strong password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isVisible: _isPasswordVisible,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                              const SizedBox(height: 10),

                              // Password requirements
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildRequirement("At least 8 characters", studyHubTeal),
                                    _buildRequirement("One uppercase letter", studyHubTeal),
                                    _buildRequirement("One number", studyHubTeal),
                                    _buildRequirement("One special character", studyHubTeal),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Confirm Password Field
                              _buildInputField(
                                controller: confirmPasswordController,
                                label: "Confirm Password",
                                hintText: "Re-enter your password",
                                icon: Icons.lock_reset,
                                isPassword: true,
                                isVisible: _isConfirmPasswordVisible,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),

                              const SizedBox(height: 20),

                              // Terms and Conditions
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _acceptTerms = !_acceptTerms;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        color: _acceptTerms ? studyHubBlue : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: _acceptTerms ? studyHubBlue : borderColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: _acceptTerms
                                          ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 13,
                                        ),
                                        children: [
                                          const TextSpan(text: "I agree to the "),
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: TextStyle(
                                              color: studyHubLightBlue,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: studyHubLightBlue,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // Register Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        studyHubBlue,
                                        studyHubLightBlue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: _isLoading
                                        ? []
                                        : [
                                      BoxShadow(
                                        color: studyHubBlue.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: _isLoading ? null : registerUser,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedOpacity(
                                            opacity: _isLoading ? 0 : 1,
                                            duration: const Duration(milliseconds: 200),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person_add_alt_1,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  "Create Account",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_isLoading)
                                            const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Divider with "or"
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: borderColor,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      "Already a member?",
                                      style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: borderColor,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: Colors.transparent,
                                        ),
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: studyHubBlue,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.underline,
                                            decorationColor: studyHubBlue,
                                            decorationThickness: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2B3C),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Icon(
                  icon,
                  color: studyHubBlue,
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !isVisible,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A2B3C),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF5A6B7C),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  cursorColor: studyHubBlue,
                ),
              ),
              if (isPassword && onToggleVisibility != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: studyHubBlue,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> registerUser() async {
    // Validation
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        academiclevelController.text.isEmpty||
        prefredcountryController.text.isEmpty||
        subjectController.text.isEmpty||
        budgetController.text.isEmpty||
        confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar("Please fill in all fields");
      return;
    }

    if (!_acceptTerms) {
      _showErrorSnackBar("Please accept terms & conditions");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackBar("Passwords don't match");
      return;
    }

    if (passwordController.text.length < 8) {
      _showErrorSnackBar("Password must be at least 8 characters");
      return;
    }

    if (usernameController.text.length < 3) {
      _showErrorSnackBar("Username must be at least 3 characters");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // CREATE USER DOCUMENT IN FIRESTORE WITH USERNAME
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        'uid': uid,
        "username": usernameController.text.trim(), // ADDED: Username field
        "email": emailController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "displayName": usernameController.text.trim(), // Can use username as display name
        "academiclevel":academiclevelController.text.trim(),
        "preferedcountry": prefredcountryController.text.trim(),
        "subjectofinterset": subjectController.text.trim(),
        "budget": budgetController.text.trim(),
      });


      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome ${usernameController.text.trim()}! Account created successfully!'),
          backgroundColor: studyHubTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      // Navigate back after delay
      await Future.delayed(const Duration(milliseconds: 1500));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to create account";
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already registered";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar("An error occurred: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}