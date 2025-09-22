import 'package:flutter/material.dart';
import 'package:learning_app/screens/flash_card_screen.dart';
import '../screens/letter_sufftle_screen.dart';

class AppRoutes {
  static const String quiz = '/quiz';
  static const String flashCard = '/flash-card';

  static Map<String, WidgetBuilder> routes = {
    quiz: (context) => const QuizScreen(),
    flashCard: (context) => FlashCardScreen(),
  };
}
