import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../data/questions_data.dart';
import 'quiz_screen.dart';

class Landmark {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Landmark(this.id, this.name, this.description, this.imageUrl);
}

final List<Landmark> landmarks = [
  Landmark(
    'petra',
    'البتراء',
    'المدينة الوردية المحفورة في الصخر، من عجائب الدنيا السبع.',
    'assets/images/petra.jpg', // No petra image in the new batch, reverting to placeholder or old.
  ),
  Landmark(
    'deadsea',
    'البحر الميت',
    'أخفض بقعة على وجه الأرض، ويشتهر بمياهه عالية الملوحة.',
    'assets/images/deadsea_float.png',
  ),
  Landmark(
    'wadi_rum',
    'وادي رم',
    'يُعرف بوادي القمر، يتميز برماله الحمراء وجباله الشاهقة.',
    'assets/images/wadi_rum_real.jpg',
  ),
  Landmark(
    'jerash',
    'جرش',
    'أكبر مدينة رومانية محفوظة في العالم، تشتهر بأعمدتها ومسارحها.',
    'assets/images/jerash_real.png',
  ),
  Landmark(
    'aqaba',
    'العقبة',
    'المنفذ البحري الوحيد للأردن المطل على البحر الأحمر، وتشتهر بالشعاب المرجانية.',
    'assets/images/aqaba_sea.png',
  ),
];

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المعالم السياحية')),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: landmarks.length + 1, // +1 for the bottom button
            itemBuilder: (context, index) {
              if (index == landmarks.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.seaBlue,
                    ),
                    onPressed: state.readSections.length == landmarks.length
                        ? () {
                            state.playClickSound();
                            state.startQuiz(allQuestions);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuizScreen(),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      state.readSections.length == landmarks.length
                          ? 'ابدأ الاختبار الآن'
                          : 'اقرأ جميع المعالم لبدء الاختبار (${state.readSections.length}/${landmarks.length})',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              final landmark = landmarks[index];
              final isRead = state.readSections.contains(landmark.id);

              return Card(
                color: isRead ? Colors.white : AppTheme.background,
                child: ExpansionTile(
                  leading: Icon(
                    isRead ? Icons.check_circle : Icons.circle_outlined,
                    color: isRead ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    landmark.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isRead ? AppTheme.seaBlue : AppTheme.textDark,
                    ),
                  ),
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      state.playClickSound();
                      state.markSectionRead(landmark.id);
                    }
                  },
                  children: [
                    Image.asset(
                      landmark.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        landmark.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
