class UserPreferences {
  final List<String> interests;
  final double budget;
  final List<String> countryPreferences;
  final String academicLevel;
  final List<String> preferredSubjects;
  final double preferredRanking;

  UserPreferences({
    required this.interests,
    required this.budget,
    required this.countryPreferences,
    required this.academicLevel,
    required this.preferredSubjects,
    required this.preferredRanking,
  });

  factory UserPreferences.fromFirestore(Map<String, dynamic> data) {
    return UserPreferences(
      interests: List<String>.from(data['interests'] ?? []),
      budget: (data['budget'] ?? 30000).toDouble(),
      countryPreferences:
      List<String>.from(data['country_preferences'] ?? []),
      academicLevel: data['academic_level'] ?? 'BS',
      preferredSubjects:
      List<String>.from(data['preferred_subjects'] ?? []),
      preferredRanking:
      (data['preferred_ranking'] ?? 3.0).toDouble(),
    );
  }
}
