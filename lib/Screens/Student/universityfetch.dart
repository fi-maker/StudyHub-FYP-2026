import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  final String universityId;
  final String country;
  final String name;
  final String program;
  final String ranking;
  final String research;
  final String scholarship;
  final String subject;
  final String tuitionFee;
  final String description;

  University({
    required this.universityId,
    required this.name,
    required this.country,
    required this.program,
    required this.tuitionFee,
    required this.ranking,
    required this.research,
    required this.scholarship,
    required this.subject,
    required final this.description,
  });

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return University(
      universityId: doc.id,
      name: data['name']?.toString() ?? '',
      country: data['Country']?.toString() ?? '',
      program: data['Program']?.toString() ?? '',
      tuitionFee: data['tuitionFee']?.toString() ?? '',
      ranking: data['ranking']?.toString() ?? '',
      research: data['research']?.toString() ?? '',
      scholarship: data['scholarship']?.toString() ?? '',
      subject: data['Course']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
    );
  }
}

Stream<List<University>> getUniversities() {
  return FirebaseFirestore.instance
      .collection('universities')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => University.fromFirestore(doc)).toList());
}

Stream<List<University>> getschUniversities() {
  return FirebaseFirestore.instance
      .collection('sch-universities')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => University.fromFirestore(doc)).toList());
}