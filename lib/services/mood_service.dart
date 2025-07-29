import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_post.dart';

class MoodService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MoodPost> _posts = [];
  bool _isLoading = false;

  List<MoodPost> get posts => _posts;
  bool get isLoading => _isLoading;

  // Get vibe wall posts
  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('mood_posts')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      _posts = snapshot.docs
          .map((doc) => MoodPost.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new mood post
  Future<void> addPost(String content, String? aiResponse) async {
    try {
      final post = MoodPost(
        id: '',
        content: content,
        timestamp: DateTime.now(),
        aiResponse: aiResponse,
        isAnonymous: true,
      );

      await _firestore.collection('mood_posts').add(post.toMap());
      
      // Refresh posts
      await fetchPosts();
    } catch (e) {
      debugPrint('Error adding post: $e');
      rethrow;
    }
  }

  // Stream posts for real-time updates
  Stream<List<MoodPost>> get postsStream {
    return _firestore
        .collection('mood_posts')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodPost.fromMap(doc.data(), doc.id))
            .toList());
  }
}