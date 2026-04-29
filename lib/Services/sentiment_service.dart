// BETTER sentiment analysis - Easy to understand!
import 'package:flutter/material.dart';

class SentimentResult {
  final String sentiment;  // 'positive', 'negative', 'neutral'
  final double score;      // -1.0 to +1.0 (how strong the feeling is)
  final String emoji;

  SentimentResult({
    required this.sentiment,
    required this.score,
    required this.emoji,
  });
}

class BetterSentimentAnalyzer {
  // Happy words 😊
  final List<String> positiveWords = [
    'good', 'great', 'excellent', 'amazing', 'nice', 'love',
    'perfect', 'awesome', 'helpful', 'fantastic', 'happy',
    'best', 'beautiful', 'wonderful', 'brilliant', 'superb',
    'outstanding', 'impressive', 'easy', 'fast', 'smooth'
  ];

  // Sad words 😞
  final List<String> negativeWords = [
    'bad', 'poor', 'terrible', 'worst', 'hate', 'awful',
    'slow', 'useless', 'problem', 'issue', 'disappointed',
    'horrible', 'annoying', 'frustrating', 'waste', 'error',
    'crash', 'bug', 'difficult', 'hard', 'confusing'
  ];

  // Words that REVERSE meaning (like "not good" means bad)
  final List<String> negationWords = [
    'not', 'no', 'never', 'isn\'t', 'aren\'t', 'wasn\'t', 'weren\'t',
    'don\'t', 'doesn\'t', 'didn\'t', 'can\'t', 'won\'t', 'wouldn\'t',
    'couldn\'t', 'shouldn\'t'
  ];

  // Words that make feeling STRONGER (like "very good" is super positive)
  final List<String> intensifiers = [
    'very', 'extremely', 'really', 'absolutely', 'completely',
    'totally', 'so', 'too', 'incredibly', 'super'
  ];

  SentimentResult analyze(String text) {
    String lowerText = text.toLowerCase();

    // Step 1: Check for negation words
    bool isNegated = false;
    for (String neg in negationWords) {
      if (lowerText.contains(neg)) {
        isNegated = true;
        break;
      }
    }

    // Step 2: Count positive words
    int positiveCount = 0;
    for (String word in positiveWords) {
      if (lowerText.contains(word)) {
        positiveCount++;
      }
    }

    // Step 3: Count negative words
    int negativeCount = 0;
    for (String word in negativeWords) {
      if (lowerText.contains(word)) {
        negativeCount++;
      }
    }

    // Step 4: Check for intensifiers (makes sentiment stronger)
    bool hasIntensifier = false;
    for (String intense in intensifiers) {
      if (lowerText.contains(intense)) {
        hasIntensifier = true;
        break;
      }
    }

    // Step 5: Calculate score
    double score = 0.0;

    if (positiveCount > 0 || negativeCount > 0) {
      // Raw score based on word counts
      int total = positiveCount + negativeCount;
      if (total > 0) {
        score = (positiveCount - negativeCount) / total;
      }

      // Apply negation (flips the meaning)
      if (isNegated) {
        score = -score;
      }

      // Apply intensifier (makes it stronger)
      if (hasIntensifier && score != 0) {
        score = score * 1.5;
      }

      // Clamp score between -1 and 1
      score = score.clamp(-1.0, 1.0);
    }

    // Step 6: Determine sentiment and emoji
    String sentiment;
    String emoji;

    if (score > 0.3) {
      sentiment = 'positive';
      if (score > 0.7) {
        emoji = '😍';  // Super happy
      } else {
        emoji = '😊';  // Happy
      }
    } else if (score < -0.3) {
      sentiment = 'negative';
      if (score < -0.7) {
        emoji = '😡';  // Super angry
      } else {
        emoji = '😞';  // Sad
      }
    } else {
      sentiment = 'neutral';
      emoji = '😐';    // Neutral
    }

    // Special case: mixed feelings (both positive and negative words)
    if (positiveCount > 0 && negativeCount > 0 && score.abs() < 0.4) {
      sentiment = 'neutral';  // Keep as neutral but with mixed emoji
      emoji = '🤔';           // Thinking face for mixed feelings
    }

    return SentimentResult(
      sentiment: sentiment,
      score: score,
      emoji: emoji,
    );
  }

  // Helper: Get color for UI
  Color getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'positive': return Colors.green;
      case 'negative': return Colors.red;
      default: return Colors.orange;
    }
  }

  // Helper: Get friendly message
  String getFeedbackMessage(String sentiment, double score) {
    switch (sentiment) {
      case 'positive':
        if (score > 0.7) return 'Amazing! Thank you so much! 😍';
        return 'Thanks for your positive feedback! 😊';
      case 'negative':
        if (score < -0.7) return 'We\'re very sorry! Fixing this now! 😡';
        return 'Sorry about that. We\'ll improve! 😞';
      default:
        return 'Thanks for sharing your thoughts! 😐';
    }
  }
}