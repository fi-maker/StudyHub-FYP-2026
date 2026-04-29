import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationDetail2 extends StatelessWidget {
  final Map<String, dynamic> applicationData;
  final int applicationNumber;
  final String docId;

  Future updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('user_applications')
        .doc(docId)
        .update({'status': status});
  }

  const ApplicationDetail2({
    Key? key,
    required this.applicationData,
    required this.applicationNumber,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF008080);
    const Color statusAccepted = Color(0xFF28A745);
    const Color statusRejected = Color(0xFFDC3545);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Application #$applicationNumber", style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primaryTeal, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${applicationData['firstname'] ?? ''} ${applicationData['lastname'] ?? ''}",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Personal Info
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
            _detailTile("Title", applicationData['title']),
            _detailTile("INTERNATIONAL APPLICATION", applicationData['']),
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
            _detailTile("Country", applicationData['country02']),
            _detailTile("City", applicationData['city your']),
            _detailTile("Email", applicationData['stuemail']),
            _detailTile("Student Phone #", applicationData['stuphone']),
            _detailTile("Home Address", applicationData['stuaddress']),
            _detailTile("Postal code", applicationData['stucity']),
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



            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      updateStatus(docId, 'accepted');
                      await FirebaseFirestore.instance
                          .collection('acceptedapplications')
                          .doc('stats sch')
                          .set({'totalApplications': FieldValue.increment(1)}, SetOptions(merge: true));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: statusAccepted, padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      updateStatus(docId, 'rejected');
                      await FirebaseFirestore.instance
                          .collection('rejectedapplications')
                          .doc('stats sch')
                          .set({'totalApplications': FieldValue.increment(1)}, SetOptions(merge: true));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: statusRejected, padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text("Reject", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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


  Widget _buildTile(String title, dynamic value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(flex: 3, child: Text(value?.toString() ?? '-', style: const TextStyle(fontSize: 12), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}