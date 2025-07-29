import 'package:cloud_firestore/cloud_firestore.dart';

class MoodPost {
  final String id;
  final String content;
  final DateTime timestamp;
  final String? aiResponse;
  final bool isAnonymous;

  MoodPost({
    required this.id,
    required this.content,
    required this.timestamp,
    this.aiResponse,
    this.isAnonymous = true,
  });

  factory MoodPost.fromMap(Map<String, dynamic> map, String id) {
    return MoodPost(
      id: id,
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      aiResponse: map['aiResponse'],
      isAnonymous: map['isAnonymous'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'aiResponse': aiResponse,
      'isAnonymous': isAnonymous,
    };
  }
}