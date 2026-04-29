import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyhub_032_031/Screens/Student/scholarship_applications.dart';
import 'package:studyhub_032_031/Screens/Student/stu-application.dart';

import '../../FeedBack/feedback.dart';
import '../../payment/agreement.dart';
import 'application_detail.dart';

const Color primaryTeal = Color(0xFF008080);
const Color lightTeal = Color(0xFF20B2AA);
const Color smokeWhite = Color(0xFFF5F5F5);
const Color pureWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF264653);
const Color textSecondary = Color(0xFF6B7B8A);

class ApplicationHistory01 extends StatelessWidget {
  const ApplicationHistory01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.history, color: Colors.white, size: 18)),
          const SizedBox(width: 8), const Text("Application For", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: primaryTeal,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user_applications').where('uid', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(color: primaryTeal), const SizedBox(height: 12), Text("Loading...", style: TextStyle(color: textSecondary))]));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: pureWhite, shape: BoxShape.circle),
                  child: Icon(Icons.history_outlined, size: 50, color: textSecondary)),
              const SizedBox(height: 16), const Text("No applications yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ]));
          }
          final docs = snapshot.data!.docs;
          docs.sort((a, b) {
            final aTime = (a['createdAt'] as Timestamp?)?.toDate();
            final bTime = (b['createdAt'] as Timestamp?)?.toDate();
            if (aTime == null || bTime == null) return 0;
            return aTime.compareTo(bTime);
          });
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final status = data['status']?.toString().toLowerCase() ?? 'pending';
              Color statusColor = status == 'accepted' ? Colors.green : (status == 'rejected' ? Colors.red : Colors.amber);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ApplicationDetail(applicationData: data, applicationNumber: index + 1))),
                      child: Row(children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryTeal, lightTeal]), borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(data['Country interseted'] ?? 'Application', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Text(status.toUpperCase(), style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.bold))),
                        ])),
                        Icon(Icons.arrow_forward_ios, color: primaryTeal, size: 14),
                      ]),
                    ),
                    if (status == 'accepted' || status == 'rejected') ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          status == 'accepted' ? const AgreementPage() : const CompleteStudentRegistrationForm())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(status == 'accepted' ? "Processed" : "Submit Again",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}