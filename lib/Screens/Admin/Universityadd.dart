import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityPage extends StatefulWidget {
  const UniversityPage({super.key});

  @override
  State<UniversityPage> createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Teal and Smoke White color palette
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController rankingController = TextEditingController();
  final TextEditingController tuitionController = TextEditingController();
  final TextEditingController acceptRateController = TextEditingController();
  final TextEditingController researchController = TextEditingController();
  final TextEditingController scholarshipController = TextEditingController();
  final TextEditingController studentstisfactionController = TextEditingController();
  final TextEditingController campuslifeController = TextEditingController();
  final TextEditingController internationalstudentsController = TextEditingController();
  String _selectedcountry = 'United Kingdom',_selectedrearch = 'No',_selectedaccept = '100%', _selectedcourse = 'Cyber Security', _selectedprogram = 'BS';
  final List<String> programOptions = ['BS', 'MS', 'MBBS'];
  final List<String> acceptOptions =['0%','40%','60%','80%','100%'];
  final List<String> researchOption = ['Yes', 'No'];
  final List<String> CountryOptions = ['United Kingdom', 'United States','Germany' , 'China','France' ];
  final List<String> coursesOption= ['Cyber Security', 'Doctrate Degree Medical', 'Natural Sciences','Artifical Intelligence', 'Digital Marketing','Software Engineering','Computer Science','Mechanical Engineering','Civil Engineering'];
  /// ---------------- ENHANCED STEP INDICATOR ----------------
  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _stepCircle(0, 'Basic'),
            _stepLine(),
            _stepCircle(1, 'Others'),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Step ${_currentStep + 1} of 2',
            style: TextStyle(
              color: primaryTeal,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepCircle(int step, String label) {
    final bool isActive = step == _currentStep;
    final bool isDone = step < _currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(colors: [primaryTeal, lightTeal])
                : (isDone ? null : null),
            color: isActive ? null : (isDone ? Colors.green : smokeWhite),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? primaryTeal : (isDone ? Colors.green : borderColor),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive ? [
              BoxShadow(color: primaryTeal.withOpacity(0.3), blurRadius: 8),
            ] : null,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? primaryTeal : textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine() {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_currentStep > 0 ? primaryTeal : borderColor, borderColor],
        ),
      ),
    );
  }

  /// ---------------- STEP 1 ----------------
  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.teal)), const SizedBox(height: 4),
      Container(height: 49, decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(value: options.contains(value) ? value : options.first, isExpanded: true, icon: Icon(Icons.arrow_drop_down, color: textSecondary),
                  items: options.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12)))).toList(), onChanged: onChanged)))),
    ]);
  }
  Widget _basicDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          _field('University Name', universityController, icon: Icons.school),
          _buildDropdown( 'Course', _selectedcourse, coursesOption, (v) => setState(() => _selectedcourse = v!)),const SizedBox(height: 12),
          _buildDropdown( 'Program', _selectedprogram, programOptions, (v) => setState(() => _selectedprogram = v!)),const SizedBox(height: 12),
          _buildDropdown( 'Country', _selectedcountry, CountryOptions, (v) => setState(() => _selectedcountry = v!)),const SizedBox(height: 12),

        ],
      ),
    );
  }

  /// ---------------- STEP 2 ----------------
  Widget _otherDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _field('Ranking', rankingController, icon: Icons.star),
          _field('Tuition Fee', tuitionController,
              keyboard: TextInputType.number, icon: Icons.attach_money),
          _buildDropdown( 'Research', _selectedrearch, researchOption, (v) => setState(() => _selectedrearch = v!)),const SizedBox(height: 12),
          _buildDropdown( 'Scholarship', _selectedaccept, acceptOptions, (v) => setState(() => _selectedaccept = v!)),const SizedBox(height: 12),
          _field('International Student', internationalstudentsController, icon: Icons.public),
          _field('Description', descriptionController, icon: Icons.description),
        ],
      ),
    );
  }

  /// ---------------- ENHANCED TEXT FIELD ----------------
  Widget _field(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
        required IconData icon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textSecondary, fontSize: 14),
          prefixIcon: Icon(icon, color: primaryTeal, size: 20),
          filled: true,
          fillColor: pureWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryTeal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  /// ---------------- SUBMIT ----------------
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('universities').doc();
      String docId = docRef.id;
      print('$docId');

      await docRef.set({
        'ID': docId,
        'name': universityController.text.trim(),
        'Country':_selectedcountry,
        'Program':_selectedprogram,
        'Course':_selectedcourse,
        'ranking': rankingController.text.trim(),
        'tuitionFee': tuitionController.text.trim(),
        'research': _selectedrearch,
        'scholarship': _selectedaccept,
        'description': descriptionController.text.trim(),  // FIXED: was missing .text.trim()
        'internationalstudents': internationalstudentsController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('University added successfully'),
          backgroundColor: primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Firestore Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  /// ---------------- ENHANCED NAVIGATION ----------------
  Widget _navigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryTeal,
                  side: BorderSide(color: primaryTeal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Back', style: TextStyle(fontSize: 14)),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 0) {
                  setState(() => _currentStep = 1);
                } else {
                  _submitForm();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                _currentStep == 1 ? 'Submit' : 'Next',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
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
              child: const Icon(Icons.add_business, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add University',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: primaryTeal,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProgressIndicator(),
            const SizedBox(height: 8),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _basicDetails(),
                  _otherDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navigationButtons(),
    );
  }
}