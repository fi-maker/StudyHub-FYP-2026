import 'package:flutter/material.dart';
import 'package:studyhub_032_031/Screens/Student/stuschapp.dart';

class ApplicationDetail extends StatelessWidget {
  final Map<String, dynamic> applicationData;
  final int applicationNumber;

  const ApplicationDetail({
    Key? key,
    required this.applicationData,
    required this.applicationNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Teal color palette
    const Color primaryTeal = Color(0xFF008080);
    const Color lightTeal = Color(0xFF20B2AA);
    const Color smokeWhite = Color(0xFFF5F5F5);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF264653);
    const Color textSecondary = Color(0xFF6B7B8A);
    const Color borderColor = Color(0xFFE0E0E0);

    void _copyToClipboard(String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied: $text'),
          duration: const Duration(seconds: 2),
          backgroundColor: primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              child: const Icon(Icons.description, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              "Application #$applicationNumber",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: primaryTeal,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with applicant name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryTeal, lightTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${applicationData['firstname'] ?? ''} ${applicationData['middlename']?? ''} ${applicationData['lastname'] ?? ''}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (applicationData['stuemail'] != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            applicationData['stuemail'],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (applicationData['stuphone'] != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          applicationData['stuphone'],
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Personal Information Section with Selectable & Copyable User ID
            _buildSectionTitle("Personal Information", Icons.person),
            const SizedBox(height: 8),

            // User ID with Selectable Text
            _detailTileWithSelectableText(
              "User ID",
              applicationData['uid'] ?? '-',
              primaryTeal,
              textPrimary,
              textSecondary,
              pureWhite,
            ),

            _detailTile("First Name", applicationData['firstname']),
            _detailTile("Middle Name", applicationData['lastname']),
            _detailTile("Email", applicationData['email first']),
            _detailTile("Phone #", applicationData['country']),
            _detailTile("date of birth(Day)", applicationData['Day']),
            _detailTile("date of birth(Month)", applicationData['month']),
            _detailTile("date of birth(Year)", applicationData['year']),
            _detailTile("Gender", applicationData['Gender']),
            _detailTile("Country", applicationData['country first']),
            _detailTile("Have any crimnal History?", applicationData['have any crimnal history']),



            const SizedBox(height: 16),

            // Family Details Section
            _buildSectionTitle("International Application", Icons.family_restroom),
            const SizedBox(height: 8),
            _detailTile("Title", applicationData['title']),
            _detailTile("First name", applicationData['firstnamefirst']),
            _detailTile("Last name", applicationData['lastnamefirst']),
            _detailTile("Nationality", applicationData['country contact']),
            _detailTile("date of birth(Day)", applicationData['dayfirst']),
            _detailTile("date of birth(Month)", applicationData['monthfirst']),
            _detailTile("date of birth(Year)", applicationData['yearfirst']),
            _detailTile("Dual Nationality", applicationData['dual nationality']),
            _detailTile("Have you applied before?", applicationData['appied before']),
            _detailTile("Interseted Country for admission", applicationData['Country interseted']),
            _detailTile(" Any Disability", applicationData['disability']),
            _detailTile("disability name", applicationData['what disability']),
            _detailTile("Strenght and Weakness", applicationData['strenght and weakness']),
            _detailTile("Birth place", applicationData['birth place']),


            const SizedBox(height: 16),

            // Contact Information Section
            _buildSectionTitle("Contact Information", Icons.contact_mail),
            const SizedBox(height: 8),
            _detailTile("Country", applicationData['country02']),
            _detailTile("City", applicationData['city your']),
            _detailTile("Email", applicationData['stuemail']),
            _detailTile("Student Phone #", applicationData['stuphone']),
            _detailTile("Home Address", applicationData['stuaddress']),
            _detailTile("Postal code", applicationData['stucity']),


            const SizedBox(height: 16),

            // Academic Information Section
            _buildSectionTitle("Academic Information", Icons.school),
            const SizedBox(height: 8),
            _detailTile("Matric marks or 10th grade", applicationData['Matricmarks']),
            _detailTile("School or institute", applicationData['matric school']),
            _detailTile("Feild of study", applicationData['matric feild of study']),
            _detailTile("High school Marks", applicationData['Intermarks']),
            _detailTile("School or institute", applicationData['collage']),
            _detailTile("Feild of study", applicationData['collage feild of study']),
            _detailTile("University CGPA", applicationData['DegreeMarks']),
            _detailTile("School or institute", applicationData['university']),
            _detailTile("Feild of study", applicationData['university feild of study']),
            _detailTile("Intersered University", applicationData['interset university subject']),
            _detailTile("Level", applicationData['interested level']),
            _detailTile("Course", applicationData['Course intersted']),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    const Color primaryTeal = Color(0xFF008080);
    const Color textPrimary = Color(0xFF264653);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: primaryTeal, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _detailTile(String title, dynamic value) {
    const Color primaryTeal = Color(0xFF008080);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF264653);
    const Color textSecondary = Color(0xFF6B7B8A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.teal),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value?.toString() ?? '-',
                style: TextStyle(
                  fontSize: 14,
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New widget with SelectableText for easy selection and copying
  Widget _detailTileWithSelectableText(
      String title,
      String value,
      Color primaryTeal,
      Color textPrimary,
      Color textSecondary,
      Color pureWhite,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.teal),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
                // Optional: Add toolbar options
                toolbarOptions: const ToolbarOptions(
                  copy: true,
                  selectAll: true,
                  cut: false,
                  paste: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}