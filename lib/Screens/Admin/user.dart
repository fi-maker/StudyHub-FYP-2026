class UserPreferences {
  final String country;
  final String subject;
  final String program;
  final String maxTuition;

  UserPreferences({
    required this.country,
    required this.subject,
    required this.program,
    required this.maxTuition,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    print('📦 UserPreferences.fromMap received: $map');

    return UserPreferences(
      country: map['country']?.toString() ??
          map['preferredCountry']?.toString() ??
          map['Country']?.toString() ?? '',
      subject: map['subject']?.toString() ??
          map['preferredSubject']?.toString() ??
          map['Subject']?.toString() ?? '',
      program: map['program']?.toString() ??
          map['preferredProgram']?.toString() ??
          map['Program']?.toString() ?? '',
      maxTuition: map['maxTuition']?.toString() ??
          map['tuitionLimit']?.toString() ??
          map['MaxTuition']?.toString() ?? '',
    );
  }
}
