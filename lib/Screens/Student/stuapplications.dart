import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplicationHistory extends StatelessWidget {
  const ApplicationHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    const Color primaryTeal = Color(0xFF008080);
    const Color textSecondary = Color(0xFF6B7B8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Applications History", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: primaryTeal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user_applications').where('uid', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.history_outlined, size: 50, color: textSecondary),
              const SizedBox(height: 10), const Text("No applications yet", style: TextStyle(fontSize: 16)),
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
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final status = data['status']?.toString().toLowerCase() ?? 'pending';
              Color statusColor = status == 'accepted' ? Colors.green : (status == 'rejected' ? Colors.red : Colors.amber);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Container(width: 35, height: 35, decoration: BoxDecoration(color: primaryTeal, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(data['Country interseted'] ?? 'Application', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text(status.toUpperCase(), style: TextStyle(fontSize: 8, color: statusColor, fontWeight: FontWeight.bold))),
                  ])),
                  Icon(Icons.arrow_forward_ios, color: primaryTeal, size: 12),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}