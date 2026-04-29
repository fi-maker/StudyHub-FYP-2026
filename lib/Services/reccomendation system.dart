import 'package:flutter/material.dart';
import '../Screens/Student/stu-application.dart';
import '../Screens/Student/universityfetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/Student/userprefrences.dart';
import 'package:url_launcher/url_launcher.dart';

// Fixed getUserPreferences - preferences are directly in the user document
Stream<UserPreferences?> getUserPreferences() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  final uid = user.uid;
  //Faiqaws123@.com
  // Fetch from users collection where preference fields are directly in the document
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;

    print('📄 User document data: $data');

    // Try to get preferences from various possible field names
    final country = data['preferedcountry'] ;


    final subject = data['subjectofinterset'] ;

    final program = data['academiclevel'] ;

    final maxTuition = data['budget'] ;

    // Check if any preference exists
    if (country.toString().isNotEmpty ||
        subject.toString().isNotEmpty ||
        program.toString().isNotEmpty ||
        maxTuition.toString().isNotEmpty) {

      final prefs = UserPreferences(
        country: country.toString(),
        subject: subject.toString(),
        program: program.toString(),
        maxTuition: maxTuition.toString(),
      );

      print('✅ Created preferences: Country=${prefs.country}, Subject=${prefs.subject}, Program=${prefs.program}, MaxTuition=${prefs.maxTuition}');
      return prefs;
    }

    print('⚠️ No preferences found in user document');
    return null;
  });
}

int calculateMatch(University u, UserPreferences p) {
  int score = 0;
  int total = 4;

  print('🔍 Calculating match for: ${u.name}');
  print('   University Country: ${u.country} vs User Country: ${p.country}');
  print('   University Subject: ${u.subject} vs User Subject: ${p.subject}');
  print('   University Program: ${u.program} vs User Program: ${p.program}');
  print('   University Tuition: ${u.tuitionFee} vs User Max Tuition: ${p.maxTuition}');

  if (u.country.toString().toLowerCase() == p.country.toString().toLowerCase()) {
    score++;
    print('   ✅ Country matched!');
  }
  if (u.subject.toString().toLowerCase() == p.subject.toString().toLowerCase()) {
    score++;
    print('   ✅ Subject matched!');
  }
  if (u.program.toString().toLowerCase() == p.program.toString().toLowerCase()) {
    score++;
    print('   ✅ Program matched!');
  }
  if (u.tuitionFee.toString() == p.maxTuition.toString()) {
    score++;
    print('   ✅ Tuition matched!');
  }

  final matchPercentage = ((score / total) * 100).round();
  print('   📊 Match Score: $score/$total = $matchPercentage%');

  return matchPercentage;
}

class UniversitiesP extends StatefulWidget {
  const UniversitiesP({super.key});

  @override
  State<UniversitiesP> createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesP> {
  String selectedCountry = 'All';
  String searchText = '';

  // Teal and Smoke White color palette
  static const Color primaryTeal =Colors.teal;
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color darkTeal = Color(0xFF004D4D);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color accentGold = Color(0xFFE6B800);

  final List<String> countries = [
    'All',
    'United States',
    'United Kingdom',
    'China',
    'Germany',
    'France'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: const Text(
          'Explore Universities',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryTeal,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryTeal, lightTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: pureWhite,
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                _buildSearch(),
                _buildCountryFilter(),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<University>>(
              stream: getUniversities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: primaryTeal,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading universities...',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: pureWhite,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            size: 60,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No universities found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<University> universities = snapshot.data!;

                // SEARCH
                if (searchText.isNotEmpty) {
                  universities = universities
                      .where((u) =>
                      u.name.toLowerCase().contains(searchText.toLowerCase()))
                      .toList();
                }

                // COUNTRY FILTER
                if (selectedCountry != 'All') {
                  universities = universities
                      .where((u) =>
                      u.country.toLowerCase().contains(selectedCountry.toLowerCase()))
                      .toList();
                }

                // SORT BY COUNTRY
                universities.sort((a, b) => a.country.compareTo(b.country));

                return StreamBuilder<UserPreferences?>(
                  stream: getUserPreferences(),
                  builder: (context, prefSnap) {
                    final prefs = prefSnap.data;

                    if (universities.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_alt_off,
                              size: 60,
                              color: textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No matching universities',
                              style: TextStyle(
                                fontSize: 16,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final u = universities[index];
                        final match = prefs == null ? 0 : calculateMatch(u, prefs);
                        return _universityCard(u, match);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search universities...',
            hintStyle: TextStyle(color: textSecondary),
            prefixIcon: Icon(Icons.search, color: primaryTeal),
            filled: true,
            fillColor: pureWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryTeal, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (value) => setState(() => searchText = value),
        ),
      ),
    );
  }

  Widget _buildCountryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          final selected = country == selectedCountry;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                country,
                style: TextStyle(
                  color: selected ? Colors.white : textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              selected: selected,
              onSelected: (_) => setState(() => selectedCountry = country),
              backgroundColor: smokeWhite,
              selectedColor: primaryTeal,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected ? primaryTeal : borderColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _universityCard(University u, int match) {
    // Determine match color
    Color matchColor;
    if (match >= 75) {
      matchColor = Colors.green;
    } else if (match >= 50) {
      matchColor = accentGold;
    } else {
      matchColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image and match badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/img.png",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: smokeWhite,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: textSecondary,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: matchColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: matchColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          match >= 75 ? Icons.stars : Icons.favorite,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$match% Match",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // University Name
            Text(
              u.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // Location, Program and Ranking
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(u.country, style: TextStyle(fontSize: 13, color: textSecondary)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(u.program, style: TextStyle(fontSize: 13, color: textSecondary)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(u.ranking, style: TextStyle(fontSize: 13, color: textSecondary)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tuition and Subject
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: smokeWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuition Fee',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${u.tuitionFee}/year",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: borderColor,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subject',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          u.subject,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UniversityDetailPage(
                        universityData: {
                          'id':u.universityId,
                          'name': u.name,
                          'country': u.country,
                          'tuitionFee': u.tuitionFee,
                          'program': u.program,
                          'subject': u.subject,
                          'ranking': u.ranking,
                          'resarch': u.research,
                          'scholarship':u.scholarship,
                          'description':u.description,
                        }, docId: '',

                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "View Detail",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UniversityDetailPage extends StatelessWidget {
  final Map<String, dynamic> universityData;
  final String docId;

  const UniversityDetailPage({
    Key? key,
    required this.universityData,
    required this.docId,
  }) : super(key: key);

  final Color primaryTeal = const Color(0xFF008080);
  final Color textPrimary = const Color(0xFF264653);
  final Color textSecondary = const Color(0xFF6B7B8A);

  Future<void> _launchURL(String url) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Back Button
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: primaryTeal,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryTeal,
                      primaryTeal.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // University Image/Icon
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.school,
                              size: 60,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            universityData['name']?.toString() ?? 'University',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),

                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // University Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Section
                  _buildSectionHeader(Icons.location_on, 'Location'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Country',
                          universityData['country']?.toString() ?? 'N/A',
                          Icons.flag,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Ranking',
                          universityData['ranking']?.toString() ?? 'N/A',
                          Icons.star,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Academic Section
                  _buildSectionHeader(Icons.school, 'Academic Information'),
                  const SizedBox(height: 12),
                  _buildDetailTile(
                    'Program',
                    universityData['program']?.toString() ?? 'N/A',
                    Icons.book,
                  ),
                  _buildDivider(),
                  _buildDetailTile(
                    'Course',
                    universityData['subject']?.toString() ?? 'N/A',
                    Icons.subject,
                  ),

                  _buildDivider(),
                  _buildDetailTile(
                    'Research oportunies',
                    universityData['resarch']?.toString() ?? 'N/A',
                    Icons.read_more,
                  ),
                  const SizedBox(height: 20),

                  // Financial Section
                  _buildSectionHeader(Icons.attach_money, 'Financial Information'),
                  const SizedBox(height: 12),
                  _buildDetailTile(
                    'Tuition Fee',
                    '\$${universityData['tuitionFee']?.toString() ?? 'N/A'}',
                    Icons.receipt,
                  ),
                  _buildDivider(),
                  _buildDetailTile(
                    'Scholarship(based on merit)',
                    universityData['scholarship']?.toString() ?? 'N/A',
                    Icons.event,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (universityData['description']?.toString().isNotEmpty ?? false) ...[
                    _buildSectionHeader(Icons.description, 'Description'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        universityData['description']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Website Link
                  if (universityData['website']?.toString().isNotEmpty ?? false) ...[
                    _buildSectionHeader(Icons.link, 'Website'),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _launchURL(universityData['website']?.toString() ?? ''),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryTeal.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryTeal.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.open_in_browser, color: primaryTeal),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                universityData['website']?.toString() ?? '',
                                style: TextStyle(
                                  color: primaryTeal,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.launch, color: primaryTeal, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Apply Now Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              // Apply now action
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Application Submitted'),
                  content: Text(
                    'Your application for ${universityData['name']?.toString() ?? 'University'} has been submitted successfully!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompleteStudentRegistrationForm(), // Replace YourNewPage with your actual page widget
                          ),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },

            icon: const Icon(Icons.send),
            label: const Text(
              'APPLY NOW',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 22, color: primaryTeal),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 2,
            color: primaryTeal.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryTeal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryTeal),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: primaryTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFE0E0E0),
    );
  }
}