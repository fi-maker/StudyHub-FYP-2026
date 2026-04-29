import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RateUniversityPage extends StatefulWidget {
  const RateUniversityPage({super.key});

  @override
  State<RateUniversityPage> createState() => _RateUniversityPageState();
}

class _RateUniversityPageState extends State<RateUniversityPage> {
  String selectedCollection = 'universities';
  String? selectedUniversityId;
  String? selectedUniversityName;
  String? selectedUniversityImage;
  double _rating = 0;
  bool _isSubmitting = false;
  bool _isRatingSubmitted = false;

  final List<String> collections = ['universities', 'sch-universities'];

  Future<void> _submitRating() async {
    if (selectedUniversityId == null || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a university and rating'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance.collection('ratings').add({
        'universityId': selectedUniversityId,
        'universityName': selectedUniversityName,
        'universityImage': selectedUniversityImage,
        'collection': selectedCollection,
        'userId': user.uid,
        'userEmail': user.email,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating submitted successfully!'), backgroundColor: Colors.green),
      );

      setState(() {
        _rating = 0;
        selectedUniversityId = null;
        selectedUniversityName = null;
        selectedUniversityImage = null;
        _isRatingSubmitted = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isRatingSubmitted = false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Rate Universities', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Category Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: collections.map((col) {
                final isSelected = selectedCollection == col;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCollection = col;
                        selectedUniversityId = null;
                        selectedUniversityName = null;
                        selectedUniversityImage = null;
                        _rating = 0;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          col == 'universities' ? 'Regular' : 'Scholarship',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(selectedCollection).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                final universities = snapshot.data!.docs;
                if (universities.isEmpty) {
                  return const Center(child: Text('No universities found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: universities.length,
                  itemBuilder: (context, index) {
                    final doc = universities[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final uniId = doc.id;
                    final uniName = data['name'] ?? 'Unnamed University';
                    final uniImage = data['imageUrl'] ?? '';
                    final isSelected = selectedUniversityId == uniId;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected ? Colors.teal.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(color: Colors.teal, width: 2)
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedUniversityId = null;
                                selectedUniversityName = null;
                                selectedUniversityImage = null;
                                _rating = 0;
                              } else {
                                selectedUniversityId = uniId;
                                selectedUniversityName = uniName;
                                selectedUniversityImage = uniImage;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // University Image
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: uniImage.isNotEmpty
                                        ? Image.network(
                                      uniImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                                    )
                                        : _buildImagePlaceholder(),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // University Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        uniName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected ? Colors.teal : Colors.grey[800],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 12, color: Colors.grey[400]),
                                          const SizedBox(width: 4),
                                          Text(
                                            data['country'] ?? 'Unknown',
                                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Rating Stars
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(5, (starIndex) {
                                        return IconButton(
                                          icon: Icon(
                                            starIndex < _rating ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () => setState(() => _rating = starIndex + 1),
                                        );
                                      }),
                                    ),
                                  ),

                                // Selection indicator
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                                  )
                                else
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 16),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Submit Button
          if (selectedUniversityId != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_rate, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Submit $_rating Star Rating',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(Icons.school, color: Colors.grey[400], size: 30),
      ),
    );
  }
}