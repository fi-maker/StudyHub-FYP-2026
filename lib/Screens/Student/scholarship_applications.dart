import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompleteStudentRegistrationFormScholarship extends StatefulWidget {
  const CompleteStudentRegistrationFormScholarship({super.key});

  @override
  State<CompleteStudentRegistrationFormScholarship> createState() => _CompleteStudentRegistrationFormState();
}

class _CompleteStudentRegistrationFormState extends State<CompleteStudentRegistrationFormScholarship> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Supabase client
  final _supabase = Supabase.instance.client;

  static const Color primaryTeal = Colors.teal;
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Store images as bytes
  Uint8List? _profileImage, _matricCertificate, _interCertificate, _degreeCertificate;

  // Store uploaded URLs from Supabase
  String? _profileImageUrl, _matricCertificateUrl, _interCertificateUrl, _degreeCertificateUrl;

  // Personal Info Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _personalEmailController = TextEditingController();
  final TextEditingController _personalPhoneController = TextEditingController();

  // International Application Controllers
  final TextEditingController _legalFirstNameController = TextEditingController();
  final TextEditingController _legalLastNameController = TextEditingController();
  final TextEditingController _dualNationalityController = TextEditingController();
  final TextEditingController _disabilityDetailsController = TextEditingController();
  final TextEditingController _strengthWeaknessController = TextEditingController();
  final TextEditingController _birthCountryController = TextEditingController();

  // Contact Info Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  // Academic Controllers
  final TextEditingController _matricMarksController = TextEditingController();
  final TextEditingController _matricSchoolController = TextEditingController();
  final TextEditingController _matricFieldController = TextEditingController();
  final TextEditingController _interMarksController = TextEditingController();
  final TextEditingController _interCollegeController = TextEditingController();
  final TextEditingController _interFieldController = TextEditingController();
  final TextEditingController _degreeMarksController = TextEditingController();
  final TextEditingController _degreeUniversityController = TextEditingController();
  final TextEditingController _degreeFieldController = TextEditingController();

  // Dropdown values
  String _selectedGender = 'Male';
  String _selectedGenderInternational = 'Male';
  String _selectedNationality = 'Pakistan';
  String _selectedNationalityInternational = 'Pakistan';
  String _selectedCity = 'Wah Cantonament';
  String _selectedTitle = 'Mr.';
  String _selectedCountry = 'China';
  String _selectedCriminalHistory = 'No';
  String _selectedPreviouslyApplied = 'No';
  String _selectedDisability = 'No';
  String _selectedProgramLevel = 'BS';
  String _selectedsubject = 'Massachusetts Institute of Technology';
  String _selectedDay = '1';
  String _selectedCourse = 'Cyber Security';
  String _selectedDayInternational = '1';
  String _selectedMonth = 'Jan';
  String _selectedMonthInternational = 'Jan';
  String _selectedYear = '2026';
  String _selectedYearInternational = '2027';

  // Dropdown options
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> titleOptions = ['Mr.', 'Miss.', 'Ms.'];
  final List<String> provinceOptions = ['Pakistan'];
  final List<String> countryOptions = ['United Kingdom', 'United States', 'Germany', 'China', 'France'];
  final List<String> yesNoOptions = ['Yes', 'No'];
  final List<String> programOptions = ['BS', 'MS', 'MBBS'];
  final List<String> coursesOption = ['Cyber Security', 'Doctrate Degree Medical', 'Natural Sciences', 'Artifical Intelligence', 'Digital Marketing', 'Software Engineering', 'Computer Science', 'Mechanical Engineering', 'Civil Engineering'];
  final List<String> dayOptions = List.generate(31, (i) => '${i + 1}');
  final List<String> monthOptions = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'August', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<String> yearOptions = List.generate(71, (i) => '${1970 + i}');
  final List<String> subjectOptions = [
    'Massachusetts Institute of Technology',
    'Stanford University',
    'University of Cambridge',
    'Harvard University',
    'ETH Zurich',
    'University of Tokyo',
    'University of Sydney',
    'National University of Singapore',
    'University of Toronto',
    'Technical University of Munich',
    'Chengde Medical University',
    'Changsha Medical University',
    'Chifeng Medical University',
    'CHINA THREE GORGES UNIVERSITY',
    'GANNAN MEDICAL UNIVERSITy',
    'GUANGXI MEDICAL UNIVERSITY',
    'HARBIN MEDICAL UNIVERSITY',
    'HEBEI UNIVERSITY OF ENGINEERING',
    'Jaimusi University',
    'KUNMING UNIVERSITY OF SCIENCE AND TECHNOLOGY',
    'NORTH CHINA UNIVERSITY OF SCIENCE & TECHNOLOGY',
    'North Sichuan Medical University',
    'QINGDAO UNIVERSITY CLINICAL MEDICINE',
    'Shanxi Medical University',
    'SouthWest Medical University',
    'Xinxiang Medical University',
  ];
  final List<String> pakistaniCities = ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Gujranwala', 'Sialkot', 'Hyderabad', 'Abbottabad', 'Sargodha', 'Bahawalpur', 'Sukkur', 'Mirpur Khas', 'Mardan', 'Gujrat', 'Jhelum', 'Rahim Yar Khan', 'Okara', 'Sheikhupura', 'Nawabshah', 'Chakwal', 'Wah Cantonament', 'Kohat'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cnicController.dispose();
    _personalEmailController.dispose();
    _personalPhoneController.dispose();
    _legalFirstNameController.dispose();
    _legalLastNameController.dispose();
    _dualNationalityController.dispose();
    _disabilityDetailsController.dispose();
    _strengthWeaknessController.dispose();
    _birthCountryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _matricMarksController.dispose();
    _matricSchoolController.dispose();
    _matricFieldController.dispose();
    _interMarksController.dispose();
    _interCollegeController.dispose();
    _interFieldController.dispose();
    _degreeMarksController.dispose();
    _degreeUniversityController.dispose();
    _degreeFieldController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_firstNameController.text.trim().isEmpty) { _showError('First Name is required'); return false; }
      if (_cnicController.text.trim().isEmpty) { _showError('CNIC is required'); return false; }
      if (_personalEmailController.text.trim().isEmpty) { _showError('Email is required'); return false; }
      if (!_personalEmailController.text.contains('@')) { _showError('Enter a valid email address'); return false; }
      if (_personalPhoneController.text.trim().isEmpty) { _showError('Phone number is required'); return false; }
    } else if (_currentStep == 1) {
      if (_legalFirstNameController.text.trim().isEmpty) { _showError('Legal First Name is required'); return false; }
      if (_strengthWeaknessController.text.trim().length < 100) { _showError('Please write at least 100 characters'); return false; }
    } else if (_currentStep == 2) {
      if (_emailController.text.trim().isEmpty) { _showError('Email Address is required'); return false; }
      if (!_emailController.text.contains('@')) { _showError('Enter a valid email address'); return false; }
      if (_phoneController.text.trim().isEmpty) { _showError('Phone Number is required'); return false; }
      if (_addressController.text.trim().isEmpty) { _showError('Address is required'); return false; }
      if (_postalCodeController.text.trim().isEmpty) { _showError('Postal Code is required'); return false; }
    } else if (_currentStep == 3) {
      if (_matricMarksController.text.trim().isEmpty) { _showError('Matric Marks/Percentage is required'); return false; }
      if (_interMarksController.text.trim().isEmpty) { _showError('Intermediate Marks/Percentage is required'); return false; }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2)
    ));
  }

  // Upload image to Supabase Storage
  Future<String?> _uploadImageToSupabase(Uint8List imageBytes, String documentType) async {
    try {
      // Get user from Firebase
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _showError('Please login first');
        return null;
      }

      // Use Firebase user ID for folder structure
      final userId = firebaseUser.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = 'scholarship/$userId/$documentType/$timestamp.jpg';

      debugPrint('Uploading to: $filePath');
      debugPrint('Image size: ${imageBytes.length} bytes');

      // Upload to Supabase
      await _supabase.storage
          .from('student_documents')
          .uploadBinary(filePath, imageBytes);

      // Get public URL
      final publicUrl = _supabase.storage.from('student_documents').getPublicUrl(filePath);
      debugPrint('Upload success! URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      debugPrint('Upload error: $e');
      _showError('Failed to upload image: $e');
      return null;
    }
  }

  // Image picker with Supabase upload
  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        final bytes = await image.readAsBytes();

        // Show uploading indicator
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading image...'), backgroundColor: Colors.orange)
        );

        // Upload to Supabase
        String? uploadedUrl;
        switch (type) {
          case 'profile':
            uploadedUrl = await _uploadImageToSupabase(bytes, 'profile');
            if (uploadedUrl != null) {
              setState(() {
                _profileImage = bytes;
                _profileImageUrl = uploadedUrl;
              });
            }
            break;
          case 'matric':
            uploadedUrl = await _uploadImageToSupabase(bytes, 'matric_certificate');
            if (uploadedUrl != null) {
              setState(() {
                _matricCertificate = bytes;
                _matricCertificateUrl = uploadedUrl;
              });
            }
            break;
          case 'inter':
            uploadedUrl = await _uploadImageToSupabase(bytes, 'inter_certificate');
            if (uploadedUrl != null) {
              setState(() {
                _interCertificate = bytes;
                _interCertificateUrl = uploadedUrl;
              });
            }
            break;
          case 'degree':
            uploadedUrl = await _uploadImageToSupabase(bytes, 'degree_certificate');
            if (uploadedUrl != null) {
              setState(() {
                _degreeCertificate = bytes;
                _degreeCertificateUrl = uploadedUrl;
              });
            }
            break;
        }

        if (uploadedUrl != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded successfully!'), backgroundColor: Colors.green)
          );
        }
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
      _showError('Failed to pick/upload image');
    }
  }

  // Photo upload section widget
  Widget _buildPhotoUploadSection(String label, Uint8List? image, String type) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: smokeWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor)
      ),
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (_) => SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                    leading: const Icon(Icons.camera_alt, color: primaryTeal),
                    title: const Text('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera, type);
                    }
                ),
                ListTile(
                    leading: const Icon(Icons.photo_library, color: primaryTeal),
                    title: const Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery, type);
                    }
                ),
              ]),
            ),
          ),
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryTeal)
              ),
              child: image != null
                  ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(image, fit: BoxFit.cover)
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: textSecondary),
                  const SizedBox(height: 4),
                  Text('Upload', style: TextStyle(fontSize: 10, color: textSecondary))
                ],
              )
          ),
        ),
      ]),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _buildStepCircle(0, 'Personal info'),
        _buildStepLine(),
        _buildStepCircle(1, 'International\nApplication'),
        _buildStepLine(),
        _buildStepCircle(2, 'Contact info'),
        _buildStepLine(),
        _buildStepCircle(3, 'Qualification'),
      ]),
      const SizedBox(height: 8),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text('Step ${_currentStep + 1} of 4', style: TextStyle(color: primaryTeal, fontSize: 12))
      ),
    ]);
  }

  Widget _buildStepCircle(int step, String label) {
    bool isActive = step == _currentStep;
    bool isCompleted = step < _currentStep;
    return Column(children: [
      Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              gradient: isActive ? const LinearGradient(colors: [primaryTeal, lightTeal]) : null,
              color: isActive ? null : (isCompleted ? Colors.green : smokeWhite),
              shape: BoxShape.circle,
              border: Border.all(color: isActive ? primaryTeal : (isCompleted ? Colors.green : borderColor), width: isActive ? 2 : 1)
          ),
          child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text('${step + 1}', style: TextStyle(color: isActive ? Colors.white : textSecondary, fontSize: 12))
          )
      ),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 9, color: isActive ? primaryTeal : textSecondary)),
    ]);
  }

  Widget _buildStepLine() => Container(
      width: 25,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [_currentStep > 0 ? primaryTeal : borderColor, borderColor])
      )
  );

  Widget _buildPersonalInfo() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        const Text('Please provide your personal details', style: TextStyle(fontSize: 12, color: textSecondary)),
        const SizedBox(height: 16),

        // Photo upload section
        _buildPhotoUploadSection('Passport Size Photo', _profileImage, 'profile'),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(child: _buildField('First Name*', _firstNameController, required: true)),
          const SizedBox(width: 8),
          Expanded(child: _buildField('Last Name', _lastNameController))
        ]),
        const SizedBox(height: 12),
        const Align(alignment: Alignment.centerLeft, child: Text('Date of birth*', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildDropdown('Day*', _selectedDay, dayOptions, (v) => setState(() => _selectedDay = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Month*', _selectedMonth, monthOptions, (v) => setState(() => _selectedMonth = v!))),
          Expanded(child: _buildDropdown('Year*', _selectedYear, yearOptions, (v) => setState(() => _selectedYear = v!)))
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildField('CNIC*\nEx: 37406-4338536-3', _cnicController, required: true)),
          const SizedBox(width: 8),
          Expanded(child: _buildField('Email*\nEx: abc123@gmail.com', _personalEmailController, keyboard: TextInputType.emailAddress, required: true)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildField('Phone no*\nEx: +92 3345772334', _personalPhoneController, keyboard: TextInputType.phone, required: true)),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Gender*', _selectedGender, genderOptions, (v) => setState(() => _selectedGender = v!)))
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildDropdown('Nationality*', _selectedNationality, provinceOptions, (v) => setState(() => _selectedNationality = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Do You Have Any Criminal History?', _selectedCriminalHistory, yesNoOptions, (v) => setState(() => _selectedCriminalHistory = v!)))
        ]),
      ])
  );

  Widget _buildFamilyDetails() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text('International Application', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        const Text('International student information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textSecondary)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildDropdown('Title*', _selectedTitle, titleOptions, (v) => setState(() => _selectedTitle = v!))),
          const SizedBox(width: 8)
        ]),
        Row(children: [
          Expanded(child: _buildField('First Name*', _legalFirstNameController, required: true)),
          const SizedBox(width: 8),
          Expanded(child: _buildField('Last Name', _legalLastNameController))
        ]),
        const SizedBox(height: 12),
        const Align(alignment: Alignment.centerLeft, child: Text('Date of birth*', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildDropdown('Day*', _selectedDayInternational, dayOptions, (v) => setState(() => _selectedDayInternational = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Month*', _selectedMonthInternational, monthOptions, (v) => setState(() => _selectedMonthInternational = v!))),
          Expanded(child: _buildDropdown('Year*', _selectedYearInternational, yearOptions, (v) => setState(() => _selectedYearInternational = v!)))
        ]),
        const SizedBox(height: 15),
        Row(children: [
          Expanded(child: _buildDropdown('Gender*', _selectedGenderInternational, genderOptions, (v) => setState(() => _selectedGenderInternational = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Nationality*', _selectedNationalityInternational, provinceOptions, (v) => setState(() => _selectedNationalityInternational = v!)))
        ]),
        _buildField('Dual Nationality\n(If yes write Country name if no write no)', _dualNationalityController),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildDropdown('Country you are interested in*', _selectedCountry, countryOptions, (v) => setState(() => _selectedCountry = v!))),
          const SizedBox(width: 8)
        ]),
        Row(children: [
          Expanded(child: _buildDropdown('Have you previously applied for studies?', _selectedPreviouslyApplied, yesNoOptions, (v) => setState(() => _selectedPreviouslyApplied = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Do you have any disability?', _selectedDisability, yesNoOptions, (v) => setState(() => _selectedDisability = v!)))
        ]),
        if (_selectedDisability == 'Yes')
          _buildField('Disability Details', _disabilityDetailsController),
        const SizedBox(height: 12),
        _buildField('Your Strengths and Weaknesses\n(100-150 words)*', _strengthWeaknessController, maxLines: 3, required: true),
        const SizedBox(height: 12),
        _buildField('Country of birth', _birthCountryController),
      ])
  );

  Widget _buildContactInfo() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        const Text('Home Address', style: TextStyle(fontSize: 15, color: textSecondary)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildDropdown('Country', _selectedNationality, provinceOptions, (v) => setState(() => _selectedNationality = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('City', _selectedCity, pakistaniCities, (v) => setState(() => _selectedCity = v!)))
        ]),
        _buildField('Email*', _emailController, keyboard: TextInputType.emailAddress, required: true),
        const SizedBox(height: 12),
        _buildField('Phone*\nEx: +92 3345456766', _phoneController, keyboard: TextInputType.phone, required: true),
        const SizedBox(height: 12),
        _buildField('Address*', _addressController, maxLines: 2, required: true),
        const SizedBox(height: 12),
        _buildField('Postal Code*', _postalCodeController, required: true),
      ])
  );

  Widget _buildAcademicInfo() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text('Academic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        const Text('Your educational background', style: TextStyle(fontSize: 12, color: textSecondary)),
        const SizedBox(height: 16),

        const Text('Matric / O-Levels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 8),
        _buildField('School*', _matricSchoolController, required: true),
        const SizedBox(height: 8),
        _buildField('Field of study*', _matricFieldController, required: true),
        const SizedBox(height: 8),
        _buildField('Marks/Percentage*', _matricMarksController, required: true),
        const SizedBox(height: 12),
        _buildPhotoUploadSection('Matric Certificate', _matricCertificate, 'matric'),

        const SizedBox(height: 16),
        const Text('Intermediate / A-Levels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 8),
        _buildField('College*', _interCollegeController, required: true),
        const SizedBox(height: 8),
        _buildField('Field of study*', _interFieldController, required: true),
        const SizedBox(height: 8),
        _buildField('Marks/Percentage*', _interMarksController, required: true),
        const SizedBox(height: 12),
        _buildPhotoUploadSection('Intermediate Certificate', _interCertificate, 'inter'),

        const SizedBox(height: 16),
        const Text("Bachelor's Degree (give detail if not simply write nill)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 8),
        _buildField('University*', _degreeUniversityController, required: true),
        const SizedBox(height: 8),
        _buildField('Field of study*', _degreeFieldController, required: true),
        const SizedBox(height: 8),
        _buildField('CGPA/Percentage*', _degreeMarksController, required: true),
        const SizedBox(height: 12),
        _buildPhotoUploadSection('Degree Certificate', _degreeCertificate, 'degree'),

        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildDropdown('Preferred University', _selectedsubject, subjectOptions, (v) => setState(() => _selectedsubject = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Level', _selectedProgramLevel, programOptions, (v) => setState(() => _selectedProgramLevel = v!))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown('Course', _selectedCourse, coursesOption, (v) => setState(() => _selectedCourse = v!)))
        ]),
      ])
  );

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text, int maxLines = 1, bool required = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary)),
      const SizedBox(height: 4),
      Container(
        height: maxLines > 1 ? null : 38,
        decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
        child: TextFormField(
            controller: ctrl,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: required ? (value) => value == null || value.trim().isEmpty ? 'Required' : null : null,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                hintText: 'Enter ${label.replaceAll('*', '').split('\n')[0]}',
                hintStyle: TextStyle(fontSize: 12, color: textSecondary)
            ),
            style: const TextStyle(fontSize: 13)
        ),
      ),
    ]);
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary)),
      const SizedBox(height: 4),
      Container(
        height: 38,
        decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: options.contains(value) ? value : options.first,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: textSecondary),
                  items: options.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: onChanged
              )
          ),
        ),
      ),
    ]);
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: pureWhite, border: Border(top: BorderSide(color: borderColor))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (_currentStep > 0)
          SizedBox(
              width: 90,
              child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: primaryTeal,
                      side: BorderSide(color: primaryTeal),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                  ),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.arrow_back, size: 14, color: Colors.white), // CHANGED: Added color: Colors.white
                    SizedBox(width: 4),
                    Text('Back', style: TextStyle(fontSize: 12, color: Colors.white)) // CHANGED: Added color: Colors.white
                  ])
              )
          )
        else
          const SizedBox(width: 90),
        SizedBox(
          width: 90,
          child: ElevatedButton(
              onPressed: () {
                if (_currentStep < 3) {
                  if (_validateCurrentStep()) setState(() => _currentStep++);
                } else {
                  if (_validateCurrentStep()) _submitForm();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_currentStep == 3 ? 'Submit' : 'Next', style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 4),
                Icon(_currentStep == 3 ? Icons.send : Icons.arrow_forward, size: 14, color: Colors.white)
              ])
          ),
        ),
      ]),
    );
  }

  void _submitForm() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Navigator.pop(context);
        _showError('User not logged in');
        return;
      }

      final uid = user.uid;

      await firestore.collection('scholarships_applications').add({
        'uid': uid,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'personalEmail': _personalEmailController.text.trim(),
        'personalPhone': _personalPhoneController.text.trim(),
        'dateOfBirth': '$_selectedDay $_selectedMonth $_selectedYear',
        'gender': _selectedGender,
        'nationality': _selectedNationality,
        'criminalHistory': _selectedCriminalHistory,
        'title': _selectedTitle,
        'legalFirstName': _legalFirstNameController.text.trim(),
        'legalLastName': _legalLastNameController.text.trim(),
        'internationalDob': '$_selectedDayInternational $_selectedMonthInternational $_selectedYearInternational',
        'internationalGender': _selectedGenderInternational,
        'internationalNationality': _selectedNationalityInternational,
        'dualNationality': _dualNationalityController.text.trim(),
        'interestedCountry': _selectedCountry,
        'previouslyApplied': _selectedPreviouslyApplied,
        'hasDisability': _selectedDisability,
        'disabilityDetails': _disabilityDetailsController.text.trim(),
        'strengthWeakness': _strengthWeaknessController.text.trim(),
        'birthCountry': _birthCountryController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'postalCode': _postalCodeController.text.trim(),
        'matricMarks': _matricMarksController.text.trim(),
        'matricSchool': _matricSchoolController.text.trim(),
        'matricField': _matricFieldController.text.trim(),
        'interMarks': _interMarksController.text.trim(),
        'interCollege': _interCollegeController.text.trim(),
        'interField': _interFieldController.text.trim(),
        'degreeMarks': _degreeMarksController.text.trim(),
        'degreeUniversity': _degreeUniversityController.text.trim(),
        'degreeField': _degreeFieldController.text.trim(),
        'preferredUniversity': _selectedsubject,
        'preferredLevel': _selectedProgramLevel,
        'preferredCourse': _selectedCourse,
        // Add Supabase image URLs
        'profileImageUrl': _profileImageUrl,
        'matricCertificateUrl': _matricCertificateUrl,
        'interCertificateUrl': _interCertificateUrl,
        'degreeCertificateUrl': _degreeCertificateUrl,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await firestore.collection('admindashboardww').doc('stats_sch').set(
          {'totalApplications': FieldValue.increment(1)},
          SetOptions(merge: true)
      );

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Success!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          content: const Text('Your scholarship application has been submitted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error: $e");
      _showError("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
          title: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8))),
            const SizedBox(width: 8),
            const Text('Scholarship Application', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600))
          ]),
          backgroundColor: primaryTeal,
          elevation: 0
      ),
      body: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 12),
            _buildProgressIndicator(),
            Expanded(child: IndexedStack(index: _currentStep, children: [
              _buildPersonalInfo(),
              _buildFamilyDetails(),
              _buildContactInfo(),
              _buildAcademicInfo()
            ]))
          ])
      ),
      bottomNavigationBar: _buildNavigationButtons(),
    );
  }
}