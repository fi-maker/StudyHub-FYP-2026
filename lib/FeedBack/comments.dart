import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationHistory03 extends StatefulWidget {
  const ApplicationHistory03({Key? key}) : super(key: key);

  @override
  State<ApplicationHistory03> createState() => _ApplicationHistory03State();
}

class _ApplicationHistory03State extends State<ApplicationHistory03> {
  // For filtering feedback
  String _selectedFilter = 'all'; // 'all', 'positive', 'negative', 'neutral'
  String _searchQuery = '';

  // Colors (same as yours)
  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color darkTeal = Color(0xFF004D4D);
  static const Color textLight = Color(0xFF666666);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color positiveColor = Color(0xFF2E7D32);
  static const Color negativeColor = Color(0xFFC62828);
  static const Color neutralColor = Color(0xFFF57C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pureWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.feedback_outlined,
                color: pureWhite,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "User Feedback",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: primaryTeal,
        elevation: 0,
        actions: [
          // Search button
          IconButton(
            onPressed: () => _showSearchDialog(),
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          // Filter button
          IconButton(
            onPressed: () => _showFilterMenu(),
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: Container(
        color: smokeWhite,
        child: Column(
          children: [
            // Filter chips (shows current filter)
            if (_selectedFilter != 'all' || _searchQuery.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'Filtered: ',
                      style: TextStyle(fontSize: 12, color: textLight),
                    ),
                    if (_selectedFilter != 'all')
                      Chip(
                        label: Text(_selectedFilter),
                        backgroundColor: _getFilterColor(_selectedFilter),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedFilter = 'all';
                          });
                        },
                      ),
                    if (_searchQuery.isNotEmpty)
                      Chip(
                        label: Text('Search: $_searchQuery'),
                        backgroundColor: Colors.grey.shade200,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ],
                ),
              ),

            // Firestore stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('feedbacks')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
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
                            "Loading feedback...",
                            style: TextStyle(color: textLight, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Get all docs
                  var docs = snapshot.data!.docs;

                  // Apply filters
                  List<QueryDocumentSnapshot> filteredDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final sentiment = data['sentiment'] ?? 'neutral';
                    final feedback = data['feedback'] ?? '';
                    final username = data['username'] ?? '';

                    // Filter by sentiment
                    if (_selectedFilter != 'all' && sentiment != _selectedFilter) {
                      return false;
                    }

                    // Filter by search query
                    if (_searchQuery.isNotEmpty) {
                      return feedback.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          username.toLowerCase().contains(_searchQuery.toLowerCase());
                    }

                    return true;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No matching feedback found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Stats header (shows filtered stats)
                      _buildStatsHeader(filteredDocs, docs.length),

                      // Feedback list
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filteredDocs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final data = filteredDocs[index].data() as Map<String, dynamic>;
                            return _buildFeedbackCard(data);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.feedback_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No feedback yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkTeal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to share your thoughts",
            style: TextStyle(fontSize: 14, color: textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(List<QueryDocumentSnapshot> filteredDocs, int totalDocs) {
    // Calculate stats from filtered docs
    int positive = filteredDocs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['sentiment'] == 'positive';
    }).length;

    int negative = filteredDocs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['sentiment'] == 'negative';
    }).length;

    int neutral = filteredDocs.length - positive - negative;

    // Calculate average score if available
    double avgScore = 0;
    int scoreCount = 0;
    for (var doc in filteredDocs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['sentimentScore'] != null) {
        avgScore += (data['sentimentScore'] as num).toDouble();
        scoreCount++;
      }
    }
    if (scoreCount > 0) avgScore /= scoreCount;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.feedback_outlined,
                count: filteredDocs.length.toString(),
                label: "Showing",
                color: primaryTeal,
              ),
              Container(
                height: 30,
                width: 1,
                color: borderColor,
              ),
              _buildStatItem(
                icon: Icons.sentiment_satisfied,
                count: positive.toString(),
                label: "Positive",
                color: positiveColor,
              ),
              Container(
                height: 30,
                width: 1,
                color: borderColor,
              ),
              _buildStatItem(
                icon: Icons.sentiment_dissatisfied,
                count: negative.toString(),
                label: "Negative",
                color: negativeColor,
              ),
              Container(
                height: 30,
                width: 1,
                color: borderColor,
              ),
              _buildStatItem(
                icon: Icons.sentiment_neutral,
                count: neutral.toString(),
                label: "Neutral",
                color: neutralColor,
              ),
            ],
          ),
          if (avgScore != 0) ...[
            const SizedBox(height: 12),
            Divider(color: borderColor),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Average Sentiment Score: ',
                  style: TextStyle(fontSize: 12, color: textLight),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(avgScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getScoreEmoji(avgScore),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(avgScore * 100).toInt()}% ${_getScoreLabel(avgScore)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(avgScore),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (totalDocs != filteredDocs.length)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Filtered from $totalDocs total feedbacks',
                style: const TextStyle(fontSize: 11, color: textLight),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> data) {
    final feedbackText = data['feedback'] ?? 'No comment';
    final user = data['username'] ?? 'Anonymous User';
    final sentiment = data['sentiment'] ?? 'neutral';
    final sentimentScore = (data['sentimentScore'] ?? 0.0).toDouble();

    // Time ago calculation
    String timeText = 'Just now';
    if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
      final Timestamp timestamp = data['createdAt'];
      final DateTime dateTime = timestamp.toDate();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        timeText = '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        timeText = '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        timeText = '${difference.inMinutes}m ago';
      } else {
        timeText = 'Just now';
      }
    }

    // Get sentiment color and icon
    Color sentimentColor;
    IconData sentimentIcon;
    switch (sentiment.toLowerCase()) {
      case 'positive':
        sentimentColor = positiveColor;
        sentimentIcon = Icons.sentiment_very_satisfied;
        break;
      case 'negative':
        sentimentColor = negativeColor;
        sentimentIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        sentimentColor = neutralColor;
        sentimentIcon = Icons.sentiment_neutral;
    }

    return Container(
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with user info and sentiment
            Row(
              children: [
                // User avatar with gradient
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryTeal, lightTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.isNotEmpty ? user[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: pureWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // User name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: darkTeal,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeText,
                            style: TextStyle(
                              fontSize: 11,
                              color: textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🔥 UPDATED: Sentiment badge with score display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: sentimentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sentimentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sentimentIcon,
                        size: 14,
                        color: sentimentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sentiment,
                        style: TextStyle(
                          fontSize: 11,
                          color: sentimentColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      // 🔥 ADDED: Show sentiment score percentage if available
                      if (data['sentimentScore'] != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: sentimentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${((data['sentimentScore'] as double) * 100).abs().toInt()}%',
                            style: TextStyle(
                              fontSize: 9,
                              color: sentimentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Feedback text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: smokeWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedbackText,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: darkTeal,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Footer with actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 12,
                        color: primaryTeal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Helpful',
                        style: TextStyle(
                          fontSize: 11,
                          color: primaryTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: textLight,
                  ),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: textLight,
                  ),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textLight,
          ),
        ),
      ],
    );
  }

  // Helper methods
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Feedback'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter keyword...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter by Sentiment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('all', 'All Feedback', Icons.list),
            _buildFilterOption('positive', 'Positive', Icons.sentiment_very_satisfied, Colors.green),
            _buildFilterOption('negative', 'Negative', Icons.sentiment_very_dissatisfied, Colors.red),
            _buildFilterOption('neutral', 'Neutral', Icons.sentiment_neutral, Colors.orange),
            const SizedBox(height: 16),
            if (_selectedFilter != 'all')
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 'all';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear Filter'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label, IconData icon, [Color? color]) {
    return ListTile(
      leading: Icon(icon, color: color ?? primaryTeal),
      title: Text(label),
      trailing: _selectedFilter == value ? const Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'positive': return positiveColor.withOpacity(0.2);
      case 'negative': return negativeColor.withOpacity(0.2);
      case 'neutral': return neutralColor.withOpacity(0.2);
      default: return Colors.grey.withOpacity(0.2);
    }
  }

  Color _getScoreColor(double score) {
    if (score > 0.3) return positiveColor;
    if (score < -0.3) return negativeColor;
    return neutralColor;
  }

  String _getScoreEmoji(double score) {
    if (score > 0.7) return '😍';
    if (score > 0.3) return '😊';
    if (score > -0.3) return '😐';
    if (score > -0.7) return '😞';
    return '😡';
  }

  String _getScoreLabel(double score) {
    if (score > 0.7) return 'Very Positive';
    if (score > 0.3) return 'Positive';
    if (score > -0.3) return 'Neutral';
    if (score > -0.7) return 'Negative';
    return 'Very Negative';
  }
}