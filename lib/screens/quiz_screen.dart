import 'package:flutter/material.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/popup.dart';
import '../widgets/answer_box.dart';

class QuizItem {
  final String word;
  final String imagePath;
  final String translation;
  final List<String> letters; // show these letters in quiz container

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
      letters: ["I", "R","H", "A", "C"],
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
      letters: ["Y","T", "O",  "S"],
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
      letters: ["T", "E", "N", "D","T", "S", "U"],
    ),
  ];

  int currentIndex = 0; // Track current quiz index
  late List<String?> answerSlots; // slots for each letter in the word
  String? wrongLetter;
  Set<String> usedLetters = {}; // track used letters with index e.g. E0, E6

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
  }

  void onLetterTap(String letter, int index) {
  final word = currentQuiz.word.toUpperCase();

  // find the first empty slot (sequence order)
  int nextIndex = answerSlots.indexWhere((e) => e == null);

  if (nextIndex == -1) return; // if already full return
//If letter matches the expected one at nextIndex → fill slot, mark button used, clear wrong flag.
  if (word[nextIndex] == letter) {
    setState(() {
      answerSlots[nextIndex] = letter;
      usedLetters.add(letter + index.toString()); 
      wrongLetter = null;
    });

    // check if completed
    if (answerSlots.join() == word) {
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
    //  wrong letter
    setState(() {
      wrongLetter = letter;
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
      // Finished all
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All quizzes completed 🎉")),
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

            // Progress text
            Align(
              alignment: Alignment.center,
              child: Text(
                "${currentIndex + 1} of ${quizzes.length}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            //  Image container
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
            AnswerBox(answer: answerSlots), //  show slots not list

            const SizedBox(height: 36),

            //  Quiz letters
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
