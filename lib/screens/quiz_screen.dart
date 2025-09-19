import 'package:flutter/material.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/popup.dart';
import '../widgets/answer_box.dart';

class QuizItem {
  final String word;
  final String imagePath;
  final String translation;
  final List<String> letters; // show these letters in container

  QuizItem({
    required this.word,
    required this.imagePath,
    required this.translation,
    required this.letters,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // ✅ All quizzes in one list
  final List<QuizItem> quizzes = [
    QuizItem(
      word: "BAG",
      imagePath: "assets/images/bag.png",
      translation: "බෑගය",
      letters: ["G", "A", "B"],
    ),
    QuizItem(
      word: "PENCIL",
      imagePath: "assets/images/pencil.png",
      translation: "පැන්සල",
      letters: ["C", "E", "L", "N", "I", "P"],
    ),
    QuizItem(
      word: "TEACHER",
      imagePath: "assets/images/teacher.png",
      translation: "ගුරුතුමිය",
      letters: ["T", "E", "A", "C", "H", "R","E"],
    ),
  ];

  int currentIndex = 0; // ✅ Track current quiz index
  List<String> answer = [];
  String? wrongLetter;
  Set<String> usedLetters = {};

  QuizItem get currentQuiz => quizzes[currentIndex];

  void onLetterTap(String letter) {
    int nextIndex = answer.length;

    if (letter == currentQuiz.word[nextIndex]) {
      setState(() {
        answer.add(letter);
        usedLetters.add(letter);
        wrongLetter = null;
      });

      if (answer.join() == currentQuiz.word) {
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
    } else {
      setState(() {
        wrongLetter = letter;
      });
    }
  }

  void goToNextQuiz() {
    if (currentIndex < quizzes.length - 1) {
      setState(() {
        currentIndex++;
        answer = [];
        wrongLetter = null;
        usedLetters.clear();
      });
    } else {
      // ✅ Finished all
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All quizzes completed 🎉")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),

            // ✅ Progress text
            Align(
              alignment: Alignment.center,
              child: Text(
                "${currentIndex + 1} of ${quizzes.length}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // ✅ Image container
            Container(
              width: screenWidth * 0.65,
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
              ),
              child: Center(
                child: Image.asset(
                  currentQuiz.imagePath,
                  width: screenWidth * 0.42,
                  height: screenWidth * 0.42,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Text(
              "Build the word for this picture",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 8),
            AnswerBox(answer: answer),

            const SizedBox(height: 36),

            // ✅ Quiz letters
            Container(
              width: 332,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
                color: Colors.white,
              ),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 12, // space between rows
                  children:
                      currentQuiz.letters
                          .map(
                            (letter) => LetterButton(
                              letter: letter,
                              isWrong: wrongLetter == letter,
                              isUsed: usedLetters.contains(letter),
                              onTap: () => onLetterTap(letter),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
