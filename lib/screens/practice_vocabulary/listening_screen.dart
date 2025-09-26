import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/screens/practice_vocabulary/results_page.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/correct_popup.dart';
import '../../../widgets/answer_box.dart';

class QuizResult {
  final String word;
  final bool isCorrect;

  QuizResult({required this.word, required this.isCorrect});
}

class ListeningQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> words;

  ListeningQuizScreen({super.key, List<Map<String, dynamic>>? words})
    : words =
          words ??
          [
            {
              "word": "Cat",
              "translation": "පූසා",
              "letters": ["T", "A", "C"],
            },
            {
              "word": "Dog",
              "translation": "බල්ලා",
              "letters": ["D", "O", "G"],
            },
            {
              "word": "BlackBoard",
              "translation": "කළු ලෑල්ල",
              "letters": ["B", "L", "A", "C", "K", "B", "O", "A", "R", "D"],
            },
            {
              "word": "Elephant",
              "translation": "අලියා",
              "letters": ["E", "L", "E", "P", "H", "A", "N", "T"],
            },
            {
              "word": "Eraser",
              "translation": "මකනය",
              "letters": ["E", "R", "A", "S", "E", "R"],
            },
            {
              "word": "Parrot",
              "translation": "ගිරවා",
              "letters": ["P", "A", "R", "R", "O", "T"],
            },
            {
              "word": "Pencil",
              "translation": "පැන්සල",
              "letters": ["P", "E", "N", "C", "I", "L"],
            },
            {
              "word": "Rabbit",
              "translation": "හාවා",
              "letters": ["R", "A", "B", "B", "I", "T"],
            },
            {
              "word": "Student",
              "translation": "ශිෂ්‍යයා",
              "letters": ["S", "T", "U", "D", "E", "N", "T"],
            },
            {
              "word": "Teacher",
              "translation": "ගුරුවරයා",
              "letters": ["T", "E", "A", "C", "H", "E", "R"],
            },
          ];

  @override
  State<ListeningQuizScreen> createState() => _ListeningQuizScreenState();
}

class _ListeningQuizScreenState extends State<ListeningQuizScreen> {
  final FlutterTts flutterTts = FlutterTts();

  int currentIndex = 0;
  String currentWord = "";
  String? wrongLetter;
  List<String?> answerSlots = [];
  Set<String> usedLetters = {};
  List<String> shuffledLetters = [];
  bool attemptedWrong = false;
  bool madeMistake = false;

  // results tracking
  List<QuizResult> results = [];

  @override
  void initState() {
    super.initState();
    initializeTts();
    loadWord();
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  void loadWord() {
    currentWord = widget.words[currentIndex]["word"].toString().toUpperCase();
    wrongLetter = null;
    attemptedWrong = false;
    madeMistake = false;
    answerSlots = List.filled(currentWord.length, null);
    usedLetters.clear();

    // Shuffle the letters for the current word
    shuffledLetters = List<String>.from(widget.words[currentIndex]["letters"]);
    shuffledLetters.shuffle();

    setState(() {});
  }

  Future<void> _speak(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  void onLetterTap(String letter, int index) {
    int nextIndex = answerSlots.indexWhere((e) => e == null);

    if (nextIndex == -1) return;

    if (currentWord[nextIndex] == letter) {
      // Correct letter
      setState(() {
        answerSlots[nextIndex] = letter;
        usedLetters.add(letter + index.toString());
        wrongLetter = null;
      });

      if (!answerSlots.contains(null)) {
        // Word completed
        results.add(QuizResult(word: currentWord, isCorrect: !attemptedWrong));

        // Show success dialog
        _showWordCompletedDialog();
      }
    } else {
      // Wrong letter
      setState(() {
        wrongLetter = letter;
        attemptedWrong = true;
        madeMistake = true;
      });
    }
  }

  void _showWordCompletedDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CorrectPopup(
          word: currentWord,
          translation: widget.words[currentIndex]["translation"],
          onNext: () {
            Navigator.pop(context);
            goNextWord();
          },
        );
      },
    );
  }

  void goNextWord() {
    if (currentIndex < widget.words.length - 1) {
      setState(() {
        currentIndex++;
      });
      loadWord();
    } else {
      // Finished all quizzes → prepare data and go to results screen
      List<Map<String, String>> masteredWords = [];
      List<Map<String, String>> toReviewWords = [];

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        final wordData = {
          'word': result.word,
          'translation': widget.words[i]['translation'].toString(),
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
                  // Restart the listening quiz with only the words that need review
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ListeningQuizScreen(
                            words:
                                toReviewWords
                                    .map(
                                      (word) => {
                                        'word': word['word']!,
                                        'translation': word['translation']!,
                                        'letters':
                                            word['word']!
                                                .toUpperCase()
                                                .split('')
                                                .toList()
                                              ..shuffle(),
                                      },
                                    )
                                    .toList(),
                          ),
                    ),
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
    double progress = (currentIndex + 1) / widget.words.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with progress
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
            SizedBox(height: screenHeight * 0.02),
            Align(
              alignment: Alignment.center,
              child: Text(
                "${currentIndex + 1} of ${widget.words.length}",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up, size: 80, color: Colors.blue),
                      onPressed: () => _speak(currentWord),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Tap to play audio",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Build the word from the audio",
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
                  children: List.generate(shuffledLetters.length, (i) {
                    final letter = shuffledLetters[i];
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
