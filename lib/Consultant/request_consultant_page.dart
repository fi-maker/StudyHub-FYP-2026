import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class RequestConsultantPage extends StatefulWidget {
  const RequestConsultantPage({Key? key}) : super(key: key);

  @override
  State<RequestConsultantPage> createState() => _RequestConsultantPageState();
}

class _RequestConsultantPageState extends State<RequestConsultantPage> {
  bool _loading = false;

  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A2B3C);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE2E8F0);

  Future<void> _requestConsultant(int currentRequestCount) async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = FirebaseFirestore.instance.collection('consultant_requests').doc();
      final batch = FirebaseFirestore.instance.batch();

      batch.set(docRef, {
        'userId': user.uid,
        'userName': user.displayName ?? 'User',
        'status': 'pending',
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'requestNumber': currentRequestCount + 1,
      });

      batch.set(FirebaseFirestore.instance.collection('chats').doc(docRef.id).collection('messages').doc(), {
        'senderId': 'system',
        'senderType': 'system',
        'text': 'Consultation request #${currentRequestCount + 1} created.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(
          requestId: docRef.id, senderId: user.uid, senderType: 'user',
        )));
      }
    } catch (e) {
      debugPrint('Request error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: const Text('Consultant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: primaryTeal,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryTeal, lightTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('consultant_requests').where('userId', isEqualTo: user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          docs.sort((a, b) {
            final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
            final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
            return (bTime ?? Timestamp.now()).compareTo(aTime ?? Timestamp.now());
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildNewRequestButton(docs.length),
              const SizedBox(height: 20),
              if (docs.isEmpty) _buildEmptyState(),
              if (docs.isNotEmpty) _buildRequestsList(docs, user!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryTeal, lightTeal]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: primaryTeal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.support_agent, color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text('Get Expert Guidance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Connect with our consultants', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNewRequestButton(int requestCount) {
    return ElevatedButton(
      onPressed: _loading ? null : () => _requestConsultant(requestCount),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
      ),
      child: _loading
          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text("New Consultation Request", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: const Column(
        children: [
          Icon(Icons.support_agent_outlined, size: 64, color: textSecondary),
          SizedBox(height: 12),
          Text('No Requests Yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
          SizedBox(height: 4),
          Text('Tap the button above to get started', style: TextStyle(fontSize: 12, color: textSecondary)),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<QueryDocumentSnapshot> docs, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 12),
        ...docs.map((doc) => _buildRequestCard(doc, user)).toList(),
      ],
    );
  }

  Widget _buildRequestCard(QueryDocumentSnapshot doc, User user) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'].toString();

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch(status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = 'ACCEPTED';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'REJECTED';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'PENDING';
        statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(
            requestId: doc.id, senderId: user.uid, senderType: 'user',
          ))),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primaryTeal, lightTeal]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('#${data['requestNumber']}',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Request #${data['requestNumber']}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 4),
                          Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, color: primaryTeal, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}