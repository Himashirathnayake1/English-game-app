import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/screens/results_page.dart';
import 'package:learning_app/widgets/correct_popup.dart';
import 'package:learning_app/widgets/wrong_popup.dart';
class QuizItem {
  final String word;
  final String imagePath;
  final String translation;
  final List<String> options;
  final String correctAnswer;

  QuizItem({
    required this.word,
    required this.imagePath,
    required this.translation,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizResult {
  final String word;
  final bool isCorrect;

  QuizResult({required this.word, required this.isCorrect});
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizItem> quizzes = [
    QuizItem(
      word: "Teacher",
      imagePath: "assets/images/Teacher.svg",
      translation: "ගුරුවරයා",
      options: ["Student", "Teacher", "Black Board"],
      correctAnswer: "Teacher",
    ),
    QuizItem(
      word: "Cat",
      imagePath: "assets/images/Cat.svg",
      translation: "පූසා",
      options: ["Dog", "Cat", "Elephant"],
      correctAnswer: "Cat",
    ),
    QuizItem(
      word: "Dog",
      imagePath: "assets/images/Dog.svg",
      translation: "බල්ලා",
      options: ["Cat", "Dog", "Rabbit"],
      correctAnswer: "Dog",
    ),
    QuizItem(
      word: "BlackBoard",
      imagePath: "assets/images/Blackboard.svg",
      translation: "කළු ලෑල්ල",
      options: ["Pencil", "Eraser", "BlackBoard"],
      correctAnswer: "BlackBoard",
    ),
    QuizItem(
      word: "Elephant",
      imagePath: "assets/images/Elephant.svg",
      translation: "අලියා",
      options: ["Elephant", "Parrot", "Rabbit"],
      correctAnswer: "Elephant",
    ),
    QuizItem(
      word: "Eraser",
      imagePath: "assets/images/Eraser.svg",
      translation: "මකනය",
      options: ["Pencil", "Eraser", "Student"],
      correctAnswer: "Eraser",
    ),
    QuizItem(
      word: "Parrot",
      imagePath: "assets/images/parrot.svg",
      translation: "ගිරවා",
      options: ["Cat", "Dog", "Parrot"],
      correctAnswer: "Parrot",
    ),
    QuizItem(
      word: "Pencil",
      imagePath: "assets/images/Pencil.svg",
      translation: "පැන්සල",
      options: ["Pencil", "Eraser", "BlackBoard"],
      correctAnswer: "Pencil",
    ),
    QuizItem(
      word: "Rabbit",
      imagePath: "assets/images/Rabbit.svg",
      translation: "හාවා",
      options: ["Dog", "Cat", "Rabbit"],
      correctAnswer: "Rabbit",
    ),
    QuizItem(
      word: "Student",
      imagePath: "assets/images/Student.svg",
      translation: "ශිෂ්‍යයා",
      options: ["Teacher", "Student", "Pencil"],
      correctAnswer: "Student",
    ),
  ];

  int currentIndex = 0;
  bool hasAnswered = false;
  List<QuizResult> results = [];

  QuizItem get currentQuiz => quizzes[currentIndex];

  void onAnswerTap(String selectedAnswer) {
    if (hasAnswered) return;

    setState(() {
      hasAnswered = true;
    });

    bool isCorrect = selectedAnswer == currentQuiz.correctAnswer;
    results.add(QuizResult(word: currentQuiz.word, isCorrect: isCorrect));

    if (isCorrect) {
      _showCorrectPopup();
    } else {
      _showWrongPopup(selectedAnswer);
    }
  }

  void _showCorrectPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CorrectPopup(
          word: currentQuiz.word,
          translation: currentQuiz.translation,
          onNext: () {
            Navigator.pop(context);
            goToNextQuiz();
          },
        );
      },
    );
  }

  void _showWrongPopup(String wrongAnswer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
         return WrongPopup(
          word: currentQuiz.word,
          translation: currentQuiz.translation,
          onNext: () {
            Navigator.pop(context);
            goToNextQuiz();
          },
        );
      },
    );
  }

  void goToNextQuiz() {
    if (currentIndex < quizzes.length - 1) {
      setState(() {
        currentIndex++;
        hasAnswered = false;
      });
    } else {
      // Finished all quizzes → prepare data and go to results screen
      List<Map<String, String>> masteredWords = [];
      List<Map<String, String>> toReviewWords = [];

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        final wordData = {
          'word': result.word,
          'translation': quizzes[i].translation,
        };

        if (result.isCorrect) {
          masteredWords.add(wordData);
        } else {
          toReviewWords.add(wordData);
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResultsPage(
                masteredWords: masteredWords,
                toReviewWords: toReviewWords,
                onReviewAgain: () {
                  // Restart the quiz
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => QuizScreen()),
                  );
                },
                onHome: () {
                  // Navigate back to home screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with close button and progress
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / quizzes.length,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Question
            Text(
              "What does the picture mean?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),

            const SizedBox(height: 40),

            // Image container
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.3,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child:
                        currentQuiz.imagePath.endsWith('.svg')
                            ? SvgPicture.asset(
                              currentQuiz.imagePath,
                              fit: BoxFit.contain,
                            )
                            : Image.asset(
                              currentQuiz.imagePath,
                              fit: BoxFit.contain,
                            ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentQuiz.translation,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Answer options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(currentQuiz.options.length, (index) {
                    final option = currentQuiz.options[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => onAnswerTap(option),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E3A59),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
