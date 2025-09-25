import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/screens/word_practice_screen.dart';
import 'package:learning_app/widgets/word_practice_modal.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> words = [
    {
      "word": "Rabbit",
      "translation": "හාවා",
      "imagePath": "assets/images/Rabbit.svg",
      "letters": ["B", "R", "I", "A", "T", "B"],
      "quizOptions": ["Rabbit", "Cat", "Dog"],
      "isCompleted": false,
    },
    {
      "word": "Pencil",
      "translation": "පැන්සල",
      "imagePath": "assets/images/Pencil.svg",
      "letters": ["N", "P", "C", "E", "I", "L"],
      "quizOptions": ["Pencil", "Eraser", "BlackBoard"],
      "isCompleted": true,
    },
    {
      "word": "Teacher",
      "translation": "ගුරුවරයා",
      "imagePath": "assets/images/Teacher.svg",
      "letters": ["E", "T", "C", "A", "H", "E", "R"],
      "quizOptions": ["Student", "Teacher", "BlackBoard"],
      "isCompleted": false,
    },
    {
      "word": "Cat",
      "translation": "පූසා",
      "imagePath": "assets/images/Cat.svg",
      "letters": ["C", "T", "A"],
      "quizOptions": ["Dog", "Cat", "Elephant"],
      "isCompleted": false,
    },
    {
      "word": "Dog",
      "translation": "බල්ලා",
      "imagePath": "assets/images/Dog.svg",
      "letters": ["O", "D", "G"],
      "quizOptions": ["Cat", "Dog", "Rabbit"],
      "isCompleted": false,
    },
    {
      "word": "Elephant",
      "translation": "අලියා",
      "imagePath": "assets/images/Elephant.svg",
      "letters": ["P", "L", "E", "E", "H", "N", "A", "T"],
      "quizOptions": ["Lion", "Elephant", "Tiger"],
      "isCompleted": false,
    },
    {
      "word": "Eraser",
      "translation": "මකනය",
      "imagePath": "assets/images/Eraser.svg",
      "letters": ["R", "A", "E", "S", "E", "R"],
      "quizOptions": ["Eraser", "Apple", "Banana"],
      "isCompleted": false,
    },
    {
      "word": "BlackBoard",
      "translation": "පොත",
      "imagePath": "assets/images/Blackboard.svg",
      "letters": ["A", "B", "L", "K", "O", "A", "R", "O", "A", "R", "D"],
      "quizOptions": ["BlackBoard", "Notebook", "Magazine"],
      "isCompleted": false,
    },

    {
      "word": "Student",
      "translation": "ශිෂ්‍යයා",
      "imagePath": "assets/images/Student.svg",
      "letters": ["T", "S", "D", "U", "N", "E", "T"],
      "quizOptions": ["Teacher", "Student", "Office"],
      "isCompleted": false,
    },
    {
      "word": "Parrot",
      "translation": "ගිරවා",
      "imagePath": "assets/images/parrot.svg",
      "letters": ["A", "P", "O", "R", "O", "T"],
      "quizOptions": ["Parrot", "Sparrow", "Pigeon"],
      "isCompleted": false,
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

  Widget _getProgressIcon(bool isCompleted) {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            shape: BoxShape.circle,
          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => WordPracticeScreen(
                        wordData: wordData,
                        onCompleted: () {
                          // Update completion status
                          setState(() {
                            wordData['isCompleted'] = true;
                          });
                          Navigator.pop(context);
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
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back, color: Colors.white),
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
                                completedWords.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.star, color: Colors.orange, size: 20),
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
                    child: GestureDetector(
                      onTap: () => _showPracticeModal(word),
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
                            GestureDetector(
                              onTap: () => _speak(word['word']),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                            _getProgressIcon(word['isCompleted']),
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

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
