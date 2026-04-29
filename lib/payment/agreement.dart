import 'package:flutter/material.dart';
import 'package:studyhub_032_031/FeedBack/feedback.dart';
import 'package:studyhub_032_031/payment/payment.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool isChecked = false;

  // Teal color palette
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.description, color: Colors.white, size: 18)),
          const SizedBox(width: 8), const Text("Application Agreement", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: primaryTeal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: const Text('''
StudyHub University Application Agreement

1. All submitted documents must be authentic.
2. Consultancy processes applications to universities.
3. Admission decisions are made by universities.
4. Application fees are non-refundable.
5. Students must follow university rules.
6. StudyHub acts as a facilitator only.

By checking below, you agree to these terms.''',
                style: TextStyle(fontSize: 13, height: 1.5, color: textPrimary),
              ),
            ),
          )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Checkbox(value: isChecked, onChanged: (v) => setState(() => isChecked = v!), activeColor: primaryTeal),
              const Expanded(child: Text("I agree to the terms and conditions", style: TextStyle(fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: isChecked ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentVerificationPage())) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("PAY NOW", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}

class PaymentPage { const PaymentPage(); }