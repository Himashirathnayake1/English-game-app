import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/screens/results_page.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/correct_popup.dart';
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

class LetterShuffleScreen extends StatefulWidget {
  const LetterShuffleScreen({super.key});

  @override
  State<LetterShuffleScreen> createState() => _LetterShuffleScreenState();
}

class _LetterShuffleScreenState extends State<LetterShuffleScreen> {
  //  All quizzes in one list
  final List<QuizItem> quizzes = [
    QuizItem(
      word: "Cat",
      imagePath: "assets/images/Cat.svg",
      translation: "පූසා",
      letters: ["T", "A", "C"],
    ),
    QuizItem(
      word: "Dog",
      imagePath: "assets/images/Dog.svg",
      translation: "බල්ලා",
      letters: ["G", "O", "D"],
    ),
    QuizItem(
      word: "BlackBoard",
      imagePath: "assets/images/Blackboard.svg",
      translation: "කළු ලෑල්ල",
      letters: ["A", "R", "B", "O", "D", "B", "L", "C", "K", "A"],
    ),
    QuizItem(
      word: "Elephant",
      imagePath: "assets/images/Elephant.svg",
      translation: "අලියා",
      letters: ["H", "E", "N", "T", "P", "A", "L", "E"],
    ),
    QuizItem(
      word: "Eraser",
      imagePath: "assets/images/Eraser.svg",
      translation: "මකනය",
      letters: ["R","S", "A", "R", "E", "E"],
    ),
    QuizItem(
      word: "Parrot",
      imagePath: "assets/images/parrot.svg",
      translation: "ගිරවා",
      letters: ["R", "O", "T", "P", "A", "R"],
    ),
    QuizItem(
      word: "Pencil",
      imagePath: "assets/images/Pencil.svg",
      translation: "පැන්සල",
      letters: ["C", "E", "L", "N", "I", "P"],
    ),
    QuizItem(
      word: "Rabbit",
      imagePath: "assets/images/Rabbit.svg",
      translation: "ගෙදර",
      letters: ["A", "R", "I", "B", "B",  "T"],
    ),
    QuizItem(
      word: "Student",
      imagePath: "assets/images/Student.svg",
      translation: "ශිෂ්‍යයා",
      letters: ["D", "T", "U", "S", "N", "E", "T"],
    ),
    QuizItem(
      word: "Teacher",
      imagePath: "assets/images/Teacher.svg",
      translation: "ගුරුවරයා",
      letters: ["R", "A", "C", "H", "E", "T", "E"],
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

      //  word completed
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
                  // Restart the letter shuffle quiz with only the words that need review
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LetterShuffleScreen()),
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
                child: SvgPicture.asset(
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
