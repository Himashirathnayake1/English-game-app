import 'package:flutter/material.dart';
import 'package:learning_app/screens/resuls_screen.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/popup.dart';
import '../widgets/answer_box.dart';

class QuizItem {
  final String word;
  final String imagePath;
  final String translation;
  final List<String> letters;

  QuizItem({
    required this.word,
    required this.imagePath,
    required this.translation,
    required this.letters,
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
  //  All quizzes in one list
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
      letters: ["R", "E", "A", "H", "C", "T", "E"],
    ),
    QuizItem(
      word: "CHAIR",
      imagePath: "assets/images/chair.png",
      translation: "පුටුව",
      letters: ["I", "R", "H", "A", "C"],
    ),
    QuizItem(
      word: "TABLE",
      imagePath: "assets/images/table.png",
      translation: "මේසය",
      letters: ["B", "A", "T", "L", "E"],
    ),
    QuizItem(
      word: "CupBoard",
      imagePath: "assets/images/cupboard.png",
      translation: "අල්මාරිය",
      letters: ["A", "U", "P", "O", "D", "C", "R", "B"],
    ),
    QuizItem(
      word: "TOYS",
      imagePath: "assets/images/toys.jpg",
      translation: "සෙල්ලම් බඩු",
      letters: ["Y", "T", "O", "S"],
    ),
    QuizItem(
      word: "HOUSE",
      imagePath: "assets/images/house.jpg",
      translation: "ගෙදර",
      letters: ["E", "U", "H", "O", "S"],
    ),
    QuizItem(
      word: "CAR",
      imagePath: "assets/images/car.avif",
      translation: "කාර්",
      letters: ["R", "A", "C"],
    ),
    QuizItem(
      word: "STUDENT",
      imagePath: "assets/images/student.webp",
      translation: "ශිෂ්‍යයා",
      letters: ["T", "E", "N", "D", "T", "S", "U"],
    ),
  ];

  int currentIndex = 0;
  late List<String?> answerSlots;
  String? wrongLetter;
  Set<String> usedLetters = {};

  // results tracking
  List<QuizResult> results = [];
  bool attemptedWrong = false;

  QuizItem get currentQuiz => quizzes[currentIndex];

  @override
  void initState() {
    super.initState();
    resetQuiz();
  }

  void resetQuiz() {
    answerSlots = List<String?>.filled(currentQuiz.word.length, null);
    wrongLetter = null;
    usedLetters.clear();
    attemptedWrong = false; // reset wrong attempts for new word
  }

  void onLetterTap(String letter, int index) {
    final word = currentQuiz.word.toUpperCase();
    int nextIndex = answerSlots.indexWhere((e) => e == null);

    if (nextIndex == -1) return;

    if (word[nextIndex] == letter) {
      setState(() {
        answerSlots[nextIndex] = letter;
        usedLetters.add(letter + index.toString());
        wrongLetter = null;
      });

      // ✅ word completed
      if (answerSlots.join() == word) {
        results.add(
          QuizResult(word: currentQuiz.word, isCorrect: !attemptedWrong),
        );

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
      //  wrong
      setState(() {
        wrongLetter = letter;
        attemptedWrong = true;
      });
    }
  }

  void goToNextQuiz() {
    if (currentIndex < quizzes.length - 1) {
      setState(() {
        currentIndex++;
        resetQuiz();
      });
    } else {
      // Finished all quizzes → go to result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(results: results),
        ),
      );
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
            Align(
              alignment: Alignment.center,
              child: Text(
                "${currentIndex + 1} of ${quizzes.length}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
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
            AnswerBox(answer: answerSlots),
            const SizedBox(height: 36),
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
                  runSpacing: 12,
                  children: List.generate(currentQuiz.letters.length, (i) {
                    final letter = currentQuiz.letters[i];
                    return LetterButton(
                      letter: letter,
                      isWrong: wrongLetter == letter,
                      isUsed: usedLetters.contains(letter + i.toString()),
                      onTap: () => onLetterTap(letter, i),
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
