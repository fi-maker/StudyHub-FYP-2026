import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Teal color palette
    const Color primaryTeal = Colors.teal;
    const Color lightTeal = Color(0xFF20B2AA);
    const Color smokeWhite = Color(0xFFF5F5F5);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF264653);
    const Color textSecondary = Color(0xFF6B7B8A);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.history, color: Colors.white, size: 20)),
          const SizedBox(width: 10),
          const Text("Transaction History", style: TextStyle(fontSize: 18, color:Colors.white,fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: primaryTeal,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
            ]));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(color: primaryTeal),
              const SizedBox(height: 16),
              Text("Loading transactions...", style: TextStyle(color: textSecondary)),
            ]));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: pureWhite, shape: BoxShape.circle),
                  child: Icon(Icons.receipt_outlined, size: 60, color: textSecondary)),
              const SizedBox(height: 20),
              const Text("No transactions found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text("Payment transactions will appear here", style: TextStyle(fontSize: 14, color: textSecondary)),
            ]));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text("Total Transactions: ${snapshot.data!.docs.length}",
                          style: TextStyle(color: primaryTeal, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    DataTable(
                      headingRowColor: WidgetStateProperty.all(primaryTeal.withOpacity(0.1)),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
                      dataRowColor: WidgetStateProperty.all(pureWhite),
                      dataTextStyle: TextStyle(fontSize: 13, color: textPrimary),
                      columnSpacing: 20,
                      horizontalMargin: 16,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('UID')),
                        DataColumn(label: Text('Payment ID')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        String formattedDate = "N/A";
                        if (data['timestamp'] != null) {
                          DateTime dt = (data['timestamp'] as Timestamp).toDate();
                          formattedDate = DateFormat('dd MMM, yyyy').format(dt);
                        }
                        return DataRow(cells: [
                          DataCell(Text(data['name'] ?? 'No Name', overflow: TextOverflow.ellipsis)),
                          DataCell(Text(data['uid'] ?? 'No UID', overflow: TextOverflow.ellipsis)),
                          DataCell(Text(data['payment_id'] ?? 'No ID', overflow: TextOverflow.ellipsis)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: data['status'] == 'verified' ? Colors.green[100] : Colors.orange[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: data['status'] == 'verified' ? Colors.green[200]! : Colors.orange[200]!),
                              ),
                              child: Text(
                                data['status']?.toUpperCase() ?? 'PENDING',
                                style: TextStyle(
                                  color: data['status'] == 'verified' ? Colors.green[800] : Colors.orange[800],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(formattedDate)),
                        ]);
                      }).toList(),
                    ),
                    const SizedBox(height: 20), // Bottom padding for scroll
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}