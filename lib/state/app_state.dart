import 'package:flutter/material.dart';
import '../models/question.dart';
import 'package:audioplayers/audioplayers.dart';

class AppState extends ChangeNotifier {
  final Set<String> _readSections = {};
  int _quizScore = 0;
  int _finalRating = 0;
  List<Question> _currentQuiz = [];
  final bool _isPlayingCheer = false;
  final bool _isPlayingApplause = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Set<String> get readSections => _readSections;
  int get quizScore => _quizScore;
  int get finalRating => _finalRating;
  List<Question> get currentQuiz => _currentQuiz;
  bool get isPlayingCheer => _isPlayingCheer;
  bool get isPlayingApplause => _isPlayingApplause;

  void markSectionRead(String sectionId) {
    if (!_readSections.contains(sectionId)) {
      _readSections.add(sectionId);
      notifyListeners();
    }
  }

  void startQuiz(List<Question> allQuestions) {
    _quizScore = 0;
    _currentQuiz = (List.of(allQuestions)..shuffle()).take(5).toList();
    // Shuffle options for each question
    for (var q in _currentQuiz) {
      q.options.shuffle();
    }
    notifyListeners();
  }

  void incrementScore() {
    _quizScore++;
    notifyListeners();
  }

  void setRating(int rating) {
    _finalRating = rating;
    notifyListeners();
  }

  void playClickSound() {
    _audioPlayer.play(AssetSource('sounds/click.wav'));
  }

  void playCorrectSound() {
    _audioPlayer.play(AssetSource('sounds/correct.wav'));
  }

  void playWrongSound() {
    _audioPlayer.play(AssetSource('sounds/wrong.wav'));
  }

  void playWinSound() {
    _audioPlayer.play(AssetSource('sounds/win.wav'));
  }
}
