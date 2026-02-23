import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;

  void _submitAnswer(String selectedAnswer, Question currentQuestion) async {
    final state = Provider.of<AppState>(context, listen: false);

    if (selectedAnswer == currentQuestion.correctAnswer) {
      state.incrementScore();
      state.playCorrectSound();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'إجابة صحيحة!',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      state.playWrongSound();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'إجابة خاطئة!',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_currentQuestionIndex < state.currentQuiz.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        if (state.currentQuiz.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = state.currentQuiz[_currentQuestionIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'اختبار المعلومات (${_currentQuestionIndex + 1}/${state.currentQuiz.length})',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ...question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.rockyPink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        state.playClickSound();
                        _submitAnswer(option, question);
                      },
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
