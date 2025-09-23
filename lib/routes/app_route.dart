import 'package:flutter/material.dart';
import 'package:learning_app/screens/flash_card_screen.dart';
import 'package:learning_app/screens/home_page.dart';
import 'package:learning_app/screens/listening_screen.dart';
import 'package:learning_app/screens/quiz_screen.dart';
import '../screens/letter_sufftle_screen.dart';

class AppRoutes {
  static const String flashCard = '/flash-card';
  static const String letterShuffle = '/letter-shuffle';
  static const String practiceVocabulary = '/practice-vocabulary';
  static const String listeningScreen = '/listening-quiz';
  static const String quiz = '/quiz';

  static Map<String, WidgetBuilder> routes = {
    flashCard: (context) => FlashCardScreen(),
    letterShuffle: (context) => const LetterShuffleScreen(),
    practiceVocabulary: (context) => PracticeVocabularyPage(),
    listeningScreen: (context) => ListeningQuizScreen(),
    quiz: (context) => const QuizScreen(),
  };
}
