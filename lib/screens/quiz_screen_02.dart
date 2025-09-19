import 'package:flutter/material.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/popup.dart';
import '../widgets/answer_box.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final String correctWord = "BAG";
  List<String> answer = [];
  String? wrongLetter;
  Set<String> usedLetters = {};

  void onLetterTap(String letter) {
    int nextIndex = answer.length;

    // Check if correct letter in sequence
    if (letter == correctWord[nextIndex]) {
      setState(() {
        answer.add(letter);
        usedLetters.add(letter); //mark as used
        wrongLetter = null; // reset wrong
      });

      if (answer.join() == correctWord) {
       showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) {
    return CorrectPopup(
      word: "Bag",
      translation: "බෑගය",
      onNext: () {
        Navigator.pop(context);
        // Do your "next" action here
      },
    );
  },
);

      }
    } else {
      setState(() {
        wrongLetter = letter; // show wrong letter in red
      });
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
            SizedBox(height: screenHeight * 0.08), // replaces top: 66
            Align(
              alignment: Alignment.center, // replaces left: 158
              child: SizedBox(
                width: screenWidth * 0.15,
                height: screenHeight * 0.03,
                child: Text(
                  "1 of 03",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Image container
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
                  "assets/images/bag.png",
                  width: screenWidth * 0.42,
                  height: screenWidth * 0.42,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 32.07),

            Align(
              alignment: Alignment.center, // replaces left: 91px (centered)

              child: Text(
                "Build the word for this picture",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            // Answer box with exact layout
            AnswerBox(answer: answer),
            //quiz container
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LetterButton(
                      letter: "G",
                      isWrong: wrongLetter == "G",
                      isUsed: usedLetters.contains("G"),
                      onTap: () => onLetterTap("G"),
                    ),
                    const SizedBox(width: 6.69),
                    LetterButton(
                      letter: "A",
                      isWrong: wrongLetter == "A",
                      isUsed: usedLetters.contains("A"),
                      onTap: () => onLetterTap("A"),
                    ),
                    const SizedBox(width: 6.69),
                    LetterButton(
                      letter: "B",
                      isWrong: wrongLetter == "B",
                      isUsed: usedLetters.contains("B"),
                      onTap: () => onLetterTap("B"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
