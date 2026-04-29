import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentVerificationPage extends StatefulWidget {
  @override
  _PaymentVerificationPageState createState() => _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  final _uidController = TextEditingController();
  final _paymentIdController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Teal color palette
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);

  Future<void> _submitTransaction() async {
    final String uid = _uidController.text.trim();
    final String payId = _paymentIdController.text.trim();
    final String name = _nameController.text.trim();

    if (uid.isEmpty || payId.isEmpty || name.isEmpty) {
      _showMessage("Please fill all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userAppRef = _firestore.collection('user_applications').doc(uid);
      final scholarAppRef = _firestore.collection('scholarships_applications').doc(uid);

      final userAppDoc = await userAppRef.get();
      final scholarAppDoc = await scholarAppRef.get();

      bool hasUserApp = userAppDoc.exists;
      bool hasScholarApp = scholarAppDoc.exists;

      if (!hasUserApp && !hasScholarApp) {
        _showMessage("Error: UID not found in any application collection.", isError: true);
        setState(() => _isLoading = false);
        return;
      }

      WriteBatch batch = _firestore.batch();
      DocumentReference transRef = _firestore.collection('transactions').doc();
      batch.set(transRef, {
        'uid': uid,
        'payment_id': payId,
        'name': name,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });

      if (hasUserApp) batch.update(userAppRef, {'status': 'completed'});
      if (hasScholarApp) batch.update(scholarAppRef, {'status': 'completed'});

      await batch.commit();

      _showMessage("Success! Your payment was verified and status updated.");
      _clearForm();
    } catch (e) {
      print("FIREBASE ERROR: $e");
      _showMessage("System Error: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : primaryTeal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _clearForm() {
    _uidController.clear();
    _paymentIdController.clear();
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.verified, color: Colors.white, size: 20)),
          const SizedBox(width: 10),
          const Text("Payment Verification", style: TextStyle(fontSize: 18, color:Colors.white,fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: primaryTeal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: Column(children: [
              _buildInput(_nameController, "Full Name", Icons.person_outline),
              const SizedBox(height: 16),
              _buildInput(_uidController, "Enter your UID", Icons.fingerprint),
              const SizedBox(height: 16),
              _buildInput(_paymentIdController, "Transaction ID", Icons.receipt_outlined),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator(color: primaryTeal)
                  : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit & Complete Application",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Icon(Icons.info_outline, color: primaryTeal, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text("Your UID is the application document ID. Enter the transaction ID from your payment. And Submit your trasaction on this detail NayaPay 03315358077",
                  style: TextStyle(fontSize: 12, color: textPrimary))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      enableInteractiveSelection: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: primaryTeal),
        filled: true,
        fillColor: smokeWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryTeal, width: 2),
        ),
      ),
    );
  }
}