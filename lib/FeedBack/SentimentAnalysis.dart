import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/sentiment_service.dart'; // Add this import

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  // Create the sentiment analyzer
  final BetterSentimentAnalyzer _sentimentAnalyzer = BetterSentimentAnalyzer();

  // For live preview
  String _currentEmoji = '😐';
  String _currentSentiment = 'neutral';

  @override
  void dispose() {
    _usernameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  // ❌ REMOVE your old simpleSentiment function completely

  // ✅ This is your NEW sentiment function
  void updateLivePreview(String text) {
    if (text.isEmpty) {
      setState(() {
        _currentEmoji = '😐';
        _currentSentiment = 'neutral';
      });
      return;
    }

    final result = _sentimentAnalyzer.analyze(text);
    setState(() {
      _currentEmoji = result.emoji;
      _currentSentiment = result.sentiment;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Teal and Smoke White color palette (same as yours)
    const Color primaryTeal = Color(0xFF008080);
    const Color lightTeal = Color(0xFF20B2AA);
    const Color smokeWhite = Color(0xFFF5F5F5);
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color darkTeal = Color(0xFF004D4D);
    const Color textLight = Color(0xFF666666);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: const Text(
          "Feedback",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: pureWhite,
        elevation: 0,
        foregroundColor: darkTeal,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: borderColor,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and description (same as yours)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryTeal, lightTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: pureWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.feedback_outlined,
                        color: pureWhite,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "We Value Your Feedback",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: pureWhite,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your suggestions help us improve and provide better experience",
                      style: TextStyle(
                        fontSize: 14,
                        color: pureWhite,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Feedback Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Share Your Thoughts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkTeal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Your feedback will help us serve you better",
                      style: TextStyle(
                        fontSize: 13,
                        color: textLight,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Username field (same as yours)
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hintText: "Enter your username",
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: primaryTeal,
                          size: 22,
                        ),
                        labelStyle: const TextStyle(
                          color: textLight,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryTeal, width: 2),
                        ),
                        filled: true,
                        fillColor: smokeWhite,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Feedback field with LIVE SENTIMENT PREVIEW (NEW!)
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 6,
                      onChanged: (value) => updateLivePreview(value), // ← ADD THIS
                      decoration: InputDecoration(
                        labelText: "Your Feedback",
                        hintText: "Tell us what you think...",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Icon(
                            Icons.message_outlined,
                            color: primaryTeal,
                            size: 22,
                          ),
                        ),
                        suffixIcon: _feedbackController.text.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _currentEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        )
                            : null,
                        labelStyle: const TextStyle(
                          color: textLight,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryTeal, width: 2),
                        ),
                        filled: true,
                        fillColor: smokeWhite,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    // Live sentiment preview card (NEW!)
                    if (_feedbackController.text.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getSentimentColor(_currentSentiment).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getSentimentColor(_currentSentiment).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(_currentEmoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getSentimentText(_currentSentiment),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _getSentimentColor(_currentSentiment),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getSentimentMessage(_currentSentiment),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Character count hint (same as yours)
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _feedbackController,
                      builder: (context, value, child) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${value.text.length} characters",
                            style: TextStyle(
                              fontSize: 12,
                              color: value.text.length > 500 ? Colors.red : textLight,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Submit button (UPDATED with better feedback)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            String username = _usernameController.text.trim();
                            String feedbackText = _feedbackController.text.trim();

                            if (username.isEmpty || feedbackText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Please fill all fields"),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                              return;
                            }

                            // ✅ Use NEW improved sentiment analysis
                            SentimentResult result = _sentimentAnalyzer.analyze(feedbackText);

                            await FirebaseFirestore.instance
                                .collection('feedbacks')
                                .add({
                              'username': username,
                              'feedback': feedbackText,
                              'sentiment': result.sentiment,
                              'sentimentScore': result.score,  // NEW: Store score too!
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            // Show better success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Text(result.emoji, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _sentimentAnalyzer.getFeedbackMessage(
                                            result.sentiment,
                                            result.score
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: _getSnackbarColor(result.sentiment),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );

                            _usernameController.clear();
                            _feedbackController.clear();
                            setState(() {
                              _currentEmoji = '😐';
                              _currentSentiment = 'neutral';
                            });

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Error submitting feedback"),
                                backgroundColor: Colors.red.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryTeal,
                          foregroundColor: pureWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Submit Feedback",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.send, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Additional info card (same as yours)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: lightTeal.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lightTeal.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: primaryTeal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Your feedback helps us improve. We analyze sentiment to better understand your needs.",
                        style: TextStyle(
                          fontSize: 12,
                          color: darkTeal,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for UI
  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'positive': return Colors.green;
      case 'negative': return Colors.red;
      default: return Colors.orange;
    }
  }

  String _getSentimentText(String sentiment) {
    switch (sentiment) {
      case 'positive': return '😊 Positive feedback detected!';
      case 'negative': return '😞 Negative feedback detected';
      default: return '😐 Neutral feedback';
    }
  }

  String _getSentimentMessage(String sentiment) {
    switch (sentiment) {
      case 'positive': return 'Thanks for your kind words! We appreciate you.';
      case 'negative': return 'Sorry you feel this way. We will improve!';
      default: return 'Thanks for sharing your thoughts with us.';
    }
  }

  Color _getSnackbarColor(String sentiment) {
    switch (sentiment) {
      case 'positive': return Colors.green.shade600;
      case 'negative': return Colors.red.shade600;
      default: return const Color(0xFF008080);
    }
  }
}