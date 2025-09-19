import 'package:flutter/material.dart';
import '../screens/quiz_screen.dart';

class AppRoutes {
  static const String quiz = '/quiz';

  static Map<String, WidgetBuilder> routes = {
    quiz: (context) => const QuizScreen(),
  };
}
