import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:learning_app/screens/single_word_game/word_review_screen.dart';
import 'package:learning_app/screens/single_word_game/all_words_completed_screen.dart';
import 'package:learning_app/widgets/word_practice_modal.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  final List<Map<String, dynamic>> words = [
    {
      "word": "Rabbit",
      "translation": "හාවා",
      "imagePath": "assets/images/Rabbit.svg",
      "letters": ["B", "R", "I", "A", "T", "B"],
      "quizOptions": ["Rabbit", "Cat", "Dog"],
      "isCompleted": false,
      "tasksCompleted": 0, // Track number of tasks completed (0-3)
      "failed": false, // Track if user failed and had to start over
    },
    {
      "word": "Pencil",
      "translation": "පැන්සල",
      "imagePath": "assets/images/Pencil.svg",
      "letters": ["N", "P", "C", "E", "I", "L"],
      "quizOptions": ["Pencil", "Eraser", "BlackBoard"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Teacher",
      "translation": "ගුරුවරයා",
      "imagePath": "assets/images/Teacher.svg",
      "letters": ["E", "T", "C", "A", "H", "E", "R"],
      "quizOptions": ["Student", "Teacher", "BlackBoard"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Cat",
      "translation": "පූසා",
      "imagePath": "assets/images/Cat.svg",
      "letters": ["C", "T", "A"],
      "quizOptions": ["Dog", "Cat", "Elephant"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Dog",
      "translation": "බල්ලා",
      "imagePath": "assets/images/Dog.svg",
      "letters": ["O", "D", "G"],
      "quizOptions": ["Cat", "Dog", "Rabbit"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Elephant",
      "translation": "අලියා",
      "imagePath": "assets/images/Elephant.svg",
      "letters": ["P", "L", "E", "E", "H", "N", "A", "T"],
      "quizOptions": ["Lion", "Elephant", "Tiger"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Eraser",
      "translation": "මකනය",
      "imagePath": "assets/images/Eraser.svg",
      "letters": ["R", "A", "E", "S", "E", "R"],
      "quizOptions": ["Eraser", "Apple", "Banana"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "BlackBoard",
      "translation": "පොත",
      "imagePath": "assets/images/Blackboard.svg",
      "letters": ["A", "B", "L", "K", "O", "B", "C", "A", "R", "D"],
      "quizOptions": ["BlackBoard", "Notebook", "Magazine"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },

    {
      "word": "Student",
      "translation": "ශිෂ්‍යයා",
      "imagePath": "assets/images/Student.svg",
      "letters": ["T", "S", "D", "U", "N", "E", "T"],
      "quizOptions": ["Teacher", "Student", "Office"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
    {
      "word": "Parrot",
      "translation": "ගිරවා",
      "imagePath": "assets/images/parrot.svg",
      "letters": ["A", "P", "T", "R", "O", "R"],
      "quizOptions": ["Parrot", "Sparrow", "Pigeon"],
      "isCompleted": false,
      "tasksCompleted": 0,
      "failed": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  // This function has been replaced by individual word completion tracking

  void _showWordCompletedScreen() {
    // Calculate coins for this single word (10 coins per word)
    int coinsEarned = 10;

    // Get the actual completion time
    String completionTime = _stopTimerAndGetFormattedTime();

    // Show completion screen after a short delay
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AllWordsCompletedScreen(
                totalCoins: coinsEarned,
                completionTime: completionTime,
                onFinished: () {
                  // Navigate back to word list screen
                  // This will be called when user presses FINISHED or HOME
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
        ),
      );
    });
  }

  Widget _getProgressIcon(Map<String, dynamic> word) {
    // If all tasks completed (word is complete)
    if (word['isCompleted']) {
      return SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset(
          'assets/icons/all_tasks_complete.svg',
          width: 30,
          height: 30,
        ),
      );
    }
    // Always show progress based on tasks completed, even if failed
    else if (word['tasksCompleted'] > 0) {
      // Show icon based on number of completed tasks
      switch (word['tasksCompleted']) {
        case 1:
          return SizedBox(
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              'assets/icons/1_task_complete.svg',
              width: 30,
              height: 30,
            ),
          );
        case 2:
          return SizedBox(
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              'assets/icons/2_task_complete.svg',
              width: 30,
              height: 30,
            ),
          );
        default:
          return SizedBox(
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              'assets/icons/fail.svg',
              width: 30,
              height: 30,
            ),
          );
      }
    }
    // Only show failed icon if no tasks completed and failed flag is true
    else if (word['failed']) {
      return SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset(
          'assets/icons/fail.svg',
          width: 30,
          height: 30,
        ),
      );
    }
    // Default case: no tasks completed and not failed
    else {
      // No tasks completed yet
      return SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset(
          'assets/icons/no_tasks_complete.svg',
          width: 30,
          height: 30,
        ),
      );
    }
  }

  void _showPracticeModal(Map<String, dynamic> wordData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => WordPracticeModal(
            wordData: wordData,
            onPracticePressed: () {
              Navigator.pop(context); // Close the modal

              // Start the timer when practice begins
              _startTimer();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => WordPracticeScreen(
                        wordData: wordData,
                        onCompleted: () {
                          // Update completion status
                          setState(() {
                            // Increment tasks completed
                            wordData['tasksCompleted'] =
                                (wordData['tasksCompleted'] as int) + 1;

                            // If all 3 tasks are completed, mark the word as complete
                            if (wordData['tasksCompleted'] == 3) {
                              wordData['isCompleted'] = true;

                              // Show completion screen only when all 3 tasks are done
                              _showWordCompletedScreen();
                            }
                          });

                          // No need to navigate here - the completion screen will handle that
                        },
                        onFailed: () {
                          // Update failed status if user runs out of stars
                          // But preserve the tasks completed count
                          setState(() {
                            wordData['failed'] = true;
                            // We don't reset tasksCompleted anymore
                          });
                        },
                      ),
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedWords = words.where((word) => word['isCompleted']).length;
    int totalCoins = completedWords * 10; // 10 coins per completed word

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top header with gradient
            Container(
              width: double.infinity,
              height: 121,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.blue, Color(0xFF1E3A8A)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          "Word List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                totalCoins.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/icons/coin.svg',
                                width: 20,
                                height: 20,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Word list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () => _showPracticeModal(word),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Speaker icon
                            InkWell(
                              onTap: () => _speak(word['word']),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.volume_up,
                                  color: Color.fromRGBO(41, 55, 72, 1),
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),

                            // Word and translation
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word['word'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    word['translation'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Progress indicator
                            _getProgressIcon(word),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Start the stopwatch for timing word practice
  void _startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  // Stop the stopwatch and format the elapsed time
  String _stopTimerAndGetFormattedTime() {
    _stopwatch.stop();
    final int minutes = _stopwatch.elapsed.inMinutes;
    final int seconds = _stopwatch.elapsed.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }
}
