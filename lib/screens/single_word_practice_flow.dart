import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/widgets/letter_button.dart';
import 'package:learning_app/widgets/answer_box.dart';
import 'package:learning_app/widgets/correct_popup.dart';
import 'package:learning_app/widgets/wrong_popup.dart';
import 'package:learning_app/screens/out_of_stars_screen.dart';

enum PracticeMode { letterShuffle, listening, quiz }

class SingleWordPracticeFlow extends StatefulWidget {
  final Map<String, dynamic> wordData;
  final VoidCallback onCompleted;

  const SingleWordPracticeFlow({
    super.key,
    required this.wordData,
    required this.onCompleted,
  });

  @override
  State<SingleWordPracticeFlow> createState() => _SingleWordPracticeFlowState();
}

class _SingleWordPracticeFlowState extends State<SingleWordPracticeFlow> {
  final FlutterTts flutterTts = FlutterTts();

  PracticeMode currentMode = PracticeMode.letterShuffle;
  int stars = 3; // Start with 3 stars

  // Letter Shuffle variables
  List<String?> answerSlots = [];
  String? wrongLetter;
  Set<String> usedLetters = {};
  List<String> shuffledLetters = [];

  // Quiz variables
  String? selectedAnswer;
  bool hasAnswered = false;

  String get currentWord => widget.wordData['word'].toString().toUpperCase();
  List<String> get wordLetters =>
      widget.wordData['letters'] ?? currentWord.split('');
  List<String> get quizOptions => widget.wordData['quizOptions'] ?? [];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _initializeLetterShuffle();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  void _initializeLetterShuffle() {
    answerSlots = List<String?>.filled(currentWord.length, null);
    wrongLetter = null;
    usedLetters.clear();
    shuffledLetters = List<String>.from(wordLetters);
    shuffledLetters.shuffle();
    hasAnswered = false;
    selectedAnswer = null;
  }

  Future<void> _speak(String word) async {
    await flutterTts.speak(word);
  }

  void onLetterTap(String letter, int index) {
    if (stars <= 0) return;

    int nextIndex = answerSlots.indexWhere((e) => e == null);
    if (nextIndex == -1) return;

    if (currentWord[nextIndex] == letter) {
      setState(() {
        answerSlots[nextIndex] = letter;
        usedLetters.add(letter + index.toString());
        wrongLetter = null;
      });

      if (!answerSlots.contains(null)) {
        _showCorrectPopup();
      }
    } else {
      setState(() {
        wrongLetter = letter;
        stars = (stars - 1).clamp(0, 3);
      });

      if (stars <= 0) {
        _showGameOverDialog();
      }
    }
  }

  void onQuizAnswerTap(String selectedAnswer) {
    if (hasAnswered || stars <= 0) return;

    setState(() {
      hasAnswered = true;
      this.selectedAnswer = selectedAnswer;
    });

    bool isCorrect = selectedAnswer == widget.wordData['word'];

    if (isCorrect) {
      _showCorrectPopup();
    } else {
      setState(() {
        stars = (stars - 1).clamp(0, 3);
      });

      if (stars <= 0) {
        _showGameOverDialog();
      } else {
        _showWrongPopup(selectedAnswer);
      }
    }
  }

  void _showCorrectPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CorrectPopup(
          word: widget.wordData['word'],
          translation: widget.wordData['translation'],
          onNext: () {
            Navigator.pop(context);
            _moveToNextMode();
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
          word: widget.wordData['word'],
          translation: widget.wordData['translation'],
          onNext: () {
            Navigator.pop(context);
            setState(() {
              hasAnswered = false;
              selectedAnswer = null;
            });
          },
        );
      },
    );
  }

  void _showGameOverDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => OutOfStarsScreen(
              onRestore: () {
                // Restore 1 star and go back to practice
                Navigator.pop(context);
                setState(() {
                  stars = 1;
                });
              },
              onRetry: () {
                // Go back to word list
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
      ),
    );
  }

  void _moveToNextMode() {
    if (currentMode == PracticeMode.letterShuffle) {
      setState(() {
        currentMode = PracticeMode.listening;
        _initializeLetterShuffle();
      });
    } else if (currentMode == PracticeMode.listening) {
      setState(() {
        currentMode = PracticeMode.quiz;
        _initializeLetterShuffle();
      });
    } else {
      // Completed all modes - quiz is the final stage
      widget.onCompleted(); // This will mark the word as completed

      // Navigate back to word list (pop all the way back)
       Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildStarsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.star,
            color: index < stars ? Colors.black : Colors.grey[300],
            size: 22,
          ),
        );
      }),
    );
  }

  Widget _buildLetterShuffleMode() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
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
            child:
                widget.wordData['imagePath'].endsWith('.svg')
                    ? SvgPicture.asset(
                      widget.wordData['imagePath'],
                      width: screenWidth * 0.42,
                      height: screenWidth * 0.42,
                      fit: BoxFit.contain,
                    )
                    : Image.asset(
                      widget.wordData['imagePath'],
                      width: screenWidth * 0.42,
                      height: screenWidth * 0.42,
                      fit: BoxFit.contain,
                    ),
          ),
        ),
        const SizedBox(height: 32),
      
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
    );
  }

  Widget _buildListeningMode() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
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
    );
  }

  Widget _buildQuizMode() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          "What does the picture mean?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 40),
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
                    widget.wordData['imagePath'].endsWith('.svg')
                        ? SvgPicture.asset(
                          widget.wordData['imagePath'],
                          fit: BoxFit.contain,
                        )
                        : Image.asset(
                          widget.wordData['imagePath'],
                          fit: BoxFit.contain,
                        ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.wordData['translation'],
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(quizOptions.length, (index) {
                final option = quizOptions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => onQuizAnswerTap(option),
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
    );
  }

  String _getModeTitle() {
    switch (currentMode) {
      case PracticeMode.letterShuffle:
        return "What does the picture mean?";
      case PracticeMode.listening:
        return "What does the audio say?";
      case PracticeMode.quiz:
        return "What does the picture mean?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with close button, progress, and stars
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
                      value: (currentMode.index + 1) / 3,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStarsWidget(),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Mode title
            Text(
              _getModeTitle(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),

            // Main content based on current mode
            Expanded(
              child:
                  currentMode == PracticeMode.letterShuffle
                      ? _buildLetterShuffleMode()
                      : currentMode == PracticeMode.listening
                      ? _buildListeningMode()
                      : _buildQuizMode(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
