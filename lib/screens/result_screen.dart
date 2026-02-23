import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Play win sound when entering the screen if score is good (e.g. >= 3)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<AppState>(context, listen: false);
      if (state.quizScore >= 3) {
        state.playWinSound();
      }
    });
  }

  void _submitRating(int rating, AppState state) async {
    state.playClickSound();
    state.setRating(rating);
    if (rating >= 4) {
      state.playCorrectSound();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'شكراً لتقييمك الرائع!',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppTheme.seaBlue,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('النتيجة النهائية'),
            automaticallyImplyLeading: false, // Prevent going back to quiz
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'لقد أتممت الاختبار!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.seaBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'نتيجتك هي:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${state.quizScore} / ${state.currentQuiz.length}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: state.quizScore >= 3 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'ما تقييمك للتطبيق؟',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return IconButton(
                        icon: Icon(
                          starValue <= state.finalRating
                              ? Icons.star
                              : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                        onPressed: () => _submitRating(starValue, state),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      backgroundColor: AppTheme.seaBlue,
                    ),
                    onPressed: () {
                      state.playClickSound();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
