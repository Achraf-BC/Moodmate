import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openai_service.dart';
import '../services/mood_service.dart';

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  final TextEditingController _moodController = TextEditingController();
  String? _aiResponse;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _moodController.dispose();
    super.dispose();
  }

  Future<void> _getAIResponse() async {
    if (_moodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please share how you\'re feeling')),
      );
      return;
    }

    final openAIService = context.read<OpenAIService>();
    final response = await openAIService.getMoodResponse(_moodController.text.trim());
    
    if (response != null) {
      setState(() {
        _aiResponse = response;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get AI response. Please try again.')),
      );
    }
  }

  Future<void> _shareToVibeWall() async {
    if (_moodController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<MoodService>().addPost(
        _moodController.text.trim(),
        _aiResponse,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shared to Vibe Wall!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share. Please try again.')),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mood Check-In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your thoughts and get supportive feedback',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Text Input
            TextField(
              controller: _moodController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'I\'m feeling...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Get AI Response Button
            Consumer<OpenAIService>(
              builder: (context, openAIService, child) {
                return ElevatedButton.icon(
                  onPressed: openAIService.isLoading ? null : _getAIResponse,
                  icon: openAIService.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.psychology),
                  label: Text(
                    openAIService.isLoading ? 'Getting Response...' : 'Get AI Response',
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // AI Response
            if (_aiResponse != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.purple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'AI Response',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_aiResponse!),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Share to Vibe Wall Button
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _shareToVibeWall,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share),
                label: Text(
                  _isSubmitting ? 'Sharing...' : 'Share to Vibe Wall',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}