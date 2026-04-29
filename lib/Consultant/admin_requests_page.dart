import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class AdminRequestsPage extends StatefulWidget {
  const AdminRequestsPage({Key? key}) : super(key: key);

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  static const Color primaryTeal = Color(0xFF008080);
  bool _isNavigating = false;

  Future<void> _acceptRequest(String requestId) async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    try {
      // Corrected: Calling the instance explicitly
      final firestore = FirebaseFirestore.instance;

      // 1. Update the status
      await firestore.collection('consultant_requests').doc(requestId).update({
        'status': 'accepted',
      });

      // 2. Add the system message
      await firestore.collection('chats').doc(requestId).collection('messages').add({
        'senderId': 'admin_user',
        'senderType': 'admin',
        'text': 'Admin has joined the chat.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // 3. Navigate to ChatPage
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            requestId: requestId,
            senderId: 'admin_user',
            senderType: 'admin',
          ),
        ),
      );
    } catch (e) {
      debugPrint("Accept Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryTeal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // FIXED: Explicitly calling FirebaseFirestore.instance here
        stream: FirebaseFirestore.instance
            .collection('consultant_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryTeal));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text("No pending requests"));

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(data['userName'] ?? 'User'),
                  subtitle: Text("Request #${data['requestNumber'] ?? ''}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryTeal),
                    onPressed: _isNavigating ? null : () => _acceptRequest(doc.id),
                    child: const Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}