import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import "package:studyhub_032_031/Screens/Student/tab1home.dart";
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';
import 'dart:io';

class CompleteStudentRegistrationForm extends StatefulWidget {
  const CompleteStudentRegistrationForm({super.key});

  @override
  State<CompleteStudentRegistrationForm> createState() => _CompleteStudentRegistrationFormState();
}

class _CompleteStudentRegistrationFormState extends State<CompleteStudentRegistrationForm> {
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

  // Store images as bytes only - no file paths
  Uint8List? _profileImage, _matricCertificate, _interCertificate, _degreeCertificate;

  // Store uploaded URLs
  String? _profileImageUrl, _matricCertificateUrl, _interCertificateUrl, _degreeCertificateUrl;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController legalfirstnameController = TextEditingController();
  final TextEditingController legallastnameController = TextEditingController();
  final TextEditingController brithCountryController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherCellController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherCellController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _matricMarksController = TextEditingController();
  final TextEditingController _matricMarksController01 = TextEditingController();
  final TextEditingController _matricMarksController02 = TextEditingController();
  final TextEditingController _interMarksController = TextEditingController();
  final TextEditingController _interMarksController01 = TextEditingController();
  final TextEditingController _interMarksController02 = TextEditingController();
  final TextEditingController _degreeMarksController = TextEditingController();
  final TextEditingController _desiredProgramController = TextEditingController();
  final TextEditingController _desiredProgramController01 = TextEditingController();
  final TextEditingController _desiredProgramController02 = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String _selectedGender = 'Male', _selectedcourse = 'Cyber Security', _selectedProvince = 'Pakistan', _selectedcitiy = 'Wah Cantonament', _selectedProvince01 = 'Pakistan', _selectedProvince02 = 'Pakistan', _selectedtitle = 'Mr.', _selectedCountry = 'China', _selectedBloodGroup = 'Yes', _selectedBloodGroup01 = 'Yes', _selectedBloodGroup02 = 'Yes', _selectedProgramLevel = 'BS', _selectedsubject = 'Massachusetts Institute of Technology', _selectedday = '1', _selectedday01 = '1', _selecteMonth = 'jan', _selecteMonth01 = 'jan', _selecteyear = '2026', _selecteyear01 = '2027';

  // Separate gender for international section
  String _selectedGenderInternational = 'Male';

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> titleOptions = ['Mr.', 'Miss.'];
  final List<String> provinceOptions = ['Pakistan'];
  final List<String> provinceOptions01 = ['Pakistan'];
  final List<String> provinceOptions02 = ['Pakistan'];
  final List<String> CountryOptions = ['United Kingdom', 'United States', 'Germany', 'China', 'France'];
  final List<String> bloodGroupOptions = ['Yes', 'No'];
  final List<String> bloodGroupOptions01 = ['Yes', 'No'];
  final List<String> bloodGroupOptions02 = ['Yes', 'No'];
  final List<String> programOptions = ['BS', 'MS', 'MBBS'];
  List<String> coursesOption = ['Cyber Security', 'Doctrate Degree Medical', 'Natural Sciences', 'Artifical Intelligence', 'Digital Marketing', 'Software Engineering', 'Computer Science', 'Mechanical Engineering', 'Civil Engineering'];
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

  late final List<String> dayOptions = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'];
  late final List<String> dayOptions01 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'];

  late final List<String> pakistaniCities = ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Gujranwala', 'Sialkot', 'Hyderabad', 'Abbottabad', 'Sargodha', 'Bahawalpur', 'Sukkur', 'Mirpur Khas', 'Mardan', 'Gujrat', 'Jhelum', 'Rahim Yar Khan', 'Okara', 'Sheikhupura', 'Nawabshah', 'Chakwal', 'Wah Cantonament', 'Kohat'];
  final List<String> MonthOptions = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'August', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<String> MonthOptions01 = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'August', 'Sep', 'Oct', 'Nov', 'Dec'];
  late final List<String> yearOptions = ['1970', '1971', '1972', '1973', '1974', '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983', '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992', '1993', '1994', '1995', '1996', '1997', '1998', '1999', '2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035', '2036', '2037', '2038', '2039', '2040'];
  late final List<String> yearOptions01 = ['1970', '1971', '1972', '1973', '1974', '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983', '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992', '1993', '1994', '1995', '1996', '1997', '1998', '1999', '2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035', '2036', '2037', '2038', '2039', '2040'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    titleController.dispose();
    legalfirstnameController.dispose();
    legallastnameController.dispose();
    brithCountryController.dispose();
    _cnicController.dispose();
    _dobController.dispose();
    _fatherNameController.dispose();
    _fatherCellController.dispose();
    _motherNameController.dispose();
    _motherCellController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _matricMarksController.dispose();
    _matricMarksController01.dispose();
    _matricMarksController02.dispose();
    _interMarksController.dispose();
    _interMarksController01.dispose();
    _interMarksController02.dispose();
    _degreeMarksController.dispose();
    _desiredProgramController.dispose();
    _desiredProgramController01.dispose();
    _desiredProgramController02.dispose();
    _countryController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_firstNameController.text.trim().isEmpty) { _showError('First Name is required'); return false; }
      if (_cnicController.text.trim().isEmpty) { _showError('CNIC is required'); return false; }
      if (_countryController.text.trim().isEmpty) { _showError('University name is required'); return false; }
    } else if (_currentStep == 1) {
      if (_fatherNameController.text.trim().isEmpty) { _showError('Father Name is required'); return false; }
      if (_motherNameController.text.trim().isEmpty) { _showError('Mother Name is required'); return false; }
      // Word limit validation for strengths and weaknesses (minimum 10 words)
      int wordCount = _motherNameController.text.trim().split(RegExp(r'\s+')).length;
      if (wordCount < 10) {
        _showError('Please write at least 10 words in Strengths and Weaknesses');
        return false;
      }
    } else if (_currentStep == 2) {
      if (_emailController.text.trim().isEmpty) { _showError('Email Address is required'); return false; }
      if (!_emailController.text.contains('@')) { _showError('Enter a valid email address'); return false; }
      if (_phoneController.text.trim().isEmpty) { _showError('Phone Number is required'); return false; }
      if (_addressController.text.trim().isEmpty) { _showError('Address is required'); return false; }
      if (_cityController.text.trim().isEmpty) { _showError('City is required'); return false; }
    } else if (_currentStep == 3) {
      if (_matricMarksController.text.trim().isEmpty) { _showError('Matric Marks/Percentage is required'); return false; }
      if (_interMarksController.text.trim().isEmpty) { _showError('Intermediate Marks/Percentage is required'); return false; }
      if (_degreeMarksController.text.trim().isEmpty) { _showError('Degree CGPA/Percentage is required'); return false; }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
  }

  // Upload image to Supabase Storage
  Future<String?> _uploadImageToSupabase(Uint8List imageBytes, String documentType) async {
    try {
      // Get user from Firebase (not Supabase)
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _showError('Please login first');
        return null;
      }

      // Use the Firebase user ID
      final userId = firebaseUser.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/$documentType/$timestamp.jpg';

      // Upload to Supabase (this will work now!)
      await Supabase.instance.client.storage
          .from('student_documents')
          .uploadBinary(filePath, imageBytes);

      // Get the picture URL
      final publicUrl = Supabase.instance.client.storage
          .from('student_documents')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error: $e');
      _showError('Failed to upload');
      return null;
    }
  }
  // Modified image picker with Supabase upload
  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
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

  Widget _buildPhotoUploadSection(String label, Uint8List? image, String type) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: smokeWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 10),
        GestureDetector(onTap: () => showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.camera_alt, color: primaryTeal), title: const Text('Take Photo'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera, type); }),
          ListTile(leading: const Icon(Icons.photo_library, color: primaryTeal), title: const Text('Choose from Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery, type); }),
        ]))),
            child: Container(width: 100, height: 100, decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: primaryTeal)),
                child: image != null ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(image, fit: BoxFit.cover)) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, color: textSecondary), const SizedBox(height: 4), Text('Upload', style: TextStyle(fontSize: 10, color: textSecondary))]))),
      ]),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _buildStepCircle(0, 'Personal info'), _buildStepLine(), _buildStepCircle(1, 'Internatonal\nApplication'), _buildStepLine(),
        _buildStepCircle(2, 'Contact info'), _buildStepLine(), _buildStepCircle(3, 'Qualification'),
      ]),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text('Step ${_currentStep + 1} of 4', style: TextStyle(color: primaryTeal, fontSize: 12))),
    ]);
  }

  Widget _buildStepCircle(int step, String label) {
    bool isActive = step == _currentStep, isCompleted = step < _currentStep;
    return Column(children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(gradient: isActive ? LinearGradient(colors: [primaryTeal, lightTeal]) : null, color: isActive ? null : (isCompleted ? Colors.green : smokeWhite), shape: BoxShape.circle, border: Border.all(color: isActive ? primaryTeal : (isCompleted ? Colors.green : borderColor), width: isActive ? 2 : 1)),
          child: Center(child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : Text('${step + 1}', style: TextStyle(color: isActive ? Colors.white : textSecondary, fontSize: 12)))),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 9, color: isActive ? primaryTeal : textSecondary)),
    ]);
  }

  Widget _buildStepLine() => Container(width: 25, height: 2, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(gradient: LinearGradient(colors: [_currentStep > 0 ? primaryTeal : borderColor, borderColor])));

  Widget _buildPersonalInfo() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
    const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
    const SizedBox(height: 4), const Text('Personal Information', style: TextStyle(fontSize: 12, color: textSecondary)), const SizedBox(height: 16),
    _buildPhotoUploadSection('Passport Size Photo', _profileImage, 'profile'), const SizedBox(height: 14),
    Row(children: [Expanded(child: _buildField('First Name*', _firstNameController, required: true)), const SizedBox(width: 8), Expanded(child: _buildField('Last Name', _middleNameController))]), const SizedBox(height: 12),
    Align(alignment: Alignment.centerLeft, child: Text('Date of birth*', style: TextStyle(color: Colors.grey))), const SizedBox(height: 12),
    Row(children: [Expanded(child: _buildDropdown('Day*', _selectedday, dayOptions, (v) => setState(() => _selectedday = v!))), const SizedBox(width: 8),
      Expanded(child: _buildDropdown('Month*', _selecteMonth, MonthOptions, (v) => setState(() => _selecteMonth = v!))),
      Expanded(child:_buildDropdown('Year*', _selecteyear, yearOptions, (v) => setState(() => _selecteyear = v!)))]), const SizedBox(height: 12),
    Row(children: [Expanded(child: _buildField('CNIC*\nEx: 37406-4338536-3', _cnicController, required: true)), const SizedBox(width: 8), Expanded(child: _buildField('Email* \nEx: abc123@gmail.com', _dobController, required: true)), const SizedBox(width: 8), Expanded(child: _buildField('Phone no \n Ex: +92 3345772334*', _countryController, required: true))]), const SizedBox(height: 12),
    Row(children: [Expanded(child: _buildDropdown('Gender*', _selectedGender, genderOptions, (v) => setState(() => _selectedGender = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown('Nationality*', _selectedProvince01, provinceOptions01, (v) => setState(() => _selectedProvince01 = v!)))]), const SizedBox(height: 12),
    _buildDropdown('Do You Have Any Criminal History?', _selectedBloodGroup, bloodGroupOptions, (v) => setState(() => _selectedBloodGroup = v!)),
  ]));

  Widget _buildFamilyDetails() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
    const Text('International Application', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textPrimary)),
    const SizedBox(height: 4), const Text('Personal infomation', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: textSecondary)), const SizedBox(height: 16),
    Row(children: [Expanded(child: _buildDropdown('Title*', _selectedtitle, titleOptions, (v) => setState(() => _selectedtitle = v!))), const SizedBox(width: 8)]),
    Row(children: [Expanded(child: _buildField('First Name*', legalfirstnameController, required: true)), const SizedBox(width: 8), Expanded(child: _buildField('Last Name', legallastnameController))]), const SizedBox(height: 12),
    Align(alignment: Alignment.centerLeft, child: Text('Date of birth*', style: TextStyle(color: Colors.grey))), const SizedBox(height: 12),
    Row(children: [Expanded(child: _buildDropdown('Day*', _selectedday01, dayOptions01, (v) => setState(() => _selectedday01 = v!))), const SizedBox(width: 8),
      Expanded(child: _buildDropdown('Month*', _selecteMonth01, MonthOptions01, (v) => setState(() => _selecteMonth01 = v!))),
      Expanded(child:_buildDropdown('Year*', _selecteyear01, yearOptions01, (v) => setState(() => _selecteyear01 = v!)))]), const SizedBox(height: 15),
    Row(children: [Expanded(child: _buildDropdown('Gender*', _selectedGenderInternational, genderOptions, (v) => setState(() => _selectedGenderInternational = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown('Nationality*', _selectedProvince, provinceOptions, (v) => setState(() => _selectedProvince = v!)))]),
    _buildField('Dual Nationality\n(If yes write Country name if no write no)', _fatherNameController, required: true), const SizedBox(height: 12),
    Row(children: [Expanded(child: _buildDropdown('Country you are interested*', _selectedCountry, CountryOptions, (v) => setState(() => _selectedCountry = v!))), const SizedBox(width: 8)]),
    Row(children: [Expanded(child: _buildDropdown('Have you previuosly applied for studies?', _selectedBloodGroup01, bloodGroupOptions01, (v) => setState(() => _selectedBloodGroup01 = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown('Do you have any disability?', _selectedBloodGroup02, bloodGroupOptions, (v) => setState(() => _selectedBloodGroup02 = v!)))]),
    _buildField('Disability(if not write no)', _fatherCellController), const SizedBox(height: 12),
    _buildField('Your Strenght and weaknesses \n (minimum 10 words)*', _motherNameController, required: true, maxLines: 3), const SizedBox(height: 12),
    _buildField('Country of birth', _motherCellController),
  ]));

  Widget _buildContactInfo() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
    const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
    const SizedBox(height: 4), const Text('Home Adress', style: TextStyle(fontSize: 15, color: textSecondary)), const SizedBox(height: 16),
    Row(children: [Expanded(child: _buildDropdown('Country', _selectedProvince02, provinceOptions02, (v) => setState(() => _selectedProvince02 = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown('City', _selectedcitiy, pakistaniCities, (v) => setState(() => _selectedcitiy = v!)))]),
    _buildField('Email*', _emailController, keyboard: TextInputType.emailAddress, required: true), const SizedBox(height: 12),
    _buildField('Phone*\nEx: +92 3345456766', _phoneController, keyboard: TextInputType.phone, required: true), const SizedBox(height: 12),
    _buildField('Address*', _addressController, maxLines: 2, required: true), const SizedBox(height: 12),
    _buildField('Postal Code*', _cityController, required: true),
  ]));

  Widget _buildAcademicInfo() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
    const Text('Academic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
    const SizedBox(height: 4), const Text('Your educational background', style: TextStyle(fontSize: 12, color: textSecondary)), const SizedBox(height: 16),
    const Text('Matric / O-Levels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)), const SizedBox(height: 8),
    _buildField('School*', _matricMarksController01, required: true), const SizedBox(height: 8),
    _buildField('Feild of study*', _matricMarksController02, required: true), const SizedBox(height: 8),
    _buildField('Marks/Percentage*', _matricMarksController, required: true), const SizedBox(height: 12),
    _buildPhotoUploadSection('Matric Certificate', _matricCertificate, 'matric'), const SizedBox(height: 16),
    const Text('Intermediate / A-Levels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)), const SizedBox(height: 8),
    _buildField('Marks/Percentage*', _interMarksController, required: true), const SizedBox(height: 8),
    _buildField('collage*', _interMarksController01, required: true), const SizedBox(height: 8),
    _buildField('Feild of study', _interMarksController02, required: true), const SizedBox(height: 12),
    _buildPhotoUploadSection('Intermediate Certificate', _interCertificate, 'inter'), const SizedBox(height: 16),
    const Text("Bachelor's Degree(give detail if not simply write nill)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)), const SizedBox(height: 8),
    _buildField('CGPA/Percentage*', _degreeMarksController, required: true), const SizedBox(height: 8),
    _buildField('University*', _desiredProgramController01, required: true), const SizedBox(height: 8),
    _buildField('Feild of study*', _desiredProgramController02, required: true), const SizedBox(height: 12),
    _buildPhotoUploadSection('Degree Certificate', _degreeCertificate, 'degree'), const SizedBox(height: 16),
    Text('You are appling for?', style: TextStyle(fontSize:20,color: Colors.grey)),
    Row(children: [Expanded(child: _buildDropdown('University', _selectedsubject, subjectOptions, (v) => setState(() => _selectedsubject = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown('Level', _selectedProgramLevel, programOptions, (v) => setState(() => _selectedProgramLevel = v!))),const SizedBox(width: 8),Expanded(child: _buildDropdown('course', _selectedcourse, coursesOption, (v) => setState(() => _selectedcourse = v!)))
    ]),
  ]));

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text, int maxLines = 1, bool required = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary)), const SizedBox(height: 4),
      Container(height: maxLines > 1 ? null : 38, decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
          child: TextFormField(controller: ctrl, keyboardType: keyboard, maxLines: maxLines, validator: required ? (value) => value == null || value.trim().isEmpty ? 'Required' : null : null,
              decoration: InputDecoration(border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), hintText: 'Enter ${label.replaceAll('*', '')}', hintStyle: TextStyle(fontSize: 12, color: textSecondary)), style: const TextStyle(fontSize: 13))),
    ]);
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary)), const SizedBox(height: 4),
      Container(height: 38, decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(value: options.contains(value) ? value : options.first, isExpanded: true, icon: Icon(Icons.arrow_drop_down, color: textSecondary),
                  items: options.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12)))).toList(), onChanged: onChanged)))),
    ]);
  }

  Widget _buildNavigationButtons() {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: pureWhite, border: Border(top: BorderSide(color: borderColor))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (_currentStep > 0) SizedBox(width: 90, child: OutlinedButton(onPressed: () => setState(() => _currentStep--),
            style: OutlinedButton.styleFrom(foregroundColor: primaryTeal, side: BorderSide(color: primaryTeal), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back, size: 14), SizedBox(width: 4), Text('Back', style: TextStyle(fontSize: 12))]))),
        SizedBox(width: 90, child: ElevatedButton(onPressed: () { if (_currentStep < 3) { if (_validateCurrentStep()) setState(() => _currentStep++); } else { if (_validateCurrentStep()) _submitForm(); } },
            style: ElevatedButton.styleFrom(backgroundColor: primaryTeal, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_currentStep == 3 ? 'Submit' : 'Next', style: const TextStyle(color: Colors.white, fontSize: 12)), const SizedBox(width: 4), Icon(_currentStep == 3 ? Icons.send : Icons.arrow_forward, size: 14, color: Colors.white)]))),
      ]),
    );
  }

  void _submitForm() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Navigator.pop(context);
        _showError('User not logged in');
        return;
      }

      final uid = user.uid;

      firestore.collection('user_applications').doc(uid).set({
        'uid': uid,
        'firstname': _firstNameController.text,
        'lastname': _middleNameController.text,
        'cnic': _cnicController.text,
        'email first': _dobController.text,
        'country': _countryController.text,
        'Day': _selectedday,
        'month': _selecteMonth,
        'year': _selecteyear,
        'Gender': _selectedGender,
        'country first': _selectedProvince,
        'have any crimnal history': _selectedBloodGroup,
        'title': _selectedtitle,
        'firstnamefirst': legalfirstnameController.text,
        'lastnamefirst': legallastnameController.text,
        'country contact': _selectedProvince02,
        'dayfirst': _selectedday01,
        'monthfirst': _selecteMonth01,
        'yearfirst': _selecteyear01,
        'dual nationality': _fatherNameController.text,
        'appied before': _selectedBloodGroup01,
        'Country interseted': _selectedCountry,
        'disability': _selectedBloodGroup02,
        'what disability': _fatherCellController.text,
        'strenght and weakness': _motherNameController.text,
        'birth place': _motherCellController.text,
        'country02': _selectedProvince01,
        'city your': _selectedcitiy,
        'stuemail': _emailController.text,
        'stuaddress': _addressController.text,
        'stucity': _cityController.text,
        'stuphone': _phoneController.text,
        'Matricmarks': _matricMarksController.text,
        'matric school': _matricMarksController01.text,
        'matric feild of study': _matricMarksController02.text,
        'Intermarks': _interMarksController.text,
        'collage': _interMarksController01.text,
        'collage feild of study': _interMarksController02.text,
        'university': _desiredProgramController01.text,
        'university feild of study': _desiredProgramController02.text,
        'DegreeMarks': _degreeMarksController.text,
        'interset university subject': _selectedsubject,
        'interested level': _selectedProgramLevel,
        'Course intersted': _selectedcourse,
        // Add Supabase image URLs to Firestore
        'profileImageUrl': _profileImageUrl,
        'matricCertificateUrl': _matricCertificateUrl,
        'interCertificateUrl': _interCertificateUrl,
        'degreeCertificateUrl': _degreeCertificateUrl,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      }).then((_) async {
        await firestore.collection('user_dashboard').doc(uid).set({'totalApplications': FieldValue.increment(1)}, SetOptions(merge: true));
        await firestore.collection('broadmindedness').doc('stats sch').set({'totalApplications': FieldValue.increment(1)}, SetOptions(merge: true));
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Success!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            content: const Text('Your registration has been submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
                },
                child: const Text('OK', style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }).catchError((e) {
        Navigator.pop(context);
        _showError("Error: $e");
      });
    } catch (e) {
      Navigator.pop(context);
      _showError("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person_add, color: Colors.white, size: 18)), const SizedBox(width: 8), const Text('Student Registration', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w600))]), backgroundColor: primaryTeal, elevation: 0),
      body: Form(key: _formKey, child: Column(children: [const SizedBox(height: 12), _buildProgressIndicator(), Expanded(child: IndexedStack(index: _currentStep, children: [_buildPersonalInfo(), _buildFamilyDetails(), _buildContactInfo(), _buildAcademicInfo()]))])),
      bottomNavigationBar: _buildNavigationButtons(),
    );
  }
}