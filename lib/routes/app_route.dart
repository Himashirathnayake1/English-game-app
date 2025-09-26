import 'package:flutter/material.dart';
import 'package:learning_app/screens/practice_vocabulary/flash_card_screen.dart';
import 'package:learning_app/screens/practice_vocabulary/home_page.dart';
import 'package:learning_app/screens/practice_vocabulary/listening_screen.dart';
import 'package:learning_app/screens/practice_vocabulary/quiz_screen.dart';
import 'package:learning_app/screens/single_word_game/all_words_completed_screen.dart';
import 'package:learning_app/screens/single_word_game/word_list_screen.dart';
import '../screens/practice_vocabulary/letter_sufftle_screen.dart';

class AppRoutes {
  static const String flashCard = '/flash-card';
  static const String letterShuffle = '/letter-shuffle';
  static const String practiceVocabulary = '/practice-vocabulary';
  static const String listeningScreen = '/listening-quiz';
  static const String quiz = '/quiz';
  static const String wordList = '/word-list';
  static const String complete = '/complete';

  static Map<String, WidgetBuilder> routes = {
    flashCard: (context) => FlashCardScreen(),
    letterShuffle: (context) => const LetterShuffleScreen(),
    practiceVocabulary: (context) => PracticeVocabularyPage(),
    listeningScreen: (context) => ListeningQuizScreen(),
    quiz: (context) => const QuizScreen(),
    wordList: (context) => const WordListScreen(),
    complete: (context) => const AllWordsCompletedScreen(totalCoins: 10, completionTime: "1:30")
  };
}
