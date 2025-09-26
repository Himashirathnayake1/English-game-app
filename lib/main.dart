import 'package:flutter/material.dart';
import 'package:learning_app/routes/app_route.dart';
import 'package:learning_app/screens/single_word_game/all_words_completed_screen.dart';
import 'package:learning_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.wordList, // Changed to start with word list
    );
  }
}
