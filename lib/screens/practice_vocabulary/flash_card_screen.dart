import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/screens/practice_vocabulary/results_page.dart';
import 'package:learning_app/widgets/bottom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final FlutterTts flutterTts = FlutterTts();

  int currentIndex = 0;
  bool wasFlipped = false;

  final List<Map<String, String>> masteredList = [];
  final List<Map<String, String>> toReviewList = [];

  // Words list
  final List<Map<String, String>> words = [
    {"word": "Cat", "translation": "පූසා", "image": "assets/images/Cat.svg"},
    {"word": "Dog", "translation": "බල්ලා", "image": "assets/images/Dog.svg"},
    {
      "word": "BlackBoard",
      "translation": "කළු ලෑල්ල",
      "image": "assets/images/Blackboard.svg",
    },
    {
      "word": "Elephant",
      "translation": "අලියා",
      "image": "assets/images/Elephant.svg",
    },
    {
      "word": "Eraser",
      "translation": "මකනය",
      "image": "assets/images/Eraser.svg",
    },
    {
      "word": "Parrot",
      "translation": "ගිරවා",
      "image": "assets/images/parrot.svg",
    },
    {
      "word": "Pencil",
      "translation": "පැන්සල",
      "image": "assets/images/Pencil.svg",
    },
    {
      "word": "Rabbit",
      "translation": "හාවා",
      "image": "assets/images/Rabbit.svg",
    },
    {
      "word": "Student",
      "translation": "ශිෂ්‍යයා",
      "image": "assets/images/Student.svg",
    },
    {
      "word": "Teacher",
      "translation": "ගුරුවරයා",
      "image": "assets/images/Teacher.svg",
    },
  ];

  Future<void> _speak(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  void _nextWord() {
    final word = words[currentIndex];

    if (wasFlipped) {
      toReviewList.add(word);
    } else {
      masteredList.add(word);
    }

    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        wasFlipped =
            false; //if the card show back side this will flip again to front
      });
      if (cardKey.currentState != null &&
          cardKey.currentState!.isFront == false) {
        cardKey.currentState?.toggleCard();
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResultsPage(
                masteredWords: masteredList,
                toReviewWords: toReviewList,
                onReviewAgain: () {
                  // Restart the flash card session
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => FlashCardScreen()),
                  );
                },

                onHome: () {
                  // Navigate back to home screen (clear all and go to first route)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / words.length;
    final word = words[currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              "Do you know this word?",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            // Flip card
            Expanded(
              child: Center(
                child: FlipCard(
                  onFlip: () {
                    // FlipCard does not tell us which side we are on, so we check manually
                    if (cardKey.currentState != null &&
                        cardKey.currentState!.isFront == false) {
                      setState(() {
                        wasFlipped = true; // mark as flipped when back is shown
                      });
                    }
                  },

                  key: cardKey,
                  flipOnTouch: false,
                  front: buildFrontCard(word),
                  back: buildBackCard(word),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FRONT CARD
  Widget buildFrontCard(Map<String, String> word) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.04,
            ),
            border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  word["image"]!,
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.width * 0.42,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                Text(
                  word["translation"]!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 52),
                GestureDetector(
                  onTap: () {
                    cardKey.currentState?.toggleCard();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.flip, size: 25, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to Study Again",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80),

        GradientButton(
          text: "Yes, I know",
          onPressed: _nextWord,
          gradientColors: [Colors.blue, const Color.fromARGB(255, 10, 29, 201)],
        ),
      ],
    );
  }

  // BACK CARD
  Widget buildBackCard(Map<String, String> word) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.04,
            ),
            border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  word["word"]!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  word["translation"]!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 32),
                IconButton(
                  icon: Icon(Icons.volume_up, size: 50, color: Colors.red),
                  onPressed: () {
                    _speak(word["word"]!);
                  },
                ),
                const SizedBox(height: 52),
                GestureDetector(
                  onTap: () {
                    cardKey.currentState?.toggleCard();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.flip, size: 25, color: Colors.red),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to Flip",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80),

        GradientButton(
          text: "Next Word",
          onPressed: _nextWord,
          gradientColors: [Colors.red, const Color.fromARGB(255, 117, 5, 5)],
        ),
      ],
    );
  }
}
